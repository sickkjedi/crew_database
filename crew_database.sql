-- Airplane and maintenance crew database

-- Database Structure
--
-- Name: Aircrafts; Type: TABLE; Schema: public; Owner: -; Tablespace:

CREATE TABLE Aircrafts (
	aircraft_id serial PRIMARY KEY,
	make varchar(10) NOT NULL,
	model varchar(10) NOT NULL,
	designation varchar(7) UNIQUE NOT NULL
);

-- Name: Crew; Type: TABLE; Schema: public; Owner: -; Tablespace:

CREATE TABLE Crew (
	crew_id serial PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	birth_date date,
	hire_date date
);

-- Name: Serviced; Type: TABLE; Schema: public; Owner: -; Tablespace:

CREATE TABLE Serviced (
    aircraft_id smallint REFERENCES aircrafts (aircraft_id) ON UPDATE CASCADE ON DELETE CASCADE,
    crew_id smallint REFERENCES crew (crew_id) ON UPDATE CASCADE,
    hours_worked real,
    CONSTRAINT service_aircraft_pkey PRIMARY KEY (aircraft_id, crew_id)
);

-- Testing data
--
-- Data for Name: Aircrafts; Type: TABLE DATA; Schema: public; Owner: -

INSERT INTO Aircrafts VALUES (DEFAULT, 'Boeing', '747', 'SAH1001');
INSERT INTO Aircrafts VALUES (DEFAULT, 'Boeing', '777', 'SAH1002');
INSERT INTO Aircrafts VALUES (DEFAULT, 'Boeing', '787', 'SAH1003');
INSERT INTO Aircrafts VALUES (DEFAULT, 'Boeing', '787', 'SAH1004');
INSERT INTO Aircrafts VALUES (DEFAULT, 'Airbus', 'A320', 'SAH2001');
INSERT INTO Aircrafts VALUES (DEFAULT, 'Airbus', 'A380', 'SAH2002');

-- Data for Name: Crew; Type: TABLE DATA; Schema: public; Owner: -

INSERT INTO Crew VALUES (DEFAULT, 'Robert', 'Weinmann', '1967-01-15', '1994-03-05');
INSERT INTO Crew VALUES (DEFAULT, 'Anthony', 'Kelly', '1971-06-08', '1994-11-15');
INSERT INTO Crew VALUES (DEFAULT, 'Norma', 'Meyers', '1988-12-02', '2015-11-30');
INSERT INTO Crew VALUES (DEFAULT, 'Maria', 'Nelson', '1951-09-07', '1993-05-03');
INSERT INTO Crew VALUES (DEFAULT, 'Robert', 'Ellis', '1986-05-22', '2014-10-03');
INSERT INTO Crew VALUES (DEFAULT, 'Julian', 'Barrios', '1977-12-25', '2002-07-25');
INSERT INTO Crew VALUES (DEFAULT, 'Jerald', 'Tucker', '1967-03-23', '1999-05-13');
INSERT INTO Crew VALUES (DEFAULT, 'Angel', 'Cassady', '1985-09-01', '2010-08-02');
INSERT INTO Crew VALUES (DEFAULT, 'Jonathan', 'Privett', '1963-08-11', '2005-05-23');
INSERT INTO Crew VALUES (DEFAULT, 'Michael', 'Simpson', '1994-07-09', '2017-02-22');
INSERT INTO Crew VALUES (DEFAULT, 'Dorothy', 'Sherman', '1993-04-11', '2016-11-14');

-- Data for Name: Serviced; Type: TABLE DATA; Schema: public; Owner: -

INSERT INTO Serviced VALUES ('1', '1', 113.53);
INSERT INTO Serviced VALUES ('1', '2', 91.65);
INSERT INTO Serviced VALUES ('3', '3', 46.70);
INSERT INTO Serviced VALUES ('2', '4', 157.21);
INSERT INTO Serviced VALUES ('4', '5', 61.12);
INSERT INTO Serviced VALUES ('5', '6', 132.79);
INSERT INTO Serviced VALUES ('2', '7', 189.90);
INSERT INTO Serviced VALUES ('6', '8', 95.85);
INSERT INTO Serviced VALUES ('5', '9', 81.57);
INSERT INTO Serviced VALUES ('6', '2', 39.20);
INSERT INTO Serviced VALUES ('4', '11', 52.13);
INSERT INTO Serviced VALUES ('1', '4', 62.70);
INSERT INTO Serviced VALUES ('1', '7', 28.00);
INSERT INTO Serviced VALUES ('2', '2', 120.68);
INSERT INTO Serviced VALUES ('3', '5', 48.80);
INSERT INTO Serviced VALUES ('3', '2', 87.57);
INSERT INTO Serviced VALUES ('4', '2', 55.28);
INSERT INTO Serviced VALUES ('3', '8', 23.43);
INSERT INTO Serviced VALUES ('5', '7', 71.82);
INSERT INTO Serviced VALUES ('6', '9', 69.25);
INSERT INTO Serviced VALUES ('6', '6', 105.42);
INSERT INTO Serviced VALUES ('5', '1', 71.79);


-- Queries
--
-- Find name of the oldest crew member

SELECT first_name, last_name FROM Crew
WHERE birth_date = (SELECT MIN(birth_date) FROM Crew)

-- Find name of the n-th oldest crew member (second oldest, fifth oldest and so on)

WITH oldest_crew AS
(
    SELECT first_name, last_name, birth_date,
          ROW_NUMBER() OVER (ORDER BY birth_date ASC) as RN
    FROM Crew
)
SELECT first_name, last_name
FROM oldest_crew
WHERE RN = 2  /* Replace with desired n-th oldest crew member */

-- Find name of the most experienced crew member - that one who knows most aircrafts

WITH get_crew AS (
	SELECT first_name, last_name, COUNT(Crew.crew_id) AS value_occurence
	FROM Crew INNER JOIN Serviced ON Crew.crew_id = Serviced.crew_id
	GROUP BY Crew.crew_id
	ORDER BY value_occurence DESC
)
SELECT first_name, last_name
FROM get_crew
LIMIT 1

-- Find name of the least experienced crew member - that one who knows least aircrafts (counting from zero)

WITH get_crew AS (
	SELECT first_name, last_name, COUNT(Serviced.crew_id) AS value_occurence
	FROM Crew LEFT JOIN Serviced ON Crew.crew_id = Serviced.crew_id
	GROUP BY Crew.crew_id
	ORDER BY value_occurence ASC
)
SELECT first_name, last_name
FROM get_crew
LIMIT 1
