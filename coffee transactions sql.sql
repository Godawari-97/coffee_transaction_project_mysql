create database coffee_transactions;

use coffee_transactions;


CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(250),
    product_id INT,
    unit_price DECIMAL(5, 2),
    product_category VARCHAR(250),
    product_type VARCHAR(250),
    product_detail VARCHAR(100)
);

show tables;

show global variables like 'local_infile';

SET GLOBAL local_infile = 1;

select * from transactions;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\coffee_transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
describe transactions;
select count(*) as total_records from transactions;
select * from transactions;

 
 -- Retrieve all transactions of Coffee products
 
 
 
-- What is the total revenue generated for each store?
select  store_location,
 sum(transaction_qty * unit_price) as total_revenue from transactions
group by store_location order by total_revenue desc;

 
--  What is the rank of each transaction based on the transaction_time for each store?
select transaction_id, store_location, transaction_time,
rank() over (partition by store_location order by transaction_time desc) as rank_transactions
from transactions;

-- What is the cumulative revenue for each transaction in a store?
select transaction_id, store_location,
transaction_qty * unit_price as transaction_revenue,
sum(transaction_qty * unit_price) over (partition by store_location order by transaction_time) ascumulative_rvenue
from transactions group by  transaction_id, store_location;



--  Find transactions where the same store sold the same product on the same day, but at different times.
select  a.transaction_id as transaction_id_1,
       b.transaction_id as transaction_id_2,
       a.store_location,
       a.product_id,
       a.transaction_date,
      a.transaction_time
from transactions a
join transactions b
on a.store_location = b.store_location
and a.product_id = b.product_id
and a.transaction_date = b.transaction_date
and a.transaction_time <> b.transaction_time;
 

 --  Find products sold in Lower Manhattan where total revenue exceeds $10.
 select store_location, sum(unit_price) as total_revenue  from transactions where unit_price =  10 
 group by store_location;
 
 
  -- Which store location generates the highest revenue, and what percentage does it contribute to the total revenue?
  select store_location,  max(unit_price) as highest_revenue  from transactions group by store_location
  order by highest_revenue desc;
  
  
  
  
 select * from transactions;
 

-- Find all transactions made in "Lower Manhattan"?
select * from transactions where store_location = "Lower Manhattan" limit 5;

-- List  all products with their product_id and product_type?
select  product_id, product_type from transactions;


-- Find transactions where the unit_price is greater than 3
select * from transactions where  unit_price >3
 limit 5;


-- Count the total number of transactions
select count(*) from transaction ;


-- Intermediate Questions:


-- Calculate the total revenue for each product category
select product_category, sum(unit_price * transaction_qty) as total_revenues from transactions 
group by product_category order by total_revenues desc limit 5;


-- Find the average transaction quantity (transaction_qty) for each store_location
select store_location, avg(transaction_qty) as avg_tranction_qty  from transactions group by store_location 
order by avg_tranction_qty  desc; 

-- Find the maximum and minimum unit_price for each product_category.
select  product_category, max(unit_price) as max_price, min(unit_price) as min_price from transactions
group by  product_category;

-- Identify transactions that occurred between 07:00:00 and 07:30:00.
select * from transactions where transaction_time between "07:00:00" and "07:30:00";

-- Rank products by their unit_price within each product_category
select product_category, product_id, unit_price,
dense_rank() over (partition by product_category order by unit_price desc) as price_rank
from transactions; 


-- Advanced Questions

-- Calculate the cumulative revenue for each product category
select product_category, sum(unit_price * transaction_qty)
 over (partition by product_category order by unit_price) as cumulative_revenue  from transactions; 


select * from transactions;

select concat(round(sum(unit_price * transaction_qty)/1000,1),'k') as total_sales,
concat(round(sum(transaction_qty)/100,1),'k') as total_qty_sold,
concat(round(sum(transaction_id)/1000,1),'k') as total_orders
from  transactions
where transaction_date = '2023-05-18';
 


select * from  transactions;
select transaction_id,
lead(transaction_id,2) over(order by transaction_id) as 'lead',
lag(transaction_id,2) over(order by transaction_id) as 'langth'
from  transactions;

select unit_price,
row_number() over(order by unit_price) as 'row_number',
rank() over(order by unit_price) as 'rank',
dense_rank() over(order by unit_price) as 'sense_rank',
percent_rank() over(order by unit_price) as 'percent_rank'
 from transactions;

