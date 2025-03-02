/* 
Identifying the earliest and latest dates (boundaries)
Helps to understand the scope of data and the timespan of products.
*/

--Finding the date of first and last order

select min(order_date) First_Order,
max(order_date) Last_Order
from dbo.[gold.fact_sales]

--How many years of sales are available

select min(order_date) First_Order,
max(order_date) Last_Order,
datediff(year,min(order_date),max(order_date)) as Order_Span
from dbo.[gold.fact_sales]

--Finding the Youngest and Oldest Customer

select
min(birthdate) as Oldest_birthdate,
datediff(year,min(birthdate),getdate()) as Oldest_age,
max(birthdate) as Youngest_birthdate,
datediff(year,max(birthdate),getdate()) as Youngest_age
from dbo.[gold.dim_customers]