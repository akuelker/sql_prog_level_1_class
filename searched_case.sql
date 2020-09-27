CREATE PROCEDURE searched_case
	@age int = 0 
AS
	DECLARE @mcode char(2)
	SET @mcode = 
		CASE
			WHEN @age <= 10 THEN 'CH'
			WHEN @age <= 21 THEN 'ST'
			WHEN @age <= 54 THEN 'AD'
			ELSE 'SR'
		END 
	PRINT 'Membership type: ' + @mcode
