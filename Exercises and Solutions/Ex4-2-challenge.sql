ALTER PROCEDURE salary_grade
	@emp_id char(5) = NULL 
AS 
	IF @emp_id NOT IN (SELECT empid FROM employee)
		BEGIN 
			PRINT 'Please enter a valid employee ID.'
			RETURN
		END  
	DECLARE @hour_rate numeric(5,2), @sal_grade char(1)
	-- get employee's hourly rate from Employee table
	SELECT @hour_rate = hourrate 
	FROM employee
	WHERE empid = @emp_id
	-- assign salary grade based on rate
	SET @sal_grade =
		CASE
			WHEN @hour_rate < 10 THEN 'A'
			WHEN @hour_rate < 20 THEN 'B'
			WHEN @hour_rate < 30 THEN 'C'
			ELSE 'D'
		END
	PRINT 'Hourly rate: $' + CONVERT(char(6), @hour_rate)
	PRINT 'Salary grade: ' + @sal_grade

