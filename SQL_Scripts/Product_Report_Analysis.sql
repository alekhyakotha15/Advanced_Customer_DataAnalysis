/* 
Product Report

Purpose:
	- This report consolidates key product metrics and behaviours.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue

	*/

create view [gold.report_products] as 
with base_query as(
select 
p.product_name,
p.category,
p.subcategory,
p.cost,
f.order_number,
f.order_date,
f.sales_amount,
f.quantity,
f.customer_key
from dbo.[gold.dim_products] p
left join dbo.[gold.fact_sales] f
on p.product_key=f.product_key
where f.order_date is not null
)
, product_aggregations as (
select 
product_name,
category,
subcategory,
cost,
count(distinct order_number) as Total_Orders,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct customer_key) as Total_Customers,
round(avg(cast(sales_amount as float)/nullif(quantity,0)),1) as avg_selling_price,
datediff(month,min(order_date),max(order_date)) as Lifespan,
max(order_date) as Last_Sale_Date
from base_query
group by 
product_name,
category,
subcategory,
cost
)
select 
product_name,
category,
subcategory,
cost,
Total_Orders,
Total_Sales,
case when Total_Sales>300000 then 'High-Performers'
	 when Total_Sales between 150000 and 299999 then 'Mid-Range'
	 else 'Low-Performers'
end as Performance,
Total_Quantity,
Total_Customers,
avg_selling_price,
--Average order revenue(AOR)
case 
	when Total_Orders=0 then 0
	else Total_Sales/Total_Orders
end as avg_order_revenue,
case
	when Lifespan=0 then 0
	else Total_Sales/Lifespan
end as avg_monthly_revenue,
Lifespan,
Last_Sale_Date,
datediff(month,Last_Sale_Date,getdate()) as recency
from product_aggregations