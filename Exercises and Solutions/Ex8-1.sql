CREATE PROCEDURE minrate_error
	@jcode char(3), @minpay numeric(5,2)
AS 
	BEGIN TRY 
		UPDATE jobs
		SET minrate = @minpay
		WHERE jobcode = @jcode
	END TRY 
	BEGIN CATCH
		PRINT 'Update failed.'
		PRINT 'Error number: ' + CONVERT(varchar(10), ERROR_NUMBER())
		PRINT 'Error message: ' + ERROR_MESSAGE()
	END CATCH

