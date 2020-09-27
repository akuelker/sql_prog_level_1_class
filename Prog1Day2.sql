USE [prog1sqld31]
GO
/****** Object:  StoredProcedure [dbo].[EMP_RAISE]    Script Date: 04/17/2020 08:35:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[EMP_RAISE]
	@EMP_ID CHAR(5) = NULL,
	@SCORE INT =2
AS
	-- Check for that the employee id is correct
	if @EMP_ID not in (select empid from employee)
		begin
			PRINT 'Please enter a valid employee ID.'
			RETURN
		end
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

select * from employee;

begin transaction
exec emp_raise 'A1465', 3 --11.18
--rollback

ALTER PROCEDURE [dbo].[EMP_RAISE]
	@EMP_ID CHAR(5) = NULL,
	@SCORE INT =2
AS
	-- Check for that the employee id is correct
	if not exists (select empid from employee 
		where empid = @EMP_ID)
		begin
			PRINT 'Please enter a valid employee ID.'
			RETURN
		end
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

begin transaction
exec emp_raise 'A1465', 3 --11.18
--rollback

/* Simple Case: Compares the expression to a simple set of expressions 
	Like the switch statement - with breaks */
/* Searched Case: evaluates a set of boolean expressions
	They don't even need to be related */
/* Both cases: First one true is returned value */

/* Simple Case 
CASE input_expression
	WHEN value1 then result1
	WHEN expression2 then result2
	...
	ELSE defaultResult  -- sometimes I put dumb values here
END
*/

SELECT MEM_ID, MEMCODE,
	CASE MEMCODE
		WHEN 'CH' THEN .25
		WHEN 'ST' THEN .2
		WHEN 'FM' THEN .1
		ELSE 0
	END AS MEM_DISCOUNT
FROM MEMBERS;

/* Spec says: Enter membershipcode
	Returns: membershipcode, discount in % */
CREATE PROCEDURE SIMPLE_CASE
	@MCODE CHAR(2) = NULL
AS
	DECLARE @DISC NUMERIC(3,2);
	SET @DISC = 
		CASE @MCODE
			WHEN 'CH' THEN .25
			WHEN 'ST' THEN .2
			WHEN 'FM' THEN .1
			ELSE 0
		END 
	PRINT 'MEMBER TYPE: ' + @MCODE
	PRINT 'DISCOUNT: ' + CONVERT(VARCHAR(5), @DISC * 100) + '%'	

/* TESTS */
exec SIMPLE_CASE 'CH'; --25%
exec SIMPLE_CASE 'ST'; --20%
exec SIMPLE_CASE 'FM'; --10%
exec SIMPLE_CASE 'AD'; --0%
exec SIMPLE_CASE;	--0% (NO MEMBERSHIP)
exec SIMPLE_CASE 'JUNK'; --0%

/* The searched case is really powerful.  
The conditions do not even need to be related
Conditions can have logic (< > = AND OR)
Remember First true is the value */

/* Searched case 
CASE 
	WHEN CONDITION1 THEN RESULT1
	WHEN CONDITION2 THEN RESULT2
	WHEN CONDITION3 THEN RESULT3
	ELSE ELSE_RESULT  -- OPTIONAL
END
*/

/* spec: judge age and give discount accordingly */
ALTER PROCEDURE SEARCHED_CASE
	@AGE INT = 0
AS
	DECLARE @MCODE CHAR(2)
	SET @MCODE = 
		CASE 
			WHEN @AGE <= 10 THEN 'CH'
			WHEN @AGE <= 21 THEN 'ST'
			WHEN @AGE <= 54 THEN 'AD'
			ELSE 'SR'
		END
	PRINT 'MEMBERSHIP TYPE: ' + @MCODE

EXEC SEARCHED_CASE 10;  --CH
EXEC SEARCHED_CASE 21;  --ST
EXEC SEARCHED_CASE 35;  --AD
EXEC SEARCHED_CASE 55;  --SR

/* Updating memberships */
/* Input: membershipid to change, age, 
number of family members
*/
ALTER PROCEDURE SEARCHED_CASE
	@MEMID CHAR(5) = NULL, @AGE INT = 0,
	@FAMNUM INT = 1
