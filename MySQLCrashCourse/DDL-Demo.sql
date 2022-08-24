/**
修改表结构
 */
-- 在旧表中 添加自增主键
alter table auth_menu_page add column id bigint auto_increment primary key ;
-- 在旧表中，添加复合主键
alter table auth_menu_page
    add primary key (app_code, menu_code, page_code);
