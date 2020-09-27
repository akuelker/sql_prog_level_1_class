CREATE PROCEDURE savings_loop
	@monthly_savings numeric(7,2) = 100
AS 
	DECLARE @total_savings numeric(7,2), 
	        @interest numeric(4,4), @num_months int
	SET @total_savings = 0
	SET @interest = .0083
	SET @num_months = 0
	WHILE @num_months < 12
		BEGIN 
			SET @total_savings = @total_savings + @monthly_savings
			SET @total_savings = @total_savings + 
				   (@total_savings * @interest)
			SET @num_months = @num_months + 1
			PRINT 'Savings after ' + CONVERT(char(2), @num_months) 
			      + ' months: ' + CONVERT(varchar(10), @total_savings)
		END 
	PRINT ''
	PRINT 'Final savings: ' + CONVERT(varchar(10), @total_savings)