AS
	--CHECK MEMBERSHIP CODE
	IF NOT EXISTS 
		(SELECT * FROM MEMBERS 
			WHERE MEM_ID = @MEMID)
		BEGIN
			PRINT 'New registration. Please get all information.'
			RETURN;
		END
	DECLARE @MCODE CHAR(2)
	SET @MCODE = 
		CASE 
			WHEN @FAMNUM > 1 THEN 'FM'
			WHEN @AGE <= 10 THEN 'CH'
			WHEN @AGE <= 21 THEN 'ST'
			WHEN @AGE <= 54 THEN 'AD'
			ELSE 'SR'
		END
	--Get the old value
	DECLARE @OLDCODE CHAR(2);
	SELECT @OLDCODE = MEMCODE 
	FROM MEMBERS
	WHERE MEM_ID = @MEMID
	--UPDATE THE MEMBERS TABLE WITH NEW CODE
	IF @OLDCODE <> @MCODE  
		BEGIN
			UPDATE MEMBERS 
				SET MEMCODE = @MCODE
			WHERE MEM_ID = @MEMID
			PRINT 'MEMBER ID: ' + @MEMID
			PRINT 'MEMBERSHIP TYPE CHANGED TO: ' + @MCODE
		END
	ELSE
		BEGIN
			PRINT 'MEMBER ID: ' + @MEMID
			PRINT 'MEMBERSHIP TYPE NOT CHANGED AND IS: ' + @MCODE
		END

BEGIN Transaction
EXEC SEARCHED_CASE @memid='AC135',@age=10,@famnum = 1;  --CH
EXEC SEARCHED_CASE @memid='AC135',@age=21,@famnum = 1;  --ST
EXEC SEARCHED_CASE @memid='AC135',@age=35,@famnum = 1;  --AD
EXEC SEARCHED_CASE @memid='AC135',@age=55,@famnum = 1;  --SR
EXEC SEARCHED_CASE @memid='AC135',@age=55,@famnum = 3; --FM
EXEC SEARCHED_CASE @memid='AC135',@age=35,@famnum = 3; --FM
EXEC SEARCHED_CASE @memid='NOONE',@age=55,@famnum = 3; --NO UPDATE
ROLLBACK

--Exercise 4-2 challenge
ALTER PROCEDURE SALARY_GRADE
	@EMPID CHAR(5)
AS
	/* THIS IS A SEARCH CASE AS NO EXACT MATCHES */
	DECLARE @HOURRATE NUMERIC(5,2),
		@GRADE CHAR(1)
	select @HOURRATE = HOURRATE,
		@GRADE = CASE 
			WHEN HOURRATE <10 THEN 'A'
			WHEN HOURRATE < 20 THEN 'B'
			WHEN HOURRATE < 30 THEN 'C'
			ELSE 'D' 
		END
	from employee WHERE EMPID = @EMPID;
	IF @HOURRATE IS NULL OR @GRADE IS NULL 
		BEGIN
			PRINT 'The employee is not entered properly ' + 
				'in the system: ' + @empid
			RETURN;
		END
	PRINT 'Hourly rate: $' + convert(char(6), @hourrate);
	PRINT 'Salary Grade: ' +  @GRADE;

exec SALARY_GRADE 'A6395' --A
exec SALARY_GRADE 'A1465'  -- B
exec SALARY_GRADE 'B1158' --C
exec SALARY_GRADE 'B2559'  --D
EXEC SALARY_GRADE 'NOONE';

--P 46
/* WHILE LOOP */
/* WHILE CONDITION
		BEGIN {
			SQL STATEMENT;
			SQL STATEMENT;
			CONDITION CHANGE - HOPEFULLY;
		END }
*/
ALTER PROCEDURE CREDIT_LOOP
	 @BAL NUMERIC (9,2)
AS
	DECLARE @PMT NUMERIC(7,2);
	SET @PMT = 300;
	WHILE @BAL >= @PMT
		BEGIN
			SET @BAL = @BAL - @PMT  -- CONDITION CHANGE
			PRINT 'NEW BALANCE: $' + CONVERT(CHAR(10), @BAL)
		END
	IF @BAL > 0 
		PRINT 'FINAL PAYMENT: $'  + CONVERT(CHAR(10), @BAL)

