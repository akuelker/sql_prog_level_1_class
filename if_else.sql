CREATE PROCEDURE if_else 
@num1 int = 0, @num2 int = 0 
AS 
	IF @num1 > @num2
		BEGIN 
			PRINT 'Number1 is greater than Number2'
			PRINT 'You''re so smart!'
		END 
	ELSE 
		BEGIN 
			PRINT 'Number1 is NOT greater than Number2'
			PRINT 'Please try again.'
		END 
	PRINT 'Thanks for playing!'
