����6
��1��ѧ����ѧ�ţ��������Ա����䣬ϵ��
��ѧ��Ϊ��������Ϊ�գ�Ψһ�����Ա�Ĭ��Ϊ�С�
��2���γ̣��γ̺ţ��γ�����ѧ�֣�
�γ̺�Ϊ������ѧ��ֻ��Ϊ1λ���֣���1, 2, 4�ȡ�
��3��ѡ�Σ�ѧ�ţ��γ̺ţ��ɼ���
ѧ�źͿγ̺�Ϊ�������ɼ�0--100֮�䡣
1��	Ҫ��ѧ����������Ҫ�󣬴������ű����͸���ʵ�����ж��壬��������涨��������Լ����
       create database cas
       create table student
       ( studentno varchar(20) primary key,
         studentname varchar(50) ,
         sex varchar(5) check(sex='��' or sex='Ů'),
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
2��	������ϣ�Ҫ��ѧ�����й������ݣ�Ϊÿ�ű��������5�ʼ�¼
bulk insert student from'F:\���ݿ�\student.txt' with (fieldterminator=',',rowterminator='\n')
bulk insert course from'F:\���ݿ�\course.txt' with (fieldterminator=',',rowterminator='\n')
bulk insert sc from'F:\���ݿ�\sc.txt' with (fieldterminator=',',rowterminator='\n')

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
3��	Ҫ��ѧ��ʹ��ALTER TABLE ���Ա�����޸ġ�����Ҫ��ѧ�������µ��ֶΣ������ڱ�3����ӿγ�����
   ���޸ĺ�����ֶε�ֵΪNULL����ʱ���Ը���ʵ�����������NULL�йص�֪ʶ�㡣
    alter table sc
    add coursename varchar(20)

4��	UPDATE��DELETE�Ŀ��ˣ����ݱ��е����ݣ�Ҫ��ѧ�����ض��ļ�¼�����޸ĺ�ɾ����
     update  sc
     set studentno='143'
     where studentno='111'
     
     delete 
     from sc 
     where studentno='143'
5��	SELECT���Ŀ��ˣ���ѯ��ѡ����ĳ�ſγ̵�ѧ���Ļ��������
    
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
     where coursename='��ѧ'
	)
	)

6��	COUNT AVG SUM�Ⱥ����Ŀ��ˣ�Ҫ��ѧ��ͳ��ѧ����ƽ�����䡣
     select AVG(age)
     from student
    
7��	�����ѯ��GROUP BY����JOIN�Ŀ��ˣ������ѯ��Ůѧ��ѡ�޿γ̵�������
    select stu.sex ,count(sc.courseno)
    from student stu,sc
    where stu.studentno=sc.studentno 
    group by stu.sex

8��	HAVING�Ŀ��ˣ���������ѯ�Ľ������ɸѡ������ֻҪ��ѯ��������5�ļ�¼�ȡ�
      select stu.sex ,count(sc.courseno)
    from student stu,sc
    where stu.studentno=sc.studentno 
    group by stu.sex
   having COUNT(sc.courseno)>2
9��	ORDER BY �Ŀ��ˣ����Ҫ��ѧ�������ض����ֶν�������
    select *
    from student 
    order by studentno desc

10��	 �Ӳ�ѯ�Ŀ��ˣ���ѯδѡ���κογ̵�ѧ�������ϡ�
          select * 
          from student 
          where not exists( select * from sc where sc.studentno=student.studentno )

		  select *from sc 