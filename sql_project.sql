use cryptopunk;

select * from pricedata;

-- Q1 
select count(*) as sales from pricedata;

-- Q2
select name, eth_price, usd_price from pricedata
order by usd_price desc
limit 5;

-- Q3
select event_date, usd_price, 
avg(usd_price) over(order by event_date desc) as Moving_Average 
from pricedata
limit 50;

-- Q4
select name, avg(usd_price) over(order by usd_price desc) as Average_Price
from pricedata
order by usd_price desc;


-- Q5
select event_date, count(transaction_hash) as Sales, avg(eth_price) from pricedata
group by event_date
order by sales asc;


-- Q6
alter table pricedata
add column summary varchar(255);

update pricedata set
summary = concat(
					name, 
					' was sold for $', 
					floor((usd_price + 99) / 1000) * 1000, 
                    ' to ', 
					buyer_address, 
					' from ',
					seller_address,
					' on ',
					date_format(event_date, '%Y-%m-%d') 
			     ); 
                 
select summary from pricedata;   
      

-- Q7
create view 1919_purchases as
select * from pricedata
where buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

select * from 1919_purchases;


-- Q8
select round(eth_price  / 100) * 100 as Eth_price_range, count(*) as frequency , 
Rpad('',count(*), '*') AS Bar_Graph 
from pricedata
group by Eth_price_range
order by Eth_price_range;


-- Q9
select name, max(eth_price) as price, 'Highest' as status 
from pricedata
group by name
union all
select name, min(eth_price) as price, 'Lowest' as status 
from pricedata
group by name
order by name asc, status asc;


-- 10
select 
	year(event_date) as Sale_Year,
	month(event_date) as Sale_Month,
    name,
    max(usd_price)
from pricedata
group by Sale_Year, Sale_Month, name;


-- 11
select 
	year(event_date) as year, 
    month(event_date) as month, 
    round(sum(usd_price)  / 100) * 100 as sum_of_sales
from pricedata
group by month, year
order by year asc , month asc;


-- 12
select count(*) from pricedata
where buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685' or
      seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
      
-- 13
create temporary table temp_table as
select event_date, 
	   usd_price, 
       avg(usd_price) over(partition by event_date ) as avg_usd_price
from pricedata;  


select * from temp_table
where usd_price >= 0.1 * avg_usd_price