-- Write an SQL query to find the product category with the highest total sales
select product_category, (select max(transaction_qty * unit_price) 
 from transactions) as highest_sales from transactions
group by product_category;



-- Calculate the cumulative sum of transaction_qty for each store_location ordered by transaction_date and transaction_time
select transaction_qty, store_location, transaction_date, transaction_time,
rank()over(partition by transaction_qty order by store_location) as rank_calculate from transactions;


select transaction_date, sum(transaction_qty * unit_price) as total_price 
 from transactions group by transaction_date order by total_price limit 5;
 
 
select * from transactions;

-- Calculate the total unit_price multiplied by transaction_qty for each transaction and return the transaction_id with the highest total.
select sum(unit_price * transaction_qty) as total_price, max(transaction_id) as max_transaction from transactions;


-- Find the store_id where the average unit_price of products is higher than the overall average unit_price across all transactions.
select store_id, round(avg(unit_price),2)  as avg_price from transactions
where unit_price < (select max(unit_price) from transactions)  group by  store_id order by avg_price desc ;



select * from transactions;

 SELECT * from transactions;
 SELECT COUNT(*) FROM  transactions;
SELECT extract(DAY FROM transaction_date) AS MONTH_TRDATE,  transaction_date  FROM  transactions;

SELECT extract(MONTH FROM transaction_date) AS MONTH_TRDATE, transaction_date  FROM  transactions;

SELECT extract(QUARTER FROM transaction_date) AS MONTH_TRDATE,  transaction_date  FROM  transactions;

-- Find the total revenue generated by each product type across all store locations
select product_type, store_location, sum(transaction_qty * unit_price) as  total_revenue from transactions
group by  product_type, store_location order by total_revenue  desc;

-- Identify the store and product type that has the highest average unit price
select store_location, product_type, avg(transaction_qty * unit_price) as highest_avg_price from trnasactions 
group by store_location, product_type order by  highest_avg_price desc;

select * from transactions;

 -- how the quantity of transactions changes over different hours of the day for a specific store.
 select hour(transaction_time) as transaction_hour,
 sum(transaction_qty) as total_qty
 from transactions where store_id = 5 group by hour(transaction_time)
 order by transaction_hour desc limit 5;
 
 
--  Compare sales of each product category across different years.
select product_category, year(transaction_date) as year_date,
sum(transaction_qty * unit_price) as total_price  from transactions
group by  product_category, year(transaction_date)
order by  year_date desc limit 5;
					
--  Calculate the running total of sales for each product type by transaction date
select transaction_date, product_type, sum(transaction_qty*unit_price)
 over(partition by product_type order  by transaction_date)as totak_price 
 from transactions order by totak_price  desc;
 
 
--  Find the top-selling product in each category based on total revenue
 select product_category, product_detail, sum(transaction_qty * unit_price) as total_revenue,
 rank() over (partition by product_category order by sum(transaction_qty * unit_price)desc) as  rank_order
 from transactions group by product_category, product_detail order by  rank_order  desc limit 5;
 
 
 -- Find all the transactions where the product type Gourmet brewed coffee' exists in the product_type column.
 select transaction_id,  transaction_date, product_type from transactions t 
 where  exists(select 1  from transactions where product_type = 'Gourmet brewed coffee'
 and t.transaction_id = transaction_id) limit 5;
 
  
--  Find all transactions where the product category is not "Tea".
select transaction_id, product_category from transactions t 
where not exists(select 1 from transactions where product_category = "Tea"
and t.transaction_id = transaction_id);
 
 
 -- Find the transaction_id of the transactions with the highest quantity (transaction_qty).
  select transaction_id, transaction_qty   from transactions where transaction_qty
  =(select max(transaction_qty) from transactions);
  
  
 --  Create a view that shows the total quantity sold for each product.
 create view product_sales  as 
 select product_id, max( transaction_qty) as total_qnty_sold from transactions
 group by product_id order by  total_qnty_sold desc;
 
 select * from product_sales;
 
 create index index_transction_dt
 on transactions (transaction_date);
 
--  Create an indexed view that summarizes product sales by location and product type.
create view ind_sales as
select store_location, product_type, sum(transaction_qty) as total_qnty_sold
from transactions  group by  store_location, product_type ;





-- Use the ROW_NUMBER() window function to assign a row number to each transaction sorted by transaction_qty within each store_location.
select transaction_id, store_location, transaction_qty,
row_number() over(partition by store_location order by transaction_qty desc) as  row_num_qnty
from transactions ;
 
