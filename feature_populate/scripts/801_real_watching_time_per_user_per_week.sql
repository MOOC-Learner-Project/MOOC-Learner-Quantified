DROP FUNCTION IF EXISTS `moocdb`.get_default_speed_at_time;

DROP FUNCTION IF EXISTS `moocdb`.get_real_watching_time_per_user_per_week;

CREATE FUNCTION get_default_speed_at_time (USER_ID VARCHAR(63), TIME_STAMP TIMESTAMP)
    RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
    DECLARE default_speed FLOAT DEFAULT 1.0;
    DECLARE flag BOOLEAN DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT video_new_speed
        FROM `moocdb`.click_events AS click_events
        WHERE click_events.user_id = USER_ID
            AND click_events.observed_event_type = 'speed_change_video'
            AND click_events.observed_event_timestamp < TIME_STAMP
        ORDER BY click_events.observed_event_timestamp DESC
        LIMIT 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = TRUE;
    OPEN cur;
    IF NOT flag THEN
        FETCH cur INTO default_speed;
    END IF;
    CLOSE cur;
    RETURN default_speed;
END;

CREATE FUNCTION get_real_watching_time_per_user_per_week (USER_ID VARCHAR(63), FEATURE_WEEK INT(2), USER_START_TIME TIMESTAMP)
    RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
  DECLARE cum_time FLOAT DEFAULT 0.0;
  DECLARE loop_flag BOOLEAN DEFAULT FALSE;
  DECLARE event_type VARCHAR(255) DEFAULT NULL;
  DECLARE new_speed FLOAT DEFAULT NULL;
  DECLARE speed FLOAT DEFAULT NULL;
  DECLARE cur_time FLOAT DEFAULT NULL;
  DECLARE new_time FLOAT DEFAULT NULL;
  DECLARE old_time FLOAT DEFAULT NULL;
  DECLARE prev_time FLOAT DEFAULT NULL;
  DECLARE start_time FLOAT DEFAULT NULL;
  DECLARE end_time FLOAT DEFAULT NULL;
  DECLARE count_flag BOOLEAN DEFAULT FALSE;
  -- There should be current_time field of speed_change_video events
  -- However now they are missing due to a bug in apipe
  -- Use time stamp difference instead to count the duration
  DECLARE time_stamp TIMESTAMP;
  DECLARE start_time_stamp TIMESTAMP;
  DECLARE end_time_stamp TIMESTAMP;
  DECLARE duration FLOAT;
  DECLARE cur CURSOR FOR SELECT observed_event_type, video_current_time, video_new_time, video_old_time, observed_event_timestamp, video_new_speed
    FROM `moocdb`.click_events AS click_events
    WHERE click_events.user_id = USER_ID
    	AND (click_events.observed_event_type != 'hide_transcript'
            AND click_events.observed_event_type != 'show_transcript')
        AND click_events.observed_event_timestamp
            BETWEEN TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL (FEATURE_WEEK-1) WEEK))
            AND
            TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL FEATURE_WEEK WEEK))
    ORDER BY observed_event_timestamp;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET loop_flag = TRUE;
  SET cum_time = 0.0;
  SET speed = get_default_speed_at_time(USER_ID, TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL (FEATURE_WEEK-1) WEEK)));
  OPEN cur;
  cum_loop: LOOP
    FETCH cur INTO event_type, cur_time, new_time, old_time, time_stamp, new_speed;
    IF loop_flag THEN
      LEAVE cum_loop;
    END IF;
    IF event_type = 'load_video' OR event_type = 'stop_video' THEN
        SET count_flag = FALSE;
        ITERATE cum_loop;
    END IF;
    IF count_flag THEN
        IF event_type = 'pause_video' THEN
            SET end_time = cur_time;
            SET cum_time = cum_time + (GREATEST(end_time - start_time, 0)) / speed;
            SET count_flag = FALSE;
        ELSEIF event_type = 'seek_video' THEN
            SET end_time = old_time;
            SET cum_time = cum_time + (GREATEST(end_time - start_time, 0)) / speed;
            SET start_time = new_time;
            SET start_time_stamp = time_stamp;
        ELSEIF event_type = 'speed_change_video' THEN
            SET end_time_stamp = time_stamp;
            SET duration = TIMESTAMPDIFF(SECOND, start_time_stamp, end_time_stamp);
            SET cum_time = cum_time + duration;
            SET start_time = start_time + duration * speed;
            SET start_time_stamp = time_stamp;
        END IF;
    ELSE
        IF event_type = 'play_video' THEN
            SET start_time = cur_time;
            SET start_time_stamp = time_stamp;
            SET count_flag = TRUE;
        END IF;
    END IF;
    IF event_type = 'speed_change_video' THEN
        SET speed = new_speed;
    END IF;
    SET prev_time = cur_time;
  END LOOP;
  CLOSE cur;
  RETURN cum_time;
END;

INSERT INTO `moocdb`.user_long_feature(feature_id, user_id, feature_week, feature_value, date_of_extraction)
SELECT 801,
	user_long_feature_base.user_id,
	user_long_feature_base.feature_week,
	get_real_watching_time_per_user_per_week(user_long_feature_base.user_id, user_long_feature_base.feature_week, (
        SELECT user_dropout.start_timestamp FROM user_dropout
        WHERE user_dropout.user_id = user_long_feature_base.user_id
    )),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_long_feature_base AS user_long_feature_base
;