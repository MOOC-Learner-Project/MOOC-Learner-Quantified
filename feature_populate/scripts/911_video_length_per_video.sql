INSERT INTO video_feature (feature_id, video_id, feature_value, date_of_extraction)
SELECT 911,
	video_axis.video_id,
    video_axis.video_length,
    CURRENT_TIMESTAMP
FROM video_axis
;