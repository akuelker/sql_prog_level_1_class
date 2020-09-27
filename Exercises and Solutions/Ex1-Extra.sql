CREATE PROCEDURE bee
AS
DECLARE @nytrain int, @latrain int, @bee_mph int, @bee_distance int
SET @nytrain = 40 
SET @latrain = 60 
SET @bee_mph = 100
SET @bee_distance = 3000 / ( @nytrain + @latrain ) * @bee_mph
PRINT 'That poor little bee travels a distance of ' +
CONVERT(varchar(10), @bee_distance) + ' miles'