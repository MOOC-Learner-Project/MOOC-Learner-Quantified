INSERT INTO `moocdb`.user_feature(feature_id, user_id, feature_value, date_of_extraction)
SELECT 701,
	user_dropout.user_id,
	user_dropout.dropout_week,
    CURRENT_TIMESTAMP
FROM `moocdb`.user_dropout AS user_dropout
WHERE user_dropout.dropout_week IS NOT NULL
GROUP BY user_dropout.user_id
;

UPDATE `moocdb`.user_feature
SET feature_value = NUM_WEEKS_PLACEHOLDER
WHERE feature_id = 701
	AND feature_value > NUM_WEEKS_PLACEHOLDER