create database OyoBusiness;
use OyoBusiness;


create table OYO_city (
  hotel_id INT PRIMARY KEY,
  city VARCHAR(50)
);

create table OYO_sales (
  booking_id INT PRIMARY KEY,
  customer_id INT,
  status VARCHAR(20), 
  checkin DATE,
  checkout DATE,
  number_of_rooms INT,
  hotel_id INT,
  amount DECIMAL(10, 2),
  discount DECIMAL(10, 2),
  date_of_booking DATE,
  FOREIGN KEY (hotel_id) references OYO_city(hotel_id)
);

insert into OYO_city values (56, 'Bangalore');
insert into OYO_city values (45, 'Delhi');
insert into OYO_city values (16, 'Gurgaon');
insert into OYO_city values (14, 'Kolkata');
insert into OYO_city values (15, 'Pune');
insert into OYO_city values (10, 'Mumbai');
insert into OYO_city values (7, 'Chennai');
insert into OYO_city values (18, 'Hyderabad');

insert into OYO_sales values 
(1, 201, 'stayed', '2025-07-19', '2025-07-20', 1, 56, 2000, 100, '2025-07-19'), 
(2, 202, 'stayed', '2025-07-22', '2025-07-23', 1, 45, 2500, 200, '2025-07-20'), 
(3, 203, 'stayed', '2025-02-21', '2025-02-22', 1, 16, 2300, 150, '2025-02-19'), 
(4, 204, 'stayed', '2025-03-01', '2025-03-02', 1, 14, 1800, 100, '2025-02-28'), 
(5, 205, 'stayed', '2025-08-01', '2025-08-03', 2, 15, 3000, 300, '2025-06-25'),
(6, 206, 'Cancelled', '2025-01-11', '2025-01-12', 1, 10, 2800, 150, '2025-01-01'), 
(7, 207, 'No Show', '2025-07-20', '2025-07-21', 1, 16, 2200, 100, '2025-07-20'), 
(8, 208, 'Cancelled', '2025-07-22', '2025-07-23', 1, 7, 2100, 100, '2025-07-21'); 



----1. Average room rate of different cities----
select c.city, AVG(s.amount) as average_room_rate from OYO_sales s inner join OYO_city c on s.hotel_id=c.hotel_id where s.status='stayed' group by c.city;
----2. Number of bookings in jan, feb,mar(by city)----
select c.city,DATENAME(MONTH, s.date_of_booking) as booking_month, COUNT(*) AS total_bookings from OYO_sales s INNER JOIN  OYO_city c ON s.hotel_id = c.hotel_id where  MONTH(s.date_of_booking) IN (1, 2, 3) group by  c.city, DATENAME(MONTH, s.date_of_booking);
----3. Frequency of Early Booking-----
select  DATEDIFF(DAY, s.date_of_booking, s.checkin) as days_before_checkin, COUNT(*) AS booking_count from  OYO_sales s group by  DATEDIFF(DAY, s.date_of_booking, s.checkin);
----4. Frequency of booking by number of rooms----
select number_of_rooms, COUNT(*) as frequency from OYO_sales group by number_of_rooms;
----5. New Customers in January-----
with FirstBookings as (select customer_id, MIN(date_of_booking) as first_booking_date from OYO_sales group by customer_id) select COUNT(*) as new_customers_in_jan from FirstBookings where MONTH(first_booking_date) = 1;
----6. Net Revenue (Booked only)----
select SUM(amount - discount) as net_revenue from OYO_sales where status = 'stayed';
---7. Gross Revenue (All bookings)----
select SUM(amount - discount) as gross_revenue from OYO_sales;

----Coding Assessment (21-7-25)----
----1. Average Revenue after discount per city------
select c.city,AVG(s.amount - s.discount) as avg_revenue from OYO_sales s INNER JOIN OYO_city c ON s.hotel_id=c.hotel_id where s.status='Stayed' group by c.city order by avg_revenue DESC;

----2. Minimum Number of Rooms booked per city------
select c.city, MIN(s.number_of_rooms) as min_rooms from OYO_sales s INNER JOIN OYO_city c ON s.hotel_id=c.hotel_id where s.status='Stayed' group by c.city order by min_rooms ASC;

----3. Avg, min and max room amount per city-----
select c.city, AVG(s.amount) as avg_amount, MIN(s.amount) as min_amount, MAX(s.amount) as max_amount from OYO_city c LEFT JOIN OYO_sales s ON c.hotel_id=s.hotel_id AND s.status ='Stayed' group by c.city order by avg_amount DESC;
----4. average duration of stay per city
select c.city, AVG(DATEDIFF(DAY, s.checkin, s.checkout)) AS avg_stay_duration from OYO_sales s RIGHT JOIN OYO_city c ON s.hotel_id=c.hotel_id AND s.status='Stayed' group by c.city order by avg_stay_duration DESC;
----5. Number of booking per city-----
select c.city, COUNT(*) AS total_bookings from OYO_sales s INNER JOIN OYO_city c ON s.hotel_id=c.hotel_id where s.status='Stayed' group by c.city Order by total_bookings DESC;