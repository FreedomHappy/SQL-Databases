create database cookbbook
on primary(
      name='cookbook_mdf',
	  filename='F:\我的数据库\cookbook\cookbook.mdf',
	  size=5mb,
	  maxsize=50mb,
	  filegrowth=2mb
   
 )
 log on
 (name='cookbok_ldf',
  filename='F:\我的数据库\cookbook\cookbook.ldf',
  size=5mb,
  maxsize=50mb,
  filegrowth=2mb
 )

 create database school
 on primary
 (name='school_mdf',
  filename='F:\我的数据库\school\school.mdf',
  size=2mb,
  maxsize=5mb,
  filegrowth=1mb
 )
 log on
 (name='school_ldf',
  filename='F:\我的数据库\school\school.ldf',
  size=2mb,
  maxsize=5mb,
  filegrowth=1mb

 )
-----------------------------------------------------------------------------



create database orderdb
create table employee
(
employeeno varchar(8) primary key,
employeename varchar(10),
sex varchar(2),
birthday datetime,
address varchar(50),
telephone varchar(20),
hiredate datetime,
department varchar(30),
headship varchar(10),
salary numeric(8,2)
)
---------------------------
create table customer
(
customerno varchar(9) primary key,
customername varchar(40),
telephone varchar(20),
address varchar(40),
zip varchar(6)
)
---------------------------
create table product
(
productno varchar(9) primary key,
productname varchar(40),
productclass varchar(20),
productprice numeric(7,2),
)
---------------------------
create table ordermaster
(
orderno varchar(12) primary key,
customerno varchar(9),
salerno varchar(8),
orderdate datetime,
ordersum numeric(9,2),
invoiceno char(10),
foreign key (customerno) references customer(customerno)
)
-----------------------------
create table orderdetail
(
orderno varchar(12),
productno varchar(9),
quantity int,
price numeric(7,2),
primary key(orderno,productno),
foreign key (orderno) references ordermaster(orderno),
foreign key (productno) references product(productno)
)
--------------------------------------------------------

bulk insert employee from 'F:\数据库\orderdb数据库创建\employee.txt'
with
(
	fieldterminator = ',',
	rowterminator='\n'
)

bulk insert customer from 'F:\数据库\orderdb数据库创建\customer.txt'
with
(
	fieldterminator = ',',
	rowterminator='\n'
)

bulk insert product from 'F:\数据库\orderdb数据库创建\product.txt'
with
(
	fieldterminator = ',',
	rowterminator='\n'
)

bulk insert ordermaster from 'F:\数据库\orderdb数据库创建\ordermaster.txt'
with
(
	fieldterminator = ',',
	rowterminator='\n'
)

bulk insert orderdetail from 'F:\数据库\orderdb数据库创建\orderdetail.txt'
with
(
	fieldterminator = ',',
	rowterminator='\n'
)











select *from employee 
select * from ordermaster
select * from orderdetail



create view  employee_ordermaster
as
select salerno ,employeename,ordermaster.orderno,orderdetail.productno,price
from employee left outer join ordermaster 
     on (employee.employeeno=ordermaster.salerno)
	  ,orderdetail
where ordermaster.orderno=orderdetail.orderno
   
select *from employee_ordermaster

update employee_ordermaster
set price=600
where orderno='200801090001' and  productno='p2005001'

insert into
employee_ordermaster
values('e2000','林东豪','asdasdasd','asdsadas',234234)

drop view employee_ordermaster
--第四章 简单查询
--（1）查询所有业务部门的员工姓名，职称，薪水
select department,employeename,headship,salary
from employee 
order by department,headship
--（2）查询名字中含有“有限”的客户姓名和所在地
select customername,address
from customer
where customername like '%有限%'

--（3）查询姓“张”并且姓名的最后一个字为“娟”的员工
select employeename
from employee
where employeename like '张%娟'

--（4）查询住址中含有上海或南昌的女员工，并显示其姓名，
--   所属部门，职称，住址，其中性别用“男”和“女”显示。
select  employeename,(case sex when 'F' then '女' when 'M' then '男'end) sex,department,headship,address
from employee
where address='上海市' or address='南昌市' and   sex='M' 
order by address

--（5）查询订单金额高于8000的所有客户编号
update ordermaster
set ordersum=(select sum(quantity* price )
               from orderdetail
			    where ordermaster.orderno=orderdetail.orderno)
select * from ordermaster

select customerno,sum(ordersum) sumorder
from orderdetail,ordermaster
group by customerno
having sum(ordersum)>8000

--（6）选取编号界于C2005001~C2005003的客户编号，客户名称，客户地址
select *from customer
select customerno,customername,address
from customer
where customerno between 'c2005001' and 'c2005003'


--（7）找出同一天进入公司服务的员工
select distinct a.employeename,a.hiredate
from employee a,employee b
where a.hiredate=b.hiredate and a.employeename!=b.employeename
order by a.hiredate



