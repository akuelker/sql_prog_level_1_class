CREATE PROCEDURE param_insert
	@mcode char(2), @mdescrip varchar(10) = NULL, 
	@mdues numeric(5,2) = NULL 
AS 
	-- insert row into Memtype table
	INSERT INTO memtype (memcode, mem_descrip, dues)
	VALUES (@mcode, @mdescrip, @mdues)
	-- display data from new row 
	SELECT * FROM memtype
	WHERE memcode = @mcode 
