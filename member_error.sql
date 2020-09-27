CREATE PROCEDURE member_error
	@mcode char(2)= NULL
AS 
	BEGIN TRY
		IF @mcode IN (SELECT memcode FROM members)
			SELECT * FROM members
			WHERE memcode = @mcode 
		ELSE
			RAISERROR('No members found', 10, 1)
		PRINT 'Thank you.'
	END TRY
	BEGIN CATCH
		PRINT 'You raised a severe error.'
	END CATCH
