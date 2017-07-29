DROP DATABASE cs122a;
CREATE DATABASE cs122a;
USE cs122a;

CREATE TABLE Building( 
	bid int NOT NULL AUTO_INCREMENT, 
	name varchar(100), 
	street varchar(100), 
	city varchar(50), 
	zipcode char(5), 
	state char(2),
	PRIMARY KEY(bid)
);

CREATE TABLE LocationObject(
        loid int NOT NULL AUTO_INCREMENT, 
        name varchar(100),
        type ENUM('Room', 'Corridor', 'Open Area') NOT NULL,
        boxLowX int unsigned,
        boxLowY  int unsigned,
        boxUpperX  int unsigned,
        boxUpperY  int unsigned,
        PRIMARY KEY(loid)
);


CREATE TABLE Room(
        loid int NOT NULL, 
        roomnumber varchar(50) NOT NULL,
        capacity int unsigned NOT NULL,
        isoffice bool NOT NULL,
        ismeetingroom bool NOT NULL,
        PRIMARY KEY(loid),
        FOREIGN KEY(loid) REFERENCES LocationObject(loid)
);



CREATE TABLE PartOf(
        bid int NOT NULL,
        loid int NOT NULL,
        floor int NOT NULL,
        PRIMARY KEY(bid, loid),
        FOREIGN KEY(bid) REFERENCES Building(bid),
        FOREIGN KEY(loid) REFERENCES LocationObject(loid)
);





CREATE TABLE Person(
        pid int NOT NULL AUTO_INCREMENT,
        firstname varchar(100),
        lastname varchar(100),
        PRIMARY KEY(pid)
);



CREATE TABLE AssignedTo(
        pid int NOT NULL,
        loid int NOT NULL,
        PRIMARY KEY(pid, loid),
        FOREIGN KEY(pid) REFERENCES Person(pid),
        FOREIGN KEY(loid) REFERENCES LocationObject(loid)
);


CREATE TABLE Sensor(
        sid int NOT NULL AUTO_INCREMENT,
        name varchar(100) not null,        
        PRIMARY KEY(sid)
);




