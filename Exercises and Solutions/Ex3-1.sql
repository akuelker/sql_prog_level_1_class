CREATE PROCEDURE drive 
	@age int = 0 
AS 
IF @age >= 16
	PRINT 'You are old enough to drive a car.'
ELSE 
	BEGIN
		PRINT 'You are only ' + CONVERT(varchar(3), @age)
		PRINT 'You must wait ' + CONVERT(varchar(3), 16-@age) +
			  ' years to drive.'
	END 