/* Query 1 - used for question 1 */
SELECT t1.title    film_title,
       t1.category category_name,
       t2.rentals  rental_count
FROM   (SELECT f.title,
               c.NAME AS category,
               f.film_id,
               c.NAME
        FROM   film f
               JOIN film_category fc
                 ON f.film_id = fc.film_id
               JOIN category c
                 ON fc.category_id = c.category_id
        WHERE  c.NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy',
                           'Family', 'Music' )) AS t1
       JOIN (SELECT DISTINCT( i.film_id ),
                            Count(r.rental_id)
                              OVER (
                                partition BY i.film_id
                                ORDER BY film_id) AS rentals
             FROM   inventory i
                    JOIN rental r
                      ON i.inventory_id = r.inventory_id) AS t2
         ON t1.film_id = t2.film_id
ORDER  BY 2;

/* Query 2 - used for question 2 */
WITH t1
     AS (SELECT f.film_id,
                f.title,
                c.NAME category
         FROM   film f
                JOIN film_category fc
                  ON f.film_id = fc.film_id
                JOIN category c
                  ON fc.category_id = c.category_id
         WHERE  c.NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy',
                            'Family', 'Music' ))
SELECT t1.title             title,
       t1.category          category_name,
       t2.rental_duration   rental_duration,
       t2.standard_quartile standard_quartile
FROM   t1
       JOIN (SELECT film_id,
                    rental_duration,
                    Ntile(4)
                      OVER (
                        ORDER BY rental_duration) AS standard_quartile
             FROM   film) AS t2
         ON t1.film_id = t2.film_id;

/* Query 3 - used for question 3 */
WITH t3
     AS (SELECT t1.title,
                t1.category,
                t2.standard_quartile
         FROM   (SELECT f.film_id,
                        f.title,
                        c.NAME category
                 FROM   film f
                        JOIN film_category fc
                          ON f.film_id = fc.film_id
                        JOIN category c
                          ON fc.category_id = c.category_id
                 WHERE  c.NAME IN ( 'Animation', 'Children', 'Classics',
                                    'Comedy',
                                    'Family', 'Music' )) AS t1
                JOIN (SELECT film_id,
                             rental_duration,
                             Ntile(4)
                               OVER (
                                 ORDER BY rental_duration) AS standard_quartile
                      FROM   film) AS t2
                  ON t1.film_id = t2.film_id)
SELECT t3.category          category_name,
       t3.standard_quartile standard_quartile,
       Count(t3.title)      count
FROM   t3
GROUP  BY 1,
          2
ORDER  BY 1,
          2;

/* Query 4 - used for question 4 */
SELECT st.store_id                     store_id,
       Date_part('year', rental_date)  AS rental_year,
       Date_part('month', rental_date) AS rental_month,
       Count(r.rental_id)              count_rentals
FROM   store st
       JOIN staff sf
         ON sf.store_id = st.store_id
       JOIN rental r
         ON r.staff_id = sf.staff_id
GROUP  BY 1,
          2,
          3
ORDER  BY 2,
          3; 
