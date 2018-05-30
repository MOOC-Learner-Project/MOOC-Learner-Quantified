INSERT INTO `moocdb`.long_feature(feature_id, feature_week, feature_value, date_of_extraction)
SELECT 942,
	long_feature_base.feature_week,
	(
	    SELECT SUM(user_long_feature.feature_value)
	    FROM `moocdb`.user_long_feature AS user_long_feature
	    WHERE user_long_feature.feature_id = 940
	        AND user_long_feature.feature_week = long_feature_base.feature_week
    ),
    CURRENT_TIMESTAMP
FROM `moocdb`.long_feature_base
;