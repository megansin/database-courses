DROP TABLE EquipmentTechnicianServices CASCADE CONSTRAINTS;
DROP TABLE RoomStay CASCADE CONSTRAINTS;
DROP TABLE Examinations CASCADE CONSTRAINTS;
DROP TABLE Admission CASCADE CONSTRAINTS;
DROP TABLE Patient CASCADE CONSTRAINTS;
DROP TABLE Doctor CASCADE CONSTRAINTS;
DROP TABLE EquipmentTechnician CASCADE CONSTRAINTS;
DROP TABLE HasAccess CASCADE CONSTRAINTS;
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE RoomService CASCADE CONSTRAINTS;
DROP TABLE EquipmentType CASCADE CONSTRAINTS;
DROP TABLE Equipment CASCADE CONSTRAINTS;
DROP TABLE Room CASCADE CONSTRAINTS;


/*
 * Table definitions 
 */

CREATE TABLE Room (   
  roomNum number NOT NULL,   
  occupied varchar2(1) CHECK(occupied = 'Y' OR occupied='N'),
  CONSTRAINT pk_room PRIMARY KEY (roomNum) 
);

CREATE TABLE EquipmentType (   
  ID number,   
  model varchar2(50) NOT NULL,   
  description varchar2(50),   
  instructions varchar2(100), 
  CONSTRAINT pk_type PRIMARY KEY (ID) 
);

CREATE TABLE Equipment (   
  serialNumber char(7),   
  typeID number NOT NULL,   
  roomNum number CHECK(roomNum >= 0),   
  lastInspection  date, 
  year number NOT NULL, 
  CONSTRAINT pk_equp PRIMARY KEY (serialNumber), 
  CONSTRAINT fk_equip_type FOREIGN KEY (typeID)  
      REFERENCES EquipmentType (id), 
  CONSTRAINT fk_equip_room FOREIGN KEY (roomNum)  
      REFERENCES Room (roomNum)   
);

CREATE TABLE RoomService (   
  roomNum number,   
  service varchar2(40),   
  CONSTRAINT pk_roomService PRIMARY KEY (roomNum,service), 
  CONSTRAINT fk_room_provide FOREIGN KEY (roomNum)  
      REFERENCES Room (roomNum) 
);

CREATE TABLE Employee (   
  ID number,   
  managerID number,   
  jobTitle varchar2(50) NOT NULL,   
  fName varchar2(50) NOT NULL,   
  lName varchar2(50) NOT NULL,  
  salary number CHECK(salary >= 0), 
  officeNum number,
  addressStreet varchar2(50),  
  addressTown varchar2(50),  
  addressZip varchar2(50),  
  type varchar(50) 
    CHECK(type='Regular' OR type='Division Manager' OR type='General Manager'),
  CONSTRAINT pk_emp PRIMARY KEY (id), 
  CONSTRAINT fk_manager FOREIGN KEY (managerid)  
      REFERENCES Employee (ID) 
);

CREATE TABLE HasAccess (   
  roomNum number NOT NULL,   
  employeeID number NOT NULL,   
  CONSTRAINT uq_access UNIQUE (roomNum,employeeid), 
  CONSTRAINT fk_room_access FOREIGN KEY (roomNum)  
      REFERENCES Room (roomNum), 
  CONSTRAINT fk_employee_access FOREIGN KEY (employeeID)  
      REFERENCES Employee (ID) 
);

CREATE TABLE Doctor (   
  docID number NOT NULL,   
  speciality varchar2(50) NOT NULL,   
  gender varchar2(1) CHECK(gender = 'M' OR gender = 'F'),   
  graduatedFrom varchar2(50) NOT NULL,   
  CONSTRAINT fk_doc FOREIGN KEY (docid) REFERENCES Employee(ID),
  CONSTRAINT pk_doc PRIMARY KEY (docid)
);

CREATE TABLE EquipmentTechnician (   
  etID number NOT NULL,   
  CONSTRAINT fk_et FOREIGN KEY (etID) REFERENCES Employee(ID),
  CONSTRAINT pk_et PRIMARY KEY (etID)
);

