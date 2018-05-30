INSERT INTO `moocdb`.video_feature(feature_id, video_id, feature_value, date_of_extraction)
SELECT 712,
	video_axis.video_id,
	(
	    SELECT COUNT(DISTINCT(click_events.user_id))
	    FROM `moocdb`.click_events AS click_events
	    WHERE click_events.video_id = video_axis.video_id
    ),
    CURRENT_TIMESTAMP
FROM `moocdb`.video_axis
;