 Q1:who is the senior most employee based on job title?
here the levels of the employess are given so we sort them on the basis of level and in desc mode

SELECT * from employee
ORDER BY levels desc
limit 1;

q2:which country has the most invoices
	
SELECT COUNT(*) as c , billing_country from invoice
group by billing_country
order by c desc

q:3 what are the 3 top most values of total invoice
SELECT total FROM invoice
order by total desc
limit 3

q:4 CITY HAS THE HIGHEST invoice total
SELECT * FROM invoice;
SELECT SUM(total) as invoice_total , billing_city 
from invoice 
group by billing_city
order by invoice_total desc
limit 1

Q5:best customer who has spent the most money.
here customer table does not have any invoice related column 
so we will connect the table along with the invoice table using schema
	
SELECT customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) as total
FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total desc
limit 1

q6:to return email,first name, last name,genre of all the rock music listeners.
	return your list ordered alphabetically by email starting wih a

SELECT email, first_name, last_name FROM customer
JOIN invoice ON customer.customer_id=invoice.customer_id
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre on track.genre_id=genre.genre_id
	WHERE genre.name= 'Rock'
)
ORDER BY email;

q:7 return the artist name that writes the most rock genre in our dataset
firstly join the artist table with the track table through the album table

SELECT artist.artist_id,artist.name,COUNT(artist.artist_id) as no_of_songs FROM track

JOIN album on album.album_id=track.album_id
JOIN artist on artist.artist_id =album.artist_id
JOIN genre on genre.genre_id=track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER by no_of_songs DESC
LIMIT 10;

q:6 return the track names have the length longer than the average song length
return the name,millisec for each track . Order by the song length with the longest songs
listed first.

SELECT track.name,track.milliseconds from track 
WHERE milliseconds>(
	SELECT AVG(milliseconds) as avg_track_length FROM track)
ORDER BY milliseconds desc

q:7find how much amount spent by each customer on artists ? write a query to
return customer name,artist name and total spent(unitPrice*Quantity from invoiceline)
here we wll observe 3 tables are used so we should firstly join the tables
in this query we will create a temporary table that stores the data only for that query

WITH temp_tabl as(
	SELECT artist.artist_id as artist_id, artist.name as artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) as total_spent from invoice_line
	JOIN track on track.track_id=invoice_line.track_id
	JOIN album on album.album_id=track.album_id
	JOIN artist on artist.artist_id=album.artist_id
	group by 1
	order by 3 desc
	limit 1
)
SELECT c.customer_id,c.first_name,c.last_name,temp_tabl.artist_name,
SUM(il.unit_price*il.quantity) as amount_spent from invoice i
JOIN customer c On c.customer_id= i.customer_id
JOIN invoice_line il on il.invoice_id=i.invoice_id
JOIN track t on t.track_id=il.track_id
JOIN album a on a.album_id = t.album_id
JOIN temp_tabl on temp_tabl.artist_id=a.artist_id
GROUP BY 1,2,3,4
order by 5 desc;

q:8 we find out the most famous genre of all the country
WITH tempo_tab as(
SELECT COUNT(invoice_line.quantity) as purchases,customer.country,genre.name,genre.genre_id,
ROW_NUMBER()OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC) as rowno
FROM invoice_line
JOIN invoice ON invoice.invoice_id=invoice_line.invoice_id
JOIN customer On customer.customer_id= invoice.customer_id
JOIN track on track.track_id=invoice_line.track_id
JOIN genre on genre.genre_id=track.genre_id
GROUP BY 2,3,4
ORDER by 2 ASC,1 DESC
)
SELECT * FROM tempo_tab WHERE rowno<=1

q:9 we have to find the customer name that has the spent the most on music 

WITH temp_tabl as(
SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total)
as total_spend,
	ROW_NUMBER() OVER (PARTITION by billing_country order by SUM(total) DESC) as rowno from invoice
	JOIN customer on customer.customer_id=invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc
)
SELECT * FROM temp_tabl WHERE rowno<=1