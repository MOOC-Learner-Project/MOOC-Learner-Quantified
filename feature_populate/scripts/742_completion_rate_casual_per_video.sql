DROP FUNCTION IF EXISTS get_completion_rate_casual_per_video;

CREATE FUNCTION get_completion_rate_casual_per_video (VIDEO_ID VARCHAR(63))
    RETURNS FLOAT
    NOT DETERMINISTIC
BEGIN
  DECLARE cum_time FLOAT DEFAULT 0.0;
  DECLARE loop_flag BOOLEAN DEFAULT FALSE;
  DECLARE event_type VARCHAR(255) DEFAULT NULL;
  DECLARE cur_time FLOAT DEFAULT NULL;
  DECLARE new_time FLOAT DEFAULT NULL;
  DECLARE old_time FLOAT DEFAULT NULL;
  DECLARE prev_time FLOAT DEFAULT 0.0;
  DECLARE start_time FLOAT DEFAULT NULL;
  DECLARE end_time FLOAT DEFAULT NULL;
  DECLARE count_flag BOOLEAN DEFAULT FALSE;
  DECLARE video_length FLOAT;
  DECLARE cur_user_id VARCHAR(63) DEFAULT NULL;
  DECLARE prev_user_id VARCHAR(63) DEFAULT NULL;
  DECLARE ncomplete FLOAT DEFAULT 0.0;
  DECLARE nuser FLOAT DEFAULT 0.0;
  DECLARE cur_video CURSOR FOR SELECT video_axis.video_length
    FROM `moocdb`.video_axis AS video_axis
    WHERE video_axis.video_id = VIDEO_ID;
  DECLARE cur CURSOR FOR SELECT observed_event_type, video_current_time, user_id, video_old_time, video_new_time
    FROM `moocdb`.click_events AS click_events
    WHERE click_events.video_id = VIDEO_ID
        AND (click_events.observed_event_type != 'hide_transcript'
            AND click_events.observed_event_type != 'show_transcript'
            AND click_events.observed_event_type != 'speed_change_video')
    ORDER BY user_id, observed_event_timestamp;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET loop_flag = TRUE;
  OPEN cur_video;
  FETCH cur_video INTO video_length;
  OPEN cur;
  cum_loop: LOOP
    FETCH cur INTO event_type, cur_time, cur_user_id, old_time, new_time;
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
            SET cum_time = cum_time + GREATEST(end_time - start_time, 0);
            SET count_flag = FALSE;
        ELSEIF event_type = 'seek_video' THEN
            SET end_time = old_time;
            SET cum_time = cum_time + GREATEST(end_time - start_time, 0);
            SET start_time = new_time;
        END IF;
    ELSE
        IF event_type = 'play_video' THEN
            SET start_time = cur_time;
            SET count_flag = TRUE;
        END IF;
    END IF;
    SET prev_time = cur_time;
    IF prev_user_id != cur_user_id THEN
        SET nuser = nuser + 1;
        IF cum_time > (video_length * 0.8) THEN
            SET ncomplete = ncomplete + 1;
        END IF;
        SET cum_time = 0.0;
    END IF;
    SET prev_user_id = cur_user_id;
  END LOOP;
  CLOSE cur;
  CLOSE cur_video;
  IF cum_time > (video_length * 0.8) THEN
    SET ncomplete = ncomplete + 1;
  END IF;
  RETURN ncomplete/NULLIF(nuser, 0);
END;

INSERT INTO `moocdb`.video_feature(feature_id, video_id, feature_value, date_of_extraction)
SELECT 742,
	video_axis.video_id,
	get_completion_rate_casual_per_video(video_axis.video_id),
    CURRENT_TIMESTAMP
FROM `moocdb`.video_axis AS video_axis
;