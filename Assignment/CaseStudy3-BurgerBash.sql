create database BurgerBash;
use BurgerBash;

create table burger_runner (
    runner_id INT PRIMARY KEY,
    registration_date DATE
);
create table burger_names (
    burger_id INT PRIMARY KEY,
    burger_name VARCHAR(50)
);
create table customer_orders (
    order_id INT,
    customer_id INT,
    burger_id INT,
    exclusions VARCHAR(100),
    extras VARCHAR(100),
    order_time DATETIME
);
create table runner_orders (
    order_id INT,
    runner_id INT,
    pickup_time DATETIME,
    distance VARCHAR(20),  
    duration VARCHAR(20),  
    cancellation VARCHAR(20) 
);
insert into burger_runner (runner_id, registration_date) values
(1, '2025-07-01'),
(2, '2025-07-02'),
(3, '2025-07-09'),
(4, '2025-07-12'),
(5, '2025-07-15');

insert into burger_names (burger_id, burger_name) values
(1, 'Vegetarian'),
(2, 'Meatlovers'),
(3, 'Cheeseburger'),
(4, 'BBQ Burger'),
(5, 'Paneer Tikka Burger');

insert into customer_orders (order_id, customer_id, burger_id, exclusions, extras, order_time) values
(101, 1001, 1, '', 'cheese', '2025-07-19 11:30:00'),
(102, 1002, 2, 'onion', '', '2025-07-19 12:45:00'),
(103, 1003, 1, '', '', '2025-07-19 14:15:00'),
(104, 1001, 3, 'lettuce', 'bacon', '2025-07-19 15:30:00'),
(105, 1004, 2, '', '', '2025-07-19 16:00:00');

insert into runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation) values
(101, 1, '2025-07-19 11:45:00', '5 km', '20 minutes', NULL),
(102, 2, '2025-07-19 13:00:00', '3.5 km', '15 minutes', NULL),
(103, 3, '2025-07-19 14:30:00', '7.2 km', '25 minutes', NULL),
(104, 4, '2025-07-19 15:50:00', '4 km', '18 minutes', NULL),
(105, 5, NULL, NULL, NULL, 'Cancelled');


----1. How many burgers were ordered?----
select COUNT(*) as total_burgers_ordered from customer_orders;
----2. How many unique customer orders were made?
select COUNT(DISTINCT order_id) as unique_customer_orders from customer_orders;
----3. How many successful orders were delivered by each runner?
select runner_id, COUNT(*) as successful_deliveries from runner_orders where cancellation IS NULL OR cancellation = 'null' group by runner_id;
----4. How many of each type of burger was delivered
select b.burger_name, COUNT(*) as total_delivered from customer_orders c JOIN runner_orders r ON c.order_id = r.order_id JOIN burger_names b ON c.burger_id = b.burger_id where r.cancellation IS NULL OR r.cancellation = 'null' group by b.burger_name;
----5. How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, SUM(CASE WHEN burger_id = 1 THEN 1 ELSE 0 END) as vegetarian_count, SUM(CASE WHEN burger_id = 2 THEN 1 ELSE 0 END) as meatlovers_count from customer_orders group by customer_id;
----6. What was the maximum number of burgers delivered in a single order?
select TOP 1 c.order_id, COUNT(*) as burger_count from customer_orders c JOIN runner_orders r ON c.order_id = r.order_id where r.cancellation IS NULL OR r.cancellation = 'null' group by c.order_id order by burger_count DESC;
-----7.For each customer, how many delivered burgers had at least 1 change and how many had no changes?
select customer_id, SUM(CASE WHEN (exclusions IS NOT NULL AND exclusions <> '')  OR (extras IS NOT NULL AND extras <> '') THEN 1 ELSE 0 END) AS burgers_with_changes,
    SUM(CASE WHEN (exclusions IS NULL OR exclusions = '') AND (extras IS NULL OR extras = '') THEN 1 ELSE 0 END) AS burgers_without_changes
from customer_orders c JOIN runner_orders r ON c.order_id = r.order_id where r.cancellation IS NULL OR r.cancellation = 'null' group by customer_id;
----8. What was the total volume of burgers ordered for each hour of the day?
select DATEPART(HOUR, order_time) AS hour_of_day, COUNT(*) AS total_burgers from customer_orders group by DATEPART(HOUR, order_time) order by hour_of_day;
----9. How many runners signed up for each 1-week period?
select DATEPART(WEEK, registration_date) AS week_number, COUNT(*) AS runners_signed_up from burger_runner group by DATEPART(WEEK, registration_date) order by week_number;
----10. What was the average distance travelled for each customer?
select c.customer_id, AVG(CAST(REPLACE(r.distance, ' km', '') AS FLOAT)) AS avg_distance_km from customer_orders c JOIN runner_orders r ON c.order_id = r.order_id where r.cancellation IS NULL OR r.cancellation = 'null' group by c.customer_id;























