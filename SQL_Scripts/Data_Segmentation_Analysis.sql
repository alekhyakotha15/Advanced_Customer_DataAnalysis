/* Segment products into cost ranges and count how many products fall 
into each segment */

with product_segment as (
select
product_key,
product_name,
cost,
case when cost<100 then 'Below 100'
	 when cost>100 and cost<500 then '100-500'
	 when cost>500 and cost<1000 then '500-1000'
	 else 'Above 1000'
end cost_range
from dbo.[gold.dim_products]
)
select 
cost_range,
count(product_key) as Total_products
from product_segment
group by cost_range
order by Total_products desc

/* Grouping customers into three segments based on their spending behavior
VIP: Atleast 12 months of history and spending more than 5000.
Regular: Atleast 12 months of history but spending 5000 or less.
New: Lifespan less than 12 months. 
Find the total number of customers for each group
*/

with customer_spending as(
select
c.customer_key,
sum(f.sales_amount) as Total_spending,
min(order_date) as First_order,
max(order_date) as Last_order,
datediff(month,min(order_date),max(order_date)) as Lifespan
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_customers] c
on f.customer_key=c.customer_key
group by c.customer_key
)
select
Customer_Segment,
count(customer_key) as Total_customers
from(
select
customer_key,
case when Lifespan>=12 and Total_spending>5000 then 'VIP'
	 when Lifespan>=12 and Total_spending<=5000 then 'Regular'
	 else 'New'
end Customer_Segment
from customer_spending) t
group by Customer_Segment
order by Total_customers desc


