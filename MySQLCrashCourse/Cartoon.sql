/*
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