EXEC CREDIT_LOOP 3200;
PRINT '';
EXEC CREDIT_LOOP 3000;

/* USE A COUNTER - MAKES SURE THIS OCCURS A SET NUMBER OF TIMES */
/* Making a while a FOR */

ALTER PROCEDURE CREDIT_LOOP
	@BAL NUMERIC (9,2)
AS
	DECLARE @PMT NUMERIC(7,2);
	DECLARE @NUM_PMT INT;
	SET @PMT = 300;
	SET @NUM_PMT = 0;  /* HOW MANY PAYMENTS */
	WHILE @BAL >= @PMT
		BEGIN
			SET @BAL = @BAL - @PMT;
			SET @NUM_PMT = @NUM_PMT + 1;  --accumulator
			PRINT 'New balance after payment # ' + 
				convert(char(5), @num_pmt) + 
				'$' + convert (char(10), @bal)
		END
	PRINT ''
	PRINT 'Total number of payments until payoff: ' + 
		convert(char(5), @num_pmt)
	if @bal > 0 
		print 'Plus one final payment of $' + convert(char(10), @bal)

EXEC CREDIT_LOOP 3200;
PRINT '';
EXEC CREDIT_LOOP 3000;

/* FOR LOOP EMULATOR */
CREATE PROCEDURE SAVINGS_LOOP
 @MONTHLY_SAVINGS NUMERIC(7,2) 
AS
	DECLARE @TOTAL_SAVINGS NUMERIC(7,2), 
		@INTEREST NUMERIC(4,4), @NUM_MONTHS INT
	SET @TOTAL_SAVINGS = 0;
	SET @INTEREST = .0083;
	SET @NUM_MONTHS = 0
	WHILE @NUM_MONTHS < 12
		BEGIN
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS + @MONTHLY_SAVINGS;
			--INTEREST
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS * (1 + @INTEREST);
			SET @NUM_MONTHS = @NUM_MONTHS + 1;
			PRINT 'SAVINGS AFTER ' + CONVERT(CHAR(2), @NUM_MONTHS) + 
				' MONTHS: $' +  CONVERT(CHAR(8), @TOTAL_SAVINGS)
		END
		PRINT ''
		PRINT 'Final Savings: $' + CONVERT(CHAR(8), @TOTAL_SAVINGS)

EXEC SAVINGS_LOOP 100;

-- Boss says: goal oriented savings account
ALTER PROCEDURE SAVINGS_LOOP
 @MONTHLY_SAVINGS NUMERIC(7,2) 
AS
	DECLARE @TOTAL_SAVINGS NUMERIC(7,2), 
		@INTEREST NUMERIC(4,4), @NUM_MONTHS INT
	SET @TOTAL_SAVINGS = 0;
	SET @INTEREST = .0083;
	SET @NUM_MONTHS = 0
	WHILE @NUM_MONTHS < 12
		BEGIN
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS + @MONTHLY_SAVINGS;
			--INTEREST
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS * (1 + @INTEREST);
			SET @NUM_MONTHS = @NUM_MONTHS + 1;
			PRINT 'SAVINGS AFTER ' + CONVERT(CHAR(2), @NUM_MONTHS) + 
				' MONTHS: $' +  CONVERT(CHAR(8), @TOTAL_SAVINGS)
			IF @TOTAL_SAVINGS > 1000
				BEGIN
					PRINT 'YOU REACHED YOUR GOAL!'
					PRINT ''
					BREAK -- EXITS FROM THE LOOP BUT NOT THE PROCEDURE
				END
		END
		PRINT ''
		PRINT 'Final Savings: $' + CONVERT(CHAR(8), @TOTAL_SAVINGS)

-- Boss now says: Let them know they reached their goal but to keep saving
ALTER PROCEDURE SAVINGS_LOOP
 @MONTHLY_SAVINGS NUMERIC(7,2) 
