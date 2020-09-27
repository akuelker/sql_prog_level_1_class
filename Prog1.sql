Select * from employee;

sp_help employee;

sp_rename 'Employee.Hourrate', 'Employee.HourlyPay'

sp_rename 'Employee.HourlyPay', 'Hourrate'

--EXEC = Execute
EXEC sp_help employee;
EXEC sp_help employee;
/*
CREATE PROCEDURE procedureName 
AS
	sql statements;
	more sql statements;
*/

CREATE PROCEDURE emplist
AS
	select * from employee;

sp_help emplist;

exec sp_helptext emplist;

ALTER PROCEDURE emplist
AS
	select * from employee order by empid;

--using procedure
exec emplist;

--CREATE makes the procedure
--ALTER changes the procedure (must already exist)
--DROP deletes the procedure

DROP PROCEDURE emplist;

/*variables
DECLARE, initialize (SET), use
DECLARE @varName varType;
SET @varName = valueOFvarType;
print @varName;  --prints out the variable value
*/

/* If the code doesn't work outside the stored procedure (proc)
it won't work inside either */
--Hello world program of SQL
CREATE PROCEDURE mymessage
AS
	DECLARE @msg char(12);
	SET @msg = 'Hello World';
	PRINT @msg  --writeln, print

--always test afterwards

Exec mymessage;


ALTER PROCEDURE mymessage
AS
	DECLARE @msg char(12);
	--SET @msg = 'Hello World';
	SELECT @msg  = 'Hello World';
	PRINT 'Do I have your attention?';
	PRINT 'Today'' message is: ' + @msg;

/* p 8 Division */
CREATE PROCEDURE divide 
AS 
	DECLARE @numerator int, @denominator int,
		@answer int, @msg varchar(20);
	--SELECT MUST ONLY HAVE ONE RESULT - cannot have multiple
	SELECT  @numerator = 12, @denominator = 3;
	--Can I set multiple variables at once - NO!
	SET @ANSWER = @NUMERATOR/ @denominator;
	--Integer must be explicitly converted - no implicit convertion here!
	SET @msg = 'The answer is ' + CONVERT(CHAR(3), @answer);
	PRINT @MSG;

exec divide;

ALTER PROCEDURE divide 
	@numerator int, @denominator int
AS 
	DECLARE @answer int, @msg varchar(20);
	SET @ANSWER = @NUMERATOR/ @denominator;
	SET @msg = 'The answer is ' + CONVERT(CHAR(3), @answer);
	PRINT @MSG;

EXEC divide 4,2;  -- by position 
EXEC divide @denominator = 10, @numerator = 30;  -- by name

--DECLARATION and INITIALIZATION are on two different lines.
DECLARE @firstname varchar(20) 
SET @firstname = 'BETH';


ALTER PROCEDURE param_msg
	@firstname varchar(20) = 'BETH'
AS  -- do not skip as - all the warning says is syntax error
	/* takes a name and says Hello name */
	DECLARE @msg varchar(25);
	SET @msg = 'Hello, ' + @firstname + '!';
	PRINT @MSG;

EXEC param_msg 
EXEC param_msg 'Amanda';

--Time passes.  Procedure param_msg needs to change
ALTER PROCEDURE [dbo].[param_msg]
	@firstname varchar(20) = '',
	@lastname varchar(20) = ''
AS  -- do not skip as - all the warning says is syntax error
	/* takes a name and says Hello name */
	DECLARE @msg varchar(25);
	SET @msg = 'Hello, ' + @firstname +' '+ @lastname +  '!';
	PRINT @MSG;

EXEC param_msg @lastname = 'Arrowsmith';  -- But I supplied a lastname!
EXEC param_msg 'Amanda', 'Matteucci';
EXEC param_msg

CREATE PROCEDURE GETSLEEPHOURS
	@bday smalldatetime = 'Apr 16, 2019'
AS 
	DECLARE @DAYS int, @HOURS int;
	SET @DAYS = DATEDIFF(day, @bday, GETDATE());
	SET @HOURS = @DAYS * 8;
	PRINT @HOURS;


--EXEC GETSLEEPHOURS 'Apr 15, 2020' -- 8 --Yesterday
--EXEC GETSLEEPHOURS 'Apr 11, 2020' --8*5 = 40  5 days

/* We want to get member information for a specific member*/

--Find the table
CREATE PROCEDURE meminfo
	@memID char(5) 
AS
	--set @memID = 'AC135';  -- ANNE COOPER
	select * from dbo.members
	where mem_id = @memID;

EXEC meminfo 'AC135';

