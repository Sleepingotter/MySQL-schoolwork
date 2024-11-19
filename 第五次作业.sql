use yggl;
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

#(5)

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






