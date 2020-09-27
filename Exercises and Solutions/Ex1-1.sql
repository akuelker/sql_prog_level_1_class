CREATE PROCEDURE parking
 	@hours int = 0 
AS
	DECLARE @park_total numeric(5,2)
	SET @park_total = .75 * @hours 
	PRINT 'PLEASE PAY: $' + CONVERT(char(6), @park_total)
