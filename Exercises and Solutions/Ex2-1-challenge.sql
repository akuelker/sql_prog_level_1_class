CREATE PROCEDURE emp_select_challenge
@emp_id char(5) = NULL 
AS 
DECLARE @fname varchar(15), @lname varchar(15), @jdesc varchar(16)
SELECT @fname = firstname, @lname = lastname, @jdesc = jobdesc
FROM   employee INNER JOIN jobs
ON employee.jobcode = jobs.jobcode 
WHERE  empid = @emp_id
PRINT 'Employee ID: ' + @emp_id
PRINT 'Name: ' + @fname + ' ' + @lname 
PRINT 'Job description: ' + @jdesc
