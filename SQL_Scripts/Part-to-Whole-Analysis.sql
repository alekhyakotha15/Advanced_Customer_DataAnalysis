/* Which Categories contribute the most to overall sales */

select category,
Sales_by_Category,
sum(Sales_by_Category) over() as Total_Sales,
concat(round((cast(Sales_by_Category as float)/sum(Sales_by_Category) over())*100,2), '%') as Perc_of_Total
from
(
select
p.category,
sum(f.sales_amount) as Sales_by_Category
from dbo.[gold.fact_sales] f
left join dbo.[gold.dim_products] p
on p.product_key=f.product_key
group by p.category
)t
