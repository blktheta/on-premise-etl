-- SETUP:
DROP VIEW IF EXISTS sales_master;
DROP VIEW IF EXISTS rentals_master;
DROP VIEW IF EXISTS actors_master;

-- WIDE FACT VIEWS:
-- SALES:
CREATE VIEW sales_master AS
SELECT 
	payment_date, 
	month_day,
	month,
	year,
	week_day,
	year_day,
	year_week,
	year_quarter,
	amount,
	c.first_name || ' ' || c.last_name AS customer,
	c.city,
	c.country,
	sta.first_name || ' ' || sta.last_name AS staff,
	sto.city AS store,
	title AS film,
	length AS minutes,
	release_year AS release,
	rating,
	category,
	rental_duration,
	rental_rate,
	trailers,
	behind_the_scenes AS bts,
	commentaries,
	deleted_scenes
FROM fact.sales AS fs
INNER JOIN dim.date AS d
	ON d.id = fs.date_id
INNER JOIN dim.staff AS sta
	ON sta.id = fs.staff_id
INNER JOIN dim.film AS f
	ON f.id = fs.film_id
INNER JOIN dim.store AS sto
	ON sto.id = fs.store_id
INNER JOIN dim.customer AS c
	ON c.id = fs.customer_id;

-- RENTALS:
CREATE VIEW rentals_master AS
SELECT 
	rental_date,
	return_date,
	days_rented,
	late_return,
	payment_date, 
	c.first_name || ' ' || c.last_name AS customer,
	c.city,
	c.country,
	sto.city AS store,
	title AS film,
	length AS minutes,
	release_year AS release,
	rating,
	category,
	rental_duration,
	rental_rate
FROM fact.rentals AS fr
INNER JOIN dim.date AS d
	ON d.id = fr.date_id
INNER JOIN dim.film AS f
	ON f.id = fr.film_id
INNER JOIN dim.store AS sto
	ON sto.id = fr.store_id
INNER JOIN dim.customer AS c
	ON c.id = fr.customer_id;

-- ACTORS:
CREATE VIEW actors_master AS
SELECT 
	payment_date, 
	month_day,
	month,
	year,
	week_day,
	year_day,
	year_week,
	year_quarter,
	amount,
	c.first_name || ' ' || c.last_name AS customer,
	c.city,
	c.country,
	a.first_name || ' ' || a.last_name AS actor,
	title AS film,
	length AS minutes,
	release_year AS release,
	rating,
	category,
	rental_duration,
	rental_rate
FROM fact.actors AS fa
INNER JOIN dim.date AS d
	ON d.id = fa.date_id
INNER JOIN dim.film AS f
	ON f.id = fa.film_id
INNER JOIN dim.customer AS c
	ON c.id = fa.customer_id
INNER JOIN dim.actor AS a
	ON a.id = fa.actor_id;
