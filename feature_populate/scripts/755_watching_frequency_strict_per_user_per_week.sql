DROP FUNCTION IF EXISTS `moocdb`.get_watching_frequency_strict_per_user_per_week;

CREATE FUNCTION get_watching_frequency_strict_per_user_per_week (USER_ID VARCHAR(63), FEATURE_WEEK INT(2), USER_START_TIME TIMESTAMP)
    RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
  DECLARE frequency INT DEFAULT 0;
  DECLARE loop_flag BOOLEAN DEFAULT FALSE;
  DECLARE event_type VARCHAR(255) DEFAULT NULL;
  DECLARE repeat_flag BOOLEAN DEFAULT FALSE;
  DECLARE cur_time_stamp TIMESTAMP;
  DECLARE prev_time_stamp TIMESTAMP;
  DECLARE cur_video_id VARCHAR(63) DEFAULT NULL;
  DECLARE prev_video_id VARCHAR(63) DEFAULT NULL;
  DECLARE cur CURSOR FOR SELECT observed_event_type, observed_event_timestamp, video_id
    FROM `moocdb`.click_events AS click_events
    WHERE click_events.user_id = USER_ID
        AND (click_events.observed_event_type = 'load_video'
            OR click_events.observed_event_type = 'play_video'
            OR click_events.observed_event_type = 'pause_video')
        AND click_events.observed_event_timestamp
            BETWEEN TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL (FEATURE_WEEK-1) WEEK))
            AND
            TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL FEATURE_WEEK WEEK))
    ORDER BY observed_event_timestamp;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET loop_flag = TRUE;
  SET frequency = 0;
  OPEN cur;
  cum_loop: LOOP
    FETCH cur INTO event_type, cur_time_stamp, cur_video_id;
    IF loop_flag THEN
      LEAVE cum_loop;
    END IF;
    IF prev_video_id != cur_video_id THEN
        SET prev_time_stamp = cur_time_stamp;
        SET prev_video_id = cur_video_id;
        ITERATE cum_loop;
    END IF;
    IF TIMESTAMPDIFF(MINUTE, prev_time_stamp, cur_time_stamp) > 30 THEN
        SET frequency = frequency + 1;
    END IF;
    SET prev_time_stamp = cur_time_stamp;
    SET prev_video_id = cur_video_id;
  END LOOP;
  CLOSE cur;
  RETURN frequency;
END;

INSERT INTO `moocdb`.user_long_feature(feature_id, user_id, feature_week, feature_value, date_of_extraction)
SELECT 755,
	user_long_feature_base.user_id,
	user_long_feature_base.feature_week,
	get_watching_frequency_strict_per_user_per_week(user_long_feature_base.user_id, user_long_feature_base.feature_week, (
        SELECT user_dropout.start_timestamp FROM user_dropout
        WHERE user_dropout.user_id = user_long_feature_base.user_id
    )),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_long_feature_base AS user_long_feature_base
;