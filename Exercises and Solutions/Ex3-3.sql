CREATE PROCEDURE emp_raise 
	@rating int = 2 
AS 
	DECLARE @raise numeric(5,3)
	IF @rating = 3
		SET @raise = .05
	ELSE 
		IF @rating = 2
			SET @raise = .03
		ELSE 
			IF @rating = 1
				SET @raise = 0
IF @raise IS NULL
	PRINT 'Enter 1, 2, or 3 as the rating.'
ELSE 
	PRINT 'Your raise is ' + CONVERT(varchar(5), (@raise * 100))
		  + '%'