CREATE PROCEDURE salary_grade
	@hour_rate numeric(5,2) = 0 
AS 
	DECLARE @sal_grade char(1)
	SET @sal_grade =
		CASE
			WHEN @hour_rate < 10 THEN 'A'
			WHEN @hour_rate < 20 THEN 'B'
			WHEN @hour_rate < 30 THEN 'C'
			ELSE 'D'
		END
	PRINT 'Hourly rate: $' + CONVERT(char(6), @hour_rate)
	PRINT 'Salary grade: ' + @sal_grade
