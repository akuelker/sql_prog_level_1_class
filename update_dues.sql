CREATE PROCEDURE update_dues
-- default 10% increase, unless you specify otherwise 
 	@incr numeric(5,2) = .1 
AS 
UPDATE memtype
SET dues = dues * (1 + @incr)
