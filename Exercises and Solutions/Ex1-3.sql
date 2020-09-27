CREATE PROCEDURE mileage
	@start numeric(7,1) = 0, @finish numeric(7,1) = 0,
	@gallons numeric(6,2) = 0 
AS
	DECLARE @mpg numeric(3,1)
	SET @mpg = (@finish - @start) / @gallons
	PRINT 'Your gas mileage was: ' + CONVERT(char(10) , @mpg)

