/* Analyze the yearly performance of products by comparing each 
products sales to both its average sales performance and
the previous years sales */

with yearly_product_sales as (
select
year(s.order_date) as Order_Year,
p.product_key,
p.product_name,
sum(s.sales_amount) as Current_Sales_Amount
from dbo.[gold.fact_sales] s
left join 
dbo.[gold.dim_products] p on 
s.product_key=p.product_key
where s.order_date is not null
group by year(s.order_date),p.product_name,p.product_key
)
select 
Order_Year,
product_key,
product_name,
Current_Sales_Amount,
avg(Current_Sales_Amount) over(partition by product_name) as Avg_Sales,
Current_Sales_Amount - avg(Current_Sales_Amount) over(partition by product_name) as Diff_Avg,
case when Current_Sales_Amount - avg(Current_Sales_Amount) over(partition by product_name) > 0 then 'Above Avg'
	 when Current_Sales_Amount - avg(Current_Sales_Amount) over(partition by product_name) < 0 then 'Below Avg'
	 else 'Avg'
end Change,
--Year over Year Analysis
LAG(Current_Sales_Amount) over (partition by product_name order by Order_Year) as Previous_Sales,
Current_Sales_Amount - LAG(Current_Sales_Amount) over (partition by product_name order by Order_Year) as Diff_Previous,
case when Current_Sales_Amount - LAG(Current_Sales_Amount) over (partition by product_name order by Order_Year) > 0 then 'Increase'
	 when Current_Sales_Amount - LAG(Current_Sales_Amount) over (partition by product_name order by Order_Year) < 0 then 'Decrease'
	 else 'No Change'
end as Performance
from yearly_product_sales
order by product_name,Order_Year