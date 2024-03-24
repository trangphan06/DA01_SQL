-- Challenge view:
CREATE VIEW movies_category AS
(
	SELECT a.title, a.length, 
	c.name as category_name
	FROM film as a 
	join film_category as b
	ON a.film_id=b.film_id
	join category as c
	ON c.category_id=b.category_id
	order by length desc
)

-- Challenge update:
update film
set rental_rate=1.99
where rental_rate=0.99
;

alter table customer
add column initials varchar(10)
;
update customer
set initials=concat(left(first_name,1),'.',left(last_name,1))
;
