INSERT INTO `moocdb`.long_feature(feature_id, feature_week, feature_value, date_of_extraction)
SELECT 734,
	long_feature_base.feature_week,
	(
	    SELECT SUM(user_long_feature.feature_value)
	    FROM `moocdb`.user_long_feature AS user_long_feature
	    WHERE user_long_feature.feature_id = 731
	        AND user_long_feature.feature_week = long_feature_base.feature_week
	        AND user_long_feature.feature_value IS NOT NULL
    )
    /
    NULLIF((
	    SELECT COUNT(*)
	    FROM `moocdb`.user_long_feature AS user_long_feature
	    WHERE user_long_feature.feature_id = 731
	        AND user_long_feature.feature_week = long_feature_base.feature_week
	        AND user_long_feature.feature_value IS NOT NULL
    ), 0),
    CURRENT_TIMESTAMP
FROM `moocdb`.long_feature_base
;