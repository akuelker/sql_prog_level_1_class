CREATE PROCEDURE emp_select
@emp_id char(5) = NULL 
AS 
DECLARE @fname varchar(15), @lname varchar(15), @jcode char(3)
SELECT @fname = firstname, @lname = lastname, @jcode = jobcode
FROM   employee
WHERE  empid = @emp_id
PRINT 'Employee ID: ' + @emp_id
PRINT 'Name: ' + @fname + ' ' + @lname 
PRINT 'Job code: ' + @jcode 
