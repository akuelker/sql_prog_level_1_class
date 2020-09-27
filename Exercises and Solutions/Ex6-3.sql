CREATE PROCEDURE nonexempt_pay_cursor
AS 
DECLARE @id char(5), @fname char(15), @lname char(15), 
		@jcode char(3), @weekpay numeric(7,2),
		@totalpay numeric(9,2), @sec_pay numeric(9,2), 
		@trg_pay numeric(9,2)
SET @totalpay = 0
SET @sec_pay = 0
SET @trg_pay = 0
DECLARE cur_emppay CURSOR FOR 
		SELECT empid, firstname, lastname, employee.jobcode, hourrate*40 
		FROM employee inner join jobs
		ON employee.jobcode = jobs.jobcode
		WHERE class = 'NON-EXEMPT'
PRINT '               WEEKLY EMPLOYEE PAYROLL               '
PRINT '-----------------------------------------------------'
PRINT ''
PRINT 'ID    Last Name       First Name      Job   Weekly Pay'
OPEN cur_emppay
FETCH cur_emppay INTO @id, @fname, @lname, @jcode, @weekpay
WHILE @@FETCH_STATUS = 0
		BEGIN 
			IF @jcode = 'SEC'
				SET @sec_pay = @sec_pay + @weekpay
			ELSE IF @jcode = 'TRG'
				SET @trg_pay = @trg_pay + @weekpay
			SET @totalpay = @totalpay + @weekpay
			PRINT @id + ' ' + @lname + ' ' + @fname + ' ' + @jcode 
				  + '   $' + CONVERT(char(10), @weekpay)
			FETCH cur_emppay INTO @id, @fname, @lname, @jcode, @weekpay
		END 
PRINT ' ' 
PRINT 'Total pay for secretaries: $' + CONVERT(char(12), @sec_pay)
PRINT 'Total pay for tour guides: $' + CONVERT(char(12), @trg_pay)
PRINT ' ' 
PRINT 'Total pay for all non-exempt employees: $' + 
      CONVERT(char(12), @totalpay)
CLOSE cur_emppay
DEALLOCATE cur_emppay
