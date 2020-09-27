CREATE PROCEDURE eval_raise 
AS 
DECLARE @eval_score int, @id char(5), @old_rate numeric(7,2), 
        @new_rate numeric(7,2), @pct_raise numeric(5,2)
DECLARE cur_raise CURSOR 
	FOR SELECT emp3.empid, hourrate, score
	FROM emp3 LEFT OUTER JOIN eval
	ON emp3.empid = eval.empid
	FOR UPDATE OF hourrate
OPEN cur_raise 
FETCH NEXT FROM cur_raise INTO @id, @old_rate, @eval_score
WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @pct_raise = 
			CASE @eval_score
				WHEN 1 THEN 0
				WHEN 2 THEN .03
				WHEN 3 THEN .05
				ELSE NULL			
			END 
		IF @pct_raise IS NOT NULL
			BEGIN 
				SET @new_rate = (@pct_raise * @old_rate) + @old_rate 
				UPDATE emp3
				SET hourrate = @new_rate 
				WHERE CURRENT OF cur_raise 
				PRINT 'Employee ID ' + @id + ' UPDATED'
				PRINT 'Evaluation score: ' + CONVERT(char(1), @eval_score)
				PRINT 'Raise: ' + CONVERT(char(5), (@pct_raise * 100))
				      + '%'
				PRINT 'Old rate: ' + CONVERT(char(6), @old_rate)
				PRINT 'New rate: ' + CONVERT(char(6), @new_rate)
				PRINT ''
			END
		ELSE 
			BEGIN 
				PRINT 'No evaluation for ' + @id 
				PRINT '' 
			END
		FETCH NEXT FROM cur_raise INTO @id, @old_rate, @eval_score
	END
	CLOSE cur_raise
	DEALLOCATE cur_raise
