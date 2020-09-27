CREATE PROCEDURE insert_error
AS
	BEGIN TRY
		INSERT INTO jobs VALUES ('PRO', 'PROGRAMMER', 'EXEMPT', 25, 40)
		PRINT 'Insert succeeded.'
	END TRY
	BEGIN CATCH
		PRINT 'Insert failed.'
	END CATCH
