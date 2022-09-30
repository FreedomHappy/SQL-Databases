# SQL-Databases
SQL and databases



# SQL语句分类
SQL语句的五种分类分别是DQL、DML、DDL、TCL和TCL，下面对SQL语句的五种分类进行列举：
1、数据库查询语言（DQL）
数据查询语言DQL基本结构是由SELECT子句，FROM子句，WHERE 子句组成的查询块，简称DQL，Data Query Language。代表关键字为select。

2、数据库操作语言（DML）
用户通过它可以实现对数据库的基本操作。简称DML，Data Manipulation Language。代表关键字为insert、delete 、update。

3、数据库定义语言（DDL）
数据定义语言DDL用来创建数据库中的各种对象，创建、删除、修改表的结构，比如表、视图、索引、同义词、聚簇等，简称DDL，Data Denifition Language。代表关键字为create、drop、alter。和DML相比，DML是修改数据库表中的数据，而 DDL 是修改数据中表的结构。

4、事务控制语言（TCL）
TCL经常被用于快速原型开发、脚本编程、GUI和测试等方面，简称：TCL，Trasactional Control Languag。代表关键字为commit、rollback。

5、数据控制语言（DCL）
数据控制语言DCL用来授予或回收访问数据库的某种特权，并控制数据库操纵事务发生的时间及效果，对数据库实行监视等。简称：DCL，Data Control Language。代表关键字为grant、revoke。


# 数据库操作优化法则归纳为5个层次
1、 减少数据访问（减少磁盘访问）

2、 返回更少数据（减少网络传输或磁盘访问）

3、 减少交互次数（减少网络传输）

4、 减少服务器CPU开销（减少CPU及内存开销）

5、 利用更多资源（增加资源）

