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