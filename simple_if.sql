CREATE PROCEDURE simple_if
	@num1 int = 0, @num2 int = 0 
AS 
	IF @num1 > @num2
		PRINT 'Number1 is greater than Number2'
	PRINT 'Thanks for playing!'
