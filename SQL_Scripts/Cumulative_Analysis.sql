/* Calculating the total sales per month and the running
total of sales over time */

select
Order_date,
Total_sales,
sum(Total_sales) over(partition by year(Order_date) order by Order_date) as Cumulative_Sales
from
(
select
datetrunc(month,order_date) as Order_date,
sum(sales_amount) as Total_sales
from dbo.[gold.fact_sales]
where order_date is not null
group by datetrunc(month,order_date)
)t

/* Finding the moving average over the year */

select
Order_date,
Total_sales,
sum(Total_sales) over(order by Order_date) as Cumulative_Sales,
avg(Avg_price) over (order by Order_date) as Moving_Avg_Price
from
(
select
datetrunc(year,order_date) as Order_date,
sum(sales_amount) as Total_sales,
avg(price) as Avg_price
from dbo.[gold.fact_sales]
where order_date is not null
group by datetrunc(year,order_date)
)t