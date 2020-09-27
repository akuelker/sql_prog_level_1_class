CREATE PROCEDURE scrolling
AS
	DECLARE cur_emp SCROLL CURSOR 
		FOR SELECT empid, hiredate, hourrate
		FROM employee
		ORDER BY hiredate 
	OPEN cur_emp
	PRINT 'First record...'
	FETCH FIRST FROM cur_emp
	PRINT ''
	PRINT 'Last record...'
	FETCH LAST FROM cur_emp
	PRINT ''
	PRINT 'Previous record...'
	FETCH PRIOR FROM cur_emp
	PRINT ''
	PRINT 'Fifth record...'
	FETCH ABSOLUTE 5 FROM cur_emp
	PRINT ''
	PRINT 'Fifth record from end...'
	FETCH ABSOLUTE -5 FROM cur_emp
	PRINT ''
	PRINT 'Add 2 to current record...'
	FETCH RELATIVE 2 FROM cur_emp
	PRINT ''
	CLOSE cur_emp
	DEALLOCATE cur_emp
