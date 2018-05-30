INSERT INTO `moocdb`.video_feature(feature_id, video_id, feature_value, date_of_extraction)
SELECT 772,
	video_axis.video_id,
    (
	SELECT COUNT(*)
	FROM `moocdb`.click_events as click_events
    WHERE click_events.video_id = video_axis.video_id
        AND click_events.observed_event_type = 'pause_video'
	),
    CURRENT_TIMESTAMP
FROM `moocdb`.video_axis AS video_axis
;