CREATE TABLE LocationSensor(
        sid int NOT NULL,
		realtime bool NOT NULL,
        PRIMARY KEY(sid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);


CREATE TABLE ImageSensor(
        sid int NOT NULL,
		resolution ENUM('720×480', '1280×720', '2048×1080') NOT NULL,
        PRIMARY KEY(sid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);


CREATE TABLE TemperatureSensor(
        sid int NOT NULL,
		metricsystem ENUM('Celsius', 'Kelvin') NOT NULL,
        PRIMARY KEY(sid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);

CREATE TABLE GPSSensor(
        sid int NOT NULL,
		power float,
        PRIMARY KEY(sid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);


CREATE TABLE SensorPlatform(
        spid int NOT NULL AUTO_INCREMENT,
        name varchar(100) NOT NULL,        
        PRIMARY KEY(spid)
);


CREATE TABLE hasSensor(
        spid int NOT NULL,
        sid int NOT NULL,
        PRIMARY KEY(spid, sid),
        FOREIGN KEY(spid) REFERENCES SensorPlatform(spid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);


CREATE TABLE MobilePlatform(
        spid int NOT NULL,
        sid int NOT NULL,
        PRIMARY KEY(spid),
        FOREIGN KEY(spid) REFERENCES SensorPlatform(spid),
        FOREIGN KEY(sid) REFERENCES LocationSensor(sid)
);


CREATE TABLE FixedPlatform(
        spid int NOT NULL,
        loid int NOT NULL,
        PRIMARY KEY(spid),
        FOREIGN KEY(spid) REFERENCES SensorPlatform(spid),
        FOREIGN KEY(loid) REFERENCES LocationObject(loid)
);



CREATE TABLE OwnerOf(
        spid int NOT NULL,
        pid int NOT NULL,
        PRIMARY KEY(spid),
        FOREIGN KEY(spid) REFERENCES SensorPlatform(spid),
        FOREIGN KEY(pid) REFERENCES Person(pid)
);


CREATE TABLE Observation(
        oid int NOT NULL,
        sid int NOT NULL,
        PRIMARY KEY(oid, sid),
        FOREIGN KEY(sid) REFERENCES Sensor(sid)
);


CREATE TABLE RawImage(
        oid int NOT NULL,
        sid int NOT NULL,
        image blob NOT NULL,
        tstamp datetime NOT NULL,
        PRIMARY KEY(oid, sid),
        FOREIGN KEY(oid, sid) REFERENCES Observation(oid, sid),
        FOREIGN KEY(sid) REFERENCES ImageSensor(sid)
);


CREATE TABLE RawTemperature(
        oid int NOT NULL,
        sid int NOT NULL,
		temperature float,
        tstamp datetime NOT NULL,
        PRIMARY KEY(oid, sid),
        FOREIGN KEY(oid, sid) REFERENCES Observation(oid, sid),
        FOREIGN KEY(sid) REFERENCES TemperatureSensor(sid)
);




CREATE TABLE RawGPS(
        oid int NOT NULL,
        sid int NOT NULL,
		latitude float,
		longitude float,
        tstamp datetime NOT NULL,
        PRIMARY KEY(oid, sid),
        FOREIGN KEY(oid, sid) REFERENCES Observation(oid, sid),
        FOREIGN KEY(sid) REFERENCES GPSSensor(sid)
);



CREATE TABLE Event(
        eid int NOT NULL AUTO_INCREMENT,
		activity ENUM('running', 'walking', 'entering', 'bending', 'standing') NOT NULL, 
		confidence int unsigned,
		PRIMARY KEY(eid)
);

CREATE TABLE DerivedFrom(
        eid int NOT NULL,
        oid int NOT NULL,
        sid int NOT NULL,
        PRIMARY KEY(eid, oid, sid),
        FOREIGN KEY(eid) REFERENCES Event(eid),
        FOREIGN KEY(oid, sid) REFERENCES Observation(oid, sid)
);


CREATE TABLE Participated(
        eid int NOT NULL,
        pid int NOT NULL,
        PRIMARY KEY(eid, pid),
        FOREIGN KEY(eid) REFERENCES Event(eid),
        FOREIGN KEY(pid) REFERENCES Person(pid)
);


CREATE TABLE TookPlace(
        eid int NOT NULL,
        loid int NOT NULL,
        PRIMARY KEY(eid, loid),
        FOREIGN KEY(eid) REFERENCES Event(eid),
        FOREIGN KEY(loid) REFERENCES LocationObject(loid)
);


-- Now, let's insert some rows

-- Person
INSERT INTO Person(firstname,lastname) VALUES ('Jane','heiasomethinglongnua');
INSERT INTO Person(firstname,lastname) VALUES ('John','heasomethingevenmorelongua');
INSERT INTO Person(firstname,lastname) VALUES ('Patrick','Tyler');
INSERT INTO Person(firstname,lastname) VALUES ('Knight','Kenneth');
INSERT INTO Person(firstname,lastname) VALUES ('Richard','Delvalle');

-- Event
INSERT INTO Event(activity,confidence) VALUES ('walking', 1);
INSERT INTO Event(activity,confidence) VALUES ('running', 2);
INSERT INTO Event(activity,confidence) VALUES ('entering', 3);

-- Participated
INSERT INTO Participated(eid,pid) VALUES (1, 1);
INSERT INTO Participated(eid,pid) VALUES (2, 3);
INSERT INTO Participated(eid,pid) VALUES (3, 1);
INSERT INTO Participated(eid,pid) VALUES (3, 2);
INSERT INTO Participated(eid,pid) VALUES (3, 3);
INSERT INTO Participated(eid,pid) VALUES (3, 4);
INSERT INTO Participated(eid,pid) VALUES (3, 5);

-- Building
INSERT INTO Building(name, street, city, zipcode, state) VALUES ('DBH','University of Irvine','Irvine','92697','CA');
INSERT INTO Building(name, street, city, zipcode, state) VALUES ('ICS','University of Irvine','Irvine','92697','CA');
INSERT INTO Building(name, street, city, zipcode, state) VALUES ('EH','University of Irvine','Irvine','92697','CA');


-- LocationObject
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R1100','Room',0,20,1,21);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R1200','Room',1,21,2,22);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R1300','Room',2,22,3,23);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('1stfloor_corridor','Corridor',2,100,3,100);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('1stfloor_lounge','Open Area',2,101,3,101);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R2110','Room',1,1,2,2);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R2120','Room',2,2,3,3);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R2130','Room',3,3,4,4);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('2ndfloor_corridor','Corridor',3,100,4,100);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('2ndfloor_lounge','Open Area',3,101,4,101);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R3210','Room',4,4,5,5);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R3220','Room',5,5,6,6);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R3223','Room',6,6,7,7);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R3230','Room',7,7,8,8);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('3rdfloor_corridor','Corridor',4,100,5,100);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('3rdfloor_lounge','Open Area',4,101,5,101);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R4410','Room',8,8,9,9);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R4420','Room',10,10,11,11);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R4430','Room',11,11,12,12);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('4thfloor_corridor','Corridor',5,100,6,100);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('4thfloor_lounge','Open Area',5,101,6,101);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R5410','Room',13,13,14,14);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R5420','Room',14,14,15,15);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('R5430','Room',15,15,16,16);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('5thfloor_corridor','Corridor',6,100,7,100);
INSERT INTO LocationObject(name, type, boxLowX, boxLowY, boxUpperX, boxUpperY) VALUES ('5thfloor_lounge','Open Area',6,101,7,101);