AS
	DECLARE @TOTAL_SAVINGS NUMERIC(7,2), 
		@INTEREST NUMERIC(4,4), @NUM_MONTHS INT
	SET @TOTAL_SAVINGS = 0;
	SET @INTEREST = .0083;
	SET @NUM_MONTHS = 0
	WHILE @NUM_MONTHS < 12
		BEGIN
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS + @MONTHLY_SAVINGS;
			--INTEREST
			SET @TOTAL_SAVINGS = @TOTAL_SAVINGS * (1 + @INTEREST);
			SET @NUM_MONTHS = @NUM_MONTHS + 1;
			PRINT 'SAVINGS AFTER ' + CONVERT(CHAR(2), @NUM_MONTHS) + 
				' MONTHS: $' +  CONVERT(CHAR(8), @TOTAL_SAVINGS)
			IF @TOTAL_SAVINGS > 1000
				BEGIN
					PRINT 'YOU REACHED YOUR GOAL!'
					PRINT ''
					CONTINUE -- GOES TO THE NEXT ITERATION
				END
			PRINT 'Keep savings  - almost to your goal...'
		END
		PRINT ''
		PRINT 'Final Savings: $' + CONVERT(CHAR(8), @TOTAL_SAVINGS)

exec savings_loop 100;

/* 
The studies on programming errors: BREAK AND CONTINUE ARE ESPECIALLY PRONE TO ERRORS
AND ARE HARD FOR programmers to fix. Often the second programmer doesn't even look
for break or continue and completely misses that there are early exits to the loop.

The general advice is: if it fits well in the while condition, do so.
If break/ continue are natural for the loop, do it at one location, not many
*/
/* code refactoring */
/* Duplicated code: Put in a function or procedure and call that one */
/* Complicated conditions: 
boolvariable = complicated condition
if boolvariable then.... */
/* loops inside of loops inside of loops: 
	Think about what you are trying to do: maybe not as many loops are needed
	Maybe the inner loop needs to be in a procedure */
/* Do you need a class ?   Do you need to remove a class */
/* are there junk comments  - old comments that are no longer true */


/* infinte loop - we are creating an exit. However...
once you discover loops, an infinite loop will happen. Know how to stop the code. */
CREATE PROCEDURE INFINITE_LOOP
	@NUM INT = 0
AS
	WHILE 1=1 --CONDITION NEVER CHANGES
		BEGIN
			PRINT 'Your number is: ' + CONVERT(char(3), @num)
			--REFACTORED TO ONE EXIT
			IF (@NUM = 5 AND DATENAME (DW, GETdATE()) = 'MONDAY')
				OR (@NUM > 10)
				BREAK;
			SET @NUM = @NUM + 1
		END

EXEC INFINITE_LOOP;

--BOSS WANTS TO KNOW NUMBER OF NEW MEMBERS AND TOTAL MEMBERS EACH YEAR
--DOING AS ONCE OFF (ONE TIME CODE) TO START
DECLARE @MEMYEAR INT, @TOTAL_MEMS INT, @NEW_MEMS INT;
SET @TOTAL_MEMS = 0;
SET @NEW_MEMS = 0;
SELECT @MEMYEAR = YEAR(MIN(MEMDATE)) FROM MEMBERS;
WHILE @MEMYEAR <= YEAR(GETdATE())
	BEGIN
		SELECT @NEW_MEMS = COUNT(*) FROM MEMBERS
			WHERE @MEMYEAR = YEAR(MEMDATE);
		SET @TOTAL_MEMS = @TOTAL_MEMS + @NEW_MEMS;
		PRINT 'Year: ' + CONVERT(CHAR(4), @MEMYEAR);
		PRINT 'New Members: ' + CONVERT(CHAR(4), @NEW_MEMS);
		PRINT 'Total Members: ' + CONVERT(CHAR(4), @TOTAL_MEMS);
		print '';
		SET @MEMYEAR = @MEMYEAR + 1  -- WITHOUT THIS, INFINTE LOOP
	END

/* page 55 */
/* BEGIN Transaction 
	commit  
	rollback
They are often used in procedures */

