CREATE PROCEDURE names_loop
   @my_name varchar(15) = NULL
AS 
	DECLARE @ctr int 
	SET @ctr = 1
	WHILE @ctr <= 10
		BEGIN
			PRINT @my_name
			SET @ctr = @ctr + 1
		END
