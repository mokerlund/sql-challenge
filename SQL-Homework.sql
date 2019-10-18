USE sakila;

-- Activity 1a
CREATE VIEW actors_names AS
SELECT first_name, last_name
FROM actor;

SELECT * FROM actors_names;

DROP VIEW actors_names_full;
-- 1b
CREATE VIEW actors_names_full AS
SELECT concat(first_name, " ", last_name) AS full_name
FROM actor;

SELECT * FROM actors_names_full LIMIT 10;

-- Activity 2

DROP VIEW find_by_first_name;

CREATE VIEW find_by_first_name AS
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

SELECT * FROM find_by_first_name;

DROP VIEW gen_in_last;

-- 2b
CREATE VIEW gen_in_last AS
SELECT * FROM actor
WHERE last_name LIKE "%GEN%";

SELECT * FROM gen_in_last;

DROP VIEW li_in_last;

-- 2c
CREATE VIEW li_in_last AS
SELECT * FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

SELECT * FROM li_in_last;

-- 2d
CREATE VIEW country_VIEW AS
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

SELECT * FROM country_VIEW;

-- Activity 3a

ALTER TABLE actor 
ADD description BLOB(200);

SELECT * FROM actor LIMIT 10;

-- 3b
ALTER TABLE actor 
DROP description;

SELECT * FROM actor LIMIT 10;

-- Activity 4a
-- List the last names of actors, as well as how many actors have that last name

CREATE VIEW last_name AS
SELECT last_name, count(last_name)
FROM actor;

SELECT * FROM last_name;

-- 4b
CREATE VIEW last_name_view AS
SELECT last_name, count(last_name)
FROM actor
HAVING count(last_name) >= 2;

SELECT * FROM last_name_view;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- Activity 5

SHOW CREATE TABLE address;

-- Activity 6a

SELECT * FROM address;
SELECT * FROM staff;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address on staff.address_id=address.address_id;

SELECT * FROM payment;

-- 6b
SELECT staff.first_name, staff.last_name, SUM(payment.amount)
AS total_payment
FROM staff
INNER JOIN payment on staff.staff_id=payment.staff_id;

SELECT * FROM film_actor;
SELECT * FROM film;

-- 6c
SELECT film.title, COUNT(*)
AS actor_count
FROM film
INNER JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.title;

SELECT * FROM inventory;

-- 6d
CREATE TABLE hunchback
SELECT film_id, title
FROM film
WHERE title like "Hunchback %";

SELECT COUNT(inventory_id), hunchback.title
FROM inventory, hunchback
WHERE hunchback.film_id = inventory.film_id;

-- 6e
SELECT customer.last_name, SUM(DISTINCT payment.amount) AS total_paid
FROM payment
INNER JOIN customer on payment.customer_id = customer.customer_id
GROUP BY customer.last_name
ORDER BY customer.last_name;

-- Activity 7
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT *
FROM film
WHERE language_id = 1 IN
(
SELECT language_id = 1
FROM film
HAVING title LIKE "K%" OR title LIKE "Q%"
);

SELECT * FROM film_actor;

SELECT *
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = "Alone Trip"
));

SELECT * FROM country;

SELECT email
FROM customer
WHERE store_id IN
(
SELECT store_id
FROM store
WHERE address_id IN
(
SELECT address_id
FROM address
WHERE city_id IN
(
SELECT city_id
FROM city
WHERE country_id IN
(
SELECT country_id
FROM country
WHERE country.country = "Canada"
))));

SELECT title
FROM film
ORDER BY rental_rate DESC;

SELECT staff_id, AVG(amount)
FROM payment
GROUP BY staff_id;

DROP TABLE store_address;
-- * 7g. Write a query to display for each store its store ID, city, and country.
-- store id > address id > city id (city) > country id (country)
CREATE TABLE store_address
SELECT store.store_id, address.city_id
FROM store
INNER JOIN address ON store.address_id = address.address_id;

SELECT * FROM store_city_country;

DROP TABLE store_city;
CREATE TABLE store_city
SELECT store_id, city.city, city.country_id
FROM store_address
INNER JOIN city ON city.city_id = store_address.city_id;

CREATE TABLE store_city_country
SELECT store_id, city, country.country
FROM store_city
INNER JOIN country ON store_city.country_id = country.country_id;

-- * 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

-- what are the top 5 categories as far as gross revenue?
-- category, category_id, film_id, inventory_id, payment_id, amount, 
SELECT * FROM inventory;

DROP TABLE first_genre;
CREATE TABLE first_genre AS
SELECT rental.inventory_id, payment.amount
FROM payment
INNER JOIN rental ON rental.rental_id = payment.rental_id;

SELECT * FROM  fourth_genre;

CREATE TABLE second_genre
SELECT first_genre.amount, film_id
FROM inventory
INNER JOIN first_genre ON first_genre.inventory_id = inventory.inventory_id;

CREATE TABLE third_genre
SELECT second_genre.amount, category_id
FROM film_category
INNER JOIN second_genre ON second_genre.film_id = film_category.film_id;

CREATE TABLE fourth_genre
SELECT third_genre.amount, name
FROM category
INNER JOIN third_genre ON third_genre.category_id = category.category_id;


SELECT * 
FROM fourth_genre
GROUP BY name
ORDER BY amount DESC
LIMIT 5;

-- 8a

CREATE VIEW top_five_genres AS
SELECT *
FROM fourth_genre
GROUP BY name
ORDER BY amount DESC
LIMIT 5;

-- 8b
SELECT * FROM top_five_genres;

-- 8c
DROP VIEW top_five_genres;