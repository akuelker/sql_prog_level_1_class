CREATE PROCEDURE exit_if_null
	@num int = NULL
AS 
	IF @num IS NULL
		BEGIN 
			PRINT 'You entered a null value. Goodbye.' 
			-- exits procedure if value is null
			RETURN 
		END 
PRINT 'Your number is...'
PRINT @num