update orderdetail
set price=100
where orderno='200801090001'
select * from orderdetail
select * from ordermaster
select *from product

update  orderdetail 
set   productno='p2007002'
where orderno='200801090001' and quantity=2

--（8）在订单主表中查询订单金额大于“E2005002”业务员在2008-1-9这天所接的任一张订单的金额”的所有订单信息。

select *
from ordermaster om,orderdetail od
where  om.orderno=od.orderno and om.orderno in
(select orderno
 from orderdetail
 where price >all
  (select price 
  from orderdetail ,ordermaster  
  where orderdetail.orderno=ordermaster.orderno 
      and salerno='E2005002'
	  and orderdate='2008-01-09'
	)
)



--（9）查询既订购了“52倍速光驱”商品，又订购了“17寸显示器”商品的客户编号、订单编号和订单金额。	

select distinct customerno,ol.orderno,ol.price
from orderdetail ol ,ordermaster ot
where  ol.orderno=ot.orderno and
ol.orderno in
(select orderno 
from orderdetail od,product pt
where   od.productno=pt.productno and pt.productname='52倍速光驱'

intersect

select orderno 
from orderdetail od,product pt
where   od.productno=pt.productno and pt.productname='17寸显示器')


--（10）查找与“陈诗杰”在同一个单位工作的员工姓名、性别、部门和职务。
select employeename,sex,department,headship
from employee
where department=
(select department
from employee
where employeename='陈诗杰'
)and employeename!='陈诗杰'

select e1.employeename,e1.sex,e1.department,e1.headship
from employee e1,employee e2
where  e1.department=e2.department and e2.employeename='陈诗杰'

--（11）查询单价高于400元的商品编号、商品名称、订货数量和订货单价。
select  pt.productno,pt.productname,sum(od.quantity) quantity,pt.productprice
from orderdetail od,product pt
where  od.productno=pt.productno and pt.productprice>400
group by pt.productno,productname,productprice


--（12）分别使用左外连接、右外连接、完整外部连接查询单价高于400元的商品编号、商品名称、订货数量和订货单价，并分析比较检索的结果。

select  pt.productno,pt.productname,od.quantity ,pt.productprice
from orderdetail od left outer join product pt on (  od.productno=pt.productno )
where pt.productprice>400

select  pt.productno,pt.productname,od.quantity,pt.productprice
from orderdetail od right outer join product pt on (  od.productno=pt.productno )
where pt.productprice>400

select  pt.productno,pt.productname,od.quantity ,pt.productprice
from orderdetail od full outer join product pt on (  od.productno=pt.productno )
where pt.productprice>400


---（13）查找每个员工的销售记录，要求显示销售员的编号、姓名、性别、商品名称、数量、单价、金额和销售日期，
--其中性别使用“男”和“女”表示，日期使用yyyy-mm-dd格式显示。

update ordermaster
set ordersum=temp.total
from ordermaster om,(select orderno,SUM(quantity*price) total from orderdetail group by orderno) temp
where om.orderno=temp.orderno

select om.orderno,om.orderno,om.salerno,em.employeename,(case sex when 'F' then '男' when 'M' then '女' end)'性别',pt.productno,od.quantity,pt.productprice,od.price,om.ordersum,CONVERT(varchar(100),om.orderdate,23)'orderdate'
from employee em,ordermaster om, orderdetail od,product pt
where em.employeeno=om.salerno and om.orderno=od.orderno and od.productno=pt.productno
select*from employee
select* from orderdetail
select* from customer
select* from ordermaster
select* from product

insert into customer
values('c2005004','207工商协会','022-324234','福州市','21233')

--（14）查找在2008年3月中有销售记录的客户编号、名称和订单总额。
select temp.customerno, customer.customername,temp.ordersum
from 
     (select customerno,sum(ordersum ) ordersum
      from ordermaster 
      where orderdate between '2008-03-01' and '2008-03-31'
	  group by customerno)   temp, customer
where temp.customerno=customer.customerno
--（15）使用左外连接查找每个客户的客户编号、名称、订单日期、订货金额，
--其中订货日期不要显示时间，日期格式为yyyy-mm-dd，按客户编号排序，同一客户再按订单金额降序排序输出。

select  cu.customerno,cu.customername,convert(varchar(100),om.orderdate,23) orderdate,om.ordersum 
from (select customerno,customername
	  from customer) cu
	  left outer join
    (select customerno,ordersum,orderdate
       from ordermaster
	  ) om 
	  on(om.customerno=cu.customerno)
order by cu.customerno,om.ordersum desc
         
