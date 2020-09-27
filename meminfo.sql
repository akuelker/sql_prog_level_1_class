CREATE PROCEDURE meminfo
@memid char(5) 
AS
	SELECT * FROM Members
	WHERE mem_id = @memid
