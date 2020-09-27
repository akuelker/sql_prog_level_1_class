CREATE PROCEDURE sleep
 	@bday smalldatetime = 'Jan 1, 1900' 
AS
	DECLARE @hours int
	SET @hours = DATEDIFF(hh, @bday, GETDATE())
	PRINT 'You have slept ' + 
		CONVERT(varchar(10) , @hours/3) + ' hours'