--TIME HAS PASSED
--going to be used for printing out cards
--Want member name, membership year
ALTER PROCEDURE meminfo
	@memID char(5) 
AS
	--set @memID = 'AC135';  -- ANNE COOPER; 2004
	DECLARE @fname char(15),  @lname char(15), @memyear int
	select @fname =  firstname,
		@lname = lastname,
		@memyear = year(memdate)  
		--@memyear = DATENAME(yyyy, memdate)
	from dbo.members
	where mem_id = @memID;
	PRINT 'Member Name: ' + RTRIM(@fname) +  ' ' + RTRIM(@lname);
	PRINT 'Member since: ' + CONVERT(char(4), @memyear); -- conversion issue here - but compiles

--EXEC meminfo 'AC135'

--p 19
/* more time passes - need dues amount.  
This is for the membership dun. */
ALTER PROCEDURE [dbo].[meminfo]
	@memID char(5) 
AS
	--set @memID = 'AC135';  -- ANNE COOPER; 2004
	DECLARE @fname char(15),  @lname char(15), 
		@memyear int, @mdues numeric(5,2); --5 digits total, 2 after
	select @fname =  members.firstname
		,@lname = members.lastname
		,@memyear = year(members.memdate)
		,@mdues = memtype.dues
	from dbo.members inner join memtype
		on members.memcode = memtype.memcode
	where mem_id = @memID;
	PRINT 'Member Name: ' + RTRIM(@fname) +  ' ' + RTRIM(@lname);
	PRINT 'Member since: ' + CONVERT(char(4), @memyear); -- conversion issue here - but compiles
	PRINT 'Membership dues: $' + CONVERT(char(6), @mdues);
--EXEC meminfo 'AC135'

/*select * from members
inner join memtype
on members.memcode = memtype.memcode;
*/

SELECT MEMDATE FROM MEMBERS;
--Aggregation in a stored procedure
--IF you can do it with a sql statement, it can be done in a stored proc
create PROCEDURE MIN_MAX
AS 
	DECLARE @FIRSTDATE SMALLDATETIME, @LASTDATE SMALLDATETIME
	SELECT @FIRSTDATE = MIN(MEMDATE), @LASTDATE = MAX(MEMDATE)
	FROM MEMBERS;

	PRINT 'FIRST MEMBERSHIP: ' + CONVERT(CHAR(20), @FIRSTDATE, 107);
	PRINT 'FIRST MEMBERSHIP: ' + CONVERT(CHAR(20), @LASTDATE, 107);

--EXEC MIN_MAX;
--THIS IS NOT VERY FLEXIBLE
CREATE PROCEDURE HARD_INSERT
AS
	INSERT INTO MEMTYPE(MEMCODE, MEM_DESCRIP, DUES)
	VALUES ('DN', 'DONOR', 0);

--EXEC HARD_INSERT;

CREATE PROCEDURE PARAM_INSERT
	@MCODE CHAR(2), @MDESCRIP VARCHAR(10) = NULL,
	@MDUES NUMERIC(5,2) = NULL
AS
	--INSERT ROW INTO MEMTYPE
	INSERT INTO MEMTYPE(MEMCODE, MEM_DESCRIP, DUES)
	VALUES (@MCODE, @MDESCRIP, @MDUES);
	--VERIFY TO USER THAT THIS HAPPENED
	SELECT * FROM MEMTYPE
	WHERE MEMCODE = @MCODE;

EXEC PARAM_INSERT 'AR', 'ARTIST', 10.95;
EXEC PARAM_INSERT 'AA';  -- DEFAULTS

/* UPDATING IS POSSIBLE TOO */
/* UPDATE TABLENAME
	SET COLUMN1 = NEWVALUE,
		COLUMN2 = NEWVALUE
	WHERE CONDITION  -- VERY IMPORTANT! */

CREATE PROCEDURE UPDATE_DUES
	--DEFAULT 10% INCREASE
	@INCR NUMERIC(5,2) = .1
AS 
	UPDATE MEMTYPE
	SET DUES = DUES * (1 + @INCR)

--tHIS IS permanent, so put in a transaction for testing
BEGIN TRANSACTION
select * from memtype;
EXEC UPDATE_DUES .05
select * from memtype;
ROLLBACK TRANSACTION;
--commit;

CREATE PROCEDURE DELETE_MEMBERS
	@MCODE CHAR(2) = NULL
AS 
	DELETE FROM MEMBERS
	WHERE MEMCODE = @MCODE;
