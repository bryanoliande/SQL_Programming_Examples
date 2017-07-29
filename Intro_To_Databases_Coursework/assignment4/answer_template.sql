-- Member information
-- STUDENT ID:     , NAME:       , E-MAIL:
-- STUDENT ID:     , NAME:       , E-MAIL:
-- STUDENT ID:     , NAME:       , E-MAIL:

USE cs122a;

-- Q1: put your query here
/*SELECT firstname, lastname
FROM Person
WHERE lastname LIKE "heia%nua"
*/

-- Q2: Put your query here
/*SELECT p2.pid, p2.lastname, p2.firstname
FROM Event AS e1, Participated AS p1, Person AS p2
WHERE e1.eid = p1.eid AND e1.activity = 'walking' AND p1.pid = p2.pid*/


-- Q3: put your query here
/*SELECT p1.floor, count(*)
FROM Building AS b1, PartOf AS p1, Room AS r1
WHERE b1.name = 'EH' AND b1.bid = p1.bid AND p1.loid = r1.loid AND r1.capacity > 35
GROUP BY p1.floor*/

-- Q4: put your query here
/*SELECT ABS(temp1 - temp2)
FROM(
		SELECT temperature AS temp1
        FROM RawTemperature
        WHERE sid = 1 and tstamp = (SELECT MAX(tstamp) FROM RawTemperature WHERE sid = 1)
        )AS t1,
	 (
		SELECT temperature AS temp2
        FROM RawTemperature
        WHERE sid = 2 AND tstamp = (SELECT MAX(tstamp) FROM RawTemperature WHERE sid = 2)
        )AS t2
        */



-- Q5: put your query here
/*SELECT sid, name
FROM Sensor
WHERE sid NOT IN (
	SELECT DISTINCT(sid)
    FROM DerivedFrom
    )
*/

-- Q6: put your query here



-- Q7: put your query here

