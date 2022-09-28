-- 查找线程并杀死
select * from information_schema.processlist where DB = 'ldh-test';
kill connection 101643;