--@@ROWCOUNT IS A GLOBAL VARIABLE - 
-- IT MUST BE DONE IMMEDIATELY AFTER THE COMMAND
	PRINT 'NUMBER OF DELETED MEMBERS: ' + CONVERT(CHAR(3), @@ROWCOUNT);

--tESTING
BEGIN TRANSACTION
SELECT * FROM MEMBERS WHERE MEMCODE = 'SR';
EXEC DELETE_MEMBERS 'SR';
SELECT * FROM MEMBERS WHERE MEMCODE = 'SR';
--ROLLBACK
--COMMIT

--Ex2-3
select * from jobs;

alter procedure increase_max
	@exemptIncr int =0,
	@notExemptIncr int =0
AS
	/* Exempt jobs */
	update jobs
		SET maxrate = maxrate * (1 + @exemptIncr/100.0)
	where class = 'EXEMPT';
	/*non-exempt jobs */
	update jobs
		SET maxrate = maxrate * (1 + @notExemptIncr/100.0)
	where class = 'NON-EXEMPT';

begin transaction;
select * from jobs;
exec increase_max 1, 2;
--exec increase_max;
select * from jobs;
--rollback;

--SQL Integer/integer is an integer
--to get around this, make one have a decimal point
select 3/2, 3/2.0;

--p 25  Writing condition If statements
/* 
If condition 
	BEGIN  --{
		SQL statement1
		SQL statement2
	END  -- }
ELSE 
	BEGIN  -- {
		sql statemen1
		sql statement2
	END -- }

*/

Create PROCEDURE simple_if
	@NUM1 INT =0, @NUM2 INT =0
AS
IF @NUM1 > @NUM2
	PRINT 'Number 1 is greater than number 2';
print 'Thanks for playing';

EXEC SIMPLE_IF 2, 1;
EXEC SIMPLE_IF 1, 2;
EXEC SIMPLE_IF; --0 and 0

ALTER PROCEDURE simple_if
	@NUM1 INT =0, @NUM2 INT =0
AS
IF @NUM1 > @NUM2
	BEGIN
		PRINT 'Number 1 is greater than number 2';
		PRINT 'You''re so smart';  -- is this part of the if or the program?
	END
ELSE 
	IF @NUM1 < @NUM2
		BEGIN
			PRINT 'Number 1 is less than number 2';
			PRINT 'Please try again.';  -- is this part of the if or the program?
		END
	ELSE 
		BEGIN
			PRINT 'The numbers are equal.';
			PRINT 'Are you trying to trick me?';  -- is this part of the if or the program?
		END
print 'Thanks for playing';

--Time has passed.
exec simple_if null, 0;

