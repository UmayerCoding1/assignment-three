-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================
-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
drop table if exists Bookings;
drop table if exists Matches;
drop table if exists Users;
-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
create table Users (
  user_id serial,
  full_name varchar(100) not null,
  email varchar(50) not null,
  role varchar(50) not null,
  phone_number varchar(20),
  constraint user_pk primary key (user_id),
  constraint unique_user_email unique (email),
  constraint check_user_role check (role in ('Ticket Manager', 'Football Fan'))
);
-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
create table Matches (
  match_id serial,
  fixture varchar(250) not null,
  tournament_category varchar(100) not null,
  base_ticket_price decimal(10, 2) not null,
  match_status varchar(20) not null,
  constraint matches_pk primary key (match_id),
  constraint check_ticket_price check (base_ticket_price >= 0),
  constraint check_match_status check (
    match_status in (
      'Available',
      'Selling Fast',
      'Sold Out',
      'Postponed'
    )
  )
);
-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
create table Bookings (
  booking_id serial,
  user_id int not null,
  match_id int not null,
  seat_number varchar(20),
  payment_status varchar(20),
  total_cost decimal(10, 2),
  constraint booking_pk primary key (booking_id),
  constraint bookings_user_fk foreign key (user_id) references Users (user_id),
  constraint bookings_match_fk foreign key (match_id) references Matches (match_id),
  constraint check_total_cost check (total_cost >= 0),
  constraint check_payment_status check (
    payment_status in ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
  )
);
insert into Users (user_id, full_name, email, role, phone_number)
values (
    1,
    'Tanvir Rahman',
    'tanvir@mail.com',
    'Football Fan',
    '+8801711111111'
  ),
  (
    2,
    'Asif Haque',
    'asif@mail.com',
    'Football Fan',
    '+8801722222222'
  ),
  (
    3,
    'Sajjad Rahman',
    'sajjad@mail.com',
    'Ticket Manager',
    '+8801733333333'
  ),
  (
    4,
    'Jannat Ara',
    'jannat@mail.com',
    'Football Fan',
    NULL
  );
-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
insert into Matches (
    match_id,
    fixture,
    tournament_category,
    base_ticket_price,
    match_status
  )
values (
    101,
    'Real Madrid vs Barcelona',
    'Champions League',
    150.00,
    'Available'
  ),
  (
    102,
    'Man City vs Liverpool',
    'Premier League',
    120.00,
    'Selling Fast'
  ),
  (
    103,
    'Bayern Munich vs PSG',
    'Champions League',
    130.00,
    'Available'
  ),
  (
    104,
    'AC Milan vs Inter Milan',
    'Serie A',
    90.00,
    'Sold Out'
  ),
  (
    105,
    'Juventus vs Roma',
    'Serie A',
    80.00,
    'Available'
  );
-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
insert into Bookings (
    booking_id,
    user_id,
    match_id,
    seat_number,
    payment_status,
    total_cost
  )
values (501, 1, 101, 'A-12', 'Confirmed', 150.00),
  (502, 1, 102, 'B-04', 'Confirmed', 120.00),
  (503, 2, 101, 'A-13', 'Confirmed', 150.00),
  (504, 2, 101, NULL, NULL, 150.00),
  (505, 3, 102, 'C-20', 'Pending', 120.00);
-- =========================================================================
-- QUERY 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
-- =========================================================================
select match_id,
  fixture,
  base_ticket_price
from matches
where tournament_category = 'Champions League'
  and match_status = 'Available';
-- =========================================================================
-- QUERY 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
-- =========================================================================
select user_id,
  full_name,
  email
from users
where full_name ilike 'Tanvir%'
  or full_name ilike '%Haque%';
-- =========================================================================
-- QUERY 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
-- =========================================================================
select booking_id,
  user_id,
  match_id,
  coalesce(payment_status, 'Action Required')
from bookings
where payment_status is null;