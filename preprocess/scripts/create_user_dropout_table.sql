DROP TABLE if exists `moocdb`.`user_dropout`;

CREATE TABLE `moocdb`.`user_dropout` (
  `user_id` VARCHAR(63) NOT NULL,
  `start_timestamp` DATETIME NULL,
  `dropout_timestamp` DATETIME NULL,
  `dropout_week` INT(2) NULL ,
  PRIMARY KEY (`user_id`)
);
