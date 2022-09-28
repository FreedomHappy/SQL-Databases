-- 存储过程 游标模版
DROP PROCEDURE IF EXISTS snapshot_compress_delete;
CREATE PROCEDURE snapshot_compress_delete()
BEGIN
    -- Declare local variables
    DECLARE done INT DEFAULT 0;
    DECLARE t_error INTEGER;

    DECLARE deleteOrderItemId bigint;
    DECLARE deleteOrderMainId bigint;

    -- Declare the cursor
    DECLARE snapshot_compress_delete_cur CURSOR
        FOR
        select coi.order_item_id, com.order_main_id
        from `cre-sigma-dev`.order_item coi
                 inner join `cre-sigma-dev`.order_main com on coi.order_item_id = com.order_main_id
        where coi.offer_id = 10031
          and coi.order_item_id not in
              (select substring_index(group_concat(coi.order_item_id order by create_time), ',', 1)
               from `cre-sigma-dev`.order_item coi
                        inner join `cre-sigma-dev`.order_main com on coi.order_item_id = com.order_main_id
               where coi.offer_id = 10031
                 and com.order_state = 'OSN'
               group by com.cust_id);

    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    #     -- Declare exception handler
#     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1;

#     -- 事务开启
#     START TRANSACTION;

    -- Open the cursor
    OPEN snapshot_compress_delete_cur;

    -- Loop through all rows
    REPEAT # 也可用循环语句加LEAVE
    -- Get subscription cur and info
        FETCH snapshot_compress_delete_cur INTO deleteOrderItemId, deleteOrderMainId;
        IF done != 1 THEN

        END IF;
        -- End of loop
    UNTIL done = 1 END REPEAT;

    -- Close the cursor
    CLOSE snapshot_compress_delete_cur;

    #     -- 事务判断
#     IF t_error = 1 THEN
#              ROLLBACK;
#         ELSE
#             COMMIT;
#          END IF;
END;

CALL snapshot_compress_delete();
DROP PROCEDURE IF EXISTS snapshot_compress_delete;

-- 存储过程 双游标模版
DROP PROCEDURE IF EXISTS ecs_data_disk_generate;
CREATE PROCEDURE ecs_data_disk_generate()
BEGIN
    -- Declare local variables
    DECLARE done INT DEFAULT 0;
    DECLARE t_error INTEGER;

    DECLARE hasDataDiskOrderItemId bigint;
    DECLARE deleteOrderMainId bigint;

    -- 定义查询包含data disk的订单 游标1
    DECLARE query_data_disk_exists_order_item_cur CURSOR
        FOR
        select distinct order_item_id
        from instance_product ip
        where ip.product_id = 10009
          and type_flag = 'datadisk';
    -- 定义查询data disk的产品信息 游标2
    DECLARE query_data_disk_cur CURSOR FOR
        select *
        from instance_product
        where order_item_id = hasDataDiskOrderItemId
          and type_flag = 'datadisk'
          and product_id = 10009;


    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    #     -- Declare exception handler
#     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET t_error = 1;

#     -- 事务开启
#     START TRANSACTION;

    -- Open 1. 查询包含data disk的订单 游标1
    OPEN query_data_disk_exists_order_item_cur;

    -- Loop through all rows
    REPEAT # 也可用循环语句加LEAVE
    -- Get order_item_id
        FETCH query_data_disk_exists_order_item_cur INTO hasDataDiskOrderItemId;
        IF done != 1 THEN
             -- Open 1. 查询包含data disk的订单 游标1
            OPEN query_data_disk_exists_order_item_cur;
                REPEAT # 也可用循环语句加LEAVE
                FETCH query_data_disk_exists_order_item_cur INTO hasDataDiskOrderItemId;
                IF done != 1 THEN

                END IF;
                UNTIL done = 1 END REPEAT;
            CLOSE query_data_disk_exists_order_item_cur;
            set done = 0;
        END IF;
        -- End of loop
    UNTIL done = 1 END REPEAT;

    -- Close the cursor
    CLOSE query_data_disk_exists_order_item_cur;

    #     -- 事务判断
#     IF t_error = 1 THEN
#              ROLLBACK;
#         ELSE
#             COMMIT;
#          END IF;
END;

CALL ecs_data_disk_generate();
DROP PROCEDURE IF EXISTS ecs_data_disk_generate;
