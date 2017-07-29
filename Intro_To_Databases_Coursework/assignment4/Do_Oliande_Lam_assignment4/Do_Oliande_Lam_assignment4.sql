-- Member information
-- STUDENT ID:43671918, NAME:Thanh Do, E-MAIL:thanhhd@uci.edu
-- STUDENT ID:58939588, NAME:Christopher Lam, E-MAIL:lamcy1@uci.edu
-- STUDENT ID:13729240, NAME:Bryan Oliande, E-MAIL:boliande@uci.edu

USE cs122a;

-- Q1: put your query here
SELECT Person.firstname, Person.lastname
FROM Person, OwnerOf
WHERE OwnerOf.pid = Person.pid AND Person.lastname LIKE 'heia%nua';

-- Q2: put your query here
SELECT distinct Person.pid, Person.lastname, Person.firstname
FROM Person, Participated, Event
WHERE Person.pid = Participated.pid AND Participated.eid = Event.eid AND Event.activity = 'walking';

-- Q3: put your query here
SELECT distinct PartOf.floor, count(room.loid)
FROM Building, PartOf, Room
WHERE Building.bid = PartOf.bid AND PartOf.loid = Room.loid AND Building.name = 'EH' AND Room.capacity > 35
group by floor;

-- Q4: put your query here
SET @s1 := (select RawTemperature.temperature
FROM TemperatureSensor, RawTemperature
WHERE TemperatureSensor.sid = 1 AND TemperatureSensor.sid = RawTemperature.sid
ORDER BY tstamp DESC
LIMIT 1);

SET @s2 := (select RawTemperature.temperature
FROM TemperatureSensor, RawTemperature
WHERE TemperatureSensor.sid = 2  AND TemperatureSensor.sid = RawTemperature.sid
ORDER BY tstamp DESC
LIMIT 1);

SELECT(abs(@s1-@s2));

-- Q5: put your query here
SELECT distinct Sensor.sid, Sensor.name
FROM Sensor
WHERE Sensor.sid NOT IN(
	SELECT distinct Sensor.sid
    FROM Sensor, DerivedFrom
    WHERE DerivedFrom.sid = Sensor.sid);
 
-- Q6: put your query here
SELECT sid, month(tstamp), count(tstamp)
FROM
(
	(SELECT rawTemperature.sid, rawTemperature.tstamp, month(rawTemperature.tstamp) FROM rawTemperature)
	UNION
	(SELECT rawGPS.sid, rawGPS.tstamp, month(rawGPS.tstamp) FROM rawGPS)
	UNION
	(SELECT rawImage.sid, rawImage.tstamp, month(rawImage.tstamp) FROM rawImage)
) as t
GROUP BY sid, month(tstamp);

-- Q7: put your query here
SELECT RawTemperature.sid, avg(RawTemperature.temperature), MIN(RawTemperature.tstamp), MAX(RawTemperature.tstamp)
FROM RawTemperature JOIN
(
SELECT avg(RawTemperature.temperature)
FROM RawTemperature
GROUP BY hour(RawTemperature.tstamp)
)avgTable
WHERE RawTemperature.sid = 1
GROUP BY hour(RawTemperature.tstamp);












