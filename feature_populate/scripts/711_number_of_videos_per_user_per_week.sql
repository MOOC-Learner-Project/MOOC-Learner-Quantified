INSERT INTO `moocdb`.user_long_feature(feature_id, user_id, feature_week, feature_value, date_of_extraction)
SELECT 711,
	user_long_feature_base.user_id,
    user_long_feature_base.feature_week,
	(
	    SELECT COUNT(DISTINCT(click_events.video_id))
	    FROM `moocdb`.click_events AS click_events
	    WHERE click_events.user_id = user_long_feature_base.user_id AND
            (click_events.observed_event_timestamp
            BETWEEN TIMESTAMP(DATE_ADD(user_dropout.start_timestamp, INTERVAL (user_long_feature_base.feature_week-1) WEEK))
            AND
            TIMESTAMP(DATE_ADD(user_dropout.start_timestamp, INTERVAL user_long_feature_base.feature_week WEEK)))
    ),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_long_feature_base
INNER JOIN `moocdb`.user_dropout AS user_dropout
    ON user_dropout.user_id = user_long_feature_base.user_id
;