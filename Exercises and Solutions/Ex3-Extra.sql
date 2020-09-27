CREATE PROCEDURE overtime
	@emp_id char(5) = NULL, @hours numeric(5,2) = 0 
AS 
	DECLARE @jclass varchar(10)
	-- get employee's job class and assign to variable
	SELECT @jclass = class
	FROM employee INNER JOIN jobs
	ON employee.jobcode = jobs.jobcode
	WHERE empid = @emp_id
	-- assign overtime eligibility based on job class 
	IF @jclass = 'NON-EXEMPT' AND @hours > 40
		PRINT 'You are eligible for overtime pay.'
	ELSE
		PRINT 'You are not eligible for overtime pay.'
