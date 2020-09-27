CREATE PROCEDURE collections_cursor
AS
	--declare local variables 
	DECLARE @descrip char(30), @don_date smalldatetime,
	        @coll_val numeric(7,2), @2006_total numeric(9,2), 
	        @2007_total numeric (9,2), @grand_total numeric(9,2)
	--initialize subtotal and grand total variables 
	SET @2006_total = 0
	SET @2007_total = 0
	SET @grand_total = 0
	--print heading
	PRINT '2006-2007 DONATIONS'
	PRINT '-------------------------------------------------'
	PRINT ''
	PRINT 'Description            Date      Value     Total Donation'
	--declare cursor 
	DECLARE cur_coll CURSOR 
		FOR SELECT coll_desc, donate_date, coll_value
		FROM collections
		WHERE donate_date >= '01/01/2006'
		ORDER BY donate_date 
	--open cursor
	OPEN cur_coll
	--first first row
	FETCH NEXT FROM cur_coll INTO @descrip, @don_date, @coll_val
	--continue loop as long as fetch is successful
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			--increment 2006 subtotal if date is in 2006
			IF DATEPART(yyyy, @don_date) = 2006
				SET @2006_total = @2006_total + @coll_val	
			--increment 2006 subtotal if date is in 2007
			ELSE IF DATEPART(yyyy, @don_date) = 2007
				SET @2007_total = @2007_total + @coll_val
			--increment grand total 
			SET @grand_total = @2006_total + @2007_total
			--print row 
			PRINT @descrip + ' ' + CONVERT(char(10), @don_date, 1) 
				   + CONVERT(char(10), @coll_val) 
				   + CONVERT(char(12), @grand_total)
			--fetch next row
			FETCH NEXT FROM cur_coll INTO @descrip, @don_date, @coll_val
		END 
	--print summary 
	PRINT ''
	PRINT '2006 Total Donations: ' + CONVERT(char(12), @2006_total)
	PRINT '2007 Total Donations: ' + CONVERT(char(12), @2007_total)
	PRINT 'Total for 2006-2007: ' + CONVERT(char(12), @grand_total)
	--close cursor 
	CLOSE cur_coll
	--deallocate cursor 
	DEALLOCATE cur_coll

