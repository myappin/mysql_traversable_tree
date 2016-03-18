DROP PROCEDURE IF EXISTS UpdateTraversable;
CREATE PROCEDURE `UpdateTraversable`(IN tb_name VARCHAR(100))
  BEGIN
    DECLARE v_rollback BOOL DEFAULT 0;
    DECLARE v_finished BOOL DEFAULT 0;

    DECLARE v_id INT(10);

    DECLARE v__left INT(10) DEFAULT 0;
    DECLARE v__right INT(10) DEFAULT 1;

    DECLARE root_cursor CURSOR FOR SELECT `id`
                                   FROM `_traversable_cursor_view`
                                   WHERE `id_parent` IS NULL
                                   GROUP BY `id`
                                   ORDER BY `position`, `id`;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
      SET v_rollback = 1;
      GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
      SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
      SELECT @full_error;
    END;

    START TRANSACTION;

    SET @query = CONCAT('CREATE VIEW `_traversable_cursor_view` AS SELECT DISTINCT `id`, `id_parent`, `position` FROM ',
                        tb_name,
                        ' GROUP BY `id` ORDER BY `position`, `id`');
    PREPARE create_view FROM @query;
    EXECUTE create_view;
    DEALLOCATE PREPARE create_view;

    OPEN root_cursor;
    read_loop: LOOP
      FETCH root_cursor
      INTO v_id;
      IF (v_finished > 0)
      THEN
        LEAVE read_loop;
      END IF;
      CALL UpdateTraversable_Recursion(tb_name, v_id, v__left, v__right, 0);
      SET v__left = v__left + 1;
      SET v__right = v__right + 1;
    END LOOP;

    DROP VIEW _traversable_cursor_view;

    COMMIT;
  END;