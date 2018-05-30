DROP TABLE if exists `moocdb`.`feature`;

CREATE TABLE `moocdb`.`feature` (
  `feature_value_id` INT NOT NULL AUTO_INCREMENT ,
  `feature_id` INT(3) NULL ,
  `feature_value` DOUBLE NULL ,
  `date_of_extraction` DATETIME NOT NULL ,
  PRIMARY KEY (`feature_value_id`),
  INDEX (`feature_id`)
);