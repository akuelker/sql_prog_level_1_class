CREATE PROCEDURE trg_raise_loop
AS 
	DECLARE @avg_rate numeric(7,2)
	-- get current average rate
	SELECT @avg_rate = AVG(hourrate)
	FROM employee
	WHERE jobcode = 'TRG'
	PRINT 'Initial average rate: $' + CONVERT(char(10), @avg_rate)
	-- use loop to assign 5% raises until average >= $11/hour
	WHILE @avg_rate < 11
		BEGIN 
			UPDATE employee
			SET hourrate = hourrate * 1.05
			WHERE jobcode = 'TRG'
			-- calculate new average
			SELECT @avg_rate = AVG(hourrate)
			FROM employee
			WHERE jobcode = 'TRG'
			-- print new average
			PRINT 'New average rate: ' + CONVERT(char(10), @avg_rate)
		END
