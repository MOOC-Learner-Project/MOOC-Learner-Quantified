INSERT INTO `moocdb`.user_long_feature(feature_id, user_id, feature_week, feature_value, date_of_extraction)
SELECT 934,
	user_long_feature_base.user_id,
    user_long_feature_base.feature_week,
	(
	    SELECT SUM(person_course_day.nseek_video)
	    FROM `moocdb`.person_course_day AS person_course_day
	    WHERE person_course_day.user_id = user_long_feature_base.user_id AND
            (person_course_day._date
            BETWEEN DATE_ADD(user_dropout.start_timestamp, INTERVAL (user_long_feature_base.feature_week-1) WEEK)
            AND
            DATE_ADD(user_dropout.start_timestamp, INTERVAL user_long_feature_base.feature_week WEEK))
    ),
    CURRENT_TIMESTAMP
FROM `moocdb`.user_long_feature_base
INNER JOIN `moocdb`.user_dropout AS user_dropout
    ON user_dropout.user_id = user_long_feature_base.user_id
;

UPDATE `moocdb`.user_long_feature
SET feature_value = 0
WHERE feature_id = 934
    AND feature_value IS NULL
;