DROP DATABASE cs122a;
CREATE DATABASE cs122a;
USE cs122a;

CREATE TABLE Seller( 
	sid int NOT NULL, 
	sname varchar(100), 
	rating int,
    age float NOT NULL
);

CREATE TABLE dept(
	dno int NOT NULL,
    location varchar(50),
    PRIMARY KEY(dno)
					);
                    
CREATE TABLE emp (
	name char(15),
    dno int NOT NULL,
    FOREIGN KEY(dno) REFERENCES dept(dno) ON DELETE SET NULL ON UPDATE CASCADE
    );
CREATE TABLE LocationObject(

loid int NOT NULL AUTO_INCREMENT,
name varchar(100),
type ENUM('Room', 'Corridor', 'Open Area') NOT NULL,
boxLowX int unsigned,
boxLowY int unsigned,
boxUpperX int unsigned,
boxUpperY int unsigned,
PRIMARY KEY(loid)
);

/* CREATE TRIGGER BoundingBoxCoordinatesConstraint
AFTER INSERT ON LocationObject
REFERENCING
	OLD_TABLE AS OldLocationObject
	NEW_TABLE AS NewLocationObject
WHEN(EXISTS(
	SELECT *
	FROM NewLocationObject
	WHERE boxLowX > 1000 OR boxLowY > 1000 OR boxUpperX > 1000 OR boxUpperY > 1000) 
DELETE FROM LocationObject
WHERE boxLowX > 1000 OR boxLowY > 1000 OR boxUpperX >1000 OR boxUpperY > 1000
CALL RaiseException());
*/

CREATE TRIGGER TemperatureConstraint
AFTER INSERT ON RawTemperature
WHEN(EXISTS(
	SELECT *
	FROM RawTemperature
	WHERE New.temperature < New.lower_threshold OR New.temperature > New.upper_threshold)
BEGIN
	IF New.temperature < lower_threshold THEN SET @threshold = 'upper'
	ELSEIF New.temperature > upper_threshold THEN SET @threshold = 'lower')
	END IF;
BEGIN
	IF threshold = 'upper' THEN INSERT INTO Event VALUES(LAST_INSERT_ID(), 'Too High Temperature', 1);
		INSERT INTO DerivedFrom
		VALUES( **Too high temp**);
	ELSEIF @threshold = 'lower' THEN INSERT INTO Event VALUES(LAST_INSERT_ID(), 'Too Low Temperature', 1);
		INSERT INTO DerivedFrom
		VALUES( ** Too low temp** );
	ENDIF;
CALL RaiseException());

INSERT INTO Seller(sid, sname, rating, age) VALUES (18,'jones',3,30.0);
INSERT INTO Seller(sid, sname, rating, age) VALUES (41,'jonah',6,56.0);
INSERT INTO Seller(sid, sname, rating, age) VALUES (22,'ahab',7,44.0);
INSERT INTO Seller(sid, sname, rating, age) VALUES (63,'moby',null,15.0);


/*a) Write SQL queries to compute the average rating, using AVG; the sum of ratings, using
SUM; and the number of ratings, using COUNT;

SELECT AVG(rating), SUM(rating), COUNT(rating)
FROM Seller
*/

/*b) If you divide the sum computed above by the count, would the result be the same as the
average? Why?

Yes. Average = Sum of all elements / number of elements 
*/

/*c) Let’s define all the tuples as table S, the first two tuples as S1 and the last two tuples as
S2: Show the result of:
I. Left outer join of S1 and S2, with the join condition being sid = sid.
II. Right outer join of S1 and S2, with the join condition being sid = sid.
III. Full outer join of S with itself, with the join condition being sid = sid.
*/

