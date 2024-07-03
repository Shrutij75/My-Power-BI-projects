copy pizza_sales(pizza_id,order_id,pizza_name_id,quantity,order_date,order_time,unit_price,total_price,pizza_size,pizza_category,pizza_ingredients,pizza_name)
from 'C:\\Users\\DELL\\Downloads\\pizza_sales.csv'
DELIMITER ','
CSV HEADER;

Select * from pizza_sales;

q:1for finding the total revenue
select SUM(total_price)as Total_Revenue from pizza_sales ;

q:2 finding the average order values
firstly calculate the total orders
select count(distinct order_id)as total_orders from pizza_sales ;

select sum(total_price)/count(distinct order_id) as avg_order_counts from pizza_sales;

q:3 find the total pizza sold
SELECT SUM(quantity) as total_pizza_sold from pizza_sales;

q:4 total order placed
SELECT COUNT(distinct order_id) as total_orders from pizza_sales;

q:5 average pizza per order
SELECT sum(quantity)/count(distinct order_id) as avg_pizza_perorder from pizza_sales;

q:6 daily trend for total orders

SELECT DATENAME(weekday, order_date) AS order_days,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(weekday, order_date);
				OR
SELECT FORMAT(order_date, 'dddd') AS order_days,
COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY FORMAT(order_date, 'dddd');


q:7 montly trend of total orders
SELECT DATENAME(MONTH, order_date) AS order_days,
COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date);

q:8 perctange of sales by pizza category
Select pizza_category,Sum(total_price) as total_sales, Sum(total_price)*100/(Select sum(total_price) from pizza_sales)as PCT
from pizza_sales
group by pizza_category
--for finding the sales based on the months condition likr
--where MONTH(order_date)=1


q:9 percentage of sales by pizza_size
Select pizza_size,cast(Sum(total_price)as decimal(10,2)) as total_sales, cast(Sum(total_price)*100/(Select sum(total_price) from pizza_sales) as decimal(10,2))as PCT
from pizza_sales
group by pizza_size
order by PCT desc

q:10 total pizza sold by pizza category
select pizza_category,Sum(quantity)as pizza_sold from pizza_sales 
group by pizza_category
order by pizza_sold desc

q:11 top 5 best sellers by revenue ,totL quantity and total orders
--konsa pizza ka selling best h
select  pizza_name,sum(total_price)as total_Revenue from pizza_sales
group by pizza_name
order by total_Revenue desc
LIMIT 5

q:12 for finding the bottom 5 -only changes desc to asc

q:13 for finding based on the quantity
select  pizza_name,sum(quantity)as total_quantity from pizza_sales
group by pizza_name
order by total_quantity desc
LIMIT 5
