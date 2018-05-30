DROP TABLE if exists `moocdb`.`user_long_feature_base`;

CREATE TABLE `moocdb`.`user_long_feature_base` (
  `user_id` VARCHAR(63) NULL ,
  `feature_week` INT(2) NULL ,
  INDEX (`user_id`, `feature_week`)
);

DROP PROCEDURE IF EXISTS `moocdb`.populate_user_long_feature_base;

CREATE PROCEDURE `moocdb`.populate_user_long_feature_base()
BEGIN
BLOCK1: BEGIN
    declare week INT;
    declare user_idx VARCHAR(63);
    declare no_more_rows1 boolean DEFAULT FALSE;
    declare cursor1 cursor for
        select user_id
        from   user_dropout;
    declare continue handler for not found
        set no_more_rows1 := TRUE;
    open cursor1;
    LOOP1: loop
        fetch cursor1
        into  user_idx;
        if no_more_rows1 then
            close cursor1;
            leave LOOP1;
        end if;
        SET week := 1;
        WHILE week <= 10 DO
            INSERT INTO user_long_feature_base (user_id, feature_week)
            SELECT user_idx, week;
            SET week := week + 1;
        END WHILE;
    end loop LOOP1;
END BLOCK1;
END;

CALL `moocdb`.populate_user_long_feature_base();