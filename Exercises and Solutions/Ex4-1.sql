CREATE PROCEDURE raise_case
	@rating int = 2 
AS 
DECLARE @raise numeric(5,3)
SET @raise = 
	CASE @rating 
		WHEN 3 THEN .05
		WHEN 2 THEN .03
		WHEN 1 THEN 0
	END
IF @raise IS NULL
	PRINT 'Enter 1, 2, or 3 as the rating.'
ELSE 
	PRINT 'Your raise is ' + CONVERT(char(5), (@raise * 100))
		  + '%'
