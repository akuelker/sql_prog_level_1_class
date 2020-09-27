CREATE PROCEDURE loop_32
AS
	DECLARE @num int, @ctr int 
	SET @num = 2
	SET @ctr = 0
	WHILE @num <= 32
		BEGIN
			PRINT CONVERT(char(2), @num)
			SET @num = @num + @num
			SET @ctr = @ctr + 1
		END 
	PRINT 'The loop executed ' + CONVERT(char(2), @ctr) + ' times.'