-- TookPlace
INSERT INTO TookPlace(eid, loid) VALUES(1,1);
INSERT INTO TookPlace(eid, loid) VALUES(2,1);
INSERT INTO TookPlace(eid, loid) VALUES(3,1);

-- Room
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (1,1100,30,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (2,1200,100,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (3,1300,50,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (6,2110,60,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (7,2120,20,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (8,2130,50,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (11,3210,45,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (12,3220,50,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (13,3223,5,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (14,3230,2,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (17,4410,15,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (18,4420,56,false,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (19,4430,120,true,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (22,5410,39,true,true);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (23,5420,60,false,false);
INSERT INTO Room(loid, roomnumber, capacity, isoffice, ismeetingroom) VALUES (24,5430,90,false,true);


-- AssignedTo
INSERT INTO AssignedTo(pid, loid) VALUES (1, 1);
INSERT INTO AssignedTo(pid, loid) VALUES (2, 2);
INSERT INTO AssignedTo(pid, loid) VALUES (3, 3);
INSERT INTO AssignedTo(pid, loid) VALUES (4, 6);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 7);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 8);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 11);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 12);
INSERT INTO AssignedTo(pid, loid) VALUES (2, 13);
INSERT INTO AssignedTo(pid, loid) VALUES (3, 14);
INSERT INTO AssignedTo(pid, loid) VALUES (4, 17);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 18);
INSERT INTO AssignedTo(pid, loid) VALUES (2, 19);
INSERT INTO AssignedTo(pid, loid) VALUES (2, 22);
INSERT INTO AssignedTo(pid, loid) VALUES (3, 23);
INSERT INTO AssignedTo(pid, loid) VALUES (1, 24);


-- PartOf
INSERT INTO PartOf(bid, loid, floor) VALUES (3,1,1);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,2,1);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,3,1);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,4,1);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,5,1);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,6,2);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,7,2);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,8,2);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,9,2);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,10,2);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,11,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,12,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,13,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,14,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,15,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,16,3);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,17,4);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,18,4);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,19,4);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,20,4);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,21,4);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,22,5);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,23,5);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,24,5);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,25,5);
INSERT INTO PartOf(bid, loid, floor) VALUES (3,26,5);

-- Sensor
INSERT INTO Sensor(name) VALUES ('Temp1');
INSERT INTO Sensor(name) VALUES ('Temp2');
INSERT INTO Sensor(name) VALUES ('GPS1');
INSERT INTO Sensor(name) VALUES ('Image1');
INSERT INTO Sensor(name) VALUES ('Temp3');

-- Sensor Platform
INSERT INTO SensorPlatform(name) VALUES ('EHSensorPlatform');

