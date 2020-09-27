create table jobs (
	jobcode char(3) primary key,
	jobdesc varchar(16),
	class varchar(10) default 'EXEMPT',
	minrate numeric(5,2) check (minrate >= 6.5),
	maxrate numeric(5,2))