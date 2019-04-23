
use test

--案例1
  --表1：客户资料表，包含以下字段：客户号（不可为空，唯一），姓名，性别(取值为男或女)，年龄，资金余额 主键为客户号。  
  --表2：资金变更表：客户号，变更时间，变更类型（存或取），变更金额。
--1、	要求学生根据上述要求，创建二张表，类型根据实际自行定义，必须满足规定的完整性约束。
		create table customer
		(customerno varchar(20) primary key,
		 customername varchar(20),
		 sex   varchar(5) check(sex='男' or sex='女'),
		 age   numeric(20),
		 rest  numeric(20)
		)

		create table change
		(
		   customerno varchar(20) primary key foreign key references customer(customerno),
		   changedate date,
		   changetype varchar(5) check(changetype='存' or changetype='取'),
		   changemoney numeric(20)
		)

--2、	表创建完毕，要求学生自行构造数据，为每张表插入至少5笔记录
        bulk insert customer from 'F:\a软件工程学科文件\customer.txt'
		with
		( fieldterminator=',',
		  rowterminator ='\n'
		)
		 bulk insert change from 'F:\a软件工程学科文件\change.txt'
		with
		( fieldterminator=',',
		  rowterminator ='\n'
		)
      
--3、	要求学生使用ALTER TABLE 语句对表进行修改。可以要求学生增加新的字段，
--比如客户资料表中增加身份证号。刚修改后的新字段的值为NULL，此时可以根据实际情况考核与NULL有关的知识点。
alter table customer
add id varchar(20)
select * from customer

--4、	UPDATE及DELETE的考核，根据表中的内容，要求学生将特定的记录进行修改和删除。
        update customer 
		set rest=3000
		where customername='赵少帅'

		delete
		from change 
		where customerno='5'  --删除customer失败
--5、	SELECT语句的考核，比如查询20007/01/01后存款的女客户的年龄和资金余额。
           select customername,age ,rest
		   from customer
		   where customerno in(select customerno from change where changedate='2017-1-1' and changetype='存')
		         and sex='男'
--6、	COUNT AVG SUM等函数的考核，教师根据实际情况随机出题。
		select count(distinct customerno)
		from change
--7、	分组查询（GROUP BY）及JOIN的考核，比如要求学生查询男女客户的存取金额等
	    select sum(changemoney),sex,changetype 
		from change ch ,customer cu	
		where ch.customerno=cu.customerno 
        group by sex,changetype 
--8、	HAVING的考核，对上述查询的结果进行筛选，比如只要查询发生金额大于1000的记录等。
		select sum(changemoney),sex,changetype 
		from change ch ,customer cu	
		where ch.customerno=cu.customerno 
        group by sex,changetype 
		having sum(changemoney)>200
--9、	ORDER BY 的考核，随机要求学生根据特定的字段进行排序。
		select*
		from customer
		order by customerno desc
--10、	子查询的考核，查询与姓刘的客户同时存款的客户资料（要求学生要用IN谓词完成）。
		select*  from customer where customerno in
		(select  customerno
		from change 
		where changedate in 
		(select ch.changedate
		from customer cu,change ch
		where customername like '赵%'and  changetype='存'and cu.customerno=ch.customerno))



