f/*
SELECT
*/

# DISTINCT 应用所有列
SELECT DISTINCT vend_id
FROM products;

# 行0检索出来的第一行为行0；行5其实是第6行
SELECT prod_name
FROM products
LIMIT 5;
SELECT prod_name
FROM products
LIMIT 5,5;

SELECT prod_name
FROM products
LIMIT 4 OFFSET 3;#从行3开始取4行

/*
 ORDER
 */
# DESC只应用到前置列
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC,prod_name;

SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC
LIMIT 1;

/*
where
*/

SELECT prod_name, prod_price
FROM products
WHERE prod_name='fuses'; # 匹配时默认不区分大小写

SELECT prod_name, prod_price
FROM products
WHERE prod_price BETWEEN 5 AND 10; # 闭区间

SELECT cust_id
FROM customers
WHERE cust_email IS NULL;

# AND 优先级高于 OR
SELECT prod_name, prod_price
FROM products
WHERE vend_id = 1002 OR vend_id = 1003 AND prod_price >= 10;

SELECT prod_name, prod_price
FROM products
WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10;

SELECT prod_name, prod_price
FROM products
WHERE vend_id IN (1002,1003) # 等价于 vend_id = 1002 OR vend_id = 1003
ORDER BY prod_name;

# MySQL 支持NOT对IN，BETWEEN，EXISTS子句取反
SELECT prod_name, prod_price
FROM products
WHERE vend_id NOT IN (1002,1003) # 等价于 vend_id = 1002 OR vend_id = 1003
ORDER BY prod_name;

/*
通配符，处理时间一般较长，不要过度使用
*/

# MySQL 可以配置搜索区分大小写
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE 'jet%'; # % 任何字符出现任何次数，但无法匹配NULL

SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE '_ ton anvil'; # _ 匹配一个字符

/*
 正则表达式 （NySQL中仅是一个子集）
 */
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000'
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name LIKE '1000' # REGEXP在列值内进行匹配，LIKE匹配整个列  ？LIKE 与 REGEXP的区别
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP BINARY 'JetPack .000' # BINARY 区分大小写，.表匹配任意一个字符
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000｜2000' # ？此出失效返回为空
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[123] Ton' # 等价于 '[1|2|3] Ton'
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '1|2|3 Ton'
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[^123] Ton' # ^表否定
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[1-5] Ton' # [a-z]表从a到z
ORDER BY prod_name;

SELECT vend_name
FROM vendors
WHERE vend_name REGEXP '\\.' # \\转义字符，可用来引用元字符（如空白元字符）， 两个反斜杠即MySQL和正则各一个
ORDER BY vend_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '\\([0-9] sticks?\\)' # ?匹配前面任何字符0次或一次出现
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[[:digit:]]{4}]' #
ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '^[0-9\\.]' # ^此时表文本开头
ORDER BY prod_name;

# 简单正则测试
SELECT 'hello' REGEXP '[0-9]'; # 返回0表示没有匹配，1表示匹配

/*
 计算字段
 */

SELECT CONCAT(vend_name, ' (', vend_country, ')')
FROM vendors
ORDER BY vend_name;

SELECT CONCAT(RTRIM(vend_name), ' (', vend_country, ')') # TRIM,LTRIM
FROM vendors
ORDER BY vend_name;

SELECT CONCAT(vend_name, ' (', vend_country, ')') AS vend_title
FROM vendors
ORDER BY vend_name;

SELECT prod_id,
       quantity,
       item_price,
       quantity*item_price AS expanded_price
FROM orderitems
WHERE order_num = 20005;

# 用SELECT测试和实验函数与计算
SELECT 3*6;
SELECT NOW();

/*
 函数
 */

# 文本函数
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM vendors
ORDER BY vend_name;

SELECT cust_name, cust_contact
FROM customers
WHERE cust_contact = 'Y. Lie';

SELECT cust_name, cust_contact
FROM customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Y. Lie'); # SOUNDEX 转换列值和搜索串

# 日期和时间 格式为：yyyy-mm-dd
SELECT cust_id, order_num
FROM orders
WHERE order_date = '2005-09-01'; # order_date datetime(存储：日期+时间)

SELECT cust_id, order_num
FROM orders
WHERE DATE(order_date) = '2005-09-01'; # Date()提取日期，Time()提取时间

