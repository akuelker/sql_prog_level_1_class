CREATE PROCEDURE member_cursor
AS
	-- declare and initialize counter
	DECLARE @counter int
	SET @counter = 1
	-- declare cursor 
	DECLARE cur_mem CURSOR FOR
		SELECT firstname, lastname, memdate
		FROM members
		ORDER BY memdate 
	-- open cursor 
	OPEN cur_mem
	-- fetch next member from cursor and increment counter
	-- stop after first five members are processed 
	WHILE @counter <= 5
		BEGIN
			FETCH NEXT FROM cur_mem 
			SET @counter = @counter + 1
		END
	-- close cursor 
	CLOSE cur_mem
	-- deallocate cursor 
	DEALLOCATE cur_mem
