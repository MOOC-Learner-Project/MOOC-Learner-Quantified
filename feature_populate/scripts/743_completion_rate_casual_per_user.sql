INSERT INTO `moocdb`.user_feature(feature_id, user_id, feature_value, date_of_extraction)
SELECT 743,
	user_dropout.user_id,
	(
	    SELECT SUM(user_long_feature.feature_value)
	    FROM `moocdb`.user_long_feature AS user_long_feature
	    WHERE user_long_feature.feature_id = 741
	        AND user_long_feature.user_id = user_dropout.user_id
	        AND user_long_feature.feature_value IS NOT NULL
    )
    /
    NULLIF((
    	SELECT COUNT(*)
	    FROM `moocdb`.user_long_feature AS user_long_feature
	    WHERE user_long_feature.feature_id = 741
	        AND user_long_feature.user_id = user_dropout.user_id
    ), 0),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_dropout
;