SELECT cust_id, order_num
FROM orders
WHERE YEAR(order_date) = 2005 AND MONTH(order_date) = 9;

#数值处理函数

/*
 汇总数据 聚集函数
 */

# AVG 忽略列值=NULL的行
SELECT AVG(prod_price) AS avg_price
FROM products;

# COUNT
SELECT COUNT(*) AS num_cust # COUNT(*) 列值=NULL加入
FROM customers;

SELECT COUNT(cust_email) AS num_cust # COUNT(cust_email) cust_email=NULL忽略不加入
FROM customers;

# MAX 忽略列值=NULL的行 可以对文本数据使用
SELECT MAX(prod_price) AS max_price
FROM products;

# MIN 忽略列值=NULL的行 可以对文本数据使用
SELECT MIN(prod_price) AS min_price
FROM products;

# SUM 忽略列值=NULL的行
SELECT SUM(quantity) AS items_ordered
FROM orderitems
WHERE order_num = 20005;

SELECT SUM(item_price*quantity) AS total_price
FROM orderitems
WHERE order_num = 20005;

SELECT AVG(DISTINCT prod_price) AS avg_price
FROM products
WHERE vend_id = 1003;


/*
 分组数据
 */

# NULL值不忽略 亦分组; 不按分组数据输出
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id;

SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id WITH ROLLUP; # 各分组的汇总

# 过滤分组
SELECT cust_id, COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;

SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price >= 10
GROUP BY vend_id
HAVING COUNT(*) >= 2;

# 排序
SELECT  order_num, SUM(quantity*item_price) AS ordertotal
FROM orderitems
GROUP BY order_num
HAVING SUM(quantity*item_price) >= 50
ORDER BY ordertotal
LIMIT 2;

/*
 子查询 逐渐增加子查询来建立查询
 */
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT  cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                     WHERE  prod_id = 'TNT2') );
# 相关子查询
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM orders
        WHERE orders.cust_id = customers.cust_id) AS orders
FROM customers
ORDER BY cust_name;


/*
 联结
 */
SELECT vend_name, prod_name, prod_price
FROM  vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;

# 明确指定联结的类型 -内联结
SELECT vend_name, prod_name, prod_price
FROM vendors INNER JOIN products
ON vendors.vend_id = products.vend_id;

# 代替子查询
SELECT cust_name, cust_contact
FROM customers
WHERE cust_id IN (SELECT  cust_id
                  FROM orders
                  WHERE order_num IN (SELECT order_num
                                      FROM orderitems
                                     WHERE  prod_id = 'TNT2') );

SELECT cust_name, cust_contact
FROM customers, orders, orderitems
WHERE  customers.cust_id = orders.cust_id
    AND orderitems.order_num = orders.order_num
    AND prod_id = 'TNT2';

# 自联结
SELECT p1.prod_id, p1.prod_name
FROM products AS p1, products AS p2
WHERE p1.vend_id = p2.vend_id
    AND p2.prod_id = 'DTNTR';

# 自然联结 排除多次出现，使每个列只返回一次 ?返回空
SELECT c.*, o.order_num, o.cust_id,oi.prod_id,oi.quantity,oi.item_price
FROM customers AS c, orders AS o, orderitems oi
WHERE c.cust_id = o.cust_id
    AND oi.order_num = o.order_num
    AND prod_id = 'F8';

# 外部联结
SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id;

# 使用聚集函数
SELECT customers.cust_name,
       customers.cust_id,
       COUNT(orders.order_num) AS num_ord
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id
GROUP BY customers.cust_id;

/*
 组合查询
 1.单个查询中从不同的表返回类似结构的数据
 2.单个表执行多个查询，按单个表返回数据
 */
 # UNION 列数据必须兼容
SELECT * FROM products WHERE prod_price <= 5
UNION
SELECT * FROM products WHERE vend_id IN (1001,1002);
# 等价于
SELECT * FROM products
WHERE prod_price <= 5
OR vend_id IN (1001,1002);

# 包含所有匹配行，包含重复行
SELECT * FROM products WHERE prod_price <= 5
UNION ALL
SELECT * FROM products WHERE vend_id IN (1001,1002);

# ORDER BY 对UNION结构集排序，不可分别排序
SELECT * FROM products WHERE prod_price <= 5
UNION
SELECT * FROM products WHERE vend_id IN (1001,1002)
ORDER BY vend_id, prod_price;

