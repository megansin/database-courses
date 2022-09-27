/*from phase 2: start*/

DROP TABLE Emp CASCADE CONSTRAINTS;
DROP TABLE Doc Cascade Constraints;
DROP Table ETech Cascade Constraints;
Drop Table EType Cascade constraints;
Drop Table CanRepair Cascade Constraints;
Drop Table Room Cascade Constraints;
Drop table equipment cascade constraints;
Drop table roomservice cascade constraints;
Drop table roomaccess cascade constraints;
Drop table patient cascade constraints; 
Drop Table Admission cascade constraints;
Drop Table examine cascade constraints;
Drop Table Stayin cascade constraints;

CREATE TABLE Emp(
	ID INTEGER NOT NULL PRIMARY KEY,
	FName CHAR(50) NOT NULL,
	LName CHAR(50) NOT NULL,
	Salary real not null,
	JobTitle CHAR(30) NOT NULL,
	OfficeNum VARCHAR2(4) NOT NULL, 
	EmpRank INTEGER NOT NULL, /* employee is regular (rank = 0), division manager (rank = 1), or general manager (rank = 2) */
	SupervisorID INTEGER, 
    AddressStreet varchar2(50),
    AddressCity VARCHAR2(50),
	CONSTRAINT CHK_EmpRank CHECK (EmpRank = 0 OR EmpRank = 1 OR EmpRank = 2),
    CONSTRAINT FK_SupervisorID Foreign Key (SupervisorID) References Emp (ID)
);

CREATE TABLE Doc(
    ID Integer Not Null Primary Key,
    Gender varchar2(20),
    Specialty varchar2(100) not null,
    GraduatedFrom varchar2(50) not null, /*Doctors have to have graduated from somewhere*/
    Constraint FK_DocID Foreign Key (ID) References Emp (ID)
);

Create Table ETech(
    ID Integer Not Null Primary Key,
    Constraint FK_ETechID Foreign Key (ID) References Emp (ID)
);

Create TABLE EType (
    ID Char(20) Not Null Primary Key,
    Description VarChar2(500),
    Model VarChar2(50) Not Null,
    Instruction VarChar2(500)
);

Create Table CanRepair(
    ID Integer Not Null,
    EID Char(20) Not Null,
    Constraint FK_RepairID Foreign Key (ID) References ETech (ID),
    Constraint FK_EID Foreign Key (EID) References EType (ID),
    Constraint PK_Repair Primary Key (ID, EID)
);

Create Table Room(
    Num Integer Not Null Primary Key,
    Occupied Integer Not Null,
    Constraint CHK_Occupied Check (Occupied = 0 OR Occupied = 1) /* Not occupied = 0, occupied = 1*/
);

CREATE TABLE Equipment(
    Serial varchar2(20) Not Null Primary Key,
    TypeID Char(20) Not Null,
    PurchaseYear Integer Not Null,
    LastInspection Date,
    RoomNum Integer Not Null,
    Constraint FK_RoomNum Foreign Key (RoomNum) References Room(Num),
    Constraint FK_TypeID Foreign Key (TypeID) References EType (ID)
);

CREATE Table RoomService(
    RoomNum Integer Not Null,
    Service varchar2(20) Not Null,
    Constraint PK_RoomService Primary Key (RoomNum, Service),
    Constraint FK_RoomNumService Foreign Key (RoomNum) References Room(Num)
);

Create Table RoomAccess(
    RoomNum Integer Not Null,
    ID Integer Not Null,
    Constraint PK_RoomAccess Primary Key (RoomNum, ID),
    Constraint FK_RoomAccess_RoomNum Foreign Key (RoomNum) References Room(Num),
    Constraint FK_RoomAccess_ID Foreign Key (ID) References Emp(ID)
);

Create Table Patient(
    SSN Integer Not Null Primary Key,
    FName Char(50) Not Null,
    LName Char(50) Not Null,
    Address VarChar2(50) Not Null,
    TelNum Integer Not Null,
    Constraint CHK_TelNum Check (TelNum > 999999999 AND  TelNum < 10000000000) /* ensures integer is 10 digits */
);

Create Table Admission(
    Num Integer Not Null Primary Key,
    AdmissionDate Date Not Null,
    LeaveDate Date,
    TotalPayment Real Not Null,
    InsurancePayment Real,
    SSN Integer Not Null,
    FutureVisit Date,
    Constraint CHK_Admission Check (AdmissionDate <= LeaveDate),
    Constraint CHK_Future Check (LeaveDate < FutureVisit),
    Constraint CHK_Payment Check (InsurancePayment <= TotalPayment),
    Constraint CHK_SSN Check (SSN > 99999999 AND SSN < 1000000000)
);

