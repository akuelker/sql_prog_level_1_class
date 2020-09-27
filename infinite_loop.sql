CREATE PROCEDURE infinite_loop 
	@num int = 0
AS
	-- condition is always true 
	WHILE 1=1
		BEGIN
			PRINT 'Your number is: ' + CONVERT(char(3), @num)
			-- break out of loop if number is 5 and today is Monday
			IF @num = 5 AND DATENAME(DW,GETDATE()) = 'MONDAY'
				BREAK
			-- break out of loop if number is greater than 10
			ELSE IF @num > 10
				BREAK
			SET @num = @num + 1
		END