/*
 全文本搜索
 1.常用数据引擎：MyISAM，InnoDB
 2.MyISAM支持全文本搜索
 3.不要在导入数据时使用FULLTEXT索引
 */

# 在索引之后，使用Match()指定被搜索的列，Against()指定要使用的搜索表达式
# 传递给MATCH()的值必须与FULLTEXT()定义的相同，指定多个列，则必须列出（而且次序正确）
# 智能排序
# 默认不区分大小写
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('rabbit');

# 智能排序
SELECT note_text, MATCH(note_text) AGAINST('rabbit') AS rank
FROM productnotes;

# 查询扩展，放宽搜索
# 查询两次
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('anvils' WITH QUERY EXPANSION);

# 布尔全文搜索 （没有FULLTEXT索引也可使用，但耗性能）
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('heavy' IN  BOOLEAN MODE);

# 排除rope开始的行，包括rope
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('heavy -rope*' IN  BOOLEAN MODE);
#包含词rabbit和bait的行
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('+rabbit +bait' IN BOOLEAN MODE );
# 包含词rabbit和bait的至少一个的行
SELECT note_text
FROM productnotes
WHERE MATCH(note_text ) AGAINST('rabbit bait' IN BOOLEAN MODE );
# 匹配短语
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('"rabbit bait"' IN BOOLEAN MODE );
# 匹配rabbit, carrot,增加前者的等级，降低后者的等级
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('>rabbit <carrot' IN BOOLEAN MODE );
# 匹配safe, combination,降低后者的等级
SELECT note_text
FROM productnotes
WHERE MATCH(note_text) AGAINST('+safe +(<combination)' IN BOOLEAN MODE);
/*
 插入数据
*/
# 不安全
INSERT INTO customers
VALUES(NULL, 'Pep E. LaPew','100 Main Street','Los Angeles','CA','90046','USA',NULL,NULL);
# 安全
INSERT INTO customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES ('Pep E. LaPew','100 Main Street','Los Angeles','CA','90046','USA',NULL,NULL);

# 插入多条
INSERT INTO customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES ('Pep E. LaPew','100 Main Street','Los Angeles','CA','90046','USA',NULL,NULL),
       ('M. Martin', '42 Galaxyc Way', 'New York', 'NY', '11213','USA',NULL,NULL);
# 插入检索出的数据
# 按列的位置填充而不是列名
INSERT INTO customers(
                      cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email
) SELECT cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email
from custnew;

/*
 更新删除
 使用UPDATE,DELET前先使用SELECT进行测试
 */
# UPDATE 最好添加WHERE子句，28章谈限制和控制UPDATE的使用
# 使用SELECT检索出的数据更新列数据
# IGNORE 关键字即使发生错误也继续更新，UPDATE默认一行出错整个操作取消，
UPDATE customers
SET cust_email = 'elmer@fudd.com',
    cust_name = 'The Fudds'
WHERE cust_id = 10005;
#删除某个列值
UPDATE customers
SET cust_email = NULL,
    cust_name = 'The Fudds'
WHERE cust_id = 10005;


# DELETE 最好添加WHERE子句，28章谈限制和控制DELETE的使用
DELETE FROM customers
WHERE cust_id = 10006;

/*
 创建和操纵表
 */
# 处理现有的表
# CREATE TABLE IF NOT EXISTS `global_table`
# (
#     `xid`                       VARCHAR(128) NOT NULL,
#     `transaction_id`            BIGINT,
#     `status`                    TINYINT      NOT NULL,
#     `application_id`            VARCHAR(32),
#     `transaction_service_group` VARCHAR(32),
#     `transaction_name`          VARCHAR(128),
#     `timeout`                   INT,
#     `begin_time`                BIGINT,
#     `application_data`          VARCHAR(2000),
#     `gmt_create`                DATETIME,
#     `gmt_modified`              DATETIME,
#     PRIMARY KEY (`xid`),
#     KEY `idx_gmt_modified_status` (`gmt_modified`, `status`),
#     KEY `idx_transaction_id` (`transaction_id`)
# ) ENGINE = InnoDB
#
# DROP TABLE IF EXISTS `bill_voucher_record`;
# create table bill_voucher_record
# (
#    bill_voucher_record_id bigint(12) not null auto_increment,
#    bill_record_id       varchar(36),
#    acct_voucher_id      bigint(12),
#    charge               decimal(24,6) comment '费用金额',
#    primary key (bill_voucher_record_id)
# );