CREATE PROCEDURE TRG_RAISE_LOOP
AS
	DECLARE @AVG_RATE NUMERIC(7,2)
	--GET CURRENT AVERAGE RATE
	SELECT @AVG_RATE = AVG(HOURRATE)
		FROM EMPLOYEE
		WHERE JOBCODE = 'TRG';
	PRINT 'INITIAL AVG RATE:  $' + CONVERT(CHAR(10), @AVG_RATE)
	WHILE (@AVG_RATE < 13)
		BEGIN
			BEGIN TRANSACTION
			UPDATE EMPLOYEE
				SET HOURRATE = HOURRATE* 1.05
			WHERE JOBCODE = 'TRG';
			--SEE WHERE AVERAGE IS NOW
			SELECT @AVG_RATE = AVG(HOURRATE)
				FROM EMPLOYEE
				WHERE JOBCODE = 'TRG';
			PRINT 'NEW AVG RATE:  $' + CONVERT(CHAR(10), @AVG_RATE)
			--IF AVERAGE > LIMIT, ROLLBACK
			IF @AVG_RATE > 13
				BEGIN
					PRINT 'AVERAGE EXCEEDS LIMIT'
					PRINT 'ROLLING BACK LAST UPDATE'
					ROLLBACK TRANSACTION;
				END
			ELSE
				BEGIN
					PRINT 'AVERAGE WIHTING LIMIT'
					PRINT 'COMMIT LAST UPDATE'
					COMMIT TRANSACTION;
				END				
		END

EXEC TRG_RAISE_LOOP;

/* CURSORS - 5 step process
DECLARE cursor_name CURSOR 
	FOR select statement;

OPEN cursor_name;
FETCH  cursor_name
	while loop here
		--fetch inside 
		FETCH next FROM cursor_name;  -- generally
CLOSE cursor_name;
DEALLOCATE  cursor_name;
*/
/* In general, you can do the same work using set theory */
/* SQL => based on set theory */


/* spec says: get the first five members
	and print them */

create PROCEDURE MEMBER_CURSOR
AS
	--DECLARE AND INIALIZE
	DECLARE @COUNTER INT
	DECLARE @FNAME VARCHAR(15), @LNAME VARCHAR(15), @MDATE SMALLDATETIME
	SET @COUNTER = 1
	--DECLARE AND OPEN CURSOR
	DECLARE CUR_MEM CURSOR FOR 
		SELECT FIRSTNAME, LASTNAME, MEMDATE
		FROM MEMBERS
		ORDER BY MEMDATE
	OPEN CUR_MEM
	WHILE @COUNTER <= 5
		BEGIN
			--PROCESSING - SOMETHING THAT HAS TO BE DONE SERIALLY
			FETCH NEXT FROM CUR_MEM INTO @FNAME, @LNAME, @MDATE
			--THE SERIAL STUFF
			PRINT 'MEMBER ' + CONVERT(CHAR(3), @COUNTER) + @FNAME + ' ' + @LNAME
			PRINT 'MEMBER DATE: ' + CONVERT(CHAR(20), @MDATE, 107)
			PRINT ''
			SET @COUNTER = @COUNTER + 1
		END
	--CLOSE AND DEALLOCATE (OTHERWISE MAY STILL TAKE UP MEMORY)
	CLOSE CUR_MEM
	DEALLOCATE CUR_MEM

EXEC MEMBER_CURSOR;

--IN REAL LIFE
--SELECT TOP 5 * FROM MEMBERS ORDER BY MEMDATE;

