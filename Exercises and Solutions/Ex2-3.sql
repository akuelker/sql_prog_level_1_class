CREATE PROCEDURE increase_maxrate
@exempt_raise numeric(5,3) = 0, @nonexempt_raise numeric(5,3) = 0 
AS 
-- increase maxrate for exempt jobs 
UPDATE jobs
SET    maxrate = maxrate * (1 + @exempt_raise)
WHERE  class = 'EXEMPT'
-- increase maxrate for non-exempt jobs 
UPDATE jobs
SET    maxrate = maxrate * (1 + @nonexempt_raise)
WHERE  class = 'NON-EXEMPT'
-- display jobs and new max rates 
SELECT jobcode, maxrate FROM jobs 