# AUTO_INCREMENT
SELECT last_insert_id();
# DEFAULT MySQL只支持常量，不支持函数
CREATE TABLE orderitems
(
  order_num  int          NOT NULL ,
  order_item int          NOT NULL ,
  prod_id    char(10)     NOT NULL ,
  quantity   int          NOT NULL DEFAULT 1,
  item_price decimal(8,2) NOT NULL ,
  PRIMARY KEY (order_num, order_item)
) ENGINE=InnoDB;

# 混用引擎，不同的表可以使用不同的引擎，但是外键不能跨引擎

# 更新表
ALTER TABLE vendors
ADD vend_phone CHAR(20);

ALTER TABLE vendors
DROP COLUMN vend_phone;

# 定义外键
ALTER TABLE orderitems ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_num) REFERENCES orders (order_num);

# 删除表
DROP TABLE customers2;
# 重命名表
RENAME TABLE backup_customers TO customers,
             backup_vendors TO vendors;

/*
 视图
 1.视图不包含任何数据，因此返回的数据是从其他表中检索出来的，每次使用都要执行所需的任何一个检索
 2.不包含任何表中应该有的列和数据，包含的是一个SQL查询
 */
# 1.视图唯一命名
# 2.ORDER BY 如果在检索数据SELECT中存在，则该视图的ORDER BY将被覆盖
# 3.视图无法索引，也不能关联触发器或默认值
# 4.视图可以和表一起使用

# 创建视图
CREATE VIEW productcustomers AS
    SELECT c.cust_name, c.cust_contact, oi.prod_id
    FROM customers c, orders o, orderitems oi
    WHERE c.cust_id = o.cust_id
    AND o.order_num = oi.order_num;
# 查看创建视图的语句
SHOW CREATE VIEW productcustomers;
# 删除视图
DROP VIEW productcustomers;
# 更新视图，无则创建，有则替换
# 视图定义有以下操作则不能更新：
# 分组(GROUP BY,HAVING),
# 联结，子查询，并，聚集函数，DISTINCT,导出（计算）列
CREATE OR REPLACE VIEW

# 查看视图
SELECT cust_name,cust_contact
FROM productcustomers
WHERE prod_id = 'TNT2';
# 格式化检索出的数据
CREATE view vendorlocations AS
    SELECT CONCAT(RTRIM(vend_name), ' (', vend_country, ')') AS vend_title
    FROM vendors
    ORDER BY vend_name;

SELECT * FROM vendorlocations;

# 用视图过滤不想要的数据
CREATE VIEW customeremaillist AS
    SELECT cust_id, cust_name, cust_email
    FROM customers
    WHERE cust_email IS NOT NULL;
SELECT * FROM customeremaillist;

/*
 存储过程
 */
# 执行存储过程
CALL productpricing(@pricelow,
                    @pricehigh,
                    @priceaverage);
# 创建存储过程
CREATE PROCEDURE productpricing()
BEGIN
   SELECT AVG(prod_price) AS priceaverage
   FROM products;
END;
CALL productpricing();
# 删除存储过程
DROP PROCEDURE productpricing;
# 不存在时
DROP PROCEDURE IF EXISTS productpricing;
# 变量 IN 传递给存储过程，out 从存储过程中传出，INOUT 对存储过程传入和传出
CREATE PROCEDURE productpricing(
    OUT pl DECIMAL(8,2),
    OUt ph DECIMAL(8,2),
    OUT pa DECIMAL(8,2)
)
BEGIN
   SELECT MIN(prod_price)
       INTO pl
    FROM products;
   SELECT MAX(prod_price)
       INTO ph
    FROM products;
   SELECT AVG(prod_price)
       INTO pa
    FROM products;
END;

CALL productpricing(@pricelow,@pricehigh,@priceaverage);
SELECT @pricelow, @pricehigh, @priceaverage;

CREATE PROCEDURE ordertotal(
    IN onum INT,
    OUT ototal DECIMAL(8,2)
)
BEGIN
    SELECT SUM(quantity*item_price) FROM orderitems WHERE order_num = onum
    INTO ototal;
