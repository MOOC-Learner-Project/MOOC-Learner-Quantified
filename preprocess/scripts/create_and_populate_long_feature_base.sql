DROP TABLE if exists `moocdb`.`long_feature_base`;

CREATE TABLE `moocdb`.`long_feature_base` (
  `feature_week` INT(2) NULL ,
  INDEX (`feature_week`)
);

DROP PROCEDURE IF EXISTS `moocdb`.populate_long_feature_base;

CREATE PROCEDURE `moocdb`.populate_long_feature_base()
BEGIN
    declare week INT;
    SET week := 1;
    WHILE week <= 10 DO
        INSERT INTO long_feature_base (feature_week)
        SELECT week;
        SET week := week + 1;
    END WHILE;
END;

CALL `moocdb`.populate_long_feature_base();