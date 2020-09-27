CREATE PROCEDURE nested_cursor
AS
	--declare local variables 
	DECLARE @descrip char(30), @don_date smalldatetime,
	        @coll_val numeric(7,2), @subtotal numeric(9,2), 
	        @grand_total numeric(9,2), @coll_year char(4)
	--initialize grand total variable 
	SET @grand_total = 0
	--print main heading
	PRINT 'COLLECTION DONATIONS'
	PRINT '-------------------------------------------------'
	PRINT ''
	--declare cursor for collection years
	DECLARE cur_years CURSOR 
		FOR SELECT DISTINCT DATEPART(yyyy, donate_date) 
		FROM collections
		ORDER BY DATEPART(yyyy, donate_date) 
	--open first cursor
	OPEN cur_years 
	--fetch first year from cur_years cursor 
	FETCH NEXT FROM cur_years INTO @coll_year
	--outer loop, continues until no more years in cur_years cursor
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			--initialize subtotal (reset for each year)
			SET @subtotal = 0
			--print subheadings for yearly donations
			PRINT @coll_year + ' DONATIONS'
			PRINT '-----------------'
			PRINT 'Description                    Date      Value     Total Donation'
			--declare second cursor to process individual collections
			DECLARE cur_coll CURSOR 
				FOR SELECT coll_desc, donate_date, coll_value
				FROM collections
				WHERE DATEPART(yyyy, donate_date) = @coll_year
				ORDER BY donate_date 
			--open cursor
			OPEN cur_coll
			--fetch first row
			FETCH NEXT FROM cur_coll INTO @descrip, @don_date, @coll_val
			--inner loop continues as long as 
			--there are collections for current year
			WHILE @@FETCH_STATUS = 0
				BEGIN 
					--increment subtotal 
					SET @subtotal = @subtotal + @coll_val	
					--print row 
					PRINT @descrip + ' ' + CONVERT(char(10), @don_date, 1) 
					   + CONVERT(char(10), @coll_val) 
					   + CONVERT(char(12), @subtotal)
				--fetch next row
				FETCH NEXT FROM cur_coll INTO @descrip, @don_date, @coll_val
			END 
			--close second cursor
			CLOSE cur_coll
			--deallocate second cursor
			DEALLOCATE cur_coll
			--increment grand total 
			SET @grand_total = @grand_total + @subtotal
			--print subtotal and grand total 
			PRINT ''
			PRINT 'Subtotal for ' + @coll_year + ': $' 
      + CONVERT(char(10), @subtotal)
			PRINT 'New grand total: $' 
      + CONVERT(char(10), @grand_total)
			PRINT ''
			--get next year			
			FETCH NEXT FROM cur_years INTO @coll_year
	END 	
	--close first cursor 
	CLOSE cur_years
	--deallocate first cursor 
	DEALLOCATE cur_years
