CREATE PROCEDURE min_max
AS
DECLARE @firstdate smalldatetime, @lastdate smalldatetime
SELECT @firstdate = MIN(memdate), @lastdate = MAX(memdate)
FROM members
PRINT 'First membership: ' + CONVERT(char(20), @firstdate, 107)
PRINT 'Most recent membership: ' + CONVERT(char(20), @lastdate, 107)
