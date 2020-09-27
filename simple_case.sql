CREATE PROCEDURE simple_case
	@mcode char(2) = NULL 
AS
	DECLARE @disc numeric(3,2)
	SET @disc = 
		CASE @mcode 
			WHEN 'CH' THEN .25
			WHEN 'ST' THEN .2
			WHEN 'FM' THEN .1
			ELSE 0
		END 
	PRINT 'Member type: ' + @mcode
	PRINT 'Discount: ' + CONVERT(varchar(5), @disc * 100) + '%'
