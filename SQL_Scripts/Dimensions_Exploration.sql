/* Exploring Dimensions to check how many unique values are 
present and used to group the data */

--Exploring all different countries of customers

select distinct(country) from dbo.[gold.dim_customers]

--Exploring all Categories of Products

select distinct(category),subcategory,product_name 
from dbo.[gold.dim_products]
order by 1,2,3

--Exploring product line of products

select distinct(product_line) 
from dbo.[gold.dim_products]