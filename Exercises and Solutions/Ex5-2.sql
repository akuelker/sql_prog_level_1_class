ALTER PROCEDURE names_loop
   @my_name varchar(15) = NULL
AS 
	DECLARE @ctr int 
	SET @ctr = 1
	WHILE @ctr <= 10
		BEGIN
			PRINT CONVERT(char(2), @ctr) + ' ' + @my_name
			IF @ctr = 5 AND LEN(@my_name) = 5
				BREAK
			SET @ctr = @ctr + 1
		END
