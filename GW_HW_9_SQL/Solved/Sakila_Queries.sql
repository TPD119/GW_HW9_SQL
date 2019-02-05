-- 1a
SELECT first_name,last_name FROM sakila.actor;

-- 1b
SELECT CONCAT(last_name,', ',first_name) AS "Actor Name" FROM sakila.actor;

-- 2a
SELECT first_name,last_name, actor_id FROM sakila.actor WHERE first_name LIKE '%Joe%';

-- 2b
SELECT first_name,last_name, actor_id FROM sakila.actor WHERE last_name LIKE '%Gen%';

-- 2c
SELECT first_name,last_name, actor_id 
FROM sakila.actor 
WHERE last_name 
LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM sakila.country 
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB NULL AFTER last_update;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, count(last_name)
FROM sakila.actor 
GROUP BY last_name;

--  4b
SELECT last_name, count(last_name) as name_count
FROM sakila.actor 
GROUP BY last_name
HAVING name_count >2;

--  4c
UPDATE actor
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO';

-- 5a
SHOW CREATE TABLE address; 

-- 6a
SELECT
	first_name
    ,last_name
    ,address
FROM
	staff
	INNER JOIN address
	ON staff.address_id = address.address_id;

-- 6b
SELECT
	first_name
    ,last_name
    ,sum(amount) as 'total_amount'
FROM
	staff
	INNER JOIN payment
	ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

-- 6c 
SELECT
	title
    ,count(actor_id) as Num_Actors
FROM
	film_actor fa
	INNER JOIN film f
	ON fa.film_id = f.film_id
GROUP BY f.film_id;

-- 6d 
SELECT
	title
    ,count(inventory_id) as Num_Copies
FROM
	film f
	LEFT JOIN inventory i
	ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY f.film_id;

-- 6e
SELECT 
	c.last_name
    ,c.first_name 
    ,sum(p.amount) as 'Total Amount Paid'
FROM 
	payment p
INNER JOIN customer c
  ON p.customer_id = c.customer_id
GROUP BY 
	p.customer_id
ORDER BY last_name; 

-- 7a
SELECT title
FROM film
WHERE language_id IN
  (
    SELECT language_id
    FROM language
    WHERE name = 'English'
  ) AND (title LIKE 'Q%' or title LIKE 'K%');
  
-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
	FROM film
	WHERE title = 'Alone Trip'
  ) 
);

-- 7c
SELECT
	first_name
    ,last_name
    ,email
    ,country
FROM
	customer c 
	INNER JOIN address a
	ON c.address_id = a.address_id
    INNER JOIN city ci
    on a.city_id = ci.city_id
    INNER JOIN country co
    on ci.country_id = co.country_id
WHERE 
	country = 'Canada';
    
-- 7d
SELECT
	title
    ,ca.name
FROM
	film f
	INNER JOIN film_category fc
	ON f.film_id = fc.film_id
    INNER JOIN category ca
    on fc.category_id = ca.category_id
WHERE 
	ca.name = 'family';

-- 7e 
SELECT
	title,
    count(r.inventory_id) AS times_rented
FROM
	rental r
	INNER JOIN inventory i
	ON r.inventory_id = i.inventory_id
    INNER JOIN film f
    on i.film_id = f.film_id
GROUP BY r.inventory_id
ORDER BY times_rented DESC;

-- 7f
SELECT
	st.store_id,
	sum(p.amount) AS total_amount
FROM
	payment p
	INNER JOIN staff s
	ON p.staff_id = s.staff_id
    INNER JOIN store st
    on s.store_id = st.store_id
GROUP BY store_id;

-- 7g
SELECT
	st.store_id,
	city,
    country
FROM
	store st
	INNER JOIN address a
	ON st.address_id = a.address_id
    INNER JOIN city ci
    on a.city_id = ci.city_id
    INNER JOIN country co
    on ci.country_id = co.country_id;
    
-- 7h
SELECT
	ca.name,
	sum(p.amount) AS total_amount
FROM
	payment p
	INNER JOIN rental r
	ON p.rental_id = r.rental_id
    INNER JOIN inventory i 
    ON r.inventory_id = i.inventory_id
    INNER JOIN film_category fc
    ON i.film_id = fc.film_id
    INNER JOIN category ca
    ON fc.category_id = ca.category_id
GROUP BY ca.name
ORDER BY total_amount DESC;
    
-- 8a
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `sakila`.`top_five` AS
    SELECT 
        `ca`.`name` AS `name`, SUM(`p`.`amount`) AS `total_amount`
    FROM
        ((((`sakila`.`payment` `p`
        JOIN `sakila`.`rental` `r` ON ((`p`.`rental_id` = `r`.`rental_id`)))
        JOIN `sakila`.`inventory` `i` ON ((`r`.`inventory_id` = `i`.`inventory_id`)))
        JOIN `sakila`.`film_category` `fc` ON ((`i`.`film_id` = `fc`.`film_id`)))
        JOIN `sakila`.`category` `ca` ON ((`fc`.`category_id` = `ca`.`category_id`)))
    GROUP BY `ca`.`name`
    ORDER BY `total_amount` DESC;
    
-- 8b    
SELECT * FROM sakila.top_five;    
    
-- 8c
DROP VIEW `sakila`.`top_five`;