-- hasSensor
INSERT INTO hasSensor(spid, sid) VALUES (1,1);
INSERT INTO hasSensor(spid, sid) VALUES (1,2);
INSERT INTO hasSensor(spid, sid) VALUES (1,3);
INSERT INTO hasSensor(spid, sid) VALUES (1,4);
INSERT INTO hasSensor(spid, sid) VALUES (1,5);

-- Fixed Platform
INSERT INTO FixedPlatform(spid, loid) VALUES (1,1);

-- TemperatureSensor
INSERT INTO TemperatureSensor(sid, metricsystem) VALUES (1,'Kelvin');
INSERT INTO TemperatureSensor(sid, metricsystem) VALUES (2,'Kelvin');
INSERT INTO TemperatureSensor(sid, metricsystem) VALUES (5,'Celsius');

-- GPSSensor
INSERT INTO GPSSensor(sid, power) VALUES (3, 10.0);

-- ImageSensor
INSERT INTO ImageSensor(sid, resolution) VALUES (4,'2048×1080');

-- Observation
INSERT INTO Observation(oid, sid) VALUES (1, 1);
INSERT INTO Observation(oid, sid) VALUES (2, 1);
INSERT INTO Observation(oid, sid) VALUES (3, 1);
INSERT INTO Observation(oid, sid) VALUES (4, 1);
INSERT INTO Observation(oid, sid) VALUES (5, 1);
INSERT INTO Observation(oid, sid) VALUES (6, 1);
INSERT INTO Observation(oid, sid) VALUES (7, 1);
INSERT INTO Observation(oid, sid) VALUES (8, 1);
INSERT INTO Observation(oid, sid) VALUES (9, 1);
INSERT INTO Observation(oid, sid) VALUES (10, 1);
INSERT INTO Observation(oid, sid) VALUES (11, 1);
INSERT INTO Observation(oid, sid) VALUES (12, 1);
INSERT INTO Observation(oid, sid) VALUES (13, 1);
INSERT INTO Observation(oid, sid) VALUES (14, 1);
INSERT INTO Observation(oid, sid) VALUES (15, 1);
INSERT INTO Observation(oid, sid) VALUES (16, 1);
INSERT INTO Observation(oid, sid) VALUES (17, 1);
INSERT INTO Observation(oid, sid) VALUES (18, 1);
INSERT INTO Observation(oid, sid) VALUES (19, 1);
INSERT INTO Observation(oid, sid) VALUES (20, 1);
INSERT INTO Observation(oid, sid) VALUES (21, 1);
INSERT INTO Observation(oid, sid) VALUES (22, 1);
INSERT INTO Observation(oid, sid) VALUES (23, 1);
INSERT INTO Observation(oid, sid) VALUES (24, 1);
INSERT INTO Observation(oid, sid) VALUES (25, 1);
INSERT INTO Observation(oid, sid) VALUES (26, 1);
INSERT INTO Observation(oid, sid) VALUES (27, 1);
INSERT INTO Observation(oid, sid) VALUES (28, 1);
INSERT INTO Observation(oid, sid) VALUES (29, 1);
INSERT INTO Observation(oid, sid) VALUES (30, 1);
INSERT INTO Observation(oid, sid) VALUES (31, 1);
INSERT INTO Observation(oid, sid) VALUES (32, 1);
INSERT INTO Observation(oid, sid) VALUES (33, 1);
INSERT INTO Observation(oid, sid) VALUES (34, 1);
INSERT INTO Observation(oid, sid) VALUES (35, 1);
INSERT INTO Observation(oid, sid) VALUES (36, 1);
INSERT INTO Observation(oid, sid) VALUES (37, 1);
INSERT INTO Observation(oid, sid) VALUES (38, 2);
INSERT INTO Observation(oid, sid) VALUES (39, 1);
INSERT INTO Observation(oid, sid) VALUES (40, 2);
INSERT INTO Observation(oid, sid) VALUES (41, 1);
INSERT INTO Observation(oid, sid) VALUES (42, 1);
INSERT INTO Observation(oid, sid) VALUES (43, 2);
INSERT INTO Observation(oid, sid) VALUES (44, 1);
INSERT INTO Observation(oid, sid) VALUES (45, 1);
INSERT INTO Observation(oid, sid) VALUES (46, 2);
INSERT INTO Observation(oid, sid) VALUES (47, 1);
INSERT INTO Observation(oid, sid) VALUES (48, 1);
INSERT INTO Observation(oid, sid) VALUES (49, 5);
INSERT INTO Observation(oid, sid) VALUES (50, 3);

