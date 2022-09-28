/**
 * 索引研究,mysql索引访问方式实践 （const、ref、range、index、all、index merge）
 * ref: https://blog.csdn.net/weixin_37968613/article/details/114652178
 */
create table test_index
(
    id           INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    key1         VARCHAR(100),
    key2         INT,
    key3         VARCHAR(100),
    key_part1    VARCHAR(100),
    key_part2    VARCHAR(100),
    key_part3    VARCHAR(100),
    common_field VARCHAR(100),
    KEY idx_key1 (key1),
    UNIQUE KEY idx_key2 (key2),
    KEY idx_key3 (key3),
    KEY idx_key_part (key_part1, key_part2, key_part3)
) Engine = InnoDB CHARSET = utf8mb4;


DROP PROCEDURE IF EXISTS insert_into_test_index;
DELIMITER //
CREATE PROCEDURE insert_into_test_index()
BEGIN
    SET @i := 1;
    WHILE @i <= 100000 DO -- 插入数据条数
    SET @key1 := concat('key1', @i);
    SET @key2 := FLOOR(@i); -- floor函数（如FLOOR(X)）返回小于等于X的最大整数
    SET @key3 := concat('key1', @i);
    SET @key_part1 := concat('key_part1', @i);
    SET @key_part2 := concat('key_part2', @i);
    SET @key_part3 := concat('key_part3', @i);
    SET @common_field := concat('common_field', @i);

    INSERT INTO test_index VALUES (@i, @key1, @key2, @key3, @key_part1, @key_part2, @key_part3, @common_field);
    SET @i := @i + 1;
    if @i % 100 = 0 then
        COMMIT;
    end if ;
    END WHILE;
END //
CALL insert_into_test_index();

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------