END;

CALL ordertotal(20005,@ototal);
SELECT @ototal;


DROP PROCEDURE IF EXISTS ordertotal;
CREATE PROCEDURE ordertotal(IN onum INT,
                            IN taxable BOOLEAN,
                            OUt ototal DECIMAL(8,2))
                            COMMENT 'Obtain order total, optionally adding tax'
BEGIN
    -- Declare variable for total
    DECLARE total DECIMAL(8,2);
    -- Declare tax percentage
    DECLARE taxrate INT DEFAULT 6;

    -- Get the order total
    SELECT SUM(quantity*item_price) FROM orderitems WHERE order_num = onum
    INTO total;

    -- IS this taxable?
    IF taxable THEN
        -- yes, so add taxrate to the total
        SELECT total+(total/100*taxrate) INTO total;
    END IF;

    -- finally , save to our variable
    SELECT total INTO ototal;
END;

CALL ordertotal(20005,0,@total);
SELECT @total;
CALL ordertotal(20005,1,@total);
SELECT @total;
# 查看存储过程
SHOW PROCEDURE STATUS;
SHOW PROCEDURE STATUS LIKE 'ordertotal';
SHOW CREATE PROCEDURE ordertotal;



/*
 游标
 1.游标是MySQl服务器上的数据库查询，是SELECT语句的结果集
 2.MySQL游标只能用于存储过程（和函数）
 */
 # DECLARE 定义游标，存储过程处理完成后，游标就消失（局限于存储过程）
DROP PROCEDURE IF EXISTS processorders;
CREATE PROCEDURE processorders()
BEGIN
    -- 定义顺序：局部变量，游标，句柄。否则出错
    -- Declare local variables
    DECLARE done BOOLEAN DEFAULT 0;
    DECLARE  o INT;
    DECLARE t DECIMAL(8,2);

    -- Declare the cursor
    DECLARE ordernumbers CURSOR
        FOR
    SELECT order_num FROM orders;

    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;# 条件出现时被执行，'02000'表未找到条件

    -- Create a table to store the results
    CREATE TABLE IF NOT EXISTS ordertotals
        (order_num INT, total  DECIMAL(8,2));

    -- Open the cursor
    OPEN ordernumbers;

    -- Loop through all rows
    REPEAT # 也可用循环语句加LEAVE
        -- Get order number
        FETCH ordernumbers INTO o;

        -- Get the total for this order
        CALL ordertotal(o,1,t);

        -- Insert order and total into ordertotals
        INSERT INTO ordertotals(order_num, total) VALUES (o,t);

    -- End of loop
    UNTIL done END REPEAT ;

    -- Close the cursor
    CLOSE ordernumbers;
END;

CALL processorders();
SELECT * from ordertotals;




/*
 触发器
 1.MySQl响应DELETE，INSERT，UPDATE，或位于BEGIN和END语句之间的一组语句
 */
# 1.每个数据库唯一的触发器名
# 2.触发器关联的表
# 3.触发器应该响应的活动
# 4.触发器何时执行
# 5.仅支持表
# 6.每个表最多支持6个触发器，单一触发器不能与多个事件或多个表关联
# 7.BEFORE 触发器失败，则不执行请求的操作，且不执行存在的AFTRER触发器
# 8.MYSQL5以后，不允许触发器返回任何结果
# 9.暂时不支持在触发器内写CALL语句，所以不能调用存储过程
CREATE TRIGGER newproduct AFTER INSERT ON products
    FOR EACH ROW SELECT 'Product added' into @asd;
SELECT @asd;

INSERT INTO vendors(vend_name, vend_address, vend_city, vend_state, vend_zip, vend_country) VALUES
('donghao','Galaxy', 'Xi An', 'SX', '2002','China');
INSERT INTO products(prod_id, vend_id, prod_name, prod_price, prod_desc)
VALUES ('BANDAI','1007', '高达', '248', '我的高达');

# 删除触发器，触发器不能更新或覆盖
DROP TRIGGER IF EXISTS newproduct;

# INSERT 触发器，应用NEW虚拟表访问被插入的行，对于AUTO_INCREMENT列，NEW在执行之前包含0，在INSERT执行之后包含新的自动生成值
CREATE TRIGGER neworder AFTER INSERT ON orders
    FOR EACH ROW SELECT NEW.order_num into @asd;

