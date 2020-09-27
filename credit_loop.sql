CREATE PROCEDURE credit_loop
	@bal numeric(7,2) = 0 
AS 
	DECLARE @pmt numeric(7,2) 
	SET @pmt = 300
	WHILE @bal > 0
	BEGIN 
		SET @bal = @bal - @pmt
		PRINT 'New balance: $' + CONVERT(char(10), @bal)
	END
