-- SETUP:
DROP TABLE IF EXISTS dim.date CASCADE;
DROP TABLE IF EXISTS dim.film CASCADE;
DROP TABLE IF EXISTS dim.actor CASCADE;
DROP TABLE IF EXISTS dim.staff CASCADE;
DROP TABLE IF EXISTS dim.store CASCADE;
DROP TABLE IF EXISTS dim.customer CASCADE;

DROP SCHEMA IF EXISTS fact CASCADE;
DROP SCHEMA IF EXISTS dim CASCADE;


-- SCHEMA:
CREATE SCHEMA fact;
CREATE SCHEMA dim;

SET search_path TO fact, dim, public;

-- SALES DIMENSION TABLES:
-- DATE
CREATE TABLE dim.date (
	id SERIAL PRIMARY KEY,
	payment_id INTEGER NOT NULL,
	payment_date TIMESTAMP NOT NULL,
	month_day SMALLINT NOT NULL,
	month SMALLINT NOT NULL,
	year SMALLINT NOT NULL,
	week_day_str CHAR(3) NOT NULL,
	month_str CHAR(3) NOT NULL,
	week_day SMALLINT NOT NULL,
	year_day SMALLINT NOT NULL,
	year_week SMALLINT NOT NULL,
	year_quarter SMALLINT NOT NULL
);

INSERT INTO dim.date (
	payment_id,
	payment_date,
	month_day,
	month,
	year,
	week_day_str,
	month_str,
	week_day,
	year_day,
	year_week,
	year_quarter
)
SELECT 
	p.payment_id,
	p.payment_date,
	EXTRACT(DAY FROM p.payment_date),
	EXTRACT(MONTH FROM p.payment_date),
	EXTRACT(YEAR FROM p.payment_date),
	TO_CHAR(p.payment_date, 'dy'),
	TO_CHAR(p.payment_date, 'mon'),
	EXTRACT(DOW FROM p.payment_date),
	EXTRACT(DOY FROM p.payment_date),
	EXTRACT(WEEK FROM p.payment_date),
	EXTRACT(QUARTER FROM p.payment_date) 
FROM public.payment AS p;

-- FILM
CREATE TABLE dim.film (	
	id SERIAL PRIMARY KEY,
	film_id INTEGER NOT NULL,
	title VARCHAR(255) NOT NULL,
	description TEXT,
	release_year YEAR,
	rental_duration SMALLINT NOT NULL,
	rental_rate NUMERIC(4,2) NOT NULL,
	length SMALLINT,
	replacement_cost NUMERIC(5,2) NOT NULL,
	rating VARCHAR(5),
	category VARCHAR(25) NOT NULL,
	trailers BOOLEAN NOT NULL,
	behind_the_scenes BOOLEAN NOT NULL,
	commentaries BOOLEAN NOT NULL,
	deleted_scenes BOOLEAN NOT NULL
);

INSERT INTO dim.film (
	film_id,
	title,
	description,
	release_year,
	rental_duration,
	rental_rate,
	length,
	replacement_cost,
	rating,
	category,
	trailers,
	behind_the_scenes,
	commentaries,
	deleted_scenes
)
SELECT 
	f.film_id,
	f.title,
	f.description,
	f.release_year,
	f.rental_duration,
	f.rental_rate,
	f.length,
	f.replacement_cost,
	f.rating,
	c.name,
	'Trailers' = ANY(f.special_features),
	'Behind the Scenes' = ANY(f.special_features),
	'Commentaries' = ANY(f.special_features),
	'Deleted Scenes' = ANY(f.special_features)  
FROM public.film_category AS fc  
INNER JOIN public.film AS f ON f.film_id = fc.film_id  
INNER JOIN public.category AS c ON c.category_id = fc.category_id;

-- ACTOR
CREATE TABLE dim.actor (
	id SERIAL PRIMARY KEY,
	actor_id INTEGER NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL
);

INSERT INTO dim.actor (
	actor_id,
	first_name,
	last_name
)
SELECT 	
	a.actor_id,
	a.first_name,
	a.last_name 
FROM public.actor AS a;

-- STAFF
CREATE TABLE dim.staff (
	id SERIAL PRIMARY KEY,
	staff_id INTEGER NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL
);

INSERT INTO dim.staff (
	staff_id,
	first_name,
	last_name
)
SELECT 	
	s.staff_id,
	s.first_name,
	s.last_name 
FROM public.staff AS s;

-- STORE
CREATE TABLE dim.store (
	id SERIAL PRIMARY KEY,
	store_id INTEGER NOT NULL,
	manager_id INTEGER NOT NULL,
	store_manager VARCHAR(90) NOT NULL,
	address VARCHAR(50) NOT NULL,
	district VARCHAR(50) NOT NULL,
	postal_code VARCHAR(10),
	city VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	phone VARCHAR(20)
);

INSERT INTO dim.store (
	store_id,
	manager_id,
	store_manager,
	address,
	district,
	postal_code,
	city,
	country,
	phone
)
SELECT  
	sto.store_id,
	sto.manager_staff_id,
	sta.first_name || ' ' || sta.last_name,
	a.address,
	a.district,
	a.postal_code,
	ci.city,
	co.country,
	a.phone  
FROM public.store AS sto  
INNER JOIN public.staff AS sta ON sta.staff_id = sto.manager_staff_id  
INNER JOIN public.address AS a ON a.address_id = sto.address_id   
INNER JOIN public.city AS ci ON ci.city_id = a.city_id  
INNER JOIN public.country AS co ON co.country_id = ci.country_id;

