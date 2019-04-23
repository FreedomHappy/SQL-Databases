案例6
表1、学生（学号，姓名，性别，年龄，系别）
（学号为主键，不为空，唯一），性别默认为男。
表2、课程（课程号，课程名，学分）
课程号为主键，学分只能为1位数字，如1, 2, 4等。
表3、选课（学号，课程号，成绩）
学号和课程号为主键，成绩0--100之间。
1、	要求学生根据上述要求，创建三张表，类型根据实际自行定义，必须满足规定的完整性约束。
       create database cas
       create table student
       ( studentno varchar(20) primary key,
         studentname varchar(50) ,
         sex varchar(5) check(sex='男' or sex='女'),
         department varchar(20)
       )
       alter table student
       add age varchar(5)
       alter table student
       alter column age numeric(10)
       
       create table course
       (
          courseno varchar(20) primary key,
          coursename varchar(20),
          credit numeric(5)
       )
       
       create table sc
       (studentno varchar(20) foreign key references student(studentno),
		  courseno varchar(20) foreign key references course(courseno),
		  
		  grade numeric(5),
		  primary key (courseno,studentno)
       )
       
       alter table	sc
       add constraint gr check(grade<=100 and grade>=0)
       
       alter table sc
       add constraint k  default('22') for studentno 
       
       alter table sc 
       drop constraint gr
       sp_helpconstraint sc
2、	表创建完毕，要求学生自行构造数据，为每张表插入至少5笔记录
bulk insert student from'F:\数据库\student.txt' with (fieldterminator=',',rowterminator='\n')
bulk insert course from'F:\数据库\course.txt' with (fieldterminator=',',rowterminator='\n')
bulk insert sc from'F:\数据库\sc.txt' with (fieldterminator=',',rowterminator='\n')

delete
from sc
where  grade='101'

insert  into sc
values('110','5',100),
values('110','3',23)

drop table sc
select * from student 
select* from course
select* from sc
3、	要求学生使用ALTER TABLE 语句对表进行修改。可以要求学生增加新的字段，比如在表3中添加课程名。
   刚修改后的新字段的值为NULL，此时可以根据实际情况考核与NULL有关的知识点。
    alter table sc
    add coursename varchar(20)

4、	UPDATE及DELETE的考核，根据表中的内容，要求学生将特定的记录进行修改和删除。
     update  sc
     set studentno='143'
     where studentno='111'
     
     delete 
     from sc 
     where studentno='143'
5、	SELECT语句的考核，查询出选修了某门课程的学生的基本情况。
    
    select * 
    from student 
    where studentno in
    (
    select studentno
    from sc 
    where courseno in
     (
     select courseno
     from course
     where coursename='数学'
	)
	)

6、	COUNT AVG SUM等函数的考核，要求学生统计学生的平均年龄。
     select AVG(age)
     from student
    
7、	分组查询（GROUP BY）及JOIN的考核，比如查询男女学生选修课程的总数。
    select stu.sex ,count(sc.courseno)
    from student stu,sc
    where stu.studentno=sc.studentno 
    group by stu.sex

8、	HAVING的考核，对上述查询的结果进行筛选，比如只要查询数量大于5的记录等。
      select stu.sex ,count(sc.courseno)
    from student stu,sc
    where stu.studentno=sc.studentno 
    group by stu.sex
   having COUNT(sc.courseno)>2
9、	ORDER BY 的考核，随机要求学生根据特定的字段进行排序。
    select *
    from student 
    order by studentno desc

10、	 子查询的考核，查询未选修任何课程的学生的资料。
          select * 
          from student 
          where not exists( select * from sc where sc.studentno=student.studentno )

		  select *from sc 