CREATE TABLE EquipmentTechnicianServices (
  technicianID number NOT NULL,   
  typeID number NOT NULL,   
  CONSTRAINT fk_technician FOREIGN KEY (technicianID) REFERENCES EquipmentTechnician(etID),
  CONSTRAINT fk_type FOREIGN KEY (typeID) REFERENCES EquipmentType(ID),
  CONSTRAINT pk_ets PRIMARY KEY (technicianID, typeID)
);

CREATE TABLE Patient (   
  SSN char(11),   
  address varchar2(50),  /* It is possible to be homeless and phoneless*/ 
  telNum number,   
  fName varchar2(50)  NOT NULL,   
  lName varchar2(50)  NOT NULL,  
  CONSTRAINT pk_pat PRIMARY KEY (SSN) 
);

CREATE TABLE Admission (   
  admID number,   
  SSN char(11) NOT NULL,   
  admDate date NOT NULL,   
  leaveDate date,    
  insurance number CHECK(insurance >= 0),   
  payment number CHECK(payment >= 0), 
  futureVisit date  NOT NULL,
  CONSTRAINT pk_adm PRIMARY KEY (admID), 
  CONSTRAINT fk_adm_pat FOREIGN KEY (SSN)  
      REFERENCES Patient (SSN) 
);

CREATE TABLE Examinations (   
  doctorID number NOT NULL,
  admID number NOT NULL, 
  comments varchar(50), 
 /* No primary key because it should be possible for the same doctor to examine the same
    patient in the same admission twice, getting the same result both times */
  CONSTRAINT fk_adm_exam FOREIGN KEY (admID)  
      REFERENCES Admission (admID), 
  CONSTRAINT fk_doc_exam FOREIGN KEY (doctorid)  
      REFERENCES Doctor (docid) 
);

CREATE TABLE RoomStay (   
  admid     number    NOT NULL,   
  roomNum     number    NOT NULL, 
  startdate   date    NOT NULL,   
  enddate   date, 
  CONSTRAINT pk_roomstay PRIMARY KEY (admID,roomNum,startDate), 
  CONSTRAINT fk_room_adm FOREIGN KEY (admID)  
      REFERENCES Admission (admID), 
  CONSTRAINT fk_room_num FOREIGN KEY (roomNum)  
      REFERENCES Room (roomNum) 
);