-- RawTemparature
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (1, 1, 313.1, '2015-01-01 01:01:01');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (2, 1, 312.2, '2015-01-01 02:02:02');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (3, 1, 305.3, '2015-01-01 03:03:03');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (4, 1, 306.4, '2015-01-01 03:13:13');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (5, 1, 307.5, '2015-01-01 04:04:11');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (6, 1, 308.6, '2015-01-01 05:05:05');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (7, 1, 309.7, '2015-01-01 06:06:06');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (8, 1, 310.8, '2015-01-01 07:07:07');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (9, 1, 311.9, '2015-01-01 08:08:08');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (10, 1, 312.10, '2015-01-01 09:09:09');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (11, 1, 311.11, '2015-01-01 10:10:10');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (12, 1, 312.12, '2015-01-01 11:11:11');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (13, 1, 313.13, '2015-01-01 11:12:13');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (14, 1, 314.14, '2015-01-01 12:12:12');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (15, 1, 315.15, '2015-01-01 13:13:13');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (16, 1, 316.16, '2015-01-01 14:14:14');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (17, 1, 317.17, '2015-01-01 14:15:15');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (18, 1, 318.18, '2015-01-01 15:15:15');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (19, 1, 319.19, '2015-01-01 15:15:18');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (20, 1, 320.20, '2015-01-01 15:15:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (21, 1, 321.21, '2015-01-01 16:16:16');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (22, 1, 322.22, '2015-01-01 16:26:26');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (23, 1, 323.23, '2015-01-01 17:17:17');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (24, 1, 324.24, '2015-01-01 17:57:57');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (25, 1, 325.25, '2015-01-01 17:59:59');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (26, 1, 326.26, '2015-01-01 18:18:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (27, 1, 327.27, '2015-01-01 18:28:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (28, 1, 328.28, '2015-01-01 18:38:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (29, 1, 329.29, '2015-01-01 18:48:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (30, 1, 330.30, '2015-01-01 18:58:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (31, 1, 331.31, '2015-01-01 19:19:19');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (32, 1, 332.32, '2015-01-01 20:20:20');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (33, 1, 333.33, '2015-01-01 21:21:21');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (34, 1, 334.34, '2015-01-01 22:22:22');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (35, 1, 335.35, '2015-01-01 23:23:23');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (36, 1, 336.36, '2015-01-01 23:33:33');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (37, 1, 337.37, '2015-01-01 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (38, 2, 338.38, '2015-01-01 23:59:59');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (39, 1, 339.39, '2015-02-02 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (40, 2, 340.40, '2015-03-03 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (41, 1, 341.41, '2015-04-05 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (42, 1, 342.42, '2015-05-05 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (43, 2, 343.43, '2015-06-06 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (44, 1, 344.45, '2015-07-07 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (45, 1, 345.45, '2015-08-08 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (46, 2, 346.46, '2015-09-10 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (47, 1, 347.47, '2015-10-10 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (48, 1, 348.46, '2015-11-11 23:55:55');
INSERT INTO RawTemperature(oid, sid, temperature, tstamp) VALUES (49, 5, 348.48, '2015-12-15 23:55:55');

-- RawGPS
INSERT INTO RawGPS(oid, sid, latitude, longitude, tstamp) VALUES (50,3,10.0,20.0,'2015-12-24 11:11:11');

-- DerivedFrom
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (1, 1, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (1, 2, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (1, 3, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (2, 40, 2);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (2, 41, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (2, 42, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (2, 43, 2);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (2, 44, 1);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (3, 49, 5);
INSERT INTO DerivedFrom(eid, oid, sid) VALUES (3, 50, 3);

 