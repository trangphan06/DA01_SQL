--ex1: datalemur-yoy-growth-rate
SELECT 
extract(year from transaction_date) as year, product_id, spend as curr_year_spend,
lag(spend) over(partition by product_id  order by extract(year from transaction_date)) as prev_year_spend,
round(100.0*(spend-lag(spend) over(partition by product_id  order by extract(year from transaction_date)))/lag(spend) over(partition by product_id  order by extract(year from transaction_date)),2) as yoy_rate
FROM user_transactions;

--ex2: datalemur-card-launch-success
select card_name, issued_amount
from
(SELECT 
card_name, make_date(issue_year, issue_month,1) as issued_date,
row_number() over(partition by card_name order by make_date(issue_year, issue_month,1)) as r, issued_amount
FROM monthly_cards_issued) as a
where r=1
order by issued_amount desc;

--ex3: datalemur-third-transaction
select user_id, spend, transaction_date
from
(SELECT user_id,
rank() over(partition by user_id order by transaction_date) as r, spend, transaction_date
FROM transactions) as a
where r=3
order by user_id, spend, transaction_date;

--ex4: datalemur-histogram-users-purchases
select transaction_date,user_id, count(r)
from
(SELECT user_id,
rank() over(partition by user_id order by transaction_date desc) as r,transaction_date 
FROM user_transactions) as a
where r=1
group by transaction_date,user_id
order by transaction_date;

--ex5: datalemur-rolling-average-tweets
SELECT user_id, tweet_date,
case 
when c3 is not null then round((c1+c2+c3)/3.0,2)
when c2 is not null then round((c1+c2)/2.0,2)
else round(c1,2)
end rolling_avg_3d
from
(select user_id, tweet_date, tweet_count c1,
lag(tweet_count) over(partition by user_id order by tweet_date) c2,
lag(tweet_count,2) over(partition by user_id order by tweet_date) c3
from tweets) as c;

--ex6: datalemur-repeated-payments
select count(*)
from
(SELECT transaction_id	,merchant_id,credit_card_id, amount,transaction_timestamp,
lag(transaction_timestamp) over(partition by credit_card_id,merchant_id, amount order by transaction_timestamp),
transaction_timestamp-lag(transaction_timestamp) over(partition by credit_card_id,merchant_id, amount order by transaction_timestamp) diff
FROM transactions) as a
where diff <= '00:10:00'

--ex7: datalemur-highest-grossing
select category,product, total_spend
from
(select category, product, sum(spend) as total_spend,
row_number() over(partition by category order by sum(spend) desc) as r
from product_spend
where extract(year from transaction_date)=2022
group by category, product) as z
where r<=2;

--ex8: datalemur-top-fans-rank
select artist_name, r as artist_rank
from
(SELECT a.artist_id, a.artist_name, count(g.rank),
dense_rank() over(order by count(g.rank) desc) as r
FROM artists as a
join songs as s
on a.artist_id=s.artist_id
join global_song_rank as g
on g.song_id=s.song_id
where g.rank <=10
group by a.artist_id, a.artist_name) as z
where r <= 5;
