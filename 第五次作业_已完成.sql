use yggl;
# 一、存储函数相关
# (1)

select * from course;
set @Java_CId := (select CId from course where CName = 'JAVA程序设计');
#select * from register;
select max(Score) as '最高分' , avg(Score) as '平均分' from register where CId = @Java_CId;

#(2)

#drop function f_course;

DELIMITER //
create function f_course(CCId CHAR(10)) returns CHAR(10)
DETERMINISTIC
begin
			DECLARE CCName CHAR(10);
			set CCName := (select CName from course where CId = CCId);
			return CCName;
end //
DELIMITER ;

select f_course('C03');

#(3)

delimiter //
create function exthree(max int,min int) returns int DETERMINISTIC
begin 
	declare cur int default min;
	declare sum int default 0;
	WHILE cur <= max DO
		if ((cur & 1) = 1) then 
			set sum = sum + cur;
		end if;
		set cur = cur + 1;
	END WHILE;
	return sum;
end //
delimiter ;

select exthree(50,0);
select exthree(150,50);

#(4)

delimiter //
create function casetwo(var int) returns char(10) deterministic
begin
	declare result char(10);
	case
			when var = 7 then 
					set result := '1';
			when var = 14 then 
					set result := '2';
			else
					set result := '-1';
	end case;
	return result;
end //
delimiter ;

select casetwo(7),casetwo(14),casetwo(1);

# 二、存储过程相关
# (5)

delimiter //
create function dj_fn() returns char(10) deterministic
begin 
	declare result char(10);
	declare g double;
	declare grade cursor for select Score from register where SId = 'S002' and CId = 'C01';
	open grade;
	fetch grade into g;
	case
			when g >= 90 
					then set result := '优秀';
			when g < 90 and g >= 80
					then set result := '良好';
			when g < 80 and g >= 70
					then set result := '中等';
			when g < 70 and g >= 60
					then set result := '及格';
			else 
					set result := '不及格';
	end case;		
	close grade;
	return result;		
end //
delimiter ;

# drop function dj_fn;
select dj_fn();

# (1) 

create procedure cn_proc()
begin 
	select count(1) as '总人数' from student;
end;
call cn_proc();

# (2)

create procedure selectscore (in VSId char(10),in VCId char(10))
begin 
	select Score from register where VSId = SId and VCId = CId;
end;
call selectscore('S002','C01');

# (3)

create procedure upbirth (in VSName char(10),in VBirth date)
begin 
	update student set SBirth = VBirth where VSName = SName; 
end;
call upbirth('罗丽','2000-11-22');
select * from student;

# (4)

create procedure stu_proc()
#declare exit handler for sqlstate '02000' close s;
begin
	declare SSID,SSNAME,SSBIRTH char(10);
  declare s cursor for select Sid ,SName,SBirth from student;
	open s;
	label: loop
			FETCH s into SSID,SSNAME,SSBIRTH;
			if SSID = 'S004' then
					select SSNAME,SSBIRTH;
					close s;
					leave label;
			end if;
	
	end loop label;
end;
call stu_proc();

# (5)

create procedure score_proc()
begin 
		declare num int;
		declare CCId char(10); 
		declare c cursor for select CLimit,CId from course;
		declare exit handler for not found close c;
		open c;
		label:loop
				fetch c into num,CCId;
				case 
						when num < 40 then
								update course set CLimit = CLimit+30 where CCId = CId;
								iterate label;
						when num>=40 and num < 60 then
								update course set CLimit = CLimit+20 where CCId = CId;
								iterate label;
						when num>=60 and num < 90 then
								update course set CLimit = CLimit+10 where CCId = CId;
								iterate label;		
						else 
							update course set CLimit =CLimit+ 5 where CCId = CId;
				end case;
		end loop label;
end;
call score_proc();

# 三、触发器相关
# (1)
# desc register;
CREATE TABLE `sc` (
  `SId` char(4) NOT NULL COMMENT '学号',
  `CId` char(3) NOT NULL COMMENT '课程名',
  `Score` decimal(5,2) DEFAULT NULL COMMENT '成绩',
  `RDate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
  PRIMARY KEY (`SId`,`CId`),
  KEY `REG_CID` (`CId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='备份注册表';

select * from register;

insert into sc values
('S001','C01',72.00,'2019-08-07 21:14:19'),
('S001','C02',50.00,'2019-07-31 05:37:02'),
('S002','C01',95.00,'2019-08-07 23:41:34'),
('S002','C05',53.00,'2019-06-25 05:45:44'),
('S002','C06',51.00,'2019-07-13 19:21:38'),
('S002','C07',62.00,'2019-08-14 03:13:58'),
('S003','C02',61.00,'2019-07-24 16:21:03'),
('S003','C03',100.00,'2019-08-01 01:36:32');

create trigger del_trig
after delete on course for each row
begin 
	delete from sc where old.CId = CId;
end;
#show triggers;

# (2)

create trigger cno_tri
after update on course for each row
begin 
	update register set CId = new.CId where CId = old.CId;
end;

# (3)

create trigger tead_trig 
before update on teacher for each row
begin
	if new.TGender not in('男','女') then
			set new.TGender = old.TGender;
	end if;
end;

# 四、事务与权限管理相关
# (1)

begin;
update course set CName = 'PHP语言' where CId = 'C05';
commit;

# (2)

create procedure auto_del()
begin 
		start transaction;
		delete from course where CId = 'C04';
		rollback;
end;
# drop procedure auto_del;
call auto_del();

# (3)

create user 'ex_user'@'%' identified by '123456';
# drop user 'ex_user'@'%';

# (4)

alter user 'ex_user'@'%' identified with mysql_native_password by '111111';

# (5)

grant delete on registration.student to 'ex_user'@'%';

# (6)

grant update on registration.student.SName to 'ex_user'@'%';

# (7)
grant execute on procedure cn_proc to 'ex_user'@'%'

# (8)
mysql -u ex_user -p111111;
use yggl;
call cn_proc;