/** Insert Statements **/
/* 10 Rooms */
INSERT INTO Room VALUES(100,'N');
INSERT INTO Room VALUES(101,'N');
INSERT INTO Room VALUES(121,'N');
INSERT INTO Room VALUES(131,'N');
INSERT INTO Room VALUES(200,'N');
INSERT INTO Room VALUES(205,'N');
INSERT INTO Room VALUES(300,'N');
INSERT INTO Room VALUES(310,'Y');
INSERT INTO Room VALUES(311,'N');
INSERT INTO Room VALUES(423,'Y');
/* Room Services */
INSERT INTO RoomService VALUES(100,'Intensive care unit (ICU)');
INSERT INTO RoomService VALUES(100,'Ward Room');
INSERT INTO RoomService VALUES(101,'Intensive care unit (ICU)');
INSERT INTO RoomService VALUES(101,'Operating Room');
INSERT INTO RoomService VALUES(121,'Intensive care unit (ICU)');
INSERT INTO RoomService VALUES(131,'Emergency Room');
INSERT INTO RoomService VALUES(200,'Ward Room');
INSERT INTO RoomService VALUES(300,'Operating Room');
INSERT INTO RoomService VALUES(311,'Operating Room');
INSERT INTO RoomService VALUES(200,'Operating Room');
/* 10 Patients */
INSERT INTO Patient VALUES('111-22-3333','100 Institute road',5086155381,'Andrew','Nolan');
INSERT INTO Patient VALUES('111-22-3334','101 Institute road',5086155382,'Chris','Myers');
INSERT INTO Patient VALUES('111-22-3335','102 Institute road',5086155383,'Wilson','Wong');
INSERT INTO Patient VALUES('111-22-3336','103 Institute road',5086155384,'Santa','Claus');
INSERT INTO Patient VALUES('111-22-3337','104 Institute road',5086155385,'Mr','Grinch');
INSERT INTO Patient VALUES('111-22-3338','105 Institute road',5086155386,'Bob','Ross');
INSERT INTO Patient VALUES('111-22-3339','106 Institute road',5086155387,'Barack','Obama');
INSERT INTO Patient VALUES('911-22-3333','107 Institute road',5086155388,'Susan','Boyle');
INSERT INTO Patient VALUES('811-22-3338','108 Institute road',5086155389,'Tamara','Bell');
INSERT INTO Patient VALUES('823-22-3338','500 Institute road',5086155322,'James','Smith');
/* 15 Regular Employees, 4 division managers, 2 general managers */
INSERT INTO Employee VALUES(16,null,'Gen Manager','Susie','Bob','10',1,'100 Institute road','Worcester','01609','General Manager');
INSERT INTO Employee VALUES(17,null,'Gen Manager','Lauren','Bob','10',1,'101 Institute road','Worcester','01609','General Manager');
INSERT INTO Employee VALUES(18,16,'Div Manager','Claire','Bob','10',1,'102 Institute road','Worcester','01609','Division Manager');
INSERT INTO Employee VALUES(19,16,'Div Manager','James','Bob','10',1,'103 Institute road','Worcester','01609','Division Manager');
INSERT INTO Employee VALUES(20,17,'Div Manager','Willow','Bob','10',1,'104 Institute road','Worcester','01609','Division Manager');
INSERT INTO Employee VALUES(21,17,'Div Manager','Craig','Bob','10',1,'105 Institute road','Worcester','01609','Division Manager');
INSERT INTO Employee VALUES(1,18,'Doctor','Bobby','Bob','10',1,'106 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(2,18,'Doctor','Chris','Bob','10',1,'107 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(3,19,'Doctor','Jack','Bob','10',1,'108 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(4,19,'Doctor','Will','Bob','10',1,'109 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(5,19,'Doctor','Mike','Bob','10',1,'110 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(6,19,'Technician','Sarah','Bob','10',1,'111 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(7,19,'Technician','Beth','Bob','10',1,'112 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(8,19,'Technician','Anne','Bob','10',1,'113 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(9,20,'Technician','Ahna','Bob','10',1,'114 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(10,20,'Technician','Steve','Bob','10',1,'115 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(11,20,'Janitor','Sue','Bob','10',1,'116 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(12,21,'Janitor','Terry','Bob','10',1,'117 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(13,21,'Security','Jerry','Bob','10',1,'118 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(14,21,'Chef','Maddi','Bob','10',1,'119 Institute road','Worcester','01609','Regular');
INSERT INTO Employee VALUES(15,21,'Security','Abigail','Bob','10',1,'120 Institute road','Worcester','01609','Regular');
/* 5 Doctors */
INSERT INTO Doctor VALUES(1,'Neuroscience','F','WPI');
INSERT INTO Doctor VALUES(2,'Cardiology','M','Penn');
INSERT INTO Doctor VALUES(3,'Radiology','F','Harvard');
INSERT INTO Doctor VALUES(4,'Anesthesiology','M','Brown');
INSERT INTO Doctor VALUES(5,'Pulmonology','F','John Hopkins');
/* 5 Equipment Technicians */
INSERT INTO EquipmentTechnician VALUES(6);
INSERT INTO EquipmentTechnician VALUES(7);
INSERT INTO EquipmentTechnician VALUES(8);
INSERT INTO EquipmentTechnician VALUES(9);
INSERT INTO EquipmentTechnician VALUES(10);
/* 3 Equipment Types */
INSERT INTO EquipmentType VALUES(1,'MRI','Scanning','Turn On');
INSERT INTO EquipmentType VALUES(2,'CT Scanner','Scanning','Turn On');
INSERT INTO EquipmentType VALUES(3,'Ultrasound','Scanning','Turn On');
/* Equipment Technician Services */
INSERT INTO EquipmentTechnicianServices VALUES(6, 1);
INSERT INTO EquipmentTechnicianServices VALUES(7, 1);
INSERT INTO EquipmentTechnicianServices VALUES(8, 2);
INSERT INTO EquipmentTechnicianServices VALUES(9, 2);
INSERT INTO EquipmentTechnicianServices VALUES(10, 3);
/* 3 Units of each Equipment Type */
INSERT INTO Equipment VALUES('A01-02X',1,100,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A02-02X',1,101,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A03-02X',1,121,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A13-02X',1,121,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A04-02X',2,100,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2012);
INSERT INTO Equipment VALUES('A05-02X',2,101,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2011);
INSERT INTO Equipment VALUES('A06-02X',2,121,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A07-02X',3,100,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2010);
INSERT INTO Equipment VALUES('A08-02X',3,101,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2011);
INSERT INTO Equipment VALUES('A09-02X',3,121,TO_DATE('17/12/2015', 'DD/MM/YYYY'),2011);
/* Admissions */
INSERT INTO Admission VALUES(1,'111-22-3333',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(2,'111-22-3334',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(3,'111-22-3335',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(4,'111-22-3336',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(5,'111-22-3337',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(6,'111-22-3338',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
INSERT INTO Admission VALUES(7,'111-22-3339',CURRENT_DATE,CURRENT_DATE,100,200,CURRENT_DATE);
/* Examinations */
INSERT INTO Examinations VALUES(1,1,'Positive');
INSERT INTO Examinations VALUES(1,1,'Negative');
INSERT INTO Examinations VALUES(1,1,'Inconclusive');
INSERT INTO Examinations VALUES(2,1,'Positive');
/* Has Access*/
INSERT INTO HasAccess VALUES(100,1);
INSERT INTO HasAccess VALUES(101,1);
INSERT INTO HasAccess VALUES(121,1);
INSERT INTO HasAccess VALUES(300,2);
/* RoomStay */
INSERT INTO RoomStay VALUES(1, 101, TO_DATE('18/1/2021', 'DD/MM/YYYY'), TO_DATE('22/1/2021', 'DD/MM/YYYY'));

drop view CriticalCases;
drop view DoctorsLoad;

CREATE VIEW CriticalCases AS 
Select SSN, FName as firstName, LName as lastName, numberOfAdmissionsToICU 
From Patient NATURAL JOIN ( 
Select SSN, Count(*) AS numberOfAdmissionsToICU 
From Admission NATURAL JOIN ( 
Select AdNum 
From StayIn NATURAL JOIN ( 
Select RoomNum 
From RoomService 
Where Service = 'ICU')) 
Group By SSN) 
Where numberOfAdmissionsToICU >= 2;

CREATE VIEW DoctorsLoad AS    
Select ID as DocID, GraduatedFrom, 'Overloaded' AS load
From Doc NATURAL JOIN(
Select DocID AS ID, Count(AdNum) AS LoadNum
From Examine
Group By DocID)
Where Loadnum > 10
Union
(Select ID as DocID, GraduatedFrom, 'Underloaded' AS load
From Doc NATURAL JOIN(
Select DocID AS ID, Count(AdNum) AS LoadNum
From Examine
Group By DocID)
Where Loadnum <= 10);

Select *
From CriticalCases
Where numberOfAdmissionsToICU > 4;

Select DocID, FName as firstName, LName as lastName
From Emp E, Doc D, DoctorsLoad L
Where E.ID = D.ID
AND D.ID = L.DocID
AND D.GraduatedFrom = 'WPI'
AND L.load = 'Overloaded';

Select L.DocID, C.SSN, E.comments
From CriticalCases C, Admission A, Examinations E, DoctorsLoad L
Where C.SSN = A.SSN
AND A.admid = E.admid
AND E.DoctorID = L.DocID
AND L.load = 'Underloaded';