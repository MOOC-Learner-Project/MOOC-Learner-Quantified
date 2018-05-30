DROP TABLE if exists `moocdb`.`long_feature`;

CREATE TABLE `moocdb`.`long_feature` (
  `feature_value_id` INT NOT NULL AUTO_INCREMENT ,
  `feature_id` INT(3) NULL ,
  `feature_week` INT(2) NULL ,
  `feature_value` DOUBLE NULL ,
  `date_of_extraction` DATETIME NOT NULL ,
  PRIMARY KEY (`feature_value_id`),
  INDEX (`feature_id`, `feature_week`)
);