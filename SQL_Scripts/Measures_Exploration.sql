/* Measure Exploration helps to answer questions like
total sales, total orders etc. */

--Finding the Total Sales

select sum(sales_amount) Total_Sales
from dbo.[gold.fact_sales]

--Finding how many items are sold

select sum(quantity) as Total_Quantity
from dbo.[gold.fact_sales]

--Finding the average selling price

select avg(price) as Avg_price
from dbo.[gold.fact_sales]

--Finding the total number of orders
/*Without distinct gives duplicate values as one customer can order 
three products in same order */

select count(order_number) as Total_Orders
from dbo.[gold.fact_sales]

--Its important to use distinct to select only unique orders
select count(distinct order_number) as Total_Orders
from dbo.[gold.fact_sales]

--Finding the total number of products
--Here we get same without distinct as table contains about all different products
select count(product_key) as Total_Products
from dbo.[gold.dim_products]

--Finding the total number of customers

select count(customer_id) as Total_Customers
from dbo.[gold.dim_customers]

--Finding the total number of customers who have placed an order

select count(distinct customer_key) as Total_customers
from dbo.[gold.fact_sales]

--Generating a report that shows all key metrics of the business

select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from dbo.[gold.fact_sales]
union all
select 'Total Quantity' , sum(quantity) from dbo.[gold.fact_sales]
union all
select 'Average Price', avg(price) from dbo.[gold.fact_sales]
union all
select 'Total No.of Orders', count(distinct order_number) from dbo.[gold.fact_sales]
union all
select 'Total No.of Products', count(product_name) from dbo.[gold.dim_products]
union all
select 'Total No.of Customers',count(distinct customer_key) from dbo.[gold.dim_customers]