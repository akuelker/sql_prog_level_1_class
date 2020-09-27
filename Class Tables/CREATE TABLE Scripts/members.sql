create table members (
	mem_id char(5),
	firstname varchar(15),
	lastname varchar(15),
	memcode char(2) default 'AD',
	memdate smalldatetime)