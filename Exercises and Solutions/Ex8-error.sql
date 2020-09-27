CREATE PROCEDURE minrate_error
	@jcode char(3), @minpay numeric(5,2)
AS 
	UPDATE jobs
	SET minrate = @minpay
	WHERE jobcode = @jcode