/* @@ ARE GLOBAL VARIABLES THAT COME WITH SQL SERVER DATABASE 
@@CURSOR_ROWS -> INTEGER OF THE NUBMER OF ROWS RETURNED BY MOST RECENT CURSOR
@@FETCH_STATUS -> STATUS OF LAST FETCH COMMAND 
	(0= SUCCESS, -1: fAILED - ROW BEYOND RESULT SET, -2 ROW IS MISSING)
*/
ALTER PROCEDURE MEMBER_CURSOR
AS
	--DECLARE AND INIALIZE
	DECLARE @COUNTER INT
	DECLARE @FNAME VARCHAR(15), @LNAME VARCHAR(15), @MDATE SMALLDATETIME
	SET @COUNTER = 1
	--DECLARE AND OPEN CURSOR
	DECLARE CUR_MEM CURSOR FOR 
		SELECT FIRSTNAME, LASTNAME, MEMDATE
		FROM MEMBERS
		ORDER BY MEMDATE
	OPEN CUR_MEM
	--GETTING THE FIRST ROW
	FETCH NEXT FROM CUR_MEM INTO @FNAME, @LNAME, @MDATE
	WHILE @@FETCH_STATUS = 0 -- ROW EXISTS AND FETCHED SUCCESSFULLY
		BEGIN
			--PROCESSING - SOMETHING THAT HAS TO BE DONE SERIALLY
			PRINT 'MEMBER ' + CONVERT(CHAR(3), @COUNTER) + @FNAME + ' ' + @LNAME
			PRINT 'MEMBER DATE: ' + CONVERT(CHAR(20), @MDATE, 107)
			PRINT ''
			SET @COUNTER = @COUNTER + 1
			--GETTING THE NEXT ROW
			FETCH NEXT FROM CUR_MEM INTO @FNAME, @LNAME, @MDATE
		END
	--CLOSE AND DEALLOCATE (OTHERWISE MAY STILL TAKE UP MEMORY)
	CLOSE CUR_MEM
	DEALLOCATE CUR_MEM

EXEC MEMBER_CURSOR;

--NOW GOING TO USE A PARAMETER WITH A CURSOR

ALTER PROCEDURE MEMBER_CURSOR
	@MCODE CHAR(2) = NULL
AS
	--DECLARE AND INIALIZE
	DECLARE @COUNTER INT
	DECLARE @FNAME VARCHAR(15), @LNAME VARCHAR(15), @MDATE SMALLDATETIME
	SET @COUNTER = 1
	--DECLARE AND OPEN CURSOR
	DECLARE CUR_MEM CURSOR FOR 
		SELECT FIRSTNAME, LASTNAME, MEMDATE
		FROM MEMBERS
		WHERE MEMCODE = @MCODE or (@MCODE IS NULL)
		ORDER BY MEMDATE

	OPEN CUR_MEM
	--GETTING THE FIRST ROW
	FETCH NEXT FROM CUR_MEM INTO @FNAME, @LNAME, @MDATE
	WHILE @@FETCH_STATUS = 0 -- ROW EXISTS AND FETCHED SUCCESSFULLY
		BEGIN
			--PROCESSING - SOMETHING THAT HAS TO BE DONE SERIALLY
			PRINT 'MEMBER ' + CONVERT(CHAR(3), @COUNTER) + @FNAME + ' ' + @LNAME
			PRINT 'MEMBER DATE: ' + CONVERT(CHAR(20), @MDATE, 107)
			PRINT ''
			SET @COUNTER = @COUNTER + 1
			--GETTING THE NEXT ROW
			FETCH NEXT FROM CUR_MEM INTO @FNAME, @LNAME, @MDATE
		END
	--CLOSE AND DEALLOCATE (OTHERWISE MAY STILL TAKE UP MEMORY)
	CLOSE CUR_MEM
	DEALLOCATE CUR_MEM

EXEC MEMBER_CURSOR 'ST';

EXEC MEMBER_CURSOR;

/* Exercis3 6-3 */
/* Weekly payroll for non-exempt - assume 40 hours per week */

select empid, lastname, firstname, jobcode, hourrate from employee;

-- get weekly pay
select empid, lastname, firstname, jobs.jobcode, hourrate 
, hourrate * 40 as weeklypay from employee
	inner join jobs
		on jobs.jobcode = employee.jobcode
	where jobs.class = 'NON-EXEMPT';