USE [prog1sqld31]
GO
/****** Object:  StoredProcedure [dbo].[simple_if]    Script Date: 04/16/2020 14:01:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[multiple_ifs]
	@NUM1 INT =0, @NUM2 INT =0
AS
IF @NUM1 IS NULL OR @NUM2 IS NULL 
	PRINT 'You must enter a non-null value for both numbers.'
ELSE
	IF @NUM1 > @NUM2
		BEGIN
			PRINT 'Number 1 is greater than number 2';
			PRINT 'You''re so smart';  -- is this part of the if or the program?
		END
	ELSE 
		IF @NUM1 < @NUM2
			BEGIN
				PRINT 'Number 1 is less than number 2';
				PRINT 'Please try again.';  -- is this part of the if or the program?
			END
		ELSE
			IF @NUM1 = @NUM2 
				BEGIN
					PRINT 'The numbers are equal.';
					PRINT 'Keep trying...'; 
				END
	print 'Thanks for playing';

exec multiple_ifs 2, 1;  --  >  Smart
exec multiple_ifs 1,2;	--  <	Try again
exec multiple_ifs 1,1; -- =	Keep trying
exec multiple_ifs null, 0;  --null one  trick
exec multiple_ifs 0, null;  -- one null	trick
exec multiple_ifs null, null;  -- all null trick

ALTER PROCEDURE MEM_DISC
	@MEMID char(5)=NULL
as
	DECLARE @MDATE SMALLDATETIME, @MCODE CHAR(2);
	DECLARE @LEVEL VARCHAR(10), 
		@DISC NUMERIC(4,2);
	SET @LEVEL = 'SILVER';
	SET @DISC = 0;
	select @MDATE = memdate, @MCODE = MEMCODE
	from members where mem_id = @memid;
	IF @MCODE = 'ST'
		BEGIN
		IF @MDATE < '01-01-2003' 
			BEGIN
			SET @LEVEL = 'PLATINUM';
				SET @DISC = .15
			END 
		ELSE 
			IF @MDATE < '01-01-2005' 
				BEGIN
				--MEMBERSHIP GOLD;
					SET @LEVEL = 'GOLD';
					SET @DISC = .1
				END
		END
	PRINT 'MEMBER ID: ' + @MEMID;
	PRINT 'MEMBERSHIP LEVEL: ' + @LEVEL;
	PRINT 'MEMBERSHIP DISCOUNT: ' + CONVERT(CHAR(5), @DISC * 100 ) + '%';
	PRINT 'MEMBERSHIP CODE: ' + @MCODE;

--TEST CASES
EXEC MEM_DISC 'AC135'; --gold, 10% (sTUDENT)
EXEC MEM_DISC 'GG292' --SILVER, 0% (ADULT)
EXEC MEM_DISC 'LS504' --PLATINUM, 15% (STUDENT)
EXEC MEM_DISC 'PS107' -- SILVER, 0%, CHILD 03
EXEC MEM_DISC 'TC769' -- SILVER, 0%, FAMILY 04
EXEC MEM_DISC 'RJ533' -- SILVER, 0%, STUDENT 06  -- LEVEL AND DISCOUNT HIDDEN - why?
EXEC MEM_DISC 'AH119' -- SILVER 0%, SENIOR 07

SELECT * FROM MEMBERS
ORDER BY MEMDATE;

--Exercise 3-3
alter PROCEDURE EMP_RAISE
	@SCORE INT =2
AS
	DECLARE @RAISE INT; --PERCENT INCREASE
	SET @RAISE = 0; -- DEFAULT VALUE
	if @score between 1 and 3
		begin
			IF (@SCORE = 3)
				SET @RAISE = 5
			IF (@SCORE = 2)
				SET @RAISE = 3;
			PRINT 'Your raise is: ' + convert(char(1), @raise) + '%'
		end
	ELSE 
		PRINT 'Enter 1,2,or 3 as the rating.';

EXEC EMP_RAISE 3 --5%
EXEC EMP_RAISE 2 --3%
EXEC EMP_RAISE 1 --0%
EXEC EMP_RAISE 0 --don't enter junk
exec emp_raise null;		


--page 36
--users/ programs often have nulls - you need to check
CREATE PROCEDURE EXIT_IF_NULL
	@NUM INT = NULL
AS
	IF @NUM IS NULL
		BEGIN
			PRINT 'YOU ENTERED A NULL.  GOODBYE.'
			RETURN;  --- LEAVES THE PROCEDURE
		END
	--NORMAL PROCESSING
	PRINT 'YOUR NUMBER IS: ';
	PRINT @NUM;

EXEC EXIT_IF_NULL  -- GOODBYE
EXEC EXIT_IF_NULL NULL  -- GOODBYE
EXEC EXIT_IF_NULL  3 -- NUMBER IS 3

sELECT * FROM EMPLOYEE;
--ID	 ORIG	5%		3%
--A1465  10.65  11.18, 10.98
--B2559  39.25  41.21, 11.31

alter PROCEDURE EMP_RAISE
	@EMP_ID CHAR(5) = NULL,
	@SCORE INT =2
AS
	DECLARE @RAISE INT; --PERCENT INCREASE
	SET @RAISE = 0; -- DEFAULT VALUE
	IF @EMP_ID IS NULL
		BEGIN
			PRINT 'You did not enter your employee id.  Try again.'
			RETURN;
		END
	if @score between 1 and 3
		begin
			IF (@SCORE = 3)
				SET @RAISE = 5
			IF (@SCORE = 2)
				SET @RAISE = 3;
		end
	ELSE 
		BEGIN
			PRINT 'Enter 1,2,or 3 as the rating.';
			RETURN;
		END
	--GOT RID OF JUNK - MAIN PART
	PRINT 'Your raise is: ' + convert(char(1), @raise) + '%'
	update employee
		set hourrate = hourrate * (1 + @raise*.01)
	where empid= @emp_id;
	PRINT 'UPDATE COMPLETE';
	DECLARE @newPay numeric(5,2);
	select @newPay = hourrate
	from employee
	where empid = @emp_id
	print 'Your new hour rate is: $' + 
		convert(varchar(8), @newPay)


exec emp_raise
BEGIN TRANSACTION
--A1465  10.65  11.18, 10.98
--EXEC EMP_RAISE 'A1465', 3  --11.98
--EXEC EMP_RAISE 'A1465', 2 --10.98
EXEC EMP_RAISE 'A1465', 1 --10.65
--ROLLBACK

select * from employee where empid = 'A1465';