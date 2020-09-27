ALTER PROCEDURE overtime
	@emp_id char(5) = NULL, @hours numeric(5,2) = 0 
AS 
	DECLARE @jclass varchar(10), @rate numeric(5,2), 
	        @weekpay numeric(7,2)
	-- get employee's job class and hourly rate 
	-- assign to variables
	SELECT @jclass = class, @rate = hourrate 
	FROM employee INNER JOIN jobs
	ON employee.jobcode = jobs.jobcode
	WHERE empid = @emp_id
	-- assign overtime eligibility and calculate weekly pay
	-- based on job class & hours
	IF @jclass = 'NON-EXEMPT' 
		BEGIN 
			IF @hours > 40
				BEGIN 
					PRINT 'You are eligible for overtime pay.'
					SET @weekpay = (40 * @rate) + 
				       ((@hours - 40) * (@rate * 1.5))
				END
			ELSE 
				BEGIN 
					PRINT 'You are not eligible for overtime pay.'
					SET @weekpay = @hours * @rate
				END 
		END
	ELSE 
		BEGIN 
			PRINT 'You are not eligible for overtime pay.'
			SET @weekpay = 40 * @rate
		END 
	PRINT 'Weekly pay: ' + CONVERT(varchar(8), @weekpay)