--PREP FOR STORED PROC
CREATE PROCEDURE NONEXEMPT_PAY
AS
	DECLARE CUR_PAY CURSOR FOR 
		select empid, lastname, firstname, jobs.jobcode 
		, hourrate * 40 as weeklypay from employee
		inner join jobs
			on jobs.jobcode = employee.jobcode
		where jobs.class = 'NON-EXEMPT';
	OPEN CUR_PAY;
	DECLARE @EMPID CHAR(5), @LNAME CHAR(18), @FNAME CHAR(18), 
		@JOBCODE CHAR(3), @WEEKPAY NUMERIC(7,2);
	DECLARE @SECTOTAL NUMERIC(10,2), @TRGTOTAL NUMERIC(10,2)
	SET @SECTOTAL = 0;
	SET @TRGTOTAL = 0;
	PRINT 'EmpId Last Name          First Name          Job Weekly Pay'
	PRINT '-------------------------------------------------------------'
	FETCH NEXT FROM CUR_PAY INTO @EMPID, @LNAME, @FNAME, @JOBCODE, 
		@WEEKPAY;
	WHILE @@FETCH_STATUS = 0 --THERE IS A ROW
		BEGIN 
			--DO STUFF
			PRINT @EMPID + ' ' + @LNAME + ' ' 
			+  @FNAME + ' ' +  @JOBCODE + ' $' +  CONVERT(CHAR(10),@WEEKPAY);
			IF @JOBCODE = 'SEC' 
				SET @SECTOTAL = @SECTOTAL + @WEEKPAY;
			ELSE --TRG
				SET @TRGTOTAL = @TRGTOTAL + @WEEKPAY;
			FETCH NEXT FROM CUR_PAY INTO @EMPID, @LNAME, @FNAME, @JOBCODE, 
				@WEEKPAY;
		END 
		CLOSE CUR_PAY;
		DEALLOCATE CUR_PAY;
		PRINT ''
		PRINT 'TOTAL PAY FOR SECRETARIES: $' + CONVERT(CHAR(11),@SECTOTAL);
		PRINT 'TOTAL PAY FOR TOUR GUIDE: $' + CONVERT(CHAR(11),@TRGTOTAL);
		PRINT ''
		PRINT 'TOTAL PAY FOR ALL NON-EXEMPT EMPLOYEES: $'+ CONVERT(CHAR(13),@SECTOTAL + @TRGTOTAL);

EXEC NONEXEMPT_PAY;

/* Exceptions - P 79*/
/* Try-except - Python
	Try-catch C# */
/* 
BEGIN TRY
	STATEMENTS THAT MAY FAIL
	--ONLY PUT STATEMENTS HERE THAT YOU ARE EXPECTING TO FAIL
	-- BETTER TO HAVE THE USER COMPLAIN THAN TO SEE NOTHING AT ALL
END TRY
BEGIN CATCH
	STATEMENT TO HANDLE ERROR
END CATCH
*/
ALTER PROCEDURE INSERT_ERROR AS
	BEGIN TRY
		INSERT INTO JOBS VALUES ('PRO', 'PROGRAMMER', 'EXEMPT', 25, 40)
		PRINT 'INSERT SUCCEEDED';
	END TRY
	BEGIN CATCH
		PRINT 'INSERT FAILED'
		PRINT 'ERROR OCCURRED ON LINE ' + CONVERT(VARCHAR(3), ERROR_LINE())
			+ ' OF THE PROCEDURE ' + ERROR_PROCEDURE() + ' PROCEDURE';
		PRINT 'ERROR NUMBER: ' + CONVERT(VARCHAR(10), ERROR_NUMBER()); 
			-- > 50000 FOR OWN APPS
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'SEVERITY LEVEL: ' + CONVERT (VARCHAR(10), ERROR_SEVERITY());
		PRINT 'ERROR STATE: ' + CONVERT(VARCHAR(10), ERROR_STATE());
	END CATCH

EXEC INSERT_ERROR;
SP_HELPTEXT INSERT_ERROR;
/*RAISERROR - ONLY ONE E? */
/* RAISERROR('TEXT MESSAGE, SEVERITY_LEVEL, STATE);
	WE ARE THROWING THE ERROR */
ALTER PROCEDURE MEMBER_ERROR 
	@MCODE CHAR(2) = NULL
AS
	BEGIN TRY
		IF @MCODE IN (SELECT MEMCODE FROM MEMBERS)
			SELECT * FROM MEMBERS
				WHERE MEMCODE = @MCODE;
		ELSE 
			RAISERROR('No members found', 11, 1);
		PRINT 'Thank you';
	END TRY
	BEGIN CATCH
		PRINT 'You raised a severe error'
	END CATCH

select * from members;

