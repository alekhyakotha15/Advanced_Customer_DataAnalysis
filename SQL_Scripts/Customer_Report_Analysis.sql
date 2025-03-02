/* Customer Report
Purpose:
This report consolidates key customer metrics and behaviors.
Highlights:
1) Gathers essential fields such as names, ages and transaction details.
2) Segments customers into categories (VIP, Regular, New) and age groups.
3) Aggregates customer-level metrics:
	- total orders
	- total sales
	- total quantity purchased
	- total products
	- lifespan (in months)
4) Calculates valuable KPIs:
	- recent (months since last order)
	- average order value
	- average monthly spend
*/

/* Basic Query: Retrieves core columns from tables */

create view [gold.report_customers] as
with customer_report as (
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name,' ',c.last_name) as Customer_Name,
datediff(year,c.birthdate,getdate()) as age
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_customers] c 
on c.customer_key=f.customer_key
where f.order_date is not null
)

/* Customer Aggregations: Summarizes key metrics at the customer level */
, customer_aggregations as (
select 
customer_key,
customer_number,
Customer_Name,
age,
count(distinct order_number) as Total_Orders,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct product_key) as Total_Products,
max(order_date) as Last_Order,
datediff(month,min(order_date),max(order_date)) as Lifespan
from customer_report
group by 
customer_key,
customer_number,
Customer_Name,
age
)
select 
customer_key,
customer_number,
Customer_Name,
age,
case when age<20 then 'Under 20'
	when age between 20 and 29 then '20-29'
	when age between 30 and 39 then '30-39'
	when age between 40 and 49 then '40-49'
	else '50 and above'
end as age_group,
case 
	when Lifespan>=12 and Total_Sales>5000 then 'VIP'
	when Lifespan>=12 and Total_Sales<=5000 then 'Regular'
	else 'New'
end as customer_segment,
Last_Order,
datediff(month,Last_Order,getdate()) as recency,
Total_Orders,
Total_Sales,
Total_Quantity,
Total_Products,
Lifespan,
--computing average order value
case when Total_Orders=0 then 0
else (Total_Sales/Total_Orders) 
end as avg_order_value,
--Computing average monthly spend
case when Lifespan=0 then Total_Sales
	 else Total_Sales/Lifespan
end as avg_monthly_spend
from customer_aggregations