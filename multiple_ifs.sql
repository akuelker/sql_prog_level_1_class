CREATE PROCEDURE multiple_ifs
@num1 int = 0, @num2 int = 0 
AS 
	IF @num1 > @num2
		BEGIN 
			PRINT 'Number1 is greater than Number2'
			PRINT 'You''re so smart!'
		END 
	ELSE 
		IF @num1 < @num2
			BEGIN 
				PRINT 'Number1 is less than Number2'
				PRINT 'Please try again.'
			END 
		ELSE 
			BEGIN 
				PRINT 'The numbers are equal'
				PRINT 'Are you trying to trick me?'
			END 	
	PRINT 'Thanks for playing!'