INSERT INTO orders(order_date, cust_id) VALUES (NOW(),10001);
SELECT @asd;

# DELETE 触发器，引用名为OLD的虚拟表，OLD中的值全部只读
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
    FOR EACH ROW
    BEGIN
        INSERT INTO archive_orders(order_num,order_date,cust_id)
        VALUES (OLD.order_num,OLD.order_date,OLD.cust_id);
    END;

CREATE TABLE archive_orders
(
  order_num  int      NOT NULL AUTO_INCREMENT,
  order_date datetime NOT NULL ,
  cust_id    int      NOT NULL ,
  PRIMARY KEY (order_num)
) ENGINE=InnoDB;
INSERT INTO archive_orders(order_num, order_date, cust_id) SELECT * from orders;
SELECT * FROM archive_orders;


# UPDATE触发器，引用OLD访问UPDATE语句前的值，NEW访问UPDATE语句后的值
# BEFORE UODATE触发器中，NEW的值可能也被更新(允许更改将要用于UPDATE语句中的值)
# OLD中的值全部都是只读，不能更新。
CREATE TRIGGER updatevendor BEFORE UPDATE ON vendors
    FOR EACH ROW SET NEW.vend_state  = upper(NEW.vend_state);



/*
 事务处理
 1.MyISAM不支持事务处理管理，InnoDB支持
 2.维护数据库完整性，保证成批的MySQL操作要么完全执行，要么完全不执行
 */
# ROLLBACK可以回退INSERT,UPDATE,DELETE,不能回退SELECT，CREATE，DROP
SELECT * FROM ordertotals;
START TRANSACTION;
DELETE FROM ordertotals;
SELECT * FROM ordertotals;
ROLLBACK ;
SELECT * FROM ordertotals;

# COMMIT 显式提交
START TRANSACTION ; # 保证订单不被部分删除
DELETE FROM orderitems WHERE order_num=20010;
DELETE FROM orders WHERE order_num = 20010;
COMMIT ;

# SAVEPOINT 部分提交和回退
SAVEPOINT deletel;
ROLLBACK TO deletel;
# 更改默认的提交行为
SET autocommit =0;# 标志是针对每个连接而不是服务器的

/*
 全球化和本地化
 1.字符集，编码，校对
 */
# 使用字符集和校对顺序
SHOW CHARACTER SET ;
SHOW COLLATION ;
SHOW VARIABLES LIKE 'character%';
SHOW VARIABLES LIKE 'collation%';

# 给表指定字符集和校对
CREATE TABLE mytable
    (
        c1  INT,
        c2  VARCHAR(10)
)DEFAULT CHARACTER SET hebrew
    COLLATE hebrew_general_ci;
# 允许对每个列设置
CREATE TABLE mytable
    (
        c1  INT,
        c2  VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_general_ci
)DEFAULT CHARACTER SET hebrew
    COLLATE hebrew_general_ci;
# SELECT 语句中设置
SELECT * FROM customers c
ORDER BY c.cust_name COLLATE latin1_general_cs;

# 串在字符集间转换 CAST(),CONVERT()

/*
 安全管理
 */
# 用户账户信息存储在名为mysql数据库中
# 获取所有用户账户列表
USE mysql;
SELECT user FROM user;

# 创建用户账号
CREATE USER lin IDENTIFIED BY '123';
# 重命名
RENAME USER lindonghao TO lin;
# MySQL5后DROP USER删除用户账号和所有相关的账号权限
DROP USER lindonghao;

# 设置访问权限 USAGE表示没有权限，用户定义为user@host，默认主机名%
SHOW GRANTS FOR lin;
GRANT SELECT,INSERT ON Cartoons.* TO lin;
REVOKE SELECT,INSERT ON Cartoons.* FROM lin; # 撤销的访问权限必须在，否则报错
# 更新用户口令
SET PASSWORD FOR 'lin'@'localhost' = PASSWORD ('1234');


/*
数据库维护
 */
# 刷新保证所有数据被写到磁盘
FLUSH TABLES ;
# 检查表键是否正确
ANALYZE TABLE  orders;

CHECK TABLE orders,orderitems;

/*
 改善性能
 */



use Cartoons;


select * from archive_orders;
select * from orderitems;
select * from customers;
select * from vendors;
select * from products;
select * from orders;
