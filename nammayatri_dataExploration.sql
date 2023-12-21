-- Total Trips
select count(distinct tripid) from trips_details4;


-- Total Drivers
select count(distinct driverid) from trips;


-- Total Earnings
select sum(fare) from trips;


-- Total Completed trips
select count(distinct tripid) trips from trips;


-- Total Searches
select sum(searches) from trips_details4;

-- Total searches which got estimate
select sum(searches_got_estimate) from trips_details4;

-- Total searches for quotes
select sum(searches_for_quotes) from trips_details4;

-- Total searches which got quotes
select sum(searches_got_quotes) from trip_details4;




-- Total driver cancelled
select sum(customer_not_cancelled) from trip_details4;


-- Total otp entered
select sum(otp_entered) from trips_details4;


-- Total end ride
select sum(end_ride) from trips_details4;



-- cancelled bookings by driver
select count(*)- sum(driver_not_cancelled) from trips_details4;


-- cancelled bookings by customer
select count(*)- sum(customer_not_cancelled) from trips_details4;



-- average distance per trip
select avg(distance) from trips;




-- average fare per trip
select avg(fare) from trips;

-- distance travelled
select sum(distance) from trips;

-- which is the most used payment method 
select * from trips;
select payment.method from (select faremethod, count(distinct tripid) count_of_payment_method_used from trips
group by faremethod
order by count_of_payment_method_used desc
limit 1) t1
inner join payment 
on t1.faremethod= payment.id;


-- the highest payment was made through which instrument
select payment.method from (select faremethod , sum(fare) total_fare from trips 
group by faremethod
order by total_fare desc
limit 1) t1 
join payment 
on t1.faremethod=payment.id;




-- which two locations had the most trips
select loc_from,loc_to from 
(select *, dense_rank() over(order by count_of_trips desc) rnk from
(select loc_from, loc_to , count(distinct tripid )count_of_trips from trips
group by loc_from , loc_to) t1)t2
where rnk=1;



-- top 5 earning drivers
select driverid from 
(select * , dense_rank() over(order by earnings_of_drivers)rnk from 
(select driverid,sum(fare) earnings_of_drivers from trips
group by driverid) t1) t2
where rnk<6;




-- which duration had more trips
select duration  from 
(select * , dense_rank() over(order by count_of_trips desc) rnk from
(select duration, count(distinct tripid) count_of_trips from trips
group by duration) t1) t2
where rnk =1;




-- which driver , customer pair had more orders
select driverid, custid from 
(select *, dense_rank() over( order by orders desc) rnk from
(select driverid, custid , count(distinct tripid) orders from trips
group by driverid , custid) t1) t2
where rnk=1;


-- search to estimate rate
select sum(searches_got_estimate)/sum(searches) search_to_estimate_rate from trips_details4;


-- estimate to search for quote rates
select sum(searches_for_quotes)/sum(searches_got_estimate) estimate_to_searhc_for_qoutes_rate from trips_details4;

-- quote acceptance rate
select sum(searches_got_quotes)/sum(searches_for_quotes) qoute_acceptance_rate from trips_details4;


-- conversion rate
select sum(end_ride)/sum(searches) conversion_rate from trips_details4;




-- which area got highest trips in which duration
select duration, loc_from as area , trips  from (
select * , dense_rank() over(partition by duration order by trips desc) rnk from
(select duration,loc_from,count(distinct tripid) trips from trips
group by duration,loc_from) t1) t2
where rnk=1
order by duration asc;



-- which area got the highest fares
select loc.assembly1, fare from 
(select * , dense_rank() over( order by fare desc) rnk from 
(select loc_from as area , sum(fare) fare from trips
group by loc_from)t1)t2
inner join loc
on t2.area=loc.id
where rnk=1;


-- which area got the cutomer cancellations
select loc.assembly1,cancellation_by_customer from 
(select * , dense_rank() over( order by cancellation_by_customer desc) rnk from 
(select loc_from as area , count(*)- sum(customer_not_cancelled) cancellation_by_customer from trips_details4
group by loc_from)t1)t2
inner join loc
on t2.area=loc.id
where rnk=1;



-- which area got the highest driver cancellations
select loc.assembly1,cancellation_by_driver from 
(select * , dense_rank() over( order by cancellation_by_driver desc) rnk from 
(select loc_from as area , count(*)- sum(driver_not_cancelled) cancellation_by_driver from trips_details4
group by loc_from)t1)t2
inner join loc
on t2.area=loc.id
where rnk=1;

-- which area got the highest trips
select loc.assembly1,count_of_trips from 
(select * , dense_rank() over( order by count_of_trips desc) rnk from 
(select loc_from as area , count(distinct tripid) count_of_trips from trips_details4
group by loc_from)t1)t2
inner join loc
on t2.area=loc.id
where rnk=1;



