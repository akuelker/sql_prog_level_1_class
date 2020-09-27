CREATE PROCEDURE update_minrate
AS 
	DECLARE @jcode char(3), @jclass varchar(10), 
		    @old_min numeric(5,2), @new_min numeric(5,2)
	DECLARE cur_job CURSOR
		FOR SELECT jobcode, class, minrate FROM job2
	OPEN cur_job
	--fetch first record
	FETCH NEXT FROM cur_job INTO @jcode, @jclass, @old_min
	WHILE @@FETCH_STATUS = 0
		BEGIN 
		-- assign new rate based on conditions 
			IF @old_min < 9.5
				SET @new_min = 10
			ELSE IF @jclass = 'EXEMPT'
				SET @new_min = (@old_min * .03) + @old_min
			ELSE IF @jclass = 'NON-EXEMPT'
				SET @new_min = (@old_min * .05) + @old_min
			-- update jobs table for current record 
			UPDATE job2 
			SET minrate = @new_min
			WHERE CURRENT OF cur_job
			-- print old and new minimum rates 
			PRINT 'Job: ' + @jcode
			PRINT 'Old minimum rate: ' + CONVERT(char(5), @old_min)
			PRINT 'New minimum rate: ' + CONVERT(char(5), @new_min)
			PRINT ''
			-- fetch next record 
			FETCH NEXT FROM cur_job INTO @jcode, @jclass, @old_min
		END 
	CLOSE cur_job
	DEALLOCATE cur_job