-- CUSTOMER
CREATE TABLE dim.customer (
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	email VARCHAR(50),
	address VARCHAR(50) NOT NULL,
	district VARCHAR(50) NOT NULL,
	postal_code VARCHAR(10),
	city VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	phone VARCHAR(20),
	create_date DATE NOT NULL
);

INSERT INTO dim.customer (
	customer_id,
	first_name,
	last_name,
	email,
	phone,
	create_date,
	address,
	district,
	postal_code,
	city,
	country
)  
SELECT  
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
	a.phone,
	c.create_date,
	a.address,
	a.district,
	a.postal_code,
	ci.city,
	co.country
FROM public.customer AS c  
INNER JOIN public.address AS a ON a.address_id = c.address_id
INNER JOIN public.city AS ci ON ci.city_id = a.city_id  
INNER JOIN public.country AS co ON co.country_id = ci.country_id;

-- FACT TABLES:
-- SALES
CREATE TABLE fact.sales (
	date_id INTEGER NOT NULL,
	staff_id INTEGER NOT NULL,
	film_id INTEGER NOT NULL,
	store_id INTEGER NOT NULL,
	customer_id INTEGER NOT NULL,
	amount NUMERIC(5,2) NOT NULL,
	FOREIGN KEY (date_id) REFERENCES dim.date,
	FOREIGN KEY (staff_id) REFERENCES dim.staff,
	FOREIGN KEY (film_id) REFERENCES dim.film,
	FOREIGN KEY (store_id) REFERENCES dim.store,
	FOREIGN KEY (customer_id) REFERENCES dim.customer,
	PRIMARY KEY(date_id, staff_id, film_id, store_id, customer_id)
);

INSERT INTO fact.sales (
	date_id,
	staff_id,
	film_id,
	store_id,
	customer_id,
	amount
)
SELECT   
	d.id,
	sta.id,
	f.id,
	sto.id,
	c.id,
	p.amount 
FROM  
	dim.date AS d,
	dim.staff AS sta,
	dim.film AS f,
	dim.store AS sto,
	dim.customer AS c,
	public.payment AS p,
	public.rental AS r,
	public.inventory AS i
WHERE  
	p.payment_id = d.payment_id AND 
	p.staff_id = sta.staff_id AND 
	p.staff_id = sto.manager_id AND 
	p.rental_id = r.rental_id AND 
	r.inventory_id = i.inventory_id AND 
	i.film_id = f.film_id AND 
	p.customer_id = c.customer_id;

-- RENTALS
CREATE TABLE fact.rentals (
	date_id INTEGER NOT NULL,
	film_id INTEGER NOT NULL,
	store_id INTEGER NOT NULL,
	customer_id INTEGER NOT NULL,
	rental_date TIMESTAMP NOT NULL,
	return_date TIMESTAMP NOT NULL,
	days_rented SMALLINT NOT NULL,
	late_return BOOLEAN NOT NULL,
	FOREIGN KEY (date_id) REFERENCES dim.date,
	FOREIGN KEY (film_id) REFERENCES dim.film,
	FOREIGN KEY (store_id) REFERENCES dim.store,
	FOREIGN KEY (customer_id) REFERENCES dim.customer,
	PRIMARY KEY(date_id, film_id, store_id, customer_id)
);

INSERT INTO fact.rentals (
	date_id,
	film_id,
	store_id,
	customer_id,
	rental_date,
	return_date,
	days_rented,
	late_return
)
SELECT 
	d.id,
	f.id,
	s.id,
	c.id,
	r.rental_date,
	r.return_date,
	(r.return_date::date - r.rental_date::date),
	(r.return_date::date - r.rental_date::date) > f.rental_duration
FROM  
	dim.date AS d,
	dim.film AS f,
	dim.store AS s,
	dim.customer AS c,
	public.rental AS r,
	public.inventory AS i,
	public.payment AS p
WHERE 
	r.return_date IS NOT NULL AND 
	r.rental_id = p.rental_id AND 
	p.payment_id = d.payment_id AND 
	r.customer_id = c.customer_id AND 
	r.inventory_id = i.inventory_id AND 
	i.film_id = f.film_id AND 
	r.staff_id = s.manager_id;
	
-- ACTORS
CREATE TABLE fact.actors (
	date_id INTEGER NOT NULL,
	actor_id INTEGER NOT NULL,
	film_id INTEGER NOT NULL,
	customer_id INTEGER NOT NULL,
	amount NUMERIC(5,2) NOT NULL,
	FOREIGN KEY (date_id) REFERENCES dim.date,
	FOREIGN KEY (actor_id) REFERENCES dim.actor,
	FOREIGN KEY (film_id) REFERENCES dim.film,
	FOREIGN KEY (customer_id) REFERENCES dim.customer,
	PRIMARY KEY(date_id, actor_id, film_id, customer_id)
);

INSERT INTO fact.actors (
	date_id,
	actor_id,
	film_id,
	customer_id,
	amount
)
SELECT  
	d.id,
	a.id,
	f.id,
	c.id,
	p.amount 
FROM 
	dim.date AS d,
	dim.actor AS a,
	dim.film AS f,
	dim.customer AS c,
	public.payment AS p,
	public.rental AS r,
	public.inventory AS i,
	public.film_actor AS fa
WHERE 
	p.payment_id = d.payment_id AND 
	p.customer_id = c.customer_id AND 
	p.rental_id = r.rental_id AND
	r.inventory_id = i.inventory_id AND 
	f.film_id = i.film_id AND 
	fa.film_id = f.film_id AND 
	fa.actor_id = a.actor_id;
