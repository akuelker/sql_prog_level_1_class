CREATE PROCEDURE member_loop
AS
	DECLARE @memyear int, @total_mems int, @new_mems int
	SET @total_mems = 0
	SELECT @memyear = DATEPART(yyyy, MIN(memdate)) FROM members
	WHILE @memyear <= DATEPART(yyyy, GETDATE())
		BEGIN
			SELECT @new_mems = count(*) FROM members
			WHERE DATEPART(yyyy, memdate) = @memyear
			SET @total_mems = @total_mems + @new_mems
			PRINT 'Year: ' + CONVERT(char(4), @memyear)
			PRINT 'New members: ' + CONVERT(char(3), @new_mems)
			PRINT 'Total members: ' + CONVERT(char(3), @total_mems)
			PRINT ''
			SET @memyear = @memyear + 1
		END	

