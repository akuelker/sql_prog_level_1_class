CREATE PROCEDURE job_insert
@jcode char(3), @jdesc varchar(16) = NULL, 
@jclass varchar(10) = NULL, @jminrate numeric(5,2) = NULL,
@jmaxrate numeric(5,2) = NULL
AS 
INSERT INTO jobs (jobcode, jobdesc, class, minrate, maxrate)
VALUES (@jcode, @jdesc, @jclass, @jminrate, @jmaxrate)
