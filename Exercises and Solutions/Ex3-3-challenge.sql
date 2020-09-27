ALTER PROCEDURE emp_raise 
	@emp_id char(5) = NULL, @rating int = 2 
AS 
DECLARE @raise numeric(5,3), @newrate numeric(5,2)
IF @rating = 3
		SET @raise = .05
ELSE 
		IF @rating = 2
			SET @raise = .03
		ELSE 
			IF @rating = 1
				SET @raise = 0
IF @raise IS NULL
		BEGIN 
			PRINT 'Enter 1, 2, or 3 as the rating.'
			PRINT 'No change to employee''s hourly rate'
		END 
ELSE 
		BEGIN 
			PRINT 'Your raise is ' + CONVERT(varchar(5), (@raise * 100))
			    + '%'
			-- update employee's rate in Employee table
			UPDATE employee
			SET hourrate = hourrate * (1 + @raise)
			WHERE empid = @emp_id
			PRINT 'Update complete.'
		END 
-- get rate from Employee table
SELECT @newrate = hourrate 
FROM employee
WHERE empid = @emp_id
-- display hourly rate	
PRINT 'Hourly rate is: ' + CONVERT(varchar(8), @newrate)
