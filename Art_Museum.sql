/* Initializing */

CREATE DATABASE IF NOT EXISTS art_museum_v13;

USE art_museum_v13;

/* Tables */

CREATE TABLE IF NOT EXISTS role
(
role_id INT PRIMARY KEY auto_increment,
name varchar(45),
is_staff boolean,
is_partner boolean
);

CREATE TABLE IF NOT EXISTS staff_role
(
staff_role_id INT PRIMARY KEY auto_increment,
role_start_date date,
role_end_date date,
fk_role_id int,
fk_staff_id int
);

CREATE TABLE IF NOT EXISTS staff
(
staff_id INT PRIMARY KEY auto_increment,
first_name VARCHAR(45),
last_name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS partner_role
(
partner_role_id INT PRIMARY KEY auto_increment,
role_start_date date,
role_end_date date,
fk_role_id int,
fk_partner_id int
);

CREATE TABLE IF NOT EXISTS partner
(
partner_id INT PRIMARY KEY auto_increment,
name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS event_staff
(
event_staff_id INT PRIMARY KEY auto_increment,
fk_event_id INT, 
fk_staff_role_id INT
);

CREATE TABLE IF NOT EXISTS event_partner
(
event_staff_id INT PRIMARY KEY auto_increment,
fk_event_id INT, 
fk_partner_role_id INT
);

CREATE TABLE IF NOT EXISTS event
(
event_id INT PRIMARY KEY auto_increment,
name VARCHAR(45),
description VARCHAR(500),
start_date DATE,
end_date DATE
);

CREATE TABLE IF NOT EXISTS room
(
room_id INT PRIMARY KEY auto_increment,
square_foot_size DECIMAL,
fk_floor_id INT,
fk_event_id INT
);

CREATE TABLE IF NOT EXISTS floor
(
floor_id INT PRIMARY KEY auto_increment,
floor_number VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS art_piece
(
art_piece_id INT PRIMARY KEY auto_increment,
name VARCHAR(400),
type VARCHAR(45),
value DECIMAL,
date_made DATE, 
is_on_display BOOLEAN,
is_event BOOLEAN,
fk_room_id INT
);

CREATE TABLE IF NOT EXISTS art_piece_artist
(
art_piece_artist_id INT PRIMARY KEY auto_increment,
fk_art_piece_id INT,
fk_artist_id INT
);

CREATE TABLE IF NOT EXISTS artist
(
artist_id INT PRIMARY KEY auto_increment,
first_name VARCHAR(45),
last_name VARCHAR(45)
);

/* Adding Foreign Keys */
ALTER TABLE staff_role
ADD FOREIGN KEY(fk_role_id) REFERENCES role(role_id),
ADD FOREIGN KEY(fk_staff_id) REFERENCES staff(staff_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE partner_role
ADD FOREIGN KEY(fk_role_id) REFERENCES role(role_id),
ADD FOREIGN KEY(fk_partner_id) REFERENCES partner(partner_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE event_staff
ADD FOREIGN KEY(fk_staff_role_id) REFERENCES staff_role(staff_role_id),
ADD FOREIGN KEY(fk_event_id) REFERENCES event(event_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE event_partner
ADD FOREIGN KEY(fk_partner_role_id) REFERENCES partner_role(partner_role_id),
ADD FOREIGN KEY(fk_event_id) REFERENCES event(event_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE room
ADD FOREIGN KEY(fk_floor_id) REFERENCES floor(floor_id),
ADD FOREIGN KEY(fk_event_id) REFERENCES event(event_id);

ALTER TABLE art_piece
ADD FOREIGN KEY(fk_room_id) REFERENCES room(room_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE art_piece_artist
ADD FOREIGN KEY(fk_art_piece_id) REFERENCES art_piece(art_piece_id),
ADD FOREIGN KEY(fk_artist_id) REFERENCES artist(artist_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

/* Inserting Data */
/* Starting from top to down, first parent tables then child tables */

INSERT INTO role
(name, is_staff,is_partner)
VALUES
('Security', True, False),
('Tour Guide', True, False),
('Custodian', True, False),
('Mover', False, True), /* Person that moves art pieces owned by partner */
('Event Manager', True, True),
('Exhibit Designer', False, True),
('Art Provider', False, True);

INSERT INTO staff
(first_name, last_name)
VALUES
('Bill', 'Hader'),
('Dillon', 'Pickles'),
('Chris', 'Kattan'),
('Molly', 'Shannon'),
('Chris', 'Parnell'),
('Theresa', 'Lizzo'),
('Bob', 'Peroski'),
('Leona', 'Mitchel'), /* I ran out of names sorry ! */
('Hank', 'Hill'),
('Dragon', 'Dragons');

INSERT INTO partner
(name)
VALUES
('Discover Ireland'),
('Van Gogh Experience'),
('Memphis Art Division'),
('Nick Cage'), /* Nick Cage is known for collecting weird objects */
('Salvador Dali Experience'),
('Andy Warhol Group'),
('The Pablo Picasso Experience'),
('David Brown Moving Company');

INSERT INTO staff_role
(fk_role_id, fk_staff_id, role_start_date, role_end_date)
VALUES
(1, 1, '2006-09-21', '2013-5-02'), /* Bill H. - Security */
(3, 2, '2019-09-12', '2019-09-22'), /* Dillon Pickles - Custodian */
(2, 3, '2020-11-06', '2022-09-22'), /* Kattan - Tour guide */
(2, 4, '2019-04-01', '2022-12-23'), /* Shannon - Tour guide */
(5, 5, '2017-07-13', '2021-08-17'), /* Parnell - Event Manager */
(2, 6, '2020-11-06', '2022-09-22'), /* Lizzo - Tour guide */
(2, 7, '2011-12-06', '2012-03-16'), /* Peroski - Tour guide */
(1, 8, '2016-05-04', '2022-09-22'), /* Mitchell - Security */
(1, 9, '2006-09-21', '2014-7-23'), /* Hill - Security */
(3, 10, '2016-05-04', '2022-09-22'); /* Dragons - Tour guide */

INSERT INTO partner_role
(fk_role_id, fk_partner_id, role_start_date, role_end_date)
VALUES
(5, 1, '2006-09-21', '2009-04-09'), /* Ireland - Event Manager */
(7, 2, '2007-05-03', '2009-04-09'), /* Gogh - Provider */
(6, 3, '2005-01-22', '2015-01-22'), /* Memphis - Designer */
(7, 4, '2003-02-13', '2021-06-06'), /* Nick Cage - Provider */
(5, 5, '2021-01-01', '2022-07-30'), /* Dali - Manager */
(6, 6, '2020-03-02', '2022-04-28'), /* Warhol - Designer */
(5, 7, '2010-04-03', '2022-04-28'), /* Picasso - Manager */
(4, 8, '2021-01-01', '2021-01-01'); /* David - Mover */

/* Now Moving into the event portion, (see ER Diagram for details) */

INSERT INTO event
(name, description, start_date, end_date)
VALUES
('Art of the Irish', 'NA', '2007-05-03', '2009-04-09'),
('The Unknown Works of Vangogh', 'Underrated Works of Van Gogh', '2007-05-03', '2009-04-09'),
('Starry Night Night', 'Van Goghs Starry Night comes to town', '2018-07-23', '2018-07-23'),
('Memphis Art Movement', 'NA', '2005-01-22', '2015-01-22'),
('Nick Cage Private Collection', 'Nick Cage shows off his private art collection to pay for his 4 past divorces', '2003-02-13', '2021-06-06'),
('The Insanity of Dali', 'NA', '2021-01-01', '2022-07-30'),
('Rabbit Hole of Warhol', 'Featuring Many of his greatest works', '2020-03-02', '2022-04-28'),
('Warhol - Soup only', 'Only his art featuring soup', '2020-04-02', '2021-04-28'),
('Picasso Classics', 'NA', '2010-04-03', '2022-04-28'), /* 9 */
('Basement', 'NA', '2010-04-03', '2022-04-28'), /* 10 */
('Ground Floor', 'NA', '2000-01-01', '2022-04-28'); /* 11 */

INSERT INTO event_staff
(fk_staff_role_id, fk_event_id)
VALUES
(1, 1), /* Bill H */
(1, 2), 
(1, 4),
(2, 3), /* Pickles */
(3, 7), /* Kattan */
(3, 8),
(3, 9),
(4, 7), /* Shannon */
(4, 8),
(4, 9),
(5, 3), /* Parnell */
(5, 4),
(5, 5),
(6, 7), /* Lizzo */
(6, 8),
(6, 9),
(7, 6), /* Peroski */
(7, 9),
(8, 6), /* Mitchell */
(8, 7),
(8, 9),
(9, 1), /* Hill */
(9, 4),
(9, 5),
(10, 4); /* Dragon */

INSERT INTO event_partner
(fk_partner_role_id, fk_event_id)
VALUES
(1, 1), /* Ireland */
(2, 2), /* Gogh */
(2, 3),
(3, 4), /* Memphis */
(4, 5), /* Nick Cage */
(5, 6), /* Dali */
(6, 7), /* Warhol */
(6, 8),
(7, 9); /* Picasso */

INSERT INTO floor 
(floor_number)
VALUES
('Basement'),
('Ground'),
('Floor One'),
('Floor Two'),
('Floor Three'),
('Floor Four'),
('Floor Five');

INSERT INTO room
(fk_floor_id, fk_event_id, square_foot_size)
VALUES
/* (1, 10, 1000.0)
(2, 12, 1) */
(3, 1, 500.0), /* Ireland */
(3, 2, 600.0), /* Van Gogh */
(3, 3, 500.0), 
(4, 4, 600.0), /* Memphis */
(5, 5, 600.0), /* Nick Cage */
(5, 6, 700.0), /* Dali */
(6, 7, 700.0), /* Warhol */
(6, 8, 600.0),
(7, 9, 600.0); /* Piccasso */


INSERT INTO art_piece
(name, type, value, date_made, is_on_display, is_event, fk_room_id)
VALUES
('The Ardagh Chalice', 'Sculpure', 50000000.0, '0750-01-01', True, True, 1), /* Irish Display, unknown artist */ /* 1 */
('Letters of a Love Betrayed', 'Painting', 12000.0, '1970-01-01', True, True, 1), /* Artist - WILLIAM CROZIER*/ /* 2 */
('The Rough Field', 'Painting', 15000.0,  '1985-01-01', True, True, 1), /* 3 */
('The Late Evening', 'Painting', 6000.0, '2010-01-01', True, True, 1), /* 4 */
('Sunflowers', 'Painting', 80000.0, '1889-01-01', True, True, 2), /* Van Gogh 1 */ /* 5 */
('Skull of a Skeleton with a Burning Cigarette', 'Painting', 80000.0, '1885-01-01', True, True, 2), /* 6 */
('Chair', 'Painting', 7.0, '1885-01-01', True, True, 2), /* 7 */
('Self-portrait with Bandaged Ear and Pipe', 'Painting', 80000.0, '1889-01-01', True, True, 2), /* 8 */
('Starry Night', 'Painting', 80000.0, '1889-01-01', True, True, 3), /* Van Gogh 2 */ /* 9 */
('Super Lamps', 'Sculpture', 150000.0, '1971-01-01', True, True, 4), /* Memphis Art, Martine Bedine */ /* 10 */
('Miss Blanche', 'Sculpture', 40000.0, '1980-01-01', True, True, 4), /* Shiro Kuramata */ /* 11 */
('Mmmkay', 'Painting', 4.0, '2017-01-01', True, True, 4), /* Jason Bateman */ /* 12 */
('Dinosaur Head', 'Sculpture', 100000.0, '0800-01-01', True, True, 5), /* Nick Cage Exhibit , Unknown Artist */ /* 13 */
('Soft Construction with Boiled Beans', 'Painting', 60000.0, '1950-01-01', True, True, 6), /* Dali Exhibit */ /* 14 */
('The Hallucinogenic Toreador', 'Painting', 500000.0, '1950-01-01', True, True, 6), /* 15 */
('The Disintegration of the Persistence of Memory', 'Painting', 500000.0, '1950-01-01', True, True, 6), /* 16 */
('The Persistence of Memory', 'Painting', 500000.0, '1939-01-01', True, True, 6), /* 17 */
('Coca Cola', 'Painting', 40000.0, '1969-01-01', True, True, 7), /* Andy Warhol exhibit */ /* 18 */
('Self Portrait', 'Painting', 40000.0, '1971-01-01', True, True, 7),  /* 19 */
('Soup', 'Painting', 40000.0, '1971-01-01', True, True, 8),  /* Soup Exhibit */ /* 20 */
('The Weeping Woman', 'Painting', 5000.0, '1937-01-01', True, True, 9);  /* Picasso */ /* 21 */

INSERT INTO artist
(first_name, last_name)
VALUES
('Unknown', 'Artist'), /* 1 */
('William', 'Crozier'), /* 2 */
('Vincent', 'Van Gogh'), /* 3 */
('Martine', 'Bedine'), /* 4 */
('Shiro',  'Kuramata'), /* 5 */
('Jason', 'Bateman'), /* 6 */
('Salvador', 'Dali'), /* 7 */
('Andy', 'Warhol'), /* 8 */
('Pablo', 'Picasso'); /* 9 */

INSERT INTO art_piece_artist
(fk_artist_id, fk_art_piece_id)
VALUES
(1, 1),
(1, 13),
(2, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(4, 10),
(5, 11),
(6, 12), 
(7, 14),
(7, 15),
(7, 16),
(7, 17),
(8, 18),
(8, 19),
(8, 20),
(9, 21);

/* List of Questions */

/* 1. What are all the partners we've had in the past? */

SELECT * FROM partner;

/* 2. Have any roles and partners began work at the same time? */
SELECT staff_role.staff_role_id, partner_role.partner_role_id
FROM staff_role
INNER JOIN partner_role
ON staff_role.role_start_date = partner_role.role_start_date;


/* 3. What Paintings Does Dali have at this museum?*/

SELECT art_piece.name
FROM art_piece
JOIN art_piece_artist
ON art_piece.art_piece_id = art_piece_artist.fk_art_piece_id
JOIN artist
ON art_piece_artist.fk_artist_id = artist.artist_id
WHERE last_name = 'Dali';

/* 4. What is the most expensive painting on hand? */

SELECT art_piece.name, max(art_piece.value)
FROM art_piece;

/* 5. How many people have worked on staff? */

SELECT COUNT(staff.last_name)
FROM staff;

/* 6. How many paintings and sculptures do we have? */

SELECT COUNT(art_piece.art_piece_id), art_piece.type
FROM art_piece
GROUP BY art_piece.type;

/* 7. How many sculptures and paintings are there if there are more than 6 of a type? */

SELECT COUNT(art_piece_id), type
FROM art_piece
GROUP BY type
HAVING COUNT(art_piece_id) > 5;

/* 8. What are the Partners we have? */

SELECT partner_id, name
FROM partner
ORDER BY name;

/* 9. What art pieces do we have over 10000?*/

SELECT name, value
FROM art_piece
WHERE value > 10000
LIMIT 5;

/* 10. What events are in room 3?*/
/* SELECT event.name
FROM event
JOIN room
ON room.fk_event_id = event.event_id
WHERE fk_event_id IN (SELECT room_id
	FROM room
    WHERE room = 3); */