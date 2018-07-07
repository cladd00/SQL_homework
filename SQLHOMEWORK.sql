use sakila;

-- Display the first and last name of all actors from table actors
SELECT first_name, last_name FROM actor;


-- Display the first and last name of each actor in a single column in upper case letters.
SELECT CONCAT(first_name,'  ',last_name) as FIRST_LAST FROM actor;

-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first, name "Joe".
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "JOE";

-- Find all actors whose last name contain the letters "GEN"
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';

-- FInd all actors whose last names contain the letters "LI". This time, order the rows by last name and first name, in that order
SELECT actor_id, last_name, first_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name;

--  Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country
WHERE country = "Afghanistan" OR country = "Bangladesh" OR country = "China";

-- Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor ADD COLUMN middle_name varchar AFTER COLUMN first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor ALTER COLUMN middle_name 'blobs';

-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS CountOfLastName 
FROM actor
GROUP BY last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS CountOfLastName 
FROM actor 
WHERE CountOfLastName > 2
GROUP BY last_name;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO' , last_name = 'WILLIAMS'
WHERE actor_id = 172;

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE first_name = 78 AND first_name = 106; 

UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT payment.amount, staff.first_name, staff.last_name,payment.payment_date
FROM payment
INNER JOIN staff on staff.staff_id = payment.staff_id
WHERE payment.payment_date <= '2005-01-01 12:00:00';


 -- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT film.title, COUNT(film_actor.actor_id) AS CountOfActors
FROM film_actor
INNER JOIN film on film.film_id = film_actor.film_id
GROUP BY film.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT film.title, COUNT(inventory.film_id) AS NumberOfCopies
FROM inventory
INNER JOIN film on film.film_id = inventory.inventory_id
WHERE film.title = 'Hunchback Impossible'
GROUP BY film.title;

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'TotalPaid'
FROM customer c  JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY c.last_name;

SELECT * from payment;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT COUNT(*)
FROM customer
WHERE customer_id IN
(
	SELECT customer_id
    FROM payment
    WHERE rental_id IN
    (
		SELECT rental_id
        FROM rental
        WHERE inventory_id IN
        (
			SELECT inventory_id
            FROM inventory
            WHERE film_id IN
            (
            SELECT film_id
            FROM film
            WHERE title = 'Alone Trip'
            )
		)
	)
);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.ave been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';
-- 7e. Display the most frequently rented movies in descending order.
SELECT film_id, title, MAX(rental_duration) AS HighestRental
FROM film 
GROUP BY film_id, title
ORDER BY rental_duration DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(amount) AS  'Gross(in dollars)'
	FROM payment p
    JOIN rental r
    ON (p.rental_id = r.inventory_id)
    JOIN inventory i
    ON(i.inventory_id = r.inventory_id)
    JOIN store s
    ON (s.store_id = i.store_id)
    GROUP BY s.store_id;
    
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

-- 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_generes;