--（16）查找32M DRAM的销售情况，要求显示相应的销售员的姓名，性别，销售日期、销售数量和金额，其中性别用“男”，“女”表示。
select  oe.employeename,oe.sex,oe.orderdate,op.quantity,op.price
from  (select orderno,quantity,price
       from orderdetail,product
	   where product.productno=orderdetail.productno and productname='32M DRAM') op,
	   
	   (select orderno,employeename,(case sex when 'F' then '女' when 'M' then '男' end) sex, orderdate
	   from ordermaster,employee
	   where ordermaster.salerno=employee.employeeno 
	    ) oe
where op.orderno=oe.orderno

--（17）查找公司男业务员所接且订单金额超过2000元的订单号及订单金额。
select  em.employeename,sum(od.price) sumprice
from(select orderno,employeeno,employeename
       from employee,ordermaster
	   where sex='M' and employeeno=salerno) em,
	  (select orderno,price
	   from orderdetail
	  ) od
where em.orderno=od.orderno
group by em.employeename
having sum(od.price)>2000

--（18）查找来自上海市的客户的姓名，电话，订单号及订单金额。
select customername,telephone,orderno,sum(md.price)sumprice
from (select customerno,customername,telephone
     from customer
	 where address='上海市'
      ) cu,
	  (select om.customerno,om.orderno, od.price
	   from ordermaster om,orderdetail od
	   where om.orderno=od.orderno
	   ) md
where cu.customerno=md.customerno
group by customername,telephone,orderno
order by customername
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

--第五章 实验 复杂查询
     select *from ordermaster
     update ordermaster  
     set ordersum=(select sum(quantity*price)
                    from orderdetail od
                    where ordermaster.orderno=od.orderno
                  )
    update ordermaster
    set ordersum=temp.total
    from ordermaster om,
         (select sum(quantity*price)total,orderno
           from orderdetail
          group by orderno) temp
    where  om.orderno=temp.orderno
--（1）用子查询查询员工“张小娟”所做的订单信息。
  --1)第一种
select '张小娟',om.orderno, om.orderdate,om.ordersum,om.customerno
from ordermaster om,employee em
where  em.employeeno=om.salerno and em.employeename='张小娟'

  --2）第二种
    
      select '张小娟',om.orderno,om.orderdate,om.ordersum,om.customerno
      from ordermaster om
		where salerno=(select employeeno 
						from employee
						where employeename='张小娟') 
     


--（2）查询没有订购商品的且在北京地区的客户编号，客户名称和邮政编码，并按邮政编码降序排序。
select customerno,customername,zip
from customer cu
where address='北京市' and not exists (select *
                                       from ordermaster om
									   where cu.customerno=om.customerno)


--（3）查询订购了“32M DRAM”商品的订单编号，订货数量和订货单价。
select orderno,quantity,price
from orderdetail
where orderno in(select orderno
                  from ordermaster
				  where productno=(select productno from product where productname='32M DRAM')
                  )

--（4）查询与员工编号“E2008005”在同一个部门的员工编号，姓名，性别，所属部门。
select employeeno,employeename ,(case sex when 'F' then '男' when 'M' then '女' end) sex,department
from employee
where department=(select department from employee where employeeno='E2008005')

--（5）查询既订购了P2005001商品，又订购了P2007002商品的客户编号，订单编号和订单金额
select * from orderdetail
select * from ordermaster
update  orderdetail
set productno='p2007002'
where orderno='200801090001' and productno='p2005003'

select om.customerno,o1.orderno,o1.price
from orderdetail as o1,ordermaster as om 
where  o1.productno='P2005001' 
         and o1.orderno in
         (select orderno 
          from orderdetail o2
		  where o2.productno='p2007002')
		and o1.orderno=om.orderno


--（6）查询没有订购“52倍速光驱”或“17寸显示器”的客户编号，客户名称。

select cu.customerno,cu.customername
from ordermaster om ,customer cu   
where orderno in
	(select orderno 
	from orderdetail 
	where productno not in
					(select productno 
					from product
					where productname='52倍速光驱' or productname='17寸显示器')
    ) and om.customerno=cu.customerno

--（7）查询订单金额最高的订单编号，客户姓名，销售员名称和相应的订单金额。
select om.orderno,cu.customername,em.employeename,om.ordersum
from    (
		select distinct orderno, ordersum,salerno ,customerno
		from   ordermaster 
		where ordersum =(select max(ordersum) from ordermaster)
		) om, 
		employee em,customer cu
where om.customerno=cu.customerno and om.salerno=em.employeeno

--（8）查询订购了“52倍速光驱”商品的订购数量，订购平均价和订购总金额。

select '52倍速光驱',sum(quantity) quantity, avg(price) , sum(price)
from  orderdetail
where  productno=(select productno from product where  productname='52倍速光驱')


--（9）查询订购了“52倍速光驱”商品且订货数量界于2~4之间的订单编号，订货数量和订货金额。
  select orderno,quantity,price 
  from orderdetail
  where productno=(select productno from product where productname='52倍速光驱')
        and quantity between 2 and 4

