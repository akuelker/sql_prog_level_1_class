CREATE PROCEDURE nested_emp_pay
AS 
DECLARE @id char(5), @fname char(15), @lname char(15), 
		@jobs_jcode char(3), @emp_jcode char(3), 
		@weekpay numeric(7,2), @subtotal_pay numeric(9,2), 
		@totalpay numeric(9,2) 
DECLARE cur_jobs CURSOR FOR
	SELECT jobcode FROM jobs
PRINT '               WEEKLY EMPLOYEE PAYROLL               '
PRINT '-----------------------------------------------------'
OPEN cur_jobs
FETCH NEXT FROM cur_jobs INTO @jobs_jcode
WHILE @@FETCH_STATUS = 0
	BEGIN 
		PRINT ''
		PRINT 'Job code: ' + @jobs_jcode
		SET @subtotal_pay = 0
		DECLARE cur_emppay CURSOR FOR 
			SELECT empid, firstname, lastname, employee.jobcode, 
			       hourrate*40 
			FROM employee 
			WHERE jobcode = @jobs_jcode
		PRINT 'ID    Last Name       First Name      Job   Weekly Pay'
		PRINT '------------------------------------------------------'
		OPEN cur_emppay
		FETCH cur_emppay INTO @id, @fname, @lname, @emp_jcode, @weekpay
		WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT @id + ' ' + @lname + ' ' + @fname + ' ' + 
					@emp_jcode + '   $' + CONVERT(char(10), @weekpay)
				SET @subtotal_pay = @subtotal_pay + @weekpay	
				FETCH cur_emppay INTO @id, @fname, @lname, @emp_jcode, 
				      @weekpay
			END
		PRINT ''
		PRINT 'Total pay for ' + @jobs_jcode + ' $' + 
      CONVERT(char(12), @subtotal_pay)
		PRINT '-------------------------------------------------'
		SET @totalpay = @totalpay + @subtotal_pay
		CLOSE cur_emppay
		DEALLOCATE cur_emppay
		FETCH NEXT FROM cur_jobs INTO @jobs_jcode
	END 
PRINT ' ' 
PRINT 'Total pay for all employees: $' + CONVERT(char(12), @totalpay)
CLOSE cur_jobs
DEALLOCATE cur_jobs
