INSERT INTO video_feature (feature_id, video_id, feature_value, date_of_extraction)
SELECT 922,
	video_stats.video_id,
    video_stats.videos_viewed,
    CURRENT_TIMESTAMP
FROM video_stats
;