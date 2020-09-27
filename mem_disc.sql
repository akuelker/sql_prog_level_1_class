CREATE PROCEDURE mem_disc
	@memid char(5) = NULL
AS 
	DECLARE @level varchar(10), @disc numeric(5,2), 
	        @mdate smalldatetime 
	-- selects membership date based on ID entered by user
	SELECT @mdate = memdate 
	FROM   members
	WHERE  mem_id = @memid
	-- determines membership level and discount based on memdate
	IF @mdate < '01-01-05'
		BEGIN
			SET @level = 'GOLD' 
			SET @disc = .1
		END 
	ELSE
		BEGIN 
			SET @level = 'WHITE' 
			SET @disc = 0
		END  
	-- displays membership level and discount 
	PRINT 'Member ID: ' + @memid
	PRINT 'Membership level: ' + @level
	PRINT 'Membership discount: ' + CONVERT(char(5), @disc*100) + '%'
