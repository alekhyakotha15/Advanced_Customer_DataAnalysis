/* Ordering the values of dimensions by measure in order to
check the top n performers or bottom n performers */

--Finding the first 5 products that generate the highest revenue

select top 5
p.product_name,
sum(f.sales_amount) as Total_Revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on f.product_key=p.product_key
group by p.product_name
order by Total_Revenue desc

--Implementing this by window function

select *
from (
select 
p.product_name,
sum(f.sales_amount) as Total_Revenue,
ROW_NUMBER() over(order by sum(f.sales_amount) desc) as Rank_Products
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on f.product_key=p.product_key
group by p.product_name
) t
where Rank_Products<=5

--What are the five worst performing products

select top 5
p.product_name,
sum(f.sales_amount) as Total_Revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on f.product_key=p.product_key
group by p.product_name
order by Total_Revenue 


-- Finding the top 10 customers who have generated the highest revenue

select top 10
c.customer_key, 
c.first_name,
c.last_name,
sum(f.sales_amount) Total_revenue
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_customers] c
on c.customer_key=f.customer_key
group by c.customer_key,c.first_name,
c.last_name
order by Total_revenue desc

--Finding 3 customers with the fewest orders placed.

select top 3
c.customer_key, 
c.first_name,
c.last_name,
count(distinct order_number) as Total_Orders
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_customers] c
on c.customer_key=f.customer_key
group by c.customer_key,c.first_name,
c.last_name
order by Total_Orders 