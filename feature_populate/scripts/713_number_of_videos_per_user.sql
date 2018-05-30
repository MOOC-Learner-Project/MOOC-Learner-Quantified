INSERT INTO `moocdb`.user_feature(feature_id, user_id, feature_value, date_of_extraction)
SELECT 713,
	user_dropout.user_id,
	(
	    SELECT COUNT(DISTINCT(click_events.video_id))
	    FROM `moocdb`.click_events AS click_events
	    WHERE click_events.user_id = user_dropout.user_id
    ),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_dropout
;