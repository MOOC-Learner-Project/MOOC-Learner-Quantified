DROP FUNCTION IF EXISTS `moocdb`.get_total_pausing_time_per_user_per_week;

CREATE FUNCTION get_total_pausing_time_per_user_per_week (USER_ID VARCHAR(63), FEATURE_WEEK INT(2), USER_START_TIME TIMESTAMP)
    RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
  DECLARE cum_time FLOAT DEFAULT 0.0;
  DECLARE loop_flag BOOLEAN DEFAULT FALSE;
  DECLARE event_type VARCHAR(255) DEFAULT NULL;
  DECLARE count_flag BOOLEAN DEFAULT FALSE;
  DECLARE cur_time_stamp TIMESTAMP;
  DECLARE prev_time_stamp TIMESTAMP;
  DECLARE start_time_stamp TIMESTAMP;
  DECLARE end_time_stamp TIMESTAMP;
  DECLARE cur CURSOR FOR SELECT observed_event_type, observed_event_timestamp
    FROM `moocdb`.click_events AS click_events
    WHERE click_events.user_id = USER_ID
        AND click_events.observed_event_timestamp
            BETWEEN TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL (FEATURE_WEEK-1) WEEK))
            AND
            TIMESTAMP(DATE_ADD(USER_START_TIME, INTERVAL FEATURE_WEEK WEEK))
    ORDER BY observed_event_timestamp;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET loop_flag = TRUE;
  SET cum_time = 0.0;
  OPEN cur;
  cum_loop: LOOP
    FETCH cur INTO event_type, cur_time_stamp;
    IF loop_flag THEN
      LEAVE cum_loop;
    END IF;
    IF event_type = 'load_video' OR event_type = 'stop_video' THEN
        SET count_flag = FALSE;
        ITERATE cum_loop;
    END IF;
    IF count_flag THEN
        IF event_type = 'play_video' THEN
            SET end_time_stamp = cur_time_stamp;
            SET cum_time = cum_time + TIMESTAMPDIFF(SECOND, start_time_stamp, end_time_stamp);
            SET count_flag = FALSE;
        END IF;
    ELSE
        IF event_type = 'pause_video' THEN
            SET start_time_stamp = cur_time_stamp;
            SET count_flag = TRUE;
        END IF;
    END IF;
    SET prev_time_stamp = cur_time_stamp;
  END LOOP;
  CLOSE cur;
  RETURN cum_time;
END;

INSERT INTO `moocdb`.user_long_feature(feature_id, user_id, feature_week, feature_value, date_of_extraction)
SELECT 781,
	user_long_feature_base.user_id,
	user_long_feature_base.feature_week,
	get_total_pausing_time_per_user_per_week(user_long_feature_base.user_id, user_long_feature_base.feature_week, (
        SELECT user_dropout.start_timestamp FROM user_dropout
        WHERE user_dropout.user_id = user_long_feature_base.user_id
    )),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_long_feature_base AS user_long_feature_base
;