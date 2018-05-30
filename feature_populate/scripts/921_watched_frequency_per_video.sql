INSERT INTO video_feature (feature_id, video_id, feature_value, date_of_extraction)
SELECT 921,
	video_stats.video_id,
    video_stats.videos_watched,
    CURRENT_TIMESTAMP
FROM video_stats
;