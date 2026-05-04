
create database event_management;
use event_management;

create table venues (
    venue_id int primary key auto_increment,
    venue_name varchar(100),
    location varchar(100),
    capacity int
);

create table organizers (
    organizer_id int primary key auto_increment,
    organizer_name varchar(100),
    contact_email varchar(100),
    phone_number varchar(15)
);

create table events (
    event_id int primary key auto_increment,
    event_name varchar(100),
    event_date date,
    venue_id int,
    organizer_id int,
    ticket_price decimal(10,2),
    total_seats int,
    available_seats int,
    foreign key (venue_id) references venues(venue_id),
    foreign key (organizer_id) references organizers(organizer_id)
);

create table attendees (
    attendee_id int primary key auto_increment,
    name varchar(100),
    email varchar(100),
    phone_number varchar(15)
);

create table tickets (
    ticket_id int primary key auto_increment,
    event_id int,
    attendee_id int,
    booking_date date,
    status varchar(20),
    foreign key (event_id) references events(event_id),
    foreign key (attendee_id) references attendees(attendee_id),
    unique (event_id, attendee_id)
);

create table payments (
    payment_id int primary key auto_increment,
    ticket_id int,
    amount_paid decimal(10,2),
    payment_status varchar(20),
    payment_date datetime,
    foreign key (ticket_id) references tickets(ticket_id)
);



insert into venues (venue_name, location, capacity) values
('city hall', 'ahmedabad', 500),
('open ground', 'surat', 1000);

insert into organizers (organizer_name, contact_email, phone_number) values
('rahul events', 'rahul@gmail.com', '9876543210'),
('star planners', 'star@gmail.com', '9123456780');

insert into events (event_name, event_date, venue_id, organizer_id, ticket_price, total_seats, available_seats) values
('music fest', '2026-12-10', 1, 1, 500, 500, 200),
('food carnival', '2026-12-15', 2, 2, 300, 1000, 600);

insert into attendees (name, email, phone_number) values
('amit', 'amit@gmail.com', '9999999999'),
('neha', null, '8888888888');

insert into tickets (event_id, attendee_id, booking_date, status) values
(1, 1, curdate(), 'confirmed'),
(2, 2, curdate(), 'pending');

insert into payments (ticket_id, amount_paid, payment_status, payment_date) values
(1, 500, 'success', now()),
(2, 0, 'pending', now());



update events set ticket_price = 600 where event_id = 1;
delete from attendees where attendee_id = 2;
select * from events;


select * 
from events e
join venues v on e.venue_id = v.venue_id
where v.location = 'ahmedabad';

select t.event_id, sum(p.amount_paid) as revenue
from payments p
join tickets t on p.ticket_id = t.ticket_id
group by t.event_id
order by revenue desc
limit 5;

select * from events
where month(event_date) = 12
and available_seats > total_seats * 0.5;


select * from events
where available_seats > 0;


select event_id, count(attendee_id) as total_attendees
from tickets
group by event_id;


select sum(amount_paid) from payments;


select event_id, count(*) as total
from tickets
group by event_id
order by total desc
limit 1;


select e.event_name, v.venue_name
from events e
inner join venues v on e.venue_id = v.venue_id;


select a.name
from attendees a
left join tickets t on a.attendee_id = t.attendee_id
left join payments p on t.ticket_id = p.ticket_id
where p.payment_status is null;


select event_id
from tickets
group by event_id
having count(*) > (
    select avg(cnt)
    from (
        select count(*) as cnt
        from tickets
        group by event_id
    ) as temp
);

select event_name, month(event_date) from events;

select event_name, datediff(event_date, curdate()) as days_left
from events;


select upper(organizer_name) from organizers;

select name, ifnull(email, 'not provided') from attendees;


select t.event_id,
sum(p.amount_paid) as revenue,
rank() over (order by sum(p.amount_paid) desc) as rank_position
from payments p
join tickets t on p.ticket_id = t.ticket_id
group by t.event_id;

-- case
select event_name,
case 
    when available_seats < total_seats * 0.2 then 'high demand'
    when available_seats between total_seats * 0.2 and total_seats * 0.5 then 'moderate demand'
    else 'low demand'
end as demand_status
from events;

select payment_id,
case
    when payment_status = 'success' then 'successful'
    when payment_status = 'failed' then 'failed'
    else 'pending'
end as status_label
from payments;