
create database job;

use job;

create table user(
	userid int not null,
	username varchar(20) not null,
	passwd varchar(20) not null,
	info text
) comment '用户表';
create unique index  index_uid on user(userid);
create index index_user on user(username,passwd);
create fulltext index index_info on user(info);

#drop table user;

create table information(
	id int not null,
	name varchar(20) not null,
	sex varchar(4) not null,
	birthday date ,
	address varchar(50),
	tel varchar(20),
	pic blob 
)comment '信息表';

create index index_name on information(name);

create index index_bir on information(birthday,address);

alter table information add unique index index_id (id asc); 

drop index index_user on user;
drop index index_id on information;

use yggl;

create view v_student as select student.SId,student.SName,register.RDate from register left join student on register.SId = student.Sid where year(register.RDate) >= 1998;

create view v_grade as select course.CName,max(register.Score),min(register.Score),avg(register.Score) from register left join course on register.CId = course.CId group by register.CId;
#select * from v_student;

insert into v_student (SId,SName,RDate) values("S100","罗浩","2001-11-12");
select * from student;

update v_student set SName = "唐建华" where SId = "S006";

create or replace view v_student as select student.SId,student.SName,register.RDate from register left join student on register.SId = student.Sid where year(register.RDate) >= 1998 with check option;

insert into v_student value("S101","林海","1995-02-02");
# 插入不成功，因为该视图已经添加了with check option 插入的数据需要满足条件

create view v_s as select Sid, SName, SBirth from student where student.SGender = "男";
select * from v_s;

update v_s set SName = "王春宇" where Sid = "S001";
select * from student;

delete from v_s where Sid = "S002";
select * from student;

desc v_student;

drop view v_student;

drop view v_s;