EXEC MEMBER_ERROR 'ST'; -- should be fine	
EXEC MEMBER_ERROR 'YY'; --should have an error

/* ERROR LEVELS < 10 ARE INFORMATIONAL ONLY
   It never gets to try-catch.
*/

EXEC SP_ADDMESSAGE 50001, 11, 'No members found';

ALTER PROCEDURE MEMBER_ERROR 
	@MCODE CHAR(2) = NULL
AS
	DECLARE @dbname varchar(128);
	SET @dbname = DB_NAME();
	BEGIN TRY
		IF @MCODE IN (SELECT MEMCODE FROM MEMBERS)
			SELECT * FROM MEMBERS
				WHERE MEMCODE = @MCODE;
		ELSE 
			RAISERROR('No members found', 11, 1, @dbname);
		PRINT 'Thank you';
	END TRY
	BEGIN CATCH
		PRINT 'You raised a severe error';
		DECLARE @ERR_MSG VARCHAR(1000), @ERR_SEV INT, 
			@ERR_STATE INT
		SET @ERR_MSG = ERROR_MESSAGE();
		SET @ERR_SEV = ERROR_SEVERITY();
		SET @ERR_STATE = ERROR_STATE();
		RAISERROR(@ERR_MSG,@ERR_SEV, @ERR_STATE, @DBNAME); -- RAISING AN ERROR AND THROWING IT
	END CATCH

EXEC MEMBER_ERROR 'AD';
EXEC MEMBER_ERROR 'YY';

--SP_ADDMESSAGE 50001, 11, 'NO MEMBERS FOUND'
--SP_DROPMESSAGE 50001

--Exercise 8-1
alter PROCEDURE MINRATE_ERROR
	@JCODE CHAR(3), @MINPAY NUMERIC(5,2)
AS 
	BEGIN TRY
		UPDATE JOBS
		SET MINRATE = @MINPAY
		WHERE JOBCODE = @JCODE;
		--check number of rows
		if @@rowcount = 0
			raiserror('Job code does not exist in the jobs table.', 11, 1);
		--raiserror('stuff needed to cause error')
	END TRY
	BEGIN CATCH;
		PRINT 'UPDATE FAILED';
		PRINT 'ERROR NUMBER: ' + convert(char(3), ERROR_NUMBER());
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE() 
	END CATCH

exec minrate_error 'pro', 10;  --no problem
exec minrate_error 'pro', 5;	--error message
exec minrate_error 'yyy', 20;  --no job code

/* Advanced cursors:  p 70 */
CREATE PROCEDURE SCROLLING 
AS 
	DECLARE CUR_EMP SCROLL CURSOR
		FOR SELECT EMPID, HIREDATE, HOURRATE
			FROM EMPLOYEE
			ORDER BY HIREDATE
	OPEN CUR_EMP;
	PRINT 'FIRST'
	FETCH FIRST FROM CUR_EMP;
	PRINT 'LAST RECORD';
	FETCH LAST FROM CUR_EMP;
	PRINT 'PREVIOUS TO LAST '
	FETCH PRIOR FROM CUR_EMP;
	PRINT '5TH RECORD'
	FETCH ABSOLUTE 5 FROM CUR_EMP;
	PRINT '5TH FROM END'
	FETCH ABSOLUTE -5 FROM CUR_EMP;
	PRINT 'ADD 2 TO CURRENT RECORD'
	FETCH RELATIVE 2 FROM CUR_EMP;
	CLOSE CUR_EMP;
	DEALLOCATE CUR_EMP;
EXEC SCROLLING;

/* CONTROL WHETHER THEY CAN UPDATE OR JUST READ */
/* DECLARE cursor_name CURSOR
	FOR SELECT statement
	FOR UPDATE OF columnlist
*/
--CAN DO UPDATES TO MINRATE ONLY
DECLARE CUR_JOB CURSOR 
	FOR SELECT JOBCODE, CLASS, MINRATE FROM JOB2
	FOR UPDATE OF MINRATE;
--CAN READ BUT NOT WRITE
DECLARE CUR_JOB CURSOR 
	FOR SELECT JOBCODE, CLASS, MINRATE FROM JOB2
	FOR READ ONLY;


