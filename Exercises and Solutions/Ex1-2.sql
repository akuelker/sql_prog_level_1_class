CREATE PROCEDURE tax
 	@price numeric(7,2) = 0 
AS
DECLARE @tax_amt numeric(7,2), @total_price numeric(7,2)
SET @tax_amt = @price * .075
SET @total_price = @price + @tax_amt
PRINT 'Original price: ' + CONVERT(varchar(10), @price) 
PRINT 'Tax: ' + CONVERT(varchar(10), @tax_amt) 
PRINT 'Total price: ' + CONVERT(varchar(10), @total_price) 