--（10）在订单主表中查询每个业务员的订单数量
select salerno,count(orderno) ordercount
from ordermaster
group by salerno

--（11）统计在业务科工作且在1973年或1967年出生的员工人数和平均工资。
 select * from employee 
 select employeeno,salary
 from  employee
 where department='业务科' and year(birthday)=1973 or  year(birthday)=1967

--（12）在订单明细表中统计每种商品的销售数量和金额，并按销售金额的升序排序输出。
 select * from orderdetail
select productname,sum(quantity) quantity , sum(price) price
from  (select productname,productno
	    from product) pt,orderdetail
where orderdetail.productno=pt.productno
group by  productname
order by price
	   
--（13）统计客户号为“C2005001”的客户的订单数，订货总额和平均订货金额
select * from ordermaster

--第一种 由于orderno有主键约束，ordersum不会存在重复计算问题 
select  'c2005001' ,count(orderno),sum(ordersum),avg(ordersum)  
from ordermaster 
where customerno='c2005001'


--第二种 如果ordeno没有主键约束，ordersum可能存在重复计算问题

select count(temp.orderno),sum(temp.ordersum) 
from (select  orderno,sum(ordersum) ordersum
	 from ordermaster
	 where customerno='c2005001'
	 group by orderno) temp
--（14）统计每个客户的订单数，订货总额和平均订货金额。
select customername,temp.countorder,temp.sos ordersum,temp.aos averageOrdersum
from 	(select customerno ,count(orderno) countorder,sum(ordersum) sos,avg(ordersum) aos
		from ordermaster 
		group by customerno) temp,customer
where customer.customerno=temp.customerno
		 


--（15）查询订单中至少包含3种（含3种）以上商品的订单编号及订购次数，且订购的商品数量在3件（含3件）以上。
         select * from orderdetail 
		 select *from ordermaster
		 
		 select orderno,count(distinct orderdate)
		 from  ordermaster 
		 where orderno in(select orderno
			 from orderdetail 
			 group by orderno 
			 having count(productno)>=3 and sum(quantity)>=3
		     )
	    group by orderno 





--（16）查找订购了“32M DRAM”的商品的客户编号，客户名称，订货总数量和订货总金额。

select cu.customerno,cu.customername,sum(temp.quantity) sumquantity,sum(temp.price) sumprice
from customer cu,ordermaster ,
          (select orderno ,quantity,price
		   from orderdetail 
		   where productno in		
			 (select productno
			  from product 
			  where productname='32M DRAM')
		  ) temp
where temp.orderno=ordermaster.orderno and ordermaster.customerno=cu.customerno
group by cu.customerno,customername



--（17）查询每个客户订购的商品编号，商品所属类别，商品数量及订货金额，结果显示客户名称，商品所属类别，商品数量及订货金额，并按客户编号升序和按订货金额的降序排序输出。
--第一种：表连接                       
					   select cu.customername ,pt.productname ,pt.productclass ,od.quantity,od.price
                        from customer cu,product pt,orderdetail od,ordermaster om
                        where cu.customerno=om.customerno 
                              and om.orderno=od.orderno  
                              and  od.productno=pt.productno  

--第一种同一公司订购的同一商品没有整合
select  cu.customerno,cu.customername,pt.productname,pt.productclass,od.quantity,od.price
from    (select productno,productname
     from product) pt,orderdetail od, ordermaster om,customer cu
where pt.productno=od.productno and od.orderno=om.orderno and om.customerno=cu.customerno
order by cu.customerno ,od.price
--第二种同一公司订购的同一商品进行了整合
	select  cu.customerno,cu.customername,pt.productname,pt.productclass,sum(od.quantity)sumquantity ,sum(od.price) sumprice
     from    (select productno,productname,productclass
             from product) pt,orderdetail od, ordermaster om,customer cu
    where pt.productno=od.productno and od.orderno=om.orderno and om.customerno=cu.customerno
   group by cu.customerno,cu.customername ,pt.productname,pt.productclass
   order by cu.customerno ,sumprice 


--（18）按商品类别查询每类商品的订货平均单价在280元（含280元）以上的订货总数量，订货平均单价和订货总金额。
                            select pt.productclass ,SUM(quantity) sumquantity,AVG(price) avgprice,sum(price) sumprice
                            from  orderdetail od, product pt
                            where   od.productno=pt.productno
                            group by pt.productclass
                            
                            
                            
--（19）查找至少有2次销售的业务员名称和销售日期。
         
        select em.employeename, om.orderdate
        from ordermaster om, employee em
        where em.employeeno in 
        (select  salerno
         from ordermaster
         group by salerno  
         having COUNT(salerno)>=2)and om.salerno=em.employeeno
         order by employeename                      
                 
