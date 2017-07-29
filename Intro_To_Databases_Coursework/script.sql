DROP DATABASE cs122a;
CREATE DATABASE cs122a;
USE cs122a;


CREATE TABLE Building(
bid int NOT NULL ,
name varchar(100),
street varchar(100),
city varchar(50),
zipcode char(5),
state char(2),
PRIMARY KEY(bid)
);


CREATE VIEW BuildingsInCali AS
SELECT Building.name
 COUNT (*) as headcnt, AVG(e.sal) as avgsal
FROM Dept d, Emp e
WHERE e.dno = d.dno
GROUP BY d.dno, d.dname, d.mgr;

/*CREATE TABLE emp
(
	eid int NOT NULL,
    ename varchar(50) NOT NULL,
    age int NOT NULL,
    salary real NOT NULL,
    PRIMARY KEY(eid)

);

CREATE TABLE Dept
(
	did int NOT NULL,
    managerid int NOT NULL,
    PRIMARY KEY(DID)

);

CREATE TABLE Works
(
	eid int NOT NULL,
    did int NOT NULL,
    
	FOREIGN KEY(eid) REFERENCES emp,
    FOREIGN KEY(did) REFERENCES Dept
);

CREATE VIEW toyEmp AS
SELECT Emp.eid,Emp.Salary
FROM Emp
*/