Create Table Examine(
    DocID Integer Not Null,
    AdNum Integer Not Null, 
    DocComment varchar2(500),
    CONSTRAINT PK_Examine PRIMARY KEY (DocID,AdNum),
	Constraint FK_ExamineDocID FOREIGN KEY (DocID) REFERENCES Doc(ID),
	Constraint FK_ExamineAdNum FOREIGN KEY (AdNum) REFERENCES Admission(Num)
);

Create Table StayIn(
    AdNum Integer not null,
    RoomNum Integer not null,
    StartDate Date not null,
    EndDate Date,
    Constraint PK_StayIn Primary Key (AdNum, RoomNum, StartDate),
    Constraint FK_StayAdNum Foreign Key (AdNum) References Admission (Num),
    Constraint FK_StayRoomNum Foreign Key (RoomNum) References Room (Num)
);

INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000000,'Sally','Jones','10 Institute Rd',5081234567);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000001,'Milly','Moe','7 Park Rd',5083462456);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000002,'Jack','Jones','102 Pond Rd',5083859304);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000003,'Max','Miller','89 Fuller St',5081323567);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000004,'Will','West','2 Pine Rd',5088294787);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000005,'Billy','Bob','53 Rocky Rd',7749683495);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000006,'Jennifer','Ant','423 King St',3489385960);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000007,'Ally','Bean','180 Circle Rd',6172930964);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(100000008,'Zachary','Fin','34 Spring St',6625672447);
INSERT INTO Patient(SSN,FName,LName,Address,TelNum) VALUES(111223333,'Cole','McDonald','5 South St',7749782635);

INSERT INTO Room(Num,Occupied) VALUES('101',0);
INSERT INTO Room(Num,Occupied) VALUES('102',1);
INSERT INTO Room(Num,Occupied) VALUES('103',0);
INSERT INTO Room(Num,Occupied) VALUES('104',1);
INSERT INTO Room(Num,Occupied) VALUES('105',0);
INSERT INTO Room(Num,Occupied) VALUES('106',0);
INSERT INTO Room(Num,Occupied) VALUES('107',0);
INSERT INTO Room(Num,Occupied) VALUES('108',1);
INSERT INTO Room(Num,Occupied) VALUES('109',1);
INSERT INTO Room(Num,Occupied) VALUES('110',1);

INSERT INTO RoomService(RoomNum,Service) VALUES('103','Xray');
INSERT INTO RoomService(RoomNum,Service) VALUES('103','MRI');
INSERT INTO RoomService(RoomNum,Service) VALUES('104','BloodWork');
INSERT INTO RoomService(RoomNum,Service) VALUES('104','ICU');
INSERT INTO RoomService(RoomNum,Service) VALUES('108','Mammogram');
INSERT INTO RoomService(RoomNum,Service) VALUES('108','CATScan');

INSERT INTO EType(ID,Description,Model,Instruction) VALUES('1234','Works Well','A','Basically works by itself');
INSERT INTO EType(ID,Description,Model,Instruction) VALUES('2345','Mostly Works','B','Works when you make it work');
INSERT INTO EType(ID,Description,Model,Instruction) VALUES('3456','Barely Works','C','Just try your best');

INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('HSJ382','1234',2022,TO_DATE('2022/02/01 21:02:03', 'yyyy/mm/dd hh24:mi:ss'),'101');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('A01-02X','1234',2010,TO_DATE('2022/02/03 20:02:44', 'yyyy/mm/dd hh24:mi:ss'),'103');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('JDS978','1234',2011,TO_DATE('2022/02/03 22:12:34', 'yyyy/mm/dd hh24:mi:ss'),'101');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('FHE642','2345',2019,TO_DATE('2022/02/12 21:11:44', 'yyyy/mm/dd hh24:mi:ss'),'105');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('MGU878','2345',2018,TO_DATE('2021/02/11 20:06:56', 'yyyy/mm/dd hh24:mi:ss'),'103');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('JJH883','2345',2011,TO_DATE('2022/02/11 12:18:34', 'yyyy/mm/dd hh24:mi:ss'),'104');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('EEH473','3456',2009,TO_DATE('2022/02/10 13:13:52', 'yyyy/mm/dd hh24:mi:ss'),'109');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('MJH485','3456',2010,TO_DATE('2022/02/08 15:28:32', 'yyyy/mm/dd hh24:mi:ss'),'105');
INSERT INTO Equipment(Serial,TypeID,PurchaseYear,LastInspection,RoomNum) VALUES('GAT175','3456',2017,TO_DATE('2022/02/02 12:43:30', 'yyyy/mm/dd hh24:mi:ss'),'102');

INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(1,TO_DATE('2022/02/10 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/15 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,111223333,TO_DATE('2024/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(2,TO_DATE('2022/02/01 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/06 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,111223333,TO_DATE('2023/05/07 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(3,TO_DATE('2022/02/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/07 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,111223333,TO_DATE('2022/05/07 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(4,TO_DATE('2022/02/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/09 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000001,TO_DATE('2023/05/10 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(5,TO_DATE('2022/02/04 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000002,TO_DATE('2022/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(6,TO_DATE('2022/02/13 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/15 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000002,TO_DATE('2022/06/30 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(7,TO_DATE('2022/02/04 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/15 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000003,TO_DATE('2024/04/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN,FutureVisit) VALUES(8,TO_DATE('2022/02/14 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/19 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000003,TO_DATE('2022/10/13 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN) VALUES(9,TO_DATE('2022/02/17 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/20 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000004);
INSERT INTO Admission(Num,AdmissionDate,LeaveDate,TotalPayment,InsurancePayment,SSN) VALUES(10,TO_DATE('2022/02/19 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2022/02/24 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),1000,900,100000004);

INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,AddressStreet,AddressCity) VALUES(800,'Bill','Gates',20.00,'General Manager','121',2,'23 Pond Rd','Gardner');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,AddressStreet,AddressCity) VALUES(801,'Stephen','Rocks',20.00,'General Manager','122',2,'12 Main St','Weston');


INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID,AddressStreet,AddressCity) VALUES(700,'Alpha','Apple',18.00,'Division Manager','111',1,800,'27 Happy Ln','Amherst');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID,AddressStreet,AddressCity) VALUES(701,'Beta','Banana',18.00,'Division Manager','112',1,800,'3 Water Rd','Beverly');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID,AddressStreet,AddressCity) VALUES(702,'Omega','Cherry',18.00,'Division Manager','113',1,801,'56 Lemon Rd','Burlington');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID,AddressStreet,AddressCity) VALUES(703,'Epsilon','Lime',18.00,'Division Manager','114',1,801,'33 Tulip Ln','Quincy');


INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(600,'Bert','Pans',15.00,'Regular Employee','101',0,700,'22 Bike Rd','Ashland');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(601,'Ernie','Pots',15.00,'Regular Employee','102',0,700,'91 West Rd','Weston');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(602,'Eddie','Wood',15.00,'Regular Employee','103',0,700,'292 Main St','Natick');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(603,'Larry','Loo',15.00,'Regular Employee','104',0,701,'231 Highland St','Lexington');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(604,'Ralph','Reck',15.00,'Regular Employee','105',0,701,'63 River Rd','Wellesley');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(605,'Gompei','Goat',15.00,'Regular Employee','106',0,701,'4 Sun St','Canton');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(606,'Josh','Cheese',15.00,'Regular Employee','107',0,702,'42 East St','Boston');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(607,'Anthony','Happy',15.00,'Regular Employee','108',0,702,'23 Dix St','Worcester');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(608,'Lily','Lin',15.00,'Regular Employee','109',0,703,'74 Legacy Rd','Dedham');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(609,'Amber','Olins',15.00,'Regular Employee','109',0, 703, '394 Rock Rd','Auburn');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(610,'Stacy','Pern',15.00,'Regular Employee','102',0,703,'175 Highland St','Worcester');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(611,'Yankey','Doodle',15.00,'Regular Employee','109',0,703,'1600 Pennsylvania Ave','Washington DC');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(612,'Amber','Quick',15.00,'Regular Employee','109',0,701,'9 On Muk Lane','Shek Mun');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(613,'Daveed','Turner',15.00,'Regular Employee','109',0,700,'12 Old Salem Cir','Shrewsbury');
INSERT INTO Emp(ID,FName,LName,Salary,JobTitle,OfficeNum,EmpRank,SupervisorID, AddressStreet,AddressCity) VALUES(614,'Matthew','Knocks',15.00,'Regular Employee','109',0,702,'72 West St','Fotan');
  
INSERT INTO Doc(ID,Gender,Specialty, GraduatedFrom) VALUES(600,'M','General', 'WPI');
INSERT INTO Doc(ID,Gender,Specialty, GraduatedFrom) VALUES(601,'M','Surgeon', 'WPI');
INSERT INTO Doc(ID,Gender,Specialty, GraduatedFrom) VALUES(602,'M','Gynecologist', 'Harvard');
INSERT INTO Doc(ID,Gender,Specialty, GraduatedFrom) VALUES(603,'M','Anesthesiologist', 'John Hopkins');
INSERT INTO Doc(ID,Gender,Specialty, GraduatedFrom) VALUES(604,'M','Pediatrician', 'Stanford');

INSERT INTO ETech(ID) VALUES(605);
INSERT INTO ETech(ID) VALUES(606);
INSERT INTO ETech(ID) VALUES(607);
INSERT INTO ETech(ID) VALUES(608);
INSERT INTO ETech(ID) VALUES(609);

Insert into RoomAccess(RoomNum, ID) Values (101, 600);
Insert into RoomAccess(RoomNum, ID) Values (102, 800);
Insert into RoomAccess(RoomNum, ID) Values (103, 800);
Insert into RoomAccess(RoomNum, ID) Values (101, 701);
Insert into RoomAccess(RoomNum, ID) Values (107, 602);
Insert into RoomAccess(RoomNum, ID) Values (110, 800);
Insert into RoomAccess(RoomNum, ID) Values (110, 703);
Insert into RoomAccess(RoomNum, ID) Values (110, 801);
Insert into RoomAccess(RoomNum, ID) Values (106, 603);

Insert Into Examine(DocID, AdNum) Values (600, 1);
Insert Into Examine(DocID, AdNum) Values (601, 2);
Insert Into Examine(DocID, AdNum) Values (602, 2);
Insert Into Examine(DocID, AdNum) Values (600, 2);
Insert Into Examine(DocID, AdNum) Values (600, 3);
Insert Into Examine(DocID, AdNum) Values (603, 4);
Insert Into Examine(DocID, AdNum) Values (604, 4);
Insert Into Examine(DocID, AdNum) Values (600, 4);
Insert Into Examine(DocID, AdNum) Values (600, 5);
Insert Into Examine(DocID, AdNum) Values (600, 6);
Insert Into Examine(DocID, AdNum) Values (600, 7);
Insert Into Examine(DocID, AdNum) Values (600, 8);
Insert Into Examine(DocID, AdNum) Values (600, 9);
Insert Into Examine(DocID, AdNum) Values (600, 10);


Insert Into StayIn(AdNum, RoomNum, StartDate) Values (1, 104, TO_DATE('2022/12/05 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert Into StayIn(AdNum, RoomNum, StartDate) Values (2, 101, TO_DATE('2022/02/19 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
Insert Into StayIn(AdNum, RoomNum, StartDate) Values (4, 104, TO_DATE('2022/03/15 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

Insert Into CanRepair(ID, EID) Values (605, '1234');
Insert Into CanRepair(ID, EID) Values (606, '2345');
Insert Into CanRepair(ID, EID) Values (607, '2345');
Insert Into CanRepair(ID, EID) Values (607, '3456');
Insert Into CanRepair(ID, EID) Values (608, '1234');
Insert Into CanRepair(ID, EID) Values (609, '1234');

/*from phase 2: end*/

/*start of phase 3*/

/*part 1*/

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

Select L.DocID, C.SSN, E.DocComment
From CriticalCases C, Admission A, Examine E, DoctorsLoad L
Where C.SSN = A.SSN
AND A.Num = E.AdNum
AND E.DocID = L.DocID
AND L.load = 'Underloaded';

/*part 2*/

CREATE OR REPLACE TRIGGER CheckEquipment
BEFORE INSERT OR UPDATE ON Equipment
FOR EACH ROW
DECLARE ETechCanRepair Char(20); 
BEGIN
  IF (:new.LastInspection < ADD_MONTHS(SYSDATE, -1)) THEN
  SELECT EID into ETechCanRepair
  FROM CanRepair cr
  WHERE :new.TypeID = cr.EID;
    IF (ETechCanRepair != null) THEN
      UPDATE Equipment SET LastInspection = SYSDATE;
    END IF;
  END IF;
END;
/

select SSN, FName, LName, Address from Patient WHERE SSN = 100000000;

-- query for doc info
select D.ID as DocID, FName as FirstName, LName as LastName, Gender, GraduatedFrom, Specialty from doc d, emp e where d.id = e.id;


-- query for admission info
select ssn, a.startdate as adStart, totalpayment, r.roomnum, r.startdate, r.enddate, e.docid 
from Admission a, RoomStay r, Examinations e 
where r.admid = a.admid 
and e.admid = a.admid;

--admission query
select ssn, a.startdate as adStart, totalpayment
from Admission a, RoomStay r, Examinations e 
where r.admid = a.admid 
and e.admid = a.admid;

-- room query
select distinct e.docid
from Admission a, RoomStay r, Examinations e 
where r.admid = a.admid 
and e.admid = a.admid;

-- updating payment
update admission
set totalpayment = ?
where admid = ?;