select transaction_id, store_location, sum(transaction_qty) as total_qty_sold,
rank() over(partition by store_location order by transaction_qty desc) from transactions
group by  transaction_id, store_location  limit 5;


-- Calculate the percentage change in transaction_qty for a specific product between two dates.
select t.transaction_id,
(t.transaction_qty -
(select transaction_qty from transactions  where transaction_date = '01-01-23' and product_id  = t.product_id)
)/
(select transaction_qty from transactions where transaction_date = '01-01-23' and product_id = t.product_id) as percente_change
from transactions t
where t.transaction_qty = '01-01-23';


SELECT t.transaction_id,
       (t.transaction_qty - 
        (SELECT transaction_qty 
         FROM transactions 
         WHERE transaction_date = '01-01-23' 
         AND product_id = t.product_id)
       ) /
       (SELECT transaction_qty 
        FROM transactions 
        WHERE transaction_date = '01-01-23' 
        AND product_id = t.product_id) AS percentage_change
FROM transactions t
WHERE t.transaction_date = '01-01-23';


--  Find the highest revenue-generating product category
select product_category, sum(transaction_qty * unit_price) as highest_revenue
from transactions group by product_category order by  highest_revenue desc limit 1;

 -- Calculate the moving average of daily sales (7-day)
 with daily_sales as(
 select transaction_date, sum(transaction_qty * unit_price) as total_sales
 from transactions group by transaction_date
 )
 select transaction_date,  total_sales,
 round(avg( total_sales) over(order by  transaction_date  rows between 6 preceding and current row),2) as moving_avg_7_days
 from daily_sales;
 



 --  Analyze peak transaction times for each store
 select store_id, extract(hour from transaction_time) as hours,
 count(transaction_id) as total_transaction
 from transactions group by store_id, hours order by total_transaction desc limit 1;
 
 
 --  Detect possible fraud based on unusually high transaction quantity
 with avg_sales as(
 select store_id, avg(transaction_qty) as avg_qnty
 from transactions group by store_id 
 )
 select t.transaction_id, t.store_id, t. transaction_date from transactions t 
 join  avg_sales a on t.store_id = t.store_id
 where t.transaction_qty > a.avg_qnty * 3;
 

 -- Compute the total revenue for each store by multiplying transaction_qty with unit_price.
 select store_id, store_location, sum(transaction_qty * unit_price) as totle_revenue
 from transactions group by  store_id, store_location;
 
 
 
--  Identify the product with the highest unit_price
select product_id, product_detail, max(unit_price) as highest_unit_price
from transactions group by product_id, product_detail
limit 5;
 
--  Compute the average unit price per product category.
 select product_category, round(avg(unit_price),2) as avg_unit_price from transactions
 group by product_category limit 5;
 
 -- Identify the store with the highest number of transactions.
 select store_id, store_location, count(transaction_id) as total_transaction 
 from transactions group by store_id, store_location  order by total_transaction  desc;


 -- Create a new column that combines product_category and product_type into a single string.
 select product_id, concat(product_category , ' - ', product_type) as new_column_concat
 from transactions limit 5;
 
 
  -- Retrieve the hour of the transaction from the transaction_time field.
  select transaction_id, transaction_time, extract(hour from transaction_time) as transaction_hour
  from transactions limit 5;
  
  -- Determine the hour of the day when the most transactions occur.
  select extract(hour from transaction_time) as sales_hour,
  count(transaction_id) as totsl_transaction from transactions 
  group by  sales_hour order by totsl_transaction  desc limit 1;
  
  
  -- List products where the transaction_qty is higher than the average quantity sold
  select product_id, product_detail, transaction_qty from transactions  
  where transaction_qty > (select avg(transaction_qty) from transactions) limit 7;
   
  -- Assume there's a stores table with store details. Retrieve transactions along with store names
  select t.transaction_id, t.transaction_date, s.product_detail, t.product_id, t.transaction_qty from transactions t
  join trnasactions s  on t.store_id = s.store_id;
  
  
  -- Identify the first and last transaction for each store based on transaction_date and transaction_time.
  with rank_tran as(
  select 
  store_id, transaction_id,
  transaction_time, row_number() over (partition by store_id
  order by transaction_date, transaction_time asc) as fist_txn,
  row_number() over (partition by store_id order by transaction_date desc,
  transaction_time desc) as last_txn from transactions) 
  
select store_id, transaction_id, transaction_date, transaction_time from  rank_tran
  where fist_txn = 1 or lst_txn = 1;
  
  
  
  
 
 
 
 
 
 
 