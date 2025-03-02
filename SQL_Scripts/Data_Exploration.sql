--Exploring all Objects in the Database

select * from INFORMATION_SCHEMA.TABLES

--Exploring all Columns in Database

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='gold.dim_customers'