INSERT INTO `moocdb`.video_feature(feature_id, video_id, feature_value, date_of_extraction)
SELECT 762,
	video_axis.video_id,
    (
	SELECT COUNT(*)
	FROM `moocdb`.click_events as click_events
    WHERE click_events.video_id = video_axis.video_id
        AND click_events.observed_event_type = 'seek_video'
        AND click_events.video_new_time > (click_events.video_old_time + 0.1)
	),
    CURRENT_TIMESTAMP
FROM `moocdb`.video_axis AS video_axis
;