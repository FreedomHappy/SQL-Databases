
use test

--����1
  --��1���ͻ����ϱ����������ֶΣ��ͻ��ţ�����Ϊ�գ�Ψһ�����������Ա�(ȡֵΪ�л�Ů)�����䣬�ʽ���� ����Ϊ�ͻ��š�  
  --��2���ʽ������ͻ��ţ����ʱ�䣬������ͣ����ȡ���������
--1��	Ҫ��ѧ����������Ҫ�󣬴������ű����͸���ʵ�����ж��壬��������涨��������Լ����
		create table customer
		(customerno varchar(20) primary key,
		 customername varchar(20),
		 sex   varchar(5) check(sex='��' or sex='Ů'),
		 age   numeric(20),
		 rest  numeric(20)
		)

		create table change
		(
		   customerno varchar(20) primary key foreign key references customer(customerno),
		   changedate date,
		   changetype varchar(5) check(changetype='��' or changetype='ȡ'),
		   changemoney numeric(20)
		)

--2��	������ϣ�Ҫ��ѧ�����й������ݣ�Ϊÿ�ű��������5�ʼ�¼
        bulk insert customer from 'F:\a�������ѧ���ļ�\customer.txt'
		with
		( fieldterminator=',',
		  rowterminator ='\n'
		)
		 bulk insert change from 'F:\a�������ѧ���ļ�\change.txt'
		with
		( fieldterminator=',',
		  rowterminator ='\n'
		)
      
--3��	Ҫ��ѧ��ʹ��ALTER TABLE ���Ա�����޸ġ�����Ҫ��ѧ�������µ��ֶΣ�
--����ͻ����ϱ����������֤�š����޸ĺ�����ֶε�ֵΪNULL����ʱ���Ը���ʵ�����������NULL�йص�֪ʶ�㡣
alter table customer
add id varchar(20)
select * from customer

--4��	UPDATE��DELETE�Ŀ��ˣ����ݱ��е����ݣ�Ҫ��ѧ�����ض��ļ�¼�����޸ĺ�ɾ����
        update customer 
		set rest=3000
		where customername='����˧'

		delete
		from change 
		where customerno='5'  --ɾ��customerʧ��
--5��	SELECT���Ŀ��ˣ������ѯ20007/01/01�����Ů�ͻ���������ʽ���
           select customername,age ,rest
		   from customer
		   where customerno in(select customerno from change where changedate='2017-1-1' and changetype='��')
		         and sex='��'
--6��	COUNT AVG SUM�Ⱥ����Ŀ��ˣ���ʦ����ʵ�����������⡣
		select count(distinct customerno)
		from change
--7��	�����ѯ��GROUP BY����JOIN�Ŀ��ˣ�����Ҫ��ѧ����ѯ��Ů�ͻ��Ĵ�ȡ����
	    select sum(changemoney),sex,changetype 
		from change ch ,customer cu	
		where ch.customerno=cu.customerno 
        group by sex,changetype 
--8��	HAVING�Ŀ��ˣ���������ѯ�Ľ������ɸѡ������ֻҪ��ѯ����������1000�ļ�¼�ȡ�
		select sum(changemoney),sex,changetype 
		from change ch ,customer cu	
		where ch.customerno=cu.customerno 
        group by sex,changetype 
		having sum(changemoney)>200
--9��	ORDER BY �Ŀ��ˣ����Ҫ��ѧ�������ض����ֶν�������
		select*
		from customer
		order by customerno desc
--10��	�Ӳ�ѯ�Ŀ��ˣ���ѯ�������Ŀͻ�ͬʱ���Ŀͻ����ϣ�Ҫ��ѧ��Ҫ��INν����ɣ���
		select*  from customer where customerno in
		(select  customerno
		from change 
		where changedate in 
		(select ch.changedate
		from customer cu,change ch
		where customername like '��%'and  changetype='��'and cu.customerno=ch.customerno))



