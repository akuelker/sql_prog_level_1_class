ALTER PROCEDURE minrate_error
	@jcode char(3), @minpay numeric(5,2)
AS 
	BEGIN TRY 
		IF @jcode IN (SELECT jobcode FROM jobs)
			UPDATE jobs
			SET minrate = @minpay
			WHERE jobcode = @jcode
		ELSE 
			RAISERROR('Invalid job code', 11, 1)
	END TRY 
	BEGIN CATCH
		PRINT 'Update failed.'
		PRINT 'Error message: ' + ERROR_MESSAGE()
	END CATCH