--（20）查询销售金额最大的客户名称和总货款额
         update ordermaster
         set ordersum=(select SUM(quantity*price)
                         from orderdetail
                         where ordermaster.orderno=orderdetail.orderno

		  select cu.customername,sumprice
          from (select om.customerno,sum(om.ordersum) sumprice
				from ordermaster om
				group by customerno
				)temp,customer cu
		  where sumprice>=all(select sum(om.ordersum) sumprice
				from ordermaster om
				group by customerno)
				and cu.customerno=temp.customerno

--（21）查找销售总额小于5000元的销售员编号，姓名和销售额
                select em.employeeno,em.employeename,om.sumorder
                from (select salerno,sum(ordersum) sumorder
					  from ordermaster 
					  group by salerno) om,employee  em
				where om.sumorder<5000 and om.salerno=em.employeeno

--（22）查找至少订购了3种商品的客户编号，客户名称，商品编号，商品名称，数量和金额。
      

	  select cu.customerno,cu.customername,pt.productno,pt.productname,od.quantity,od.price
	  from customer cu, ordermaster om,orderdetail od,product pt
      where cu.customerno=om.customerno  and om.orderno=od.orderno and od.productno=pt.productno
			and cu.customerno in(select om.customerno
								from ordermaster om,orderdetail od
								where om.orderno=od.orderno
								group by  om.customerno
								having count(distinct od.productno)>=3)
	order by cu.customerno


--（23）查找同时订购了商品为“P2007002”和商品编号为“P2007001”的商品的客户编号，客户姓名，
--商品编号，商品名称和销售数量，按客户编号排序输出。
		
				    select cu.customerno,cu.customername,pt.productno,pt.productname, sum(od.quantity) quantity
					from customer cu,ordermaster om,product pt,
					(select orderno,productno,quantity 
					from orderdetail
					where productno='p2007002' and orderno 
													in(select orderno 
													from orderdetail  
													where productno='p2007001' ) 
					) od
					where cu.customerno=om.customerno and om.orderno =od.orderno and od.productno=od.productno
					group by cu.customerno,cu.customername,pt.productno,pt.productname
					order by customerno

--（24）计算每一商品每月的销售金额总和，并将结果首先按销售月份然后按订货金额降序排序输出。
                 select pt.productname,dm.sumprice,dm.orderdate
				 from product pt,
						(select productno,sum(price) sumprice,om.orderdate
						from orderdetail od,ordermaster om 
						where od.orderno=od.orderno
						group by productno,om.orderdate)  dm
				 where pt.productno=dm.productno
				 order by dm.orderdate ,dm.sumprice desc
--（25）查询订购了“键盘”商品的客户姓名，订货数量和订货日期
		select cu.customername,op.quantity,om.orderdate
		from	(select orderno,quantity 
				from orderdetail
				where productno in
								(select productno from product where productname='键盘')) op,
		customer cu,ordermaster om
		where cu.customerno=om.customerno and om.orderno=op.orderno
				
--（26）查询每月订购“键盘”商品的客户名称。
        select month(om.orderdate) monthorder,cu.customername
        from ordermaster om,customer cu,
		(select od.orderno,od.productno
		 from orderdetail od, product pt
         where od.productno=pt.productno and pt.productname='键盘') dp
		where   dp.orderno=om.orderno and cu.customerno=om.customerno
		group by month(om.orderdate),cu.customername
		order by monthorder
--（27）查询至少销售了5种商品的销售员编号，姓名，商品名称，数量及相应的单价，并按销售员编号排序输出。
		select om.salerno,em.employeename,pt.productname,sum(od.quantity)quantity,pt.productprice
		from employee em,product pt ,orderdetail od,ordermaster om				
		where em.employeeno=om.salerno and om.orderno=od.orderno and od.productno=pt.productno
				 and om.salerno in(select om.salerno
									from ordermaster om,orderdetail od
									where om.orderno=od.orderno
									group by om.salerno
									having count(distinct productno)>=5)
        group by om.salerno,em.employeename,pt.productprice,pt.productname
		order by salerno
--（28）查询没有订购商品的客户编号和客户名称。
		select customerno ,customername
		from customer
		where customerno not in(select customerno from ordermaster)
--（29）查询至少包含了“世界技术开发公司”所订购的商品的客户编号，客户名称，商品编号，商品名称，数量和金额。
		select  cu1.customerno,cu1.customername,od1.productno,pt1.productname,od1.quantity,od1.price
		from    customer cu1,ordermaster om1,orderdetail od1,product pt1
		where cu1.customerno=om1.customerno and om1.orderno=od1.orderno and od1.productno=pt1.productno
		and not exists
			(select *
			from customer cu2,ordermaster om2,orderdetail od2
			where cu2.customerno=om2.customerno and om2.orderno=od2.orderno and
				  cu2.customername='世界技术开发公司' 
				  and not exists 
						( select *
						  from ordermaster  om3,orderdetail od3
						  where  om3.orderno=od3.orderno 
						         and  od3.productno=od2.productno 
								 and  om3.customerno=cu1.customerno
						 )

			 )
		order by cu1.customerno
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------

--第六章 数据库的安全性
--（1）分别创建登陆账号和用户账号john，mary（注意服务器角色的设置）
		sp_addlogin  'john','123','orderdb'
		sp_addlogin  'mary','123','orderdb'
		sp_adduser 'john'
		sp_adduser 'mary'
 --（2）将员工表的所有权限给全部用户

        grant select,update,delete
        on employee
        to john,mary
--（3）创建角色r1，r2，将订单明细表所有列的select权限，price列的update权限给r1。 
        sp_addrole 'r1'
        sp_addrole 'r2'
        grant select,update(price)
        on orderdetail
        to r1,r2
--（4）收回全部用户对员工表的所有权限。
        revoke  select
        on employee
        from john,mary
--（5）将john，mary两个用户赋予r1角色。
		sp_addrolemember  'r1','john'	 
--（6）收回john对订单明细表所有列的select权限。
        revoke select
        on orderdetail
        from john
--（7）在当前数据库中删除角色r2。
	    sp_droprole 'r2'
-------------------------------------------------------------------------------		
-------------------------------------------------------------------------------      
--第七章 数据库的完整性
--（1）重建orderDB数据库中的表，分别为每张表建立主键，外键。
--（2）各表的用户定义的完整性如下：
			create database oredrDB
--员工表：员工编号，姓名、性别、所属部门、职称、薪水设为not null；
			--员工编号构成：年流水号，共8位，第一位为E，如E2008001，年份取雇佣日期的年份；
			--性别：f表示女，m表示男。
--创建员工表
	       create table Employee
			(	employeeNo   char(8)  primary key,
				employeeName varchar(20), 
                constraint E_NO check(employeeNo like 'E[0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
			    Sex			varchar(10) check(sex='f' or sex='m'),
			    Department   varchar(20),
				Title		varchar(10),
				Salary       numeric(10,2) not null ,
				Hiredate     datetime,
			    constraint E_Hire_NO check(substring(employeeNo,2,4)=year(Hiredate))
			)
--添加员工记录
			insert
			into employee(employeename,sex,department,Title,salary,hiredate)
			select		'王帅','m','销售部','主管',1200,getdate() union all
			select     '赵少帅','m','娱乐部','部长',200000,getdate()
--添加员工流水号触发器
			create trigger T_E_employeeNo
			on employee
			instead of insert
			as 
				declare @head varchar,@datebody varchar(10),@maxid varchar(10)
				set @head='E'
				set @datebody=year(getdate())
				select @maxid=right(max(employeeNo),3) from employee
				if @maxid is null
				   set @maxid='000'
				declare @temp int
				set  @temp=cast(@maxid as int)
				select * into #temp from inserted
				update #temp set @temp=@temp+1,
						employeeno=@head+@datebody+right(('00'+cast(@temp as varchar)),3)
				insert into employee select *from #temp
				   
			    
			
				
			
--商品表：商品编号、商品名称、商品类别、建立日期设为not null；
		--商品编号构成：年流水号，共9位，第一位为P，如P20080001，年份取建立日期的年份
--创建商品表
       create table Product
		(  productNo   char(9)  primary key,
		   constraint  P_No check(productNo like 'P[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		   productName varchar(20),
		   productType varchar(20),
		   productDate date			not null,
		   constraint P_Date_No check(substring(productNo,2,4)=year(productDate))
		)
--添加商品记录
		insert into product(productname,productdate,producttype) 
		select '内存',getdate(),'硬件' union all
		select '显卡',getdate(),'硬件'
--添加商品流水号触发器
	    create trigger T_P_productNo
			on product
			instead of insert
			as 
				declare @head varchar,@datebody varchar(10),@maxid varchar(10)
				set @head='P'
				set @datebody=year(getdate())
				select @maxid=right(max(productNo),4) from product
				if @maxid is null
				   set @maxid='0000'
				declare @temp int
				set  @temp=cast(@maxid as int)
				select * into #temp from inserted
				update #temp set @temp=@temp+1,
						productno=@head+@datebody+right(('000'+cast(@temp as varchar)),4)
				insert into product select *from #temp
			
--客户表：客户编号、电话属性为not null；
    客户号构成：年流水号，共9位，第一位为C，如C20080001，年份取建立日期的年份
--创建客户表
	create table Customer
	(
		customerNo	 char(9)	primary key,
		constraint C_No check(customerNo like 'C[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		customerName varchar(20) ,
		Telephone 	 varchar(20)    not null, 
		Sex          varchar(5)	check(sex='f' or sex='m'),
		constraint C_Date_No check(substring(customerNo,2,4)=year(getDate()))
	)
--添加客户记录
             insert into customer(customername,telephone,sex)
			 select '上海工商','1778922990','f' union all
			 select '香港电子','1778923990','m'
--添加客户流水号触发器
	 create trigger T_C_customerNo
			on customer
			instead of insert
			as 
				declare @head varchar,@datebody varchar(10),@maxid varchar(10)
				set @head='C'
				set @datebody=year(getdate())
				select @maxid=right(max(customerno),4) from customer
				if @maxid is null
				   set @maxid='0000'
				declare @temp int
				set  @temp=cast(@maxid as int)
				select * into #temp from inserted
				update #temp set @temp=@temp+1,
						customerno=@head+@datebody+right(('000'+cast(@temp as varchar)),4)
				insert into customer select *from #temp
--订单主表：订单编号的构成：年月日流水号，共12位，如200708090001；
    订单编号、客户编号、员工编号、发票号码设为not null；业务员必须是员工；
    订货日期和出货日期的默认值设为系统当前日期；订单金额默认值为0；发票号码建立unique约束。
--创建订单主表
	create table orderMaster
	(   orderNo char(12) primary key,
	    constraint OM_No check(orderNo like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
		customerNo char(9) foreign key references Customer(customerNo),
		salesmanNo char(8) foreign key references employee(employeeNo),
		invoiceNo  varchar(10)   unique,
		orderDate DateTime default(getDate()),
		shipment datetime default(getDate()),
		orderPrice numeric default(0)
	)

--添加记录到订单主表
		insert into ordermaster(customerno,salesmanno,invoiceno,orderdate,shipment)
		 select 'C20180001','E2018001','1231230',getdate(),getdate() union all
		 select 'C20180002','E2018002','1231231',getdate(),getdate()
	select *from ordermaster

--创建订单主表订单流水号触发器

	 create trigger T_OM_orderNo
			on orderMaster
			instead of insert
			as 
				declare @datebody varchar(10),@maxid varchar(10),
			            @year char(4),@month char(2),@day char(2)
				set @year=year(getdate()) set @month=datename(month,getdate()) set @day=datename(day,getdate())
				set @datebody=@year+@month+@day      --replace(convert(char(10),getdate(),120),'-','')
				select @maxid=right(max(orderno),4) from ordermaster
				if @maxid is null
				   set @maxid='0000'
				declare @temp int
				set  @temp=cast(@maxid as int)
				select * into #temp from inserted
				update #temp set @temp=@temp+1,
						orderno=@datebody+right(('000'+cast(@temp as varchar)),4)
				insert into ordermaster select *from #temp

--订单明细表：订单编号、商品编号、数量、单价设为not null。 
--创建订单明细表
	create table orderDetail
	(	
		orderNo char(12) foreign key references orderMaster(orderNo),
		productNo char(9) foreign key references Product(ProductNo),
		quantity  numeric(10),
		unitPrice numeric(10) not null,
		primary key(orderNo,productNo)
	)
--第八章 游标、存储过程与触发器
--（1）利用游标查找所有女业务员的基本情况
         declare find_female cursor static
		 for
		 select * 
		 from employee
		 where sex='F'
		
		 open find_female
		
		 fetch next from find_female
		 while @@fetch_status=0
			begin 
				fetch next from find_female
			end
		
		close find_female
		
		deallocate find_female



--（2）创建一游标，逐行显示表customer的记录，要求按
--‘客户编号’+‘-------’+‘客户名称’+‘-------’+‘客户地址’+‘-------------------’+‘客户电话’+‘
   ----------’+‘客户邮编’+‘--------’格式输出，
--并且用while结构来测试游标的函数@@Fetch_Status的返回值。
     
     
	 declare dis_customer  cursor  static
	 for 
		select *
		from customer

	 open dis_customer 
	 
	 declare @no varchar(9),@name varchar(40),@address varchar(40),@telephone varchar(20),
			@zip varchar(6)
	 
	 fetch first from dis_customer into @no,@name,@telephone,@address,@zip
	 print '客户编号:'+@no+'客户名称:'+@name+'客户地址:'+@address+'客户电话:'+@telephone+'客户邮编:'+@zip
	 while @@fetch_status=0
		begin
			fetch next from dis_customer into @no,@name,@telephone,@address,@zip
			print '客户编号:'+@no+'客户名称:'+@name+'客户地址:'+@address+'客户电话:'+@telephone+'客户邮编:'+@zip
	    end
	close dis_customer
	deallocate dis_customer



--（3）利用游标修改orderMaster表中的Ordersum的值
      declare up_om cursor scroll 
	  for 
	  select *from ordermaster
	   
	  open up_om
	  fetch first from up_om
	  while @@fetch_status=0
		begin 
			update ordermaster
			set ordersum=0
			where current of up_om
			fetch next from up_om
		end

		close up_om
		deallocate up_om
--（4）利用游标显示出orderMaster表中每一个订单所对应的明细数据信息。
        declare dis_om cursor scroll 
		for 
			select orderno from ordermaster
        open dis_om
		
		declare @orderno varchar(12)
		while 1=1
			begin 	
				fetch next from dis_om into @orderno
				if @@fetch_status=0
					begin
						declare dis_od cursor scroll
						for 
						select * from orderdetail
						where orderno=@orderno
						open dis_od
						fetch first from dis_od
						while @@fetch_status=0
							begin 
								fetch next from dis_od
							end
						close dis_od
						deallocate dis_od
					end
				else
					break 
			end
			
			close dis_om
			deallocate dis_om
--（5）利用存储过程，给Employee表添加一条业务部门员工的信息。
	go
	create procedure pr_insertem
		@emno varchar(20),
		@emname varchar(20)
	as 
	begin 
		insert into employee(employeeno,employeename) values(@emno,@emname)
	end		
	go	
	execute pr_insertem 'E2018005','吴起'
	go	
	drop proc pr_insertem
--（6）利用存储过程输出所有客户姓名、客户订购金额及其相应业务员的姓名
		go
		create proc pr_outinfo
		as
		begin
			select cu.customername ,om.ordersum,em.employeename
			from   customer cu,ordermaster om, employee em
			where cu.customerno=om.customerno and om.salerno=em.employeeno
		end	
		execute pr_outinfo
		drop proc pr_outinfo
--（7）利用存储过程查找某员工的员工编号、订单编号、销售金额。
		go
		create proc pr_selemployee
		as 
		begin
			select em.employeeno,om.orderno,om.ordersum
			from employee em,ordermaster om
			where em.employeeno=om.salerno
			order by em.employeeno 
		end 
		go
		execute pr_selemployee
		go
		drop proc pr_selemployee
--（8）利用存储过程查找姓“李”并且职称为“职员”的员工的员工编号、订单编号、销售金额
	go
	create proc pr_selemployee
	as
	begin
		select em.employeeno,om.orderno,om.ordersum
		from employee em,ordermaster om
		where em.employeeno=om.salerno and em.employeename like '李%' and em.headship='职员'
		order by em.employeeno 
	end
	execute pr_selemployee
	drop proc pr_selemployee
	
--（9）请使用游标和循环语句编写一个存储过程proSearchCustomer，
    --根据客户编号，查询该客户的名称、地址以及所有与该客户有关的销售记录，销售记录按商品分组输出。
		create proc proSearchCustomer
		@cuname varchar(20)
		as 
		begin
		    declare customers cursor scroll
		    for
				select cu.customername,cu.address,om.orderno,om.customerno,om.salerno,om.orderdate,om.ordersum,om.invoiceno
				from customer cu,ordermaster om
				where   cu.customername=@cuname and cu.customerno=om.customerno
		    open customers
		    fetch next from customers
		    while @@FETCH_STATUS=0
		    begin
				fetch next from customers
			end
            close customers		
            deallocate customers    
		end
		execute proSearchCustomer '统一股份有限公司'
		
		drop proc proSearchCustomer
		
--（10）设置一个触发器，该触发器仅允许dbo用户可以删除Employee表内数据，否则出错。
		create trigger deleteemployee
		on employee
		for delete
		as 
		begin
		  if user='dbo'
		    begin 
		        commit
		        print'删除成功'
		     end
		  else
			begin 
			    rollback
			    print'无权限修改employeeb表'
			end 
		end		
--（11）在OrderMaster表中创建触发器，
    --插入数据时要先检查Employee表中是否存在和Ordermaster表同样值的业务员编号，如果不存在则不允许插入。
	create trigger ins_om
	on ordermaster
	for insert
	as
	  if exists(
		select salerno from inserted
		where salerno
				in (select employeeno from employee)
			)
			begin
			commit
			print('employeeno存在！')
			end
	   else 
			begin
			rollback
			print('employeeno不存在！')
			end
--（12）级联更新：当更新customer表中的customerNo列的值时，
    --同时更新OrderMaster表中的customerNo列的值，并且一次只能更新一行。



			--??????????????????????????????????????????????????尚存问题 主外键约束阻碍触发器运行
create trigger up_cusno
on customer 
for update
as
	if(update(customerno))
		begin
		update ordermaster
		set customerno=(select ins.customerno from inserted ins)
		where customerno=(select del.customerno from deleted del)
		end

--（13）对product表写一个UPDATE触发器。


	--??????????????????????????????????????????????????尚存问题 主外键约束阻碍触发器运行
create trigger up_pro
on product
for update
as
	if(update(productno))
		begin
		update orderdetail
		set productno=(select ins.productno from inserted ins)
		where productno=(select del.productno from deleted del)
		end
		



