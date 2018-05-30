INSERT INTO `moocdb`.user_dropout(user_id)
SELECT DISTINCT submissions.user_id from submissions;

UPDATE `moocdb`.`user_dropout`
SET user_dropout.start_timestamp = (
    SELECT click_events.observed_event_timestamp
    FROM `moocdb`.`click_events` AS click_events
    WHERE click_events.user_id = user_dropout.user_id
    ORDER BY click_events.observed_event_timestamp
    LIMIT 1
)
;

UPDATE `moocdb`.`user_dropout`
SET user_dropout.dropout_timestamp = (
    SELECT submissions.submission_timestamp
    FROM `moocdb`.`submissions` AS submissions
    WHERE submissions.user_id = user_dropout.user_id
    ORDER BY submissions.submission_timestamp DESC
    LIMIT 1
)
;

UPDATE `moocdb`.`user_dropout`
SET user_dropout.dropout_week = TIMESTAMPDIFF(WEEK, user_dropout.start_timestamp, user_dropout.dropout_timestamp) + 1
;

UPDATE `moocdb`.`user_dropout`
SET user_dropout.dropout_week = NULL
WHERE user_dropout.dropout_week < 0
;