CREATE PROCEDURE trg_cursor
AS 
	DECLARE @fname varchar(15), @lname varchar(15), @pay numeric(5,2)
	DECLARE cur_trg CURSOR FOR
		SELECT firstname, lastname, hourrate
		FROM employee
		WHERE jobcode = 'TRG'
	OPEN cur_trg
	WHILE 1=1
		BEGIN
			FETCH NEXT FROM cur_trg INTO @fname, @lname, @pay
			IF @@FETCH_STATUS <> 0
				BREAK
			PRINT 'Employee name: ' + @fname + ' ' + @lname
			PRINT 'Hourly rate: $' + CONVERT(char(8), @pay)
			PRINT ''
		END
	CLOSE cur_trg
	DEALLOCATE cur_trg
