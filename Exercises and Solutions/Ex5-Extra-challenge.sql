CREATE PROCEDURE trg_raise_loop_challenge
AS 
	DECLARE @avg_rate numeric(7,2), @max_emp_rate numeric(7,2),
	        @max_possible numeric(7,2)
	-- get current average and max rates
	SELECT @avg_rate = AVG(hourrate), @max_emp_rate = MAX(hourrate)
	FROM emp2
	WHERE jobcode = 'TRG'
	PRINT 'Initial average rate: $' + CONVERT(char(10), @avg_rate)
	-- get max possible from jobs table
	SELECT @max_possible = maxrate
	FROM jobs
	WHERE jobcode = 'TRG'
	-- use loop to assign 5% raises until average >= $11/hour
	WHILE @avg_rate < 11
		BEGIN 
			UPDATE emp2
			SET hourrate = hourrate * 1.05
			WHERE jobcode = 'TRG'
			-- calculate new average and max
			SELECT @avg_rate = AVG(hourrate), @max_emp_rate = MAX(hourrate)
			FROM emp2
			WHERE jobcode = 'TRG'
			-- print new average
			PRINT 'New average rate: ' + CONVERT(char(10), @avg_rate)
			-- exit if employee exceeds max possible
			IF @max_emp_rate > @max_possible
				BEGIN 
					PRINT 'Employee exceeded max rate.'
					BREAK 
				END 
		END
