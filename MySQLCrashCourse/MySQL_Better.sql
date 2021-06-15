/*
 * MySQL实战45讲
 * url: https://time.geekbang.org/column/article/67888
 */

 /*
    索引
  */

show variables like 'general_log';
select * from information_schema.innodb_trx;

show create table orders;





/*
 * 进一步深入学习MySQL
 */

/*
 数据库级别操作， 数据库属性操作
 */
 -- 查看表结构
desc customers;
describe customers;
explain customers;
show COLUMNS FROM customers;
explain orders;

-- 查看建表sql语句
show create table customers;

-- 查看表的统计信息
show table status;
show table status like '%customer%';

-- 复制备份表
create table customers_bak like customers;
INSERT INTO customers_bak SELECT * FROM customers;

/**
  SQL执行优化，执行计划
  ref: https://blog.csdn.net/weixin_37968613/article/details/114652178
 */
explain test_index;
-- 根据主键等值查询，const
explain select * from test_index where id = 2;

-- 根据普通唯一索引等值查询,const
explain select * from test_index where key2 = 10;

-- 根据普通索引等值匹配,ref
explain select * from test_index where key1 = 'key112';

-- 根据主键索引进行范围查询,range
explain select * from test_index where id < 100;

-- 根据普通唯一索引进行范围查找,range
explain select * from test_index where key2 < 20 and key2 > 10;

-- 根据联合索引的最左列查询索引列的值,ref, 最左前缀，覆盖索引
explain select key_part1,key_part2,key_part3 from test_index where key_part1 = 'key_part112';

-- 根据联合索引的非最左列查询索引列的值，index
explain select key_part1,key_part2,key_part3 from test_index where key_part2 = 'key_part212';

-- 根据联合索引的非最左列查询索引列的值
explain select * from test_index where key_part2 = 'key_part212';

/**
  MySQL事务
 */
-- 查到当前执行中的事务
select * from information_schema.INNODB_TRX;