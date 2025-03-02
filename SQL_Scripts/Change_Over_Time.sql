/* Change over time Trends */

select 
year(order_date) as Order_Year,
Month(order_date) as Order_Month,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct customer_key) as Total_Customers
from dbo.[gold.fact_sales]
where order_date is not null
group by Year(order_date),Month(order_date)
order by year(order_date),Month(order_date)


/* To make year and month appear in same column rather than having two columns*/
select 
datetrunc(year,order_date) as Order_Year,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct customer_key) as Total_Customers
from dbo.[gold.fact_sales]
where order_date is not null
group by datetrunc(year,order_date)
order by datetrunc(year,order_date)

select 
datetrunc(month,order_date) as Order_Year,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct customer_key) as Total_Customers
from dbo.[gold.fact_sales]
where order_date is not null
group by datetrunc(month,order_date)
order by datetrunc(month,order_date)

/* Creating my own format for the date */

select 
format(order_date,'yyyy-MMM') as Order_Year,
sum(sales_amount) as Total_Sales,
sum(quantity) as Total_Quantity,
count(distinct customer_key) as Total_Customers
from dbo.[gold.fact_sales]
where order_date is not null
group by format(order_date,'yyyy-MMM')
order by format(order_date,'yyyy-MMM')