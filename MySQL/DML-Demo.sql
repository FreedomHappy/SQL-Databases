/** DML（Data Manipulation Langauge，数据操纵/管理语言） （insert，delete，update，select） */

/**
  更新语句
 */
-- 多表条件
update user_profile up
inner join user_user_customer uuc on
up.user_code = uuc.user_code
set uuc.STATUS = '00X'
where up.STATUS = '99'
and uuc.user_type = '03';

