CREATE PROCEDURE memcode_lookup
@mcode char(2) 
AS
DECLARE @fname varchar(15), @lname varchar(15), @memyear char(4)
SELECT @fname = firstname, 
       @lname = lastname, 
       @memyear = DATENAME(yyyy, memdate)
FROM members
WHERE memcode = @mcode
PRINT 'Member name: ' + @fname + ' ' + @lname
PRINT 'Member since: ' + @memyear
