use sakila;

--  Select the first name, last name, and email address of all the customers who have rented a movie.

select distinct(c.customer_id), c.first_name, c.last_name, c.email from customer c
join rental r on c.customer_id = r.customer_id;

--  What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select c.customer_id, concat(c.first_name, " ", c.last_name) as name, avg(p.amount) from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id;


-- Select the name and email address of all the customers who have rented the "Action" movies.
 
select concat(c.first_name, " ", c.last_name) as name, c.email from customer c
join rental r on c.customer_id = r.customer_id
join inventory i on r.inventory_id = i.inventory_id
join film_category fc on i.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
where cat.name = "Action";


-- Write the query using sub queries with multiple WHERE clause and IN condition.
select concat(first_name, " ", last_name) as name, email from customer c
where c.customer_id in (
	select r.customer_id from rental r
	where r.inventory_id in(
		select i.inventory_id from inventory i
		where i.film_id in (
			select fc.film_id
			from film_category fc
			where fc.category_id in (
				select cat.category_id
				from category cat
				where cat.name = "Action"
				)
			)
		)
	);
 
 
 -- Verify if the above two queries produce the same results or not == same results

 
 
-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select c.customer_id, concat(c.first_name, " ", c.last_name) as name, round(avg(p.amount), 2) as avg_amount, 
	case
		when round(avg(p.amount), 2) < 2 then 'low'
		when round(avg(p.amount), 2) >= 2 and round(avg(p.amount), 2) < 4 then 'medium'
		when round(avg(p.amount), 2) >= 4 then 'high'
	 end as value_transaction
from customer c
join payment p on c.customer_id = p.customer_id 
group by c.customer_id;