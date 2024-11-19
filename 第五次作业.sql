# (1)
use yggl;
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

create function dj_fn() returns char(10) DETERMINISTIC
begin 
	declare grade cursor for select Score from register where SId = 'S002' and CId = 'C01';
	declare result char(10);
	case
			when grade >= 90 
					then result := '优秀';
			when grade < 90 and grade >= 80
					then result := '良好';
			when grade < 80 and grade >= 70
					then result := '中等';
			when grade < 70 and grade >= 60
					then result := '及格';
			else 
					result := '不及格';
	end case;		
	return result;		
end //

delimiter ;





