CREATE PROCEDURE delete_members
@mcode char(2) = NULL 
AS 
DELETE FROM members
WHERE memcode = @mcode
