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


/**
 字符集查看
 */

-- 1. 查看MYSQL数据库服务器和数据库字符集
show variables like '%character%';

show variables like 'collation%';

-- 2. 查看MYSQL所支持的字符集
show charset where Charset = 'utf8mb4';

-- 3. 查看库的字符集
show create database cre-dev;

-- 4. 查看表的字符集
show table status from `cre-dev` like 'user_profile';

-- 5. 查看表中所有列的字符集
show full columns from user_profile;


/**
 mysql自增值查看
 */
show variables like '%auto_inc%';
show session variables like '%auto_inc%';   --  //session会话变量
show global variables like '%auto_inc%';   --  //全局变量

/**
mysql 表库信息查看
 */
-- 表的引擎
SELECT table_name, table_type, engine FROM information_schema.tables
WHERE table_schema = 'cre-sigma-cis'  ORDER BY table_name DESC;

-- 主键不存在的表
select t1.TABLE_SCHEMA,t1.TABLE_NAME from information_schema.`TABLES` t1
LEFT OUTER JOIN information_schema.TABLE_CONSTRAINTS t2 on t1.TABLE_SCHEMA = t2.TABLE_SCHEMA
and t1.TABLE_NAME = t2.TABLE_NAME and t2.CONSTRAINT_NAME in ('PRIMARY')
where t2.TABLE_NAME is NULL
and t1.TABLE_TYPE = 'BASE TABLE'
and t1.TABLE_SCHEMA = 'cre-sigma-cis';