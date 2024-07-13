-- ---------------------------------------------------------------
-- SCHEMA MSManSys_db_app
-- ---------------------------------------------------------------

DROP SCHEMA IF EXISTS MSManSys_db_app;
CREATE SCHEMA IF NOT EXISTS MSManSys_db_app;
USE MSManSys_db_app;

-- ---------------------------------------------------------------
-- Table studentProfiles
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS studentProfiles;
CREATE TABLE IF NOT EXISTS studentProfiles (
    studentID               INT(8) NOT NULL,
    studentType             ENUM('Regular', 'Irregular') NOT NULL,
    firstname               VARCHAR(50) NOT NULL,
    middleInitial           CHAR(2),
    lastName                VARCHAR(50) NOT NULL,
    birthDate               DATE NOT NULL,
    gender                  ENUM('Male', 'Female') NOT NULL,
    schoolEmail             VARCHAR(50) NOT NULL,
    phoneNum                VARCHAR(15) NOT NULL, -- Adjusted data type for phone number
    PRIMARY KEY             (studentID)
);

-- ---------------------------------------------------------------
-- Table semester
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS semester;
CREATE TABLE IF NOT EXISTS semester (
    semID                              INT(5) NOT NULL,
    sem                                ENUM('1st', '2nd', '3rd') NOT NULL,
    semStart                           DATE NOT NULL,
    semEnd                             DATE NOT NULL,
    PRIMARY KEY                        (semID)
);

-- ---------------------------------------------------------------
-- Table base_fees
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS base_fees;
CREATE TABLE IF NOT EXISTS base_fees (
    fee_id INT NOT NULL,
    semID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    fee_desc VARCHAR(45) NOT NULL,
    
    PRIMARY KEY(fee_id),
    FOREIGN KEY (semID)
		REFERENCES semester(semID)
);
-- ---------------------------------------------------------------
-- Table departments
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS departments;
CREATE TABLE IF NOT EXISTS departments(
    departmentID                       INT(5) NOT NULL,
    departmentName                     VARCHAR(50) NOT NULL,
    PRIMARY KEY                        (departmentID)
);


-- ---------------------------------------------------------------
-- Table instructor
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS instructor;
CREATE TABLE IF NOT EXISTS instructor (
    instructorID            INT(5) NOT NULL,
    i_firstName             VARCHAR(20) NOT NULL,
    i_middleInitial         CHAR(2),
    i_lastName              VARCHAR(25) NOT NULL,
    instructorType          ENUM('Full-time', 'Part-time') NOT NULL,    
    departmentID			INT(5) NOT NULL,
    PRIMARY KEY             (instructorID),
	FOREIGN KEY 			(departmentID)
		REFERENCES			departments(departmentID)
);

-- ---------------------------------------------------------------
-- Table emerg_contact
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS emerg_contact;
CREATE TABLE IF NOT EXISTS emerg_contact(
    emergencyID                          INT(6) NOT NULL,
    e_firstName                          VARCHAR(50)  NOT NULL,
    e_middleInitial                      CHAR(2),  
    e_lastName                           VARCHAR(50) NOT NULL,
    e_relation                           ENUM('Parent' , 'Guardian') NOT NULL,
    e_conNum                             VARCHAR(11) NOT NULL,
    studentID                            INT(8) NOT NULL,
    PRIMARY KEY                          (emergencyID),
    INDEX                                (studentID ASC),
    FOREIGN KEY                          (studentID)
		REFERENCES            			 studentProfiles(studentID)
);

-- ---------------------------------------------------------------
-- Table address
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS address;
CREATE TABLE IF NOT EXISTS address(
    addressID                          INT(7) NOT NULL,
    street                             VARCHAR(50) NOT NULL,
    barangay                           VARCHAR(50) NOT NULL,
    city                               VARCHAR(50) NOT NULL,
    region                             VARCHAR(50) NOT NULL,
    zipCode                            INT(10) NOT NULL UNIQUE,
    studentID                          INT(8) NOT NULL,
    emergencyID                        INT(5) NOT NULL,
    PRIMARY KEY                        (addressID),
    INDEX                              (studentID ASC),
    INDEX                              (emergencyID ASC),
    FOREIGN KEY                        (studentID)
		REFERENCES          studentProfiles(studentID),
    FOREIGN KEY                        (emergencyID)
		REFERENCES            emerg_contact(emergencyID)
);

-- ---------------------------------------------------------------
-- Table degree_programs
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS degree_programs; -- List of degrees offered by music school
CREATE TABLE IF NOT EXISTS degree_programs(
    program_id INT NOT NULL,
    department_id INT NOT NULL,
    is_available TINYINT(1) NOT NULL,
    degree_type ENUM('Undergraduate','Graduate') NOT NULL,
    program_name VARCHAR(45) NOT NULL,
    PRIMARY KEY (program_id),
    FOREIGN KEY (department_id)
      REFERENCES departments(departmentID)
);

-- ---------------------------------------------------------------
-- Table general_enrollment
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS general_enrollment; -- Not related to course
CREATE TABLE IF NOT EXISTS general_enrollment(
    enrollmentID                       INT(10) NOT NULL,
    first_semesterID				   INT(5) NOT NULL,
    eStatus                            ENUM('Active','Inactive') NOT NULL,
   -- withdrawalDate                     DATE, this should not be its own field here IMO
   -- completionDate                     DATE,
    studentID                          INT(8) NOT NULL,
    PRIMARY KEY                        (enrollmentID),
    INDEX                              (studentID ASC),
    FOREIGN KEY						   (first_semesterID)
		REFERENCES						semester(semID),
    FOREIGN KEY                        (studentID)
		REFERENCES         			   studentProfiles (studentID)
);

-- ---------------------------------------------------------------
-- Table ge_change
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS ge_change;
CREATE TABLE IF NOT EXISTS ge_change(
	ge_change_id INT(10) NOT NULL,
    ge_id INT(10) NOT NULL,
    specific_change ENUM('Graduated','Withdrawn','Transferred') NOT NULL,
    date_changed DATE NOT NULL,
    PRIMARY KEY (ge_change_id),
    FOREIGN KEY (ge_id)
		REFERENCES general_enrollment(enrollmentID)
);

-- ---------------------------------------------------------------
-- Table semester_bill
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS semester_bill; 
CREATE TABLE IF NOT EXISTS semester_bill 
(
	bill_id INT NOT NULL,
    semID INT(5) NOT NULL,
    studentID INT(8) NOT NULL,
    
    PRIMARY KEY (bill_id),
    FOREIGN KEY (semID)
		REFERENCES semester(semID),
	FOREIGN KEY (studentID)
		REFERENCES studentProfiles(studentID)
);


-- ---------------------------------------------------------------
-- Table payment
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS payment;
CREATE TABLE IF NOT EXISTS payment(
    paymentRefID                       INT(12) NOT NULL,
    paymentDate                        DATE NOT NULL,
    bill_id							   INT NOT NULL,
    amount                             DECIMAL(10,2) NOT NULL, 
    paymentMethod                      ENUM('Cash' , 'Cheque' , 'Bank') NOT NULL,
    studentID                          INT(8) NOT NULL,
    PRIMARY KEY                        (paymentRefID),
    INDEX                              (studentID ASC),
    FOREIGN KEY 					   (bill_id)
		REFERENCES					   semester_bill(bill_id),
    FOREIGN KEY                        (studentID)
		REFERENCES         			   studentProfiles (studentID)
);
-- ---------------------------------------------------------------
-- Table college_degree
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS college_degree; -- Degree enrollment
CREATE TABLE IF NOT EXISTS college_degree(
    degreeID                           INT(5)NOT NULL,
    year                               INT(4) NOT NULL,
    program_id                         INT NOT NULL,
    type                               ENUM('Major','Minor','Graduate'),
    status                             ENUM('Ongoing','Completed','Dropped'),
    ge_id                          	   INT(8) NOT NULL,
    PRIMARY KEY                        (degreeID),
    FOREIGN KEY (program_id)
      REFERENCES degree_programs(program_id),
	FOREIGN KEY (ge_id)
	  REFERENCES general_enrollment(enrollmentID)
);

-- ---------------------------------------------------------------
-- Table course
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS course;
CREATE TABLE IF NOT EXISTS course(
    courseID                       INT(10) NOT NULL,
    courseName                     VARCHAR(50) NOT NULL,
    -- IMO these are unnecessary because of semID (in course_enrollment).
   /*
    duration                       INT(1) NOT NULL,
    startDate                      DATE NOT NULL,
    endDate                        DATE NOT NULL,*/ 
    units                          INT(1) NOT NULL,
    instructorID                   INT(5) NOT NULL,
    tuition_cost				   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY                    (courseID),
    INDEX                          (instructorID ASC),
    FOREIGN KEY                    (instructorID)
		REFERENCES           	   instructor(instructorID)
);
-- ---------------------------------------------------------------
-- Table prerequisites
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS prerequisites; -- Class/course prerequisites
CREATE TABLE IF NOT EXISTS prerequisites(
    pre_id INT NOT NULL,
    prerequisite_id INT NOT NULL, -- id of prerequisite
    course_id INT NOT NULL, -- id of subsequent course
    
    PRIMARY KEY (pre_id),
    FOREIGN KEY (prerequisite_id)
		REFERENCES course(courseID),
	FOREIGN KEY (course_id)
		REFERENCES course(courseID)
);


-- ---------------------------------------------------------------
-- Table course_enrollment
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS course_enrollment;
CREATE TABLE IF NOT EXISTS course_enrollment(
    c_enroll_id INT NOT NULL,
    student_id INT NOT NULL,
    course_id INT(10) NOT NULL,
    c_grade DECIMAL(10,1) NOT NULL,
    semID INT(5) NOT NULL,
    status ENUM('Ongoing', 'Dropped','Failed','Cancelled','Completed'), -- school may cancel course and it will not count as a failure
    is_retake TINYINT(1) NOT NULL,

    PRIMARY KEY (c_enroll_id),
    FOREIGN KEY (student_id)
      REFERENCES studentProfiles(studentID),
    FOREIGN KEY (course_id)
      REFERENCES course(courseID),
    FOREIGN KEY (semID)
      REFERENCES semester(semID)
);

-- ---------------------------------------------------------------
-- Table retaker
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS retaker;
CREATE TABLE IF NOT EXISTS retaker(
    retakerID                         INT(6) NOT NULL,
    retakeSem                         INT NOT NULL,
    originalAttempt                   INT NOT NULL,
    attempts                          INT(2) NOT NULL,
    reason                            VARCHAR(45) NOT NULL,
    finalGrade                        DECIMAL(5,2) NOT NULL,
    studentID                         INT(8) NOT NULL,
    PRIMARY KEY                       (retakerID),
    INDEX                             (studentID ASC),
    FOREIGN KEY 					  (retakeSem)
		REFERENCES					  semester(semID),
	FOREIGN KEY						  (originalAttempt)
		REFERENCES					  course_enrollment(c_enroll_id),
    FOREIGN KEY                       (studentID)
		REFERENCES         			  studentProfiles(studentID)
);

-- ---------------------------------------------------------------
-- Table room
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS room;
CREATE TABLE IF NOT EXISTS room(
    roomID                      INT(5) NOT NULL,
    roomType                    ENUM('Classroom' , 'Studio' , 'None') NOT NULL,
    mode                        ENUM('Hybrid' , 'Face-to-Face' , 'Online') NOT NULL,
    capacity                    INT(2) NOT NULL,
    location                    VARCHAR(45) NOT NULL,
    PRIMARY KEY                 (roomID) 
    -- room should be a foreign key in course because the same room can be used as a venue for different courses across semesters
);

-- ---------------------------------------------------------------
-- Table room_assignment
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS room_assignment;
CREATE TABLE IF NOT EXISTS room_assignment(
    r_asst_id INT NOT NULL,
    semID INT NOT NULL,
    course_id INT NOT NULL,
    day_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday'),
    time_start TIME NOT NULL,
    time_end TIME NOT NULL,
    
    PRIMARY KEY (r_asst_id),
    FOREIGN KEY(semID)
		REFERENCES semester(semID),
	FOREIGN KEY (course_id)
		REFERENCES course(courseID)
);


-- ---------------------------------------------------------------
-- Table instrument
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS instrument;
CREATE TABLE IF NOT EXISTS instrument(
    instrumentID                         INT(4) NOT NULL,
    instruName                           VARCHAR(50) NOT NULL,
    r_room                               VARCHAR(4) NOT NULL,
    instrumentType                       ENUM('String', 'Brass', 'Keyboard', 
                                         'Percussion', 'Woodwind', 'Electronic') NOT NULL,
    instrumentLevel                      ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,
    r_availability                       ENUM('Available', 'Unavailable') NOT NULL,
    instructorID                         INT(5) NOT NULL,
    departmentID                         INT(5) NOT NULL,
    courseID                             INT(5) NOT NULL,
    PRIMARY KEY                          (instrumentID),
    INDEX                                (instrumentID ASC),
    INDEX                                (departmentID ASC),
    INDEX                                (courseID ASC),
    FOREIGN KEY                          (instructorID)
		REFERENCES                 	     instructor(instructorID),
    FOREIGN KEY                          (departmentID)
		REFERENCES                 		 departments(departmentID),
    FOREIGN KEY                          (courseID)
		REFERENCES                       course(courseID)
);
-- ---------------------------------------------------------------
-- Table instrument_incident
-- ---------------------------------------------------------------
DROP TABLE IF EXISTS instrument_incident;
CREATE TABLE IF NOT EXISTS instrument_incident(
	incident_id INT NOT NULL,
    date_reported DATE NOT NULL,
    reporter_name VARCHAR(45) NULL, -- nullable just in case
    instrument_id INT(4) NOT NULL,
    incident_type ENUM('Broken', 'Missing', 'Other') NOT NULL,
    comment VARCHAR(255) NULL,
    
    INDEX(date_reported ASC),
    
    PRIMARY KEY(incident_id),
    FOREIGN KEY (instrument_id)
		REFERENCES instrument(instrumentID)
);
-- ---------------------------------------------------------------
-- Table waitlist
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS waitlist;
CREATE TABLE IF NOT EXISTS waitlist(
    waitlistID                     INT(5) NOT NULL,
    e_Date                         DATE NOT NULL,
    w_status                       ENUM('Pending', 'Accepted', 'Denied', 
                                   'Notified') NOT NULL,
    studentID                      INT(5) NOT NULL,
    program_id                      INT(5) NOT NULL,
    PRIMARY KEY                    (waitlistID),
    INDEX                          (studentID ASC),
    FOREIGN KEY                    (studentID)
		REFERENCES      		   studentProfiles(studentID),
    FOREIGN KEY                    (program_id)
		REFERENCES                 degree_programs(program_id)
);

-- ---------------------------------------------------------------
-- Table instrumentBorrow
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS instrumentBorrow;
CREATE TABLE IF NOT EXISTS instrumentBorrow(
    borrowID                            INT(5) NOT NULL,
    b_startDate                         DATE NOT NULL,
    b_returnDate                        DATE NOT NULL,
    b_dueDate                           DATE NOT NULL,
    
    /* 
	DB or app should check this table every day - if current date is greater than returnDate and status = 'Borrowed', status should be updated to 'Overdue'
    Students who log in should be notified of dues
    */
    b_status							ENUM('Borrowed','Returned','Overdue') NOT NULL, 
    instrumentID                        INT(5) NOT NULL,
    studentID                           INT(5) NOT NULL,
    PRIMARY KEY                         (borrowID),
    INDEX                               (studentID ASC),
    INDEX                               (instrumentID ASC),
    FOREIGN KEY                         (studentID)
		REFERENCES           			studentProfiles(studentID),
    FOREIGN KEY                         (instrumentID)
		REFERENCES                		instrument(instrumentID)
);

-- ---------------------------------------------------------------
-- Table account
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS account;
CREATE TABLE IF NOT EXISTS account (
    accountID               INT(8) NOT NULL,
    username                VARCHAR(30) NOT NULL,
    password                VARCHAR(100) NOT NULL, -- Storing hashed passwords
    studentID               INT(8) NOT NULL,
    PRIMARY KEY             (accountID),
    UNIQUE KEY              (username),
    FOREIGN KEY             (studentID)
		REFERENCES      	studentProfiles(studentID)
);

-- ---------------------------------------------------------------
-- INSERT DATA
-- ---------------------------------------------------------------

-- ---------------------------------------------------------------
-- Table studentProfiles
-- ---------------------------------------------------------------

INSERT INTO studentProfiles (studentID, studentType, firstname, middleInitial, lastName, birthDate, gender, schoolEmail, phoneNum)
	VALUES	(1, 'Regular', 'John', 'D', 'Doe', '2000-01-15', 'Male', 'john.doe@example.com', '1234567890'),
			(2, 'Irregular', 'Jane', 'E', 'Smith', '1998-05-22', 'Female', 'jane.smith@example.com', '9876543210'),
			(3, 'Regular', 'Alice', 'M', 'Johnson', '2001-08-10', 'Female', 'alice.johnson@example.com', '1112233445'),
			(4, 'Irregular', 'Bob', 'L', 'Anderson', '1999-03-18', 'Male', 'bob.anderson@example.com', '5556667777'),
			(5, 'Regular', 'Emily', 'A', 'White', '2002-02-28', 'Female', 'emily.white@example.com', '9998887777'),
			(6, 'Irregular', 'Charlie', 'K', 'Brown', '2000-11-05', 'Male', 'charlie.brown@example.com', '4443332222'),
			(7, 'Regular', 'Ella', 'R', 'Garcia', '2001-07-12', 'Female', 'ella.garcia@example.com', '7776665555'),
			(8, 'Irregular', 'David', 'J', 'Taylor', '1998-12-03', 'Male', 'david.taylor@example.com', '2221119999'),
			(9, 'Regular', 'Sophia', 'S', 'Miller', '2003-04-17', 'Female', 'sophia.miller@example.com', '8889990000'),
			(10, 'Irregular', 'Jack', 'P', 'Martinez', '1999-09-09', 'Male', 'jack.martinez@example.com', '6665554444'),
			(11, 'Regular', 'Reko', 'R','Yabusame','2004-02-27','Female','reko.yabusame@example.com','1112224444');

-- ---------------------------------------------------------------
-- Table semester
-- ---------------------------------------------------------------

INSERT INTO semester (semID, sem, semStart, semEnd)
	VALUES	(1, '1st', '2016-05-19', '2016-08-27'),
(2, '2nd', '2016-09-10', '2016-12-19'),
(3, '3rd', '2017-01-02', '2017-04-12'),
(4, '1st', '2017-04-26', '2017-08-04'),
(5, '2nd', '2017-08-18', '2017-11-26'),
(6, '1st', '2017-12-10', '2018-03-20'),
(7, '3rd', '2018-04-03', '2018-07-12'),
(8, '1st', '2018-07-26', '2018-11-03'),
(9, '2nd', '2018-11-17', '2019-02-25'),
(10, '3rd', '2019-03-11', '2019-06-19'),
(11, '2nd', '2019-07-03', '2019-10-11'),
(12, '1st', '2019-10-25', '2020-02-02'),
(13, '3rd', '2020-02-16', '2020-05-26'),
(14, '1st', '2020-06-09', '2020-09-17'),
(15, '2nd', '2020-10-01', '2021-01-09'),
(16, '3rd', '2021-01-23', '2021-05-03'),
(17, '2nd', '2021-05-17', '2021-08-25'),
(18, '1st', '2021-09-08', '2021-12-17'),
(19, '3rd', '2021-12-31', '2022-04-10'),
(20, '1st', '2022-04-24', '2022-08-02'),
(21, '2nd', '2022-08-16', '2022-11-24'),
(22, '3rd', '2022-12-08', '2023-03-18'),
(23, '2nd', '2023-04-01', '2023-07-10'),
(24, '1st', '2023-07-24', '2023-11-01'),
(25, '3rd', '2023-11-15', '2024-02-23'),
(26, '1st', '2024-03-08', '2024-06-16'),
(27, '2nd', '2024-06-30', '2024-10-08'),
(28, '3rd', '2024-10-22', '2025-01-30');

-- ---------------------------------------------------------------
-- Table base_fees
-- ---------------------------------------------------------------
INSERT INTO base_fees(fee_id,semID,amount,fee_desc)
VALUES
(4001, 1, 2145.00, 'Give us your money'),
(4002, 1, 3970.00, 'Give us your money'),
(4003, 2, 3031.00, 'Give us your money'),
(4004, 2, 3938.00, 'Give us your money'),
(4005, 3, 2425.00, 'Give us your money'),
(4006, 3, 3611.00, 'Give us your money'),
(4007, 4, 3347.00, 'Give us your money'),
(4008, 4, 3735.00, 'Give us your money'),
(4009, 5, 1944.00, 'Give us your money'),
(4010, 5, 1155.00, 'Give us your money'),
(4011, 6, 2749.00, 'Give us your money'),
(4012, 6, 3460.00, 'Give us your money'),
(4013, 7, 3035.00, 'Give us your money'),
(4014, 7, 1555.00, 'Give us your money'),
(4015, 8, 2741.00, 'Give us your money'),
(4016, 8, 1410.00, 'Give us your money'),
(4017, 9, 1516.00, 'Give us your money'),
(4018, 9, 1025.00, 'Give us your money'),
(4019, 10, 2891.00, 'Give us your money'),
(4020, 10, 2220.00, 'Give us your money'),
(4021, 11, 2595.00, 'Give us your money'),
(4022, 11, 1633.00, 'Give us your money'),
(4023, 12, 1611.00, 'Give us your money'),
(4024, 12, 2496.00, 'Give us your money'),
(4025, 13, 2073.00, 'Give us your money'),
(4026, 13, 1299.00, 'Give us your money'),
(4027, 14, 2750.00, 'Give us your money'),
(4028, 14, 2578.00, 'Give us your money'),
(4029, 15, 1070.00, 'Give us your money'),
(4030, 15, 2408.00, 'Give us your money'),
(4031, 16, 3045.00, 'Give us your money'),
(4032, 16, 3739.00, 'Give us your money'),
(4033, 17, 2434.00, 'Give us your money'),
(4034, 17, 1690.00, 'Give us your money'),
(4035, 18, 2919.00, 'Give us your money'),
(4036, 18, 1281.00, 'Give us your money'),
(4037, 19, 3608.00, 'Give us your money'),
(4038, 19, 2176.00, 'Give us your money'),
(4039, 20, 2913.00, 'Give us your money'),
(4040, 20, 1668.00, 'Give us your money'),
(4041, 21, 1119.00, 'Give us your money'),
(4042, 21, 3395.00, 'Give us your money'),
(4043, 22, 3293.00, 'Give us your money'),
(4044, 22, 2685.00, 'Give us your money'),
(4045, 23, 1322.00, 'Give us your money'),
(4046, 23, 1911.00, 'Give us your money'),
(4047, 24, 3659.00, 'Give us your money'),
(4048, 24, 1266.00, 'Give us your money'),
(4049, 25, 1975.00, 'Give us your money'),
(4050, 25, 1145.00, 'Give us your money');

-- ---------------------------------------------------------------
-- Table departments
-- ---------------------------------------------------------------

INSERT INTO departments (departmentID, departmentName)
	VALUES	(1, 'Music Theory'),
	(2, 'Composition'),
	(3, 'Instrumental Performance'),
	(4, 'Vocal Performance'),
	(5, 'Music History'),
	(6, 'Music Technology'),
	(7, 'Music Education'),
	(8, 'Sound Engineering'),
	(9, 'Jazz Studies'),
	(10, 'Ethnomusicology');

-- ---------------------------------------------------------------
-- Table instructor
-- ---------------------------------------------------------------

INSERT INTO instructor (instructorID, i_firstName, i_middleInitial, i_lastName, instructorType, departmentID)
	VALUES	(1, 'JODI', 'U', 'MITCHELL', 'Part-time', 9),
(2, 'LETICIA', 'E', 'GARCIA', 'Part-time', 5),
(3, 'SHELLEY', 'M', 'WALKER', 'Part-time', 1),
(4, 'LESLIE', 'M', 'PRICE', 'Full-time', 9),
(5, 'HEATHER', 'W', 'RUSSELL', 'Full-time', 2),
(6, 'BONNIE', 'L', 'MILLER', 'Part-time', 8),
(7, 'KRISTA', 'O', 'HENDERSON', 'Part-time', 3),
(8, 'VICKIE', 'Q', 'BROOKS', 'Part-time', 10),
(9, 'MARIE', 'Z', 'WILLIAMS', 'Full-time', 7),
(10, 'ANITA', 'D', 'EVANS', 'Full-time', 10),
(11, 'PAUL', 'O', 'BUTLER', 'Full-time', 3),
(12, 'PATTY', 'O', 'WILSON', 'Part-time', 3),
(13, 'RUBY', 'F', 'CARTER', 'Part-time', 2),
(14, 'GEORGE', 'P', 'PETERSON', 'Full-time', 2),
(15, 'MARYANN', 'V', 'SCOTT', 'Full-time', 6),
(16, 'PHYLLIS', 'E', 'ROBERTS', 'Part-time', 3),
(17, 'CRISTINA', 'Q', 'LEE', 'Part-time', 2),
(18, 'MARLENE', 'T', 'GREEN', 'Part-time', 9),
(19, 'ANA', 'B', 'HAYES', 'Part-time', 5),
(20, 'MISTY', 'I', 'PHILLIPS', 'Full-time', 5),
(21, 'VICKI', 'W', 'LONG', 'Part-time', 1),
(22, 'SHANNON', 'J', 'HILL', 'Full-time', 3),
(23, 'BILLIE', 'R', 'TURNER', 'Full-time', 4),
(24, 'CORA', 'B', 'GARCIA', 'Part-time', 3),
(25, 'SYLVIA', 'W', 'CAMPBELL', 'Part-time', 4),
(26, 'MARGUERITE', 'Z', 'MILLER', 'Part-time', 7),
(27, 'YVETTE', 'C', 'HENDERSON', 'Full-time', 10),
(28, 'ETHEL', 'S', 'YOUNG', 'Full-time', 5),
(29, 'FELICIA', 'H', 'CLARK', 'Full-time', 2),
(30, 'RICHARD', 'B', 'WILLIAMS', 'Full-time', 9),
(31, 'NINA', 'J', 'JOHNSON', 'Full-time', 6),
(32, 'BESSIE', 'Y', 'REED', 'Full-time', 5),
(33, 'SALLY', 'H', 'PRICE', 'Part-time', 5),
(34, 'MAUREEN', 'F', 'ROGERS', 'Part-time', 3),
(35, 'MAUREEN', 'G', 'JOHNSON', 'Full-time', 7),
(36, 'JUANA', 'F', 'COOK', 'Full-time', 1),
(37, 'AMBER', 'U', 'SANCHEZ', 'Full-time', 7),
(38, 'MADELINE', 'V', 'COX', 'Full-time', 8),
(39, 'JANICE', 'P', 'TURNER', 'Full-time', 10),
(40, 'JANA', 'U', 'HALL', 'Full-time', 7),
(41, 'EULA', 'D', 'TAYLOR', 'Part-time', 5),
(42, 'MARGUERITE', 'H', 'SANCHEZ', 'Part-time', 3),
(43, 'EILEEN', 'R', 'HARRIS', 'Part-time', 9),
(44, 'KRISTY', 'X', 'LEWIS', 'Full-time', 10),
(45, 'CHRISTOPHER', 'O', 'PHILLIPS', 'Part-time', 10),
(46, 'ROSA', 'R', 'HERNANDEZ', 'Full-time', 4),
(47, 'TERRI', 'E', 'DIAZ', 'Part-time', 4),
(48, 'JUNE', 'B', 'BRYANT', 'Part-time', 3),
(49, 'RUBY', 'F', 'JACKSON', 'Part-time', 8),
(50, 'CAROL', 'K', 'MARTIN', 'Full-time', 5),
(51, 'LYNETTE', 'E', 'NELSON', 'Full-time', 3),
(52, 'BARBARA', 'D', 'BARNES', 'Part-time', 7),
(53, 'MEGHAN', 'W', 'ROBERTS', 'Part-time', 10),
(54, 'MARIA', 'J', 'REED', 'Part-time', 5),
(55, 'ERNESTINE', 'Z', 'COX', 'Part-time', 3),
(56, 'JUANITA', 'E', 'BAKER', 'Full-time', 10),
(57, 'AMBER', 'P', 'FOSTER', 'Part-time', 7),
(58, 'MEREDITH', 'W', 'JENKINS', 'Part-time', 5),
(59, 'ANNA', 'B', 'JONES', 'Part-time', 6),
(60, 'RACHAEL', 'A', 'COLLINS', 'Part-time', 9),
(61, 'THOMAS', 'S', 'SMITH', 'Full-time', 4),
(62, 'LISA', 'U', 'ROSS', 'Part-time', 1),
(63, 'IRMA', 'F', 'BROOKS', 'Full-time', 4),
(64, 'JOHN', 'K', 'TURNER', 'Part-time', 2),
(65, 'LETICIA', 'K', 'FOSTER', 'Full-time', 7),
(66, 'CYNTHIA', 'Q', 'ROGERS', 'Part-time', 2),
(67, 'MAGGIE', 'S', 'BROOKS', 'Part-time', 8),
(68, 'GINGER', 'X', 'SANDERS', 'Part-time', 5),
(69, 'GENEVIEVE', 'C', 'BROOKS', 'Full-time', 3),
(70, 'EDITH', 'D', 'JONES', 'Part-time', 10),
(71, 'NANCY', 'Q', 'MITCHELL', 'Full-time', 8),
(72, 'APRIL', 'P', 'SIMMONS', 'Part-time', 3),
(73, 'BRITTANY', 'O', 'THOMAS', 'Part-time', 4),
(74, 'MARCIA', 'A', 'SANCHEZ', 'Full-time', 4),
(75, 'JOYCE', 'X', 'KING', 'Part-time', 8),
(76, 'KATHLEEN', 'R', 'KELLY', 'Part-time', 6),
(77, 'IRIS', 'V', 'WOOD', 'Full-time', 8),
(78, 'FAYE', 'S', 'MORGAN', 'Full-time', 4),
(79, 'SUSIE', 'W', 'PRICE', 'Full-time', 7),
(80, 'ROSEMARIE', 'A', 'BROOKS', 'Full-time', 1),
(81, 'STACY', 'G', 'BRYANT', 'Full-time', 2),
(82, 'VICKY', 'F', 'TORRES', 'Part-time', 5),
(83, 'LAUREN', 'F', 'ALLEN', 'Part-time', 3),
(84, 'MONICA', 'F', 'ALEXANDER', 'Full-time', 4),
(85, 'ROXANNE', 'Y', 'GARCIA', 'Part-time', 10),
(86, 'SHELIA', 'A', 'GARCIA', 'Part-time', 9),
(87, 'CLAUDIA', 'U', 'WILSON', 'Part-time', 3),
(88, 'ALISON', 'J', 'JOHNSON', 'Part-time', 7),
(89, 'ROSEMARY', 'C', 'HOWARD', 'Full-time', 2),
(90, 'LOUISE', 'G', 'HALL', 'Full-time', 2),
(91, 'ADA', 'Z', 'JONES', 'Part-time', 5),
(92, 'ROCHELLE', 'M', 'POWELL', 'Part-time', 1),
(93, 'ELEANOR', 'X', 'THOMAS', 'Part-time', 8),
(94, 'MELISSA', 'Z', 'BAKER', 'Full-time', 2),
(95, 'WILLIAM', 'U', 'HERNANDEZ', 'Part-time', 3),
(96, 'FANNIE', 'D', 'HAYES', 'Full-time', 2),
(97, 'JOANN', 'M', 'PHILLIPS', 'Full-time', 5),
(98, 'NICOLE', 'D', 'KING', 'Part-time', 7),
(99, 'CINDY', 'Q', 'BROWN', 'Part-time', 2),
(100, 'EMMA', 'D', 'EVANS', 'Full-time', 4);

-- ---------------------------------------------------------------
-- Table emerg_contact
-- ---------------------------------------------------------------

INSERT INTO emerg_contact (emergencyID, e_firstName, e_middleInitial, e_lastName, e_relation, e_conNum, studentID)
	VALUES	(1, 'Parent1', 'A', 'Contact1', 'Parent', 09499928487, 1),
			(2, 'Guardian1', 'B', 'Contact2', 'Guardian', 98765432101, 2),
			(3, 'Parent2', 'C', 'Contact3', 'Parent', 11122233444, 3),
			(4, 'Guardian2', 'D', 'Contact4', 'Guardian', 55566677888, 4),
			(5, 'Parent3', 'E', 'Contact5', 'Parent', 99988887777, 5),
			(6, 'Guardian3', 'F', 'Contact6', 'Guardian', 44433332222, 6),
			(7, 'Parent4', 'G', 'Contact7', 'Parent', 77776666555, 7),
			(8, 'Guardian4', 'H', 'Contact8', 'Guardian', 33332222111, 8),
			(9, 'Parent5', 'I', 'Contact9', 'Parent', 66665555444, 9),
			(10, 'Guardian5', 'J', 'Contact10', 'Guardian', 22221111000, 10);

-- ---------------------------------------------------------------
-- Table address
-- ---------------------------------------------------------------

INSERT INTO address (addressID, street, barangay, city, region, zipCode, studentID, emergencyID)
	VALUES	(1, 'Street1', 'Barangay1', 'City1', 'Region1', 1234, 1, 1), -- need to allow duplicates here
			(2, 'Street2', 'Barangay2', 'City2', 'Region2', 5678, 2, 2),
			(3, 'Street3', 'Barangay3', 'City3', 'Region3', 9101, 3, 3),
			(4, 'Street4', 'Barangay4', 'City4', 'Region4', 1122, 4, 4),
			(5, 'Street5', 'Barangay5', 'City5', 'Region5', 3344, 5, 5),
			(6, 'Street6', 'Barangay6', 'City6', 'Region6', 5566, 6, 6),
			(7, 'Street7', 'Barangay7', 'City7', 'Region7', 7788, 7, 7),
			(8, 'Street8', 'Barangay8', 'City8', 'Region8', 9900, 8, 8),
			(9, 'Street9', 'Barangay9', 'City9', 'Region9', 1132, 9, 9),
			(10, 'Street10', 'Barangay10', 'City10', 'Region10', 3342, 10, 10);

-- ---------------------------------------------------------------
-- Table general_enrollment
-- ---------------------------------------------------------------

INSERT INTO general_enrollment(enrollmentID, first_semesterID,eStatus,studentID) 
VALUES (10001,7,'Active',1),
		(10002,1,'Inactive',2),
		(10003,11,'Active',3),
		(10004,4,'Inactive',4),
		(10005,15,'Inactive',5),
		(10006,9,'Active',6),
		(10007,9,'Active',7),
		(10008,1,'Inactive',8),
		(10009,16,'Active',9),
		(10010,5,'Inactive',10),
        (10011,22,'Active',11);

-- ---------------------------------------------------------------
-- Table ge_change
-- ---------------------------------------------------------------
INSERT INTO ge_change(ge_change_id,ge_id,specific_change,date_changed)
VALUES (1101,10002,'Graduated','2020-05-28'),
		(1102,10004,'Graduated','2021-05-28'),
		(1103,10005,'Withdrawn','2021-08-20'),
		(1104,10008,'Transferred','2017-07-06'),
		(1105,10010,'Graduated','2021-05-28');

-- ---------------------------------------------------------------
-- Table semester_bill
-- ---------------------------------------------------------------
INSERT INTO semester_bill(bill_id,semID,studentID) 
VALUES
(1, 7, 1),
(2, 8, 1),
(3, 9, 1),
(4, 10, 1),
(5, 11, 1),
(6, 12, 1),
(7, 13, 1),
(8, 14, 1),
(9, 15, 1),
(10, 16, 1),
(11, 17, 1),
(12, 18, 1),
(13, 19, 1),
(14, 20, 1),
(15, 21, 1),
(16, 22, 1),
(17, 23, 1),
(18, 24, 1),
(19, 25, 1),
(26, 1, 2),
(27, 2, 2),
(28, 3, 2),
(29, 4, 2),
(30, 5, 2),
(31, 6, 2),
(32, 7, 2),
(33, 8, 2),
(34, 9, 2),
(35, 10, 2),
(36, 11, 2),
(37, 12, 2),
(38, 13, 2),
(39, 11, 3),
(40, 12, 3),
(41, 13, 3),
(42, 14, 3),
(43, 15, 3),
(44, 16, 3),
(45, 17, 3),
(46, 18, 3),
(47, 19, 3),
(48, 20, 3),
(49, 21, 3),
(50, 22, 3),
(51, 23, 3),
(52, 24, 3),
(53, 25, 3),
(54, 4, 4),
(55, 5, 4),
(56, 6, 4),
(57, 7, 4),
(58, 8, 4),
(59, 9, 4),
(60, 10, 4),
(61, 11, 4),
(62, 12, 4),
(63, 13, 4),
(64, 14, 4),
(65, 15, 4),
(66, 16, 4),
(67, 17, 4),
(68, 15, 5),
(69, 16, 5),
(70, 17, 5),
(71, 9, 6),
(72, 10, 6),
(73, 11, 6),
(74, 12, 6),
(75, 13, 6),
(76, 14, 6),
(77, 15, 6),
(78, 16, 6),
(79, 17, 6),
(80, 18, 6),
(81, 19, 6),
(82, 20, 6),
(83, 21, 6),
(84, 22, 6),
(85, 23, 6),
(86, 24, 6),
(87, 25, 6),
(88, 9, 7),
(89, 10, 7),
(90, 11, 7),
(91, 12, 7),
(92, 13, 7),
(93, 14, 7),
(94, 15, 7),
(95, 16, 7),
(96, 17, 7),
(97, 18, 7),
(98, 19, 7),
(99, 20, 7),
(100, 21, 7),
(101, 22, 7),
(102, 23, 7),
(103, 24, 7),
(104, 25, 7),
(105, 1, 8),
(106, 2, 8),
(107, 3, 8),
(108, 4, 8),
(109, 16, 9),
(110, 17, 9),
(111, 18, 9),
(112, 19, 9),
(113, 20, 9),
(114, 21, 9),
(115, 22, 9),
(116, 23, 9),
(117, 24, 9),
(118, 25, 9),
(119, 5, 10),
(120, 6, 10),
(121, 7, 10),
(122, 8, 10),
(123, 9, 10),
(124, 10, 10),
(125, 11, 10),
(126, 12, 10),
(127, 13, 10),
(128, 14, 10),
(129, 15, 10),
(130, 16, 10),
(131, 17, 10),
(132, 22, 11),
(133, 23, 11),
(134, 24, 11),
(135, 25, 11);


-- ---------------------------------------------------------------
-- Table payment
-- ---------------------------------------------------------------

INSERT INTO payment (paymentRefID, paymentDate, bill_id, amount, paymentMethod, studentID)
	VALUES	(1, '2023-01-15', 1, 500.00, 'Cash', 1),
			(2, '2023-01-15', 2, 800.00, 'Cheque', 2),
			(3, '2023-01-15', 3, 600.00, 'Bank', 3),
			(4, '2023-04-30', 4, 750.00, 'Cash', 4),
			(5, '2023-05-15', 5, 900.00, 'Cheque', 5),
			(6, '2023-06-20', 6, 700.00, 'Bank', 6),
			(7, '2023-07-25', 7, 850.00, 'Cash', 7),
			(8, '2023-08-30', 8, 950.00, 'Cheque', 8),
			(9, '2023-09-15', 9, 720.00, 'Bank', 9),
			(10, '2023-10-20', 10, 830.00, 'Cash', 10);

-- ---------------------------------------------------------------
-- Table degree_programs
-- ---------------------------------------------------------------
            
INSERT INTO degree_programs(program_id, department_id, is_available, degree_type, program_name)
VALUES		(01, 1, 1, 'Undergraduate', 'General Theory'),
			(02, 1, 1, 'Graduate', 'Experimental Theory'),
			(03, 2, 1, 'Undergraduate', 'Composition for Advertising'),
			(04, 2, 0, 'Graduate', 'Composition for Cinema'),
			(05, 3, 0, 'Undergraduate', 'Flute'),
			(06, 3, 1, 'Graduate', 'Piano'),
			(07, 4, 1, 'Undergraduate', 'Musical Theatre'),
			(08, 4, 1, 'Graduate', 'Classical Vocal Performance'),
			(09, 5, 1, 'Undergraduate', 'Western Music History'),
			(10, 5, 0, 'Graduate', 'Music Prehistory'),
			(11, 6, 1, 'Undergraduate', 'Music Technology Design'),
			(12, 6, 0, 'Graduate', 'Audio Equipment Engineering'),
			(13, 7, 1, 'Undergraduate', 'Choral Pedagogy'),
			(14, 7, 1, 'Graduate', 'Old World Vocal Pedagogy'),
			(15, 8, 1, 'Undergraduate', 'Sound Engineering'),
			(16, 8, 0, 'Graduate', 'Advanced Sound Engineering'),
			(17, 9, 0, 'Undergraduate', 'Jazz Fusion Studies'),
			(18, 9, 1, 'Graduate', 'Experimental Jazz'),
			(19, 10, 0, 'Undergraduate', 'Music and Culture'),
			(20, 10, 1, 'Graduate', 'Kundiman Studies');

-- ---------------------------------------------------------------
-- Table college_degree
-- ---------------------------------------------------------------

INSERT INTO college_degree(degreeID,year,program_id,type,status,ge_id)
VALUES
	(1,2018,01,'Major','Ongoing',10001),
	(2,2016,03,'Major','Completed',10002),
	(3,2019,05,'Major','Dropped',10003),
	(4,2020,09,'Major','Ongoing',10003),
	(5,2017,07,'Major','Completed',10004),
	(6,2020,09,'Major','Dropped',10005),
	(7,2018,11,'Major','Ongoing',10006),
	(8,2019,13,'Major','Ongoing',10007),
	(9,2016,15,'Major','Dropped',10008),
	(10,2021,17,'Major','Ongoing',10009),
	(11,2017,19,'Major','Completed',10010),
	(12,2017,15,'Minor','Completed',10010),
    (13,2023,11,'Major','Ongoing',10011);


-- ---------------------------------------------------------------
-- Table course
-- ---------------------------------------------------------------

INSERT INTO course(courseID,courseName,units,instructorID,tuition_cost)
VALUES (10001, 'MTCourse1', 2, 80, 5729.00),
(10002, 'MTCourse2', 4, 62, 9920.00),
(10003, 'MTCourse3', 2, 36, 16050.00),
(10004, 'MTCourse4', 2, 92, 18530.00),
(10005, 'MTCourse5', 1, 36, 8326.00),
(10006, 'MTCourse6', 3, 62, 7909.00),
(10007, 'MTCourse7', 2, 92, 14414.00),
(10008, 'MTCourse8', 4, 62, 11301.00),
(10009, 'MTCourse9', 1, 36, 15097.00),
(10010, 'MTCourse10', 1, 3, 11255.00),
(10011, 'MTCourse11', 1, 92, 8916.00),
(10012, 'MTCourse12', 4, 21, 18930.00),
(10013, 'MTCourse13', 3, 80, 16975.00),
(10014, 'MTCourse14', 3, 3, 13540.00),
(10015, 'MTCourse15', 3, 3, 17780.00),
(10016, 'MTCourse16', 4, 92, 18315.00),
(10017, 'MTCourse17', 4, 3, 8908.00),
(10018, 'MTCourse18', 2, 80, 9448.00),
(10019, 'MTCourse19', 1, 92, 14936.00),
(10020, 'MTCourse20', 3, 21, 8513.00),
(10021, 'MTCourse21', 3, 92, 19713.00),
(10022, 'MTCourse22', 1, 36, 6940.00),
(10023, 'MTCourse23', 3, 36, 8108.00),
(10024, 'MTCourse24', 1, 3, 14779.00),
(10025, 'MTCourse25', 4, 21, 5702.00),
(10026, 'MTCourse26', 1, 80, 17489.00),
(10027, 'MTCourse27', 1, 62, 13095.00),
(10028, 'MTCourse28', 4, 80, 15655.00),
(10029, 'MTCourse29', 3, 80, 8062.00),
(10030, 'MTCourse30', 2, 80, 6691.00),
(20001, 'CCourse1', 1, 66, 18949.00),
(20002, 'CCourse2', 4, 64, 12684.00),
(20003, 'CCourse3', 3, 17, 10212.00),
(20004, 'CCourse4', 3, 66, 6675.00),
(20005, 'CCourse5', 2, 29, 14587.00),
(20006, 'CCourse6', 4, 90, 10158.00),
(20007, 'CCourse7', 4, 14, 12951.00),
(20008, 'CCourse8', 2, 64, 5244.00),
(20009, 'CCourse9', 4, 96, 19499.00),
(20010, 'CCourse10', 2, 14, 19503.00),
(20011, 'CCourse11', 2, 64, 7001.00),
(20012, 'CCourse12', 1, 17, 6621.00),
(20013, 'CCourse13', 4, 5, 16958.00),
(20014, 'CCourse14', 3, 64, 7139.00),
(20015, 'CCourse15', 4, 90, 14081.00),
(20016, 'CCourse16', 2, 13, 19989.00),
(20017, 'CCourse17', 1, 64, 18968.00),
(20018, 'CCourse18', 1, 99, 16796.00),
(20019, 'CCourse19', 2, 90, 6894.00),
(20020, 'CCourse20', 1, 94, 19612.00),
(20021, 'CCourse21', 3, 17, 16405.00),
(20022, 'CCourse22', 2, 89, 12305.00),
(20023, 'CCourse23', 4, 81, 5140.00),
(20024, 'CCourse24', 1, 13, 12710.00),
(20025, 'CCourse25', 4, 14, 12581.00),
(20026, 'CCourse26', 1, 29, 17849.00),
(20027, 'CCourse27', 2, 14, 5574.00),
(20028, 'CCourse28', 2, 66, 5534.00),
(20029, 'CCourse29', 2, 89, 9697.00),
(20030, 'CCourse30', 2, 96, 9015.00),
(20031, 'CCourse31', 1, 66, 12923.00),
(20032, 'CCourse32', 2, 5, 13301.00),
(20033, 'CCourse33', 3, 13, 17013.00),
(20034, 'CCourse34', 3, 13, 12837.00),
(20035, 'CCourse35', 4, 14, 10010.00),
(20036, 'CCourse36', 4, 14, 16650.00),
(20037, 'CCourse37', 1, 66, 17790.00),
(20038, 'CCourse38', 4, 13, 13210.00),
(20039, 'CCourse39', 1, 13, 9695.00),
(20040, 'CCourse40', 2, 99, 19880.00),
(20041, 'CCourse41', 3, 14, 10332.00),
(20042, 'CCourse42', 2, 99, 9054.00),
(20043, 'CCourse43', 4, 90, 19382.00),
(20044, 'CCourse44', 2, 66, 16013.00),
(20045, 'CCourse45', 4, 13, 10990.00),
(20046, 'CCourse46', 1, 99, 18147.00),
(20047, 'CCourse47', 2, 66, 15261.00),
(20048, 'CCourse48', 3, 94, 6991.00),
(20049, 'CCourse49', 1, 5, 5266.00),
(20050, 'CCourse50', 2, 89, 13195.00),
(20051, 'CCourse51', 2, 14, 6596.00),
(20052, 'CCourse52', 1, 99, 14143.00),
(30001, 'IPCourse1', 3, 48, 8635.00),
(30002, 'IPCourse2', 1, 51, 6902.00),
(30003, 'IPCourse3', 3, 42, 13659.00),
(30004, 'IPCourse4', 3, 69, 7744.00),
(30005, 'IPCourse5', 3, 7, 18416.00),
(30006, 'IPCourse6', 1, 24, 6859.00),
(30007, 'IPCourse7', 2, 22, 12540.00),
(30008, 'IPCourse8', 1, 16, 6404.00),
(30009, 'IPCourse9', 3, 55, 8946.00),
(30010, 'IPCourse10', 2, 48, 5396.00),
(30011, 'IPCourse11', 2, 11, 8760.00),
(30012, 'IPCourse12', 3, 11, 15363.00),
(30013, 'IPCourse13', 1, 95, 15974.00),
(30014, 'IPCourse14', 1, 51, 8199.00),
(30015, 'IPCourse15', 4, 95, 14370.00),
(30016, 'IPCourse16', 2, 95, 9549.00),
(30017, 'IPCourse17', 1, 72, 16457.00),
(30018, 'IPCourse18', 1, 83, 10939.00),
(30019, 'IPCourse19', 3, 22, 6979.00),
(30020, 'IPCourse20', 1, 22, 9375.00),
(30021, 'IPCourse21', 4, 12, 9324.00),
(30022, 'IPCourse22', 1, 16, 16784.00),
(30023, 'IPCourse23', 4, 48, 18059.00),
(30024, 'IPCourse24', 1, 83, 16727.00),
(30025, 'IPCourse25', 4, 12, 11337.00),
(30026, 'IPCourse26', 1, 72, 16073.00),
(30027, 'IPCourse27', 4, 11, 13887.00),
(30028, 'IPCourse28', 2, 72, 19732.00),
(30029, 'IPCourse29', 2, 11, 13996.00),
(30030, 'IPCourse30', 4, 95, 19923.00),
(30031, 'IPCourse31', 2, 95, 9658.00),
(30032, 'IPCourse32', 4, 7, 8160.00),
(30033, 'IPCourse33', 1, 72, 10988.00),
(30034, 'IPCourse34', 3, 16, 14309.00),
(30035, 'IPCourse35', 4, 72, 13302.00),
(30036, 'IPCourse36', 3, 7, 9847.00),
(30037, 'IPCourse37', 3, 55, 15345.00),
(30038, 'IPCourse38', 4, 22, 12816.00),
(30039, 'IPCourse39', 4, 12, 16986.00),
(30040, 'IPCourse40', 4, 22, 5360.00),
(30041, 'IPCourse41', 3, 55, 19173.00),
(30042, 'IPCourse42', 3, 95, 5134.00),
(30043, 'IPCourse43', 1, 72, 12867.00),
(30044, 'IPCourse44', 3, 22, 19664.00),
(30045, 'IPCourse45', 1, 83, 13613.00),
(30046, 'IPCourse46', 2, 55, 18637.00),
(30047, 'IPCourse47', 1, 34, 12548.00),
(30048, 'IPCourse48', 1, 72, 19827.00),
(40001, 'VPCourse1', 1, 73, 8638.00),
(40002, 'VPCourse2', 1, 46, 14649.00),
(40003, 'VPCourse3', 3, 25, 14910.00),
(40004, 'VPCourse4', 4, 78, 8366.00),
(40005, 'VPCourse5', 3, 100, 9274.00),
(40006, 'VPCourse6', 1, 74, 7868.00),
(40007, 'VPCourse7', 3, 47, 18553.00),
(40008, 'VPCourse8', 2, 84, 19136.00),
(40009, 'VPCourse9', 3, 23, 10762.00),
(40010, 'VPCourse10', 3, 78, 13024.00),
(40011, 'VPCourse11', 3, 100, 10668.00),
(40012, 'VPCourse12', 3, 25, 17473.00),
(40013, 'VPCourse13', 1, 74, 19087.00),
(40014, 'VPCourse14', 4, 23, 15566.00),
(40015, 'VPCourse15', 4, 100, 5758.00),
(40016, 'VPCourse16', 3, 78, 15031.00),
(40017, 'VPCourse17', 1, 73, 9394.00),
(40018, 'VPCourse18', 2, 46, 8197.00),
(40019, 'VPCourse19', 1, 61, 14236.00),
(40020, 'VPCourse20', 2, 63, 6936.00),
(40021, 'VPCourse21', 2, 73, 12966.00),
(40022, 'VPCourse22', 4, 84, 16748.00),
(40023, 'VPCourse23', 4, 61, 7278.00),
(40024, 'VPCourse24', 3, 61, 18406.00),
(40025, 'VPCourse25', 1, 73, 6912.00),
(40026, 'VPCourse26', 1, 46, 11390.00),
(40027, 'VPCourse27', 4, 61, 13607.00),
(40028, 'VPCourse28', 3, 74, 19955.00),
(40029, 'VPCourse29', 3, 100, 18400.00),
(40030, 'VPCourse30', 1, 46, 6709.00),
(40031, 'VPCourse31', 1, 61, 11172.00),
(40032, 'VPCourse32', 1, 25, 5443.00),
(40033, 'VPCourse33', 4, 25, 19992.00),
(40034, 'VPCourse34', 4, 73, 19745.00),
(40035, 'VPCourse35', 2, 23, 16082.00),
(40036, 'VPCourse36', 3, 25, 19718.00),
(40037, 'VPCourse37', 4, 84, 12169.00),
(40038, 'VPCourse38', 4, 73, 6048.00),
(40039, 'VPCourse39', 2, 84, 16249.00),
(40040, 'VPCourse40', 2, 73, 12236.00),
(40041, 'VPCourse41', 3, 100, 10346.00),
(40042, 'VPCourse42', 4, 84, 19046.00),
(40043, 'VPCourse43', 2, 46, 9125.00),
(40044, 'VPCourse44', 3, 23, 11569.00),
(50001, 'MHCourse1', 1, 82, 17579.00),
(50002, 'MHCourse2', 4, 82, 18037.00),
(50003, 'MHCourse3', 1, 58, 15938.00),
(50004, 'MHCourse4', 1, 41, 13719.00),
(50005, 'MHCourse5', 4, 20, 16097.00),
(50006, 'MHCourse6', 4, 19, 18534.00),
(50007, 'MHCourse7', 1, 33, 5627.00),
(50008, 'MHCourse8', 2, 2, 6032.00),
(50009, 'MHCourse9', 4, 20, 19668.00),
(50010, 'MHCourse10', 3, 82, 11996.00),
(50011, 'MHCourse11', 2, 28, 11336.00),
(50012, 'MHCourse12', 2, 33, 7435.00),
(50013, 'MHCourse13', 4, 91, 16776.00),
(50014, 'MHCourse14', 4, 28, 5619.00),
(50015, 'MHCourse15', 4, 41, 9338.00),
(50016, 'MHCourse16', 4, 68, 9434.00),
(50017, 'MHCourse17', 3, 28, 10379.00),
(50018, 'MHCourse18', 2, 32, 5475.00),
(50019, 'MHCourse19', 1, 58, 8412.00),
(50020, 'MHCourse20', 4, 68, 19632.00),
(50021, 'MHCourse21', 2, 54, 10630.00),
(50022, 'MHCourse22', 2, 54, 12917.00),
(50023, 'MHCourse23', 4, 41, 10492.00),
(50024, 'MHCourse24', 2, 50, 17180.00),
(50025, 'MHCourse25', 4, 91, 16340.00),
(50026, 'MHCourse26', 2, 28, 9763.00),
(50027, 'MHCourse27', 3, 91, 10769.00),
(50028, 'MHCourse28', 4, 2, 19198.00),
(50029, 'MHCourse29', 3, 97, 5424.00),
(50030, 'MHCourse30', 1, 32, 9665.00),
(50031, 'MHCourse31', 4, 68, 12308.00),
(50032, 'MHCourse32', 3, 41, 9719.00),
(50033, 'MHCourse33', 4, 54, 16080.00),
(50034, 'MHCourse34', 3, 97, 5944.00),
(50035, 'MHCourse35', 1, 97, 14289.00),
(50036, 'MHCourse36', 1, 82, 6666.00),
(50037, 'MHCourse37', 4, 68, 17854.00),
(50038, 'MHCourse38', 1, 33, 17439.00),
(50039, 'MHCourse39', 2, 97, 14748.00),
(50040, 'MHCourse40', 3, 20, 19023.00),
(50041, 'MHCourse41', 1, 2, 5386.00),
(50042, 'MHCourse42', 1, 2, 5914.00),
(50043, 'MHCourse43', 4, 20, 16686.00),
(50044, 'MHCourse44', 3, 97, 12668.00),
(50045, 'MHCourse45', 1, 97, 16291.00),
(50046, 'MHCourse46', 3, 68, 18501.00),
(50047, 'MHCourse47', 4, 28, 6792.00),
(50048, 'MHCourse48', 1, 2, 11300.00),
(50049, 'MHCourse49', 4, 97, 12797.00),
(50050, 'MHCourse50', 2, 33, 19264.00),
(50051, 'MHCourse51', 1, 28, 11044.00),
(50052, 'MHCourse52', 4, 28, 9426.00),
(50053, 'MHCourse53', 4, 97, 15994.00),
(50054, 'MHCourse54', 4, 41, 12058.00),
(50055, 'MHCourse55', 2, 82, 13873.00),
(50056, 'MHCourse56', 3, 20, 8988.00),
(60001, 'MTechCourse1', 4, 59, 10813.00),
(60002, 'MTechCourse2', 3, 15, 11413.00),
(60003, 'MTechCourse3', 3, 15, 19072.00),
(60004, 'MTechCourse4', 4, 59, 11923.00),
(60005, 'MTechCourse5', 2, 59, 17158.00),
(60006, 'MTechCourse6', 1, 31, 9989.00),
(60007, 'MTechCourse7', 1, 76, 14075.00),
(60008, 'MTechCourse8', 4, 59, 14649.00),
(60009, 'MTechCourse9', 1, 76, 8798.00),
(60010, 'MTechCourse10', 3, 76, 9014.00),
(60011, 'MTechCourse11', 2, 76, 15699.00),
(60012, 'MTechCourse12', 3, 15, 14372.00),
(60013, 'MTechCourse13', 2, 31, 18839.00),
(60014, 'MTechCourse14', 4, 31, 13323.00),
(60015, 'MTechCourse15', 3, 59, 14632.00),
(60016, 'MTechCourse16', 1, 15, 5860.00),
(60017, 'MTechCourse17', 3, 31, 13382.00),
(60018, 'MTechCourse18', 1, 76, 6103.00),
(60019, 'MTechCourse19', 2, 76, 19753.00),
(60020, 'MTechCourse20', 4, 15, 11818.00),
(60021, 'MTechCourse21', 2, 15, 14888.00),
(60022, 'MTechCourse22', 4, 15, 12626.00),
(60023, 'MTechCourse23', 1, 15, 8331.00),
(60024, 'MTechCourse24', 3, 31, 14505.00),
(60025, 'MTechCourse25', 2, 15, 19590.00),
(60026, 'MTechCourse26', 4, 31, 7973.00),
(60027, 'MTechCourse27', 2, 76, 11467.00),
(60028, 'MTechCourse28', 3, 15, 18713.00),
(60029, 'MTechCourse29', 4, 15, 6091.00),
(60030, 'MTechCourse30', 3, 76, 17594.00),
(60031, 'MTechCourse31', 3, 76, 16256.00),
(60032, 'MTechCourse32', 1, 59, 8952.00),
(60033, 'MTechCourse33', 1, 31, 9882.00),
(60034, 'MTechCourse34', 1, 76, 17415.00),
(60035, 'MTechCourse35', 3, 76, 10388.00),
(60036, 'MTechCourse36', 3, 31, 8217.00),
(70001, 'MEdCourse1', 3, 98, 16745.00),
(70002, 'MEdCourse2', 3, 65, 17982.00),
(70003, 'MEdCourse3', 4, 52, 13103.00),
(70004, 'MEdCourse4', 1, 26, 19232.00),
(70005, 'MEdCourse5', 1, 65, 12959.00),
(70006, 'MEdCourse6', 3, 37, 18733.00),
(70007, 'MEdCourse7', 2, 52, 5498.00),
(70008, 'MEdCourse8', 4, 37, 5241.00),
(70009, 'MEdCourse9', 4, 88, 7390.00),
(70010, 'MEdCourse10', 2, 52, 15035.00),
(70011, 'MEdCourse11', 2, 98, 10560.00),
(70012, 'MEdCourse12', 1, 79, 9055.00),
(70013, 'MEdCourse13', 3, 57, 13473.00),
(70014, 'MEdCourse14', 2, 52, 10174.00),
(70015, 'MEdCourse15', 2, 26, 10930.00),
(70016, 'MEdCourse16', 2, 26, 11131.00),
(70017, 'MEdCourse17', 2, 65, 14037.00),
(70018, 'MEdCourse18', 3, 40, 10018.00),
(70019, 'MEdCourse19', 2, 26, 5586.00),
(70020, 'MEdCourse20', 3, 35, 13294.00),
(70021, 'MEdCourse21', 3, 57, 16659.00),
(70022, 'MEdCourse22', 2, 57, 10487.00),
(70023, 'MEdCourse23', 2, 35, 17701.00),
(70024, 'MEdCourse24', 2, 98, 10327.00),
(70025, 'MEdCourse25', 2, 35, 17387.00),
(70026, 'MEdCourse26', 4, 57, 5984.00),
(70027, 'MEdCourse27', 2, 52, 11080.00),
(70028, 'MEdCourse28', 4, 26, 6020.00),
(70029, 'MEdCourse29', 2, 79, 12969.00),
(70030, 'MEdCourse30', 4, 9, 16319.00),
(70031, 'MEdCourse31', 4, 98, 15053.00),
(70032, 'MEdCourse32', 1, 57, 17789.00),
(70033, 'MEdCourse33', 4, 40, 6266.00),
(70034, 'MEdCourse34', 1, 79, 5884.00),
(70035, 'MEdCourse35', 3, 9, 19853.00),
(70036, 'MEdCourse36', 2, 9, 18910.00),
(70037, 'MEdCourse37', 1, 35, 11869.00),
(70038, 'MEdCourse38', 4, 98, 18381.00),
(70039, 'MEdCourse39', 3, 35, 17876.00),
(70040, 'MEdCourse40', 4, 57, 11282.00),
(70041, 'MEdCourse41', 1, 88, 19331.00),
(70042, 'MEdCourse42', 1, 37, 17165.00),
(70043, 'MEdCourse43', 3, 26, 14305.00),
(70044, 'MEdCourse44', 2, 65, 8467.00),
(80001, 'SECourse1', 1, 71, 8691.00),
(80002, 'SECourse2', 1, 75, 14251.00),
(80003, 'SECourse3', 4, 38, 13900.00),
(80004, 'SECourse4', 4, 49, 10907.00),
(80005, 'SECourse5', 2, 49, 12413.00),
(80006, 'SECourse6', 3, 6, 16875.00),
(80007, 'SECourse7', 3, 67, 15854.00),
(80008, 'SECourse8', 3, 93, 11376.00),
(80009, 'SECourse9', 3, 77, 13062.00),
(80010, 'SECourse10', 3, 49, 9803.00),
(80011, 'SECourse11', 3, 38, 6586.00),
(80012, 'SECourse12', 2, 67, 5634.00),
(80013, 'SECourse13', 4, 67, 18739.00),
(80014, 'SECourse14', 2, 6, 18553.00),
(80015, 'SECourse15', 3, 6, 5355.00),
(80016, 'SECourse16', 1, 49, 18941.00),
(80017, 'SECourse17', 3, 67, 14699.00),
(80018, 'SECourse18', 3, 75, 10621.00),
(80019, 'SECourse19', 4, 71, 15028.00),
(80020, 'SECourse20', 3, 71, 9277.00),
(80021, 'SECourse21', 4, 77, 18064.00),
(80022, 'SECourse22', 1, 93, 19200.00),
(80023, 'SECourse23', 4, 67, 19396.00),
(80024, 'SECourse24', 2, 67, 9425.00),
(80025, 'SECourse25', 4, 49, 15501.00),
(80026, 'SECourse26', 1, 6, 15422.00),
(80027, 'SECourse27', 4, 67, 16539.00),
(80028, 'SECourse28', 2, 6, 18490.00),
(80029, 'SECourse29', 3, 49, 18390.00),
(80030, 'SECourse30', 3, 6, 18629.00),
(80031, 'SECourse31', 4, 6, 19892.00),
(80032, 'SECourse32', 1, 71, 16803.00),
(90001, 'JSCourse1', 2, 60, 9085.00),
(90002, 'JSCourse2', 3, 86, 17466.00),
(90003, 'JSCourse3', 4, 30, 9714.00),
(90004, 'JSCourse4', 2, 4, 6018.00),
(90005, 'JSCourse5', 3, 43, 15226.00),
(90006, 'JSCourse6', 3, 18, 12923.00),
(90007, 'JSCourse7', 1, 4, 16388.00),
(90008, 'JSCourse8', 3, 43, 14070.00),
(90009, 'JSCourse9', 4, 43, 15206.00),
(90010, 'JSCourse10', 2, 4, 18995.00),
(90011, 'JSCourse11', 2, 60, 5312.00),
(90012, 'JSCourse12', 1, 43, 16903.00),
(90013, 'JSCourse13', 1, 43, 12694.00),
(90014, 'JSCourse14', 3, 4, 14877.00),
(90015, 'JSCourse15', 3, 30, 5416.00),
(90016, 'JSCourse16', 4, 4, 14210.00),
(90017, 'JSCourse17', 3, 43, 6376.00),
(90018, 'JSCourse18', 4, 60, 15304.00),
(90019, 'JSCourse19', 3, 1, 15392.00),
(90020, 'JSCourse20', 2, 1, 5281.00),
(90021, 'JSCourse21', 2, 30, 11845.00),
(90022, 'JSCourse22', 4, 86, 15494.00),
(90023, 'JSCourse23', 4, 60, 17915.00),
(90024, 'JSCourse24', 4, 18, 16459.00),
(90025, 'JSCourse25', 4, 60, 6087.00),
(90026, 'JSCourse26', 3, 86, 17936.00),
(90027, 'JSCourse27', 4, 4, 10939.00),
(90028, 'JSCourse28', 1, 18, 11631.00),
(100001, 'EthCourse1', 2, 39, 5345.00),
(100002, 'EthCourse2', 4, 8, 15994.00),
(100003, 'EthCourse3', 4, 85, 6275.00),
(100004, 'EthCourse4', 1, 44, 15967.00),
(100005, 'EthCourse5', 2, 56, 7921.00),
(100006, 'EthCourse6', 3, 53, 9269.00),
(100007, 'EthCourse7', 4, 10, 6097.00),
(100008, 'EthCourse8', 3, 39, 17729.00),
(100009, 'EthCourse9', 2, 53, 14748.00),
(100010, 'EthCourse10', 1, 85, 8772.00),
(100011, 'EthCourse11', 3, 10, 16156.00),
(100012, 'EthCourse12', 4, 10, 11089.00),
(100013, 'EthCourse13', 4, 45, 5474.00),
(100014, 'EthCourse14', 2, 10, 12781.00),
(100015, 'EthCourse15', 4, 39, 16269.00),
(100016, 'EthCourse16', 1, 10, 11137.00),
(100017, 'EthCourse17', 2, 53, 17224.00),
(100018, 'EthCourse18', 1, 45, 17054.00),
(100019, 'EthCourse19', 3, 53, 15768.00),
(100020, 'EthCourse20', 1, 39, 6903.00),
(100021, 'EthCourse21', 1, 45, 11744.00),
(100022, 'EthCourse22', 2, 8, 7220.00),
(100023, 'EthCourse23', 1, 53, 15204.00),
(100024, 'EthCourse24', 2, 27, 18920.00),
(100025, 'EthCourse25', 4, 53, 14767.00),
(100026, 'EthCourse26', 4, 39, 16488.00),
(100027, 'EthCourse27', 2, 70, 19617.00),
(100028, 'EthCourse28', 2, 85, 16989.00),
(100029, 'EthCourse29', 2, 27, 17960.00),
(100030, 'EthCourse30', 3, 44, 7297.00),
(100031, 'EthCourse31', 4, 56, 16873.00),
(100032, 'EthCourse32', 3, 44, 12947.00),
(100033, 'EthCourse33', 2, 10, 10571.00),
(100034, 'EthCourse34', 4, 8, 9886.00),
(100035, 'EthCourse35', 2, 56, 13985.00),
(100036, 'EthCourse36', 3, 27, 19180.00),
(100037, 'EthCourse37', 4, 8, 8266.00),
(100038, 'EthCourse38', 3, 44, 19570.00),
(100039, 'EthCourse39', 1, 85, 15543.00),
(100040, 'EthCourse40', 3, 53, 14337.00);

-- ---------------------------------------------------------------
-- Table prerequisites
-- ---------------------------------------------------------------

INSERT INTO prerequisites(pre_id,prerequisite_id,course_id)
VALUES
(1,10002,10009),
(2,10002,10012),
(3,10005,10012),
(4,10012,10015),
(5,20004,20013),
(6,20004,20015),
(7,20015,20039),
(8,20012,20022),
(9,30001,30003),
(10,30003,30044),
(11,30012,30015),
(12,30012,30025),
(13,40010,40038),
(14,40012,40038),
(15,40011,40038),
(16,40013,40017),
(17,50005,50011),
(18,50012,50015),
(19,50033,50034),
(20,50030,50055),
(21,60002,60004),
(22,60012,60010),
(23,60006,60010),
(24,60012,60022),
(25,70001,70010),
(26,70001,70005),
(27,70008,70031),
(28,70009,70044),
(29,80002,80028),
(30,80016,80026),
(31,80020,80021),
(32,80019,80031),
(33,90003,90015),
(34,90004,90015),
(35,90011,90012),
(36,90012,90014),
(37,100013,100015),
(38,100019,100039),
(39,100020,100040),
(40,100011,100015);

-- ---------------------------------------------------------------
-- Table course_enrollment
-- ---------------------------------------------------------------
INSERT INTO course_enrollment(c_enroll_id,student_id,course_id,c_grade,semID,status,is_retake)
VALUES

(10,11,60001,3.0,22,'Completed',0),
(11,11,60002,3.5,22,'Completed',0),
(12,11,60003,3.0,22,'Completed',0),
(13,11,60005,2.5,22,'Completed',0),
(14,11,60004,3.5,23,'Completed',0),
(15,11,60006,3.5,23,'Completed',0),
(16,11,60012,3.0,23,'Completed',0),
(17,11,60010,3.0,24,'Completed',0),
(18,11,60022,0.0,24,'Failed',0),
(19,11,60013,3.5,24,'Completed',0),
(20,11,60015,3.5,24,'Completed',0),
(21,11,60017,2.0,25,'Ongoing',0),
(22,11,60022,3.5,25,'Ongoing',1),
(23,11,60016,3.5,25,'Ongoing',0),
(24, 1, 10006, 3.5, 7, 'Completed', 0),
(25, 1, 10009, 2.5, 7, 'Completed', 0),
(26, 1, 10011, 0.0, 7, 'Failed', 0),
(27, 1, 10014, 0.0, 7, 'Dropped', 0),
(28, 1, 10019, 2.5, 8, 'Completed', 0),
(29, 1, 10022, 3.5, 8, 'Completed', 0),
(30, 1, 10011, 2.0, 8, 'Completed', 1),
(31, 1, 10030, 0.0, 8, 'Dropped', 0),
(32, 1, 20002, 3.5, 8, 'Completed', 0),
(33, 1, 20009, 2.5, 8, 'Completed', 0),
(34, 1, 20014, 1.0, 9, 'Completed', 0),
(35, 1, 20016, 2.0, 9, 'Completed', 0),
(36, 1, 20017, 2.0, 9, 'Completed', 0),
(37, 1, 20020, 3.5, 10, 'Completed', 0),
(38, 1, 20022, 3.5, 10, 'Completed', 0),
(39, 1, 20024, 2.0, 10, 'Completed', 0),
(40, 1, 20025, 1.5, 10, 'Completed', 0),
(41, 1, 20028, 3.5, 10, 'Completed', 0),
(42, 1, 20033, 3.5, 11, 'Completed', 0),
(43, 1, 20036, 2.5, 11, 'Completed', 0),
(44, 1, 20040, 3.0, 11, 'Completed', 0),
(45, 1, 20045, 0.0, 11, 'Failed', 0),
(46, 1, 20050, 2.0, 11, 'Completed', 0),
(47, 1, 30003, 1.5, 11, 'Completed', 0),
(48, 1, 30005, 4.0, 12, 'Completed', 0),
(49, 1, 30010, 2.0, 12, 'Completed', 0),
(50, 1, 30012, 3.0, 12, 'Completed', 0),
(51, 1, 30017, 4.0, 12, 'Completed', 0),
(52, 1, 30020, 3.0, 13, 'Completed', 0),
(53, 1, 20045, 3.5, 13, 'Completed', 1),
(54, 1, 30026, 1.5, 13, 'Completed', 0),
(55, 1, 30030, 2.5, 13, 'Completed', 0),
(56, 1, 30035, 3.5, 13, 'Completed', 0),
(57, 1, 30040, 0.0, 14, 'Dropped', 0),
(58, 1, 30043, 2.0, 14, 'Completed', 0),
(59, 1, 30044, 3.5, 14, 'Completed', 0),
(60, 1, 30048, 3.5, 14, 'Completed', 0),
(61, 1, 40005, 1.5, 14, 'Completed', 0),
(62, 1, 40007, 3.0, 15, 'Completed', 0),
(63, 1, 40010, 0.0, 15, 'Dropped', 0),
(64, 1, 40013, 3.5, 15, 'Completed', 0),
(65, 1, 40018, 1.5, 16, 'Completed', 0),
(66, 1, 40022, 0.0, 16, 'Dropped', 0),
(67, 1, 40025, 3.0, 16, 'Completed', 0),
(68, 1, 40028, 4.0, 17, 'Completed', 0),
(69, 1, 40029, 1.5, 17, 'Completed', 0),
(70, 1, 40031, 3.5, 17, 'Completed', 0),
(71, 1, 40036, 2.0, 17, 'Completed', 0),
(72, 1, 40038, 4.0, 17, 'Completed', 0),
(73, 1, 40039, 4.0, 17, 'Completed', 0),
(74, 1, 40044, 0.0, 17, 'Failed', 0),
(75, 1, 50005, 1.5, 18, 'Completed', 0),
(76, 1, 50007, 2.0, 18, 'Completed', 0),
(77, 1, 50008, 4.0, 18, 'Completed', 0),
(78, 1, 50013, 3.0, 18, 'Completed', 0),
(79, 1, 50017, 0.0, 19, 'Failed', 0),
(80, 1, 50018, 2.5, 19, 'Completed', 0),
(81, 1, 50019, 2.0, 19, 'Completed', 0),
(82, 1, 50024, 1.5, 20, 'Completed', 0),
(83, 1, 50028, 1.0, 20, 'Completed', 0),
(84, 1, 50032, 4.0, 20, 'Completed', 0),
(85, 1, 50037, 3.5, 20, 'Completed', 0),
(86, 1, 50041, 4.0, 20, 'Completed', 0),
(87, 1, 50043, 2.5, 20, 'Completed', 0),
(88, 1, 50045, 1.0, 21, 'Completed', 0),
(89, 1, 50048, 3.0, 21, 'Completed', 0),
(90, 1, 50051, 2.5, 21, 'Completed', 0),
(91, 1, 50053, 2.5, 21, 'Completed', 0),
(92, 1, 60001, 3.0, 22, 'Completed', 0),
(93, 1, 60003, 1.5, 22, 'Completed', 0),
(94, 1, 60005, 1.0, 22, 'Completed', 0),
(95, 1, 60006, 1.0, 22, 'Completed', 0),
(96, 1, 60008, 4.0, 22, 'Completed', 0),
(97, 1, 60012, 3.5, 22, 'Completed', 0),
(98, 1, 60017, 1.0, 22, 'Completed', 0),
(99, 1, 60019, 1.5, 23, 'Completed', 0),
(100, 1, 60020, 1.5, 23, 'Completed', 0),
(101, 1, 60025, 3.0, 23, 'Completed', 0),
(102, 1, 60027, 3.0, 23, 'Completed', 0),
(103, 1, 60032, 3.5, 23, 'Completed', 0),
(104, 1, 60033, 1.0, 24, 'Completed', 0),
(105, 1, 60036, 1.5, 24, 'Completed', 0),
(106, 1, 70004, 2.0, 24, 'Completed', 0),
(107, 1, 70005, 1.0, 24, 'Completed', 0),
(108, 1, 70009, 0.0, 24, 'Failed', 0),
(109, 1, 70012, 1.5, 24, 'Completed', 0),
(110, 1, 70016, 3.0, 24, 'Completed', 0),
(111, 1, 70009, 2.5, 25, 'Ongoing', 1),
(112, 1, 70023, 1.0, 25, 'Ongoing', 0),
(113, 1, 70028, 1.5, 25, 'Ongoing', 0),
(114, 1, 70030, 1.5, 25, 'Ongoing', 0),
(116, 2, 10006, 1.0, 1, 'Completed', 0),
(117, 2, 10010, 3.0, 1, 'Completed', 0),
(118, 2, 10011, 2.0, 1, 'Completed', 0),
(119, 2, 10012, 3.5, 2, 'Completed', 0),
(120, 2, 10014, 4.0, 2, 'Completed', 0),
(121, 2, 10019, 1.5, 2, 'Completed', 0),
(122, 2, 10023, 3.0, 3, 'Completed', 0),
(123, 2, 10024, 3.5, 3, 'Completed', 0),
(124, 2, 10026, 2.5, 3, 'Completed', 0),
(125, 2, 10029, 3.0, 3, 'Completed', 0),
(126, 2, 10030, 4.0, 3, 'Completed', 0),
(127, 2, 20001, 1.0, 4, 'Completed', 0),
(128, 2, 20004, 3.0, 4, 'Completed', 0),
(129, 2, 20007, 2.5, 4, 'Completed', 0),
(130, 2, 20011, 3.0, 5, 'Completed', 0),
(131, 2, 20013, 3.5, 5, 'Completed', 0),
(132, 2, 20018, 1.5, 5, 'Completed', 0),
(133, 2, 20021, 3.0, 6, 'Completed', 0),
(134, 2, 20025, 4.0, 6, 'Completed', 0),
(135, 2, 20026, 4.0, 6, 'Completed', 0),
(136, 2, 20030, 1.0, 6, 'Completed', 0),
(137, 2, 20033, 2.5, 6, 'Completed', 0),
(138, 2, 20037, 3.0, 6, 'Completed', 0),
(139, 2, 20038, 2.0, 7, 'Completed', 0),
(140, 2, 20043, 2.5, 7, 'Completed', 0),
(141, 2, 20048, 3.0, 7, 'Completed', 0),
(142, 2, 20050, 2.0, 7, 'Completed', 0),
(143, 2, 30002, 4.0, 8, 'Completed', 0),
(144, 2, 30005, 2.5, 8, 'Completed', 0),
(145, 2, 30006, 2.5, 8, 'Completed', 0),
(146, 2, 30009, 1.0, 8, 'Completed', 0),
(147, 2, 30012, 1.5, 9, 'Completed', 0),
(148, 2, 30016, 3.5, 9, 'Completed', 0),
(149, 2, 30021, 3.0, 9, 'Completed', 0),
(150, 2, 30023, 3.5, 9, 'Completed', 0),
(151, 2, 30027, 3.5, 9, 'Completed', 0),
(152, 2, 30030, 3.5, 9, 'Completed', 0),
(153, 2, 30033, 4.0, 10, 'Completed', 0),
(154, 2, 30038, 3.0, 10, 'Completed', 0),
(155, 2, 30039, 2.5, 10, 'Completed', 0),
(156, 2, 30044, 1.5, 10, 'Completed', 0),
(157, 2, 30045, 3.0, 10, 'Completed', 0),
(158, 2, 40001, 1.0, 11, 'Completed', 0),
(159, 2, 40006, 1.5, 11, 'Completed', 0),
(160, 2, 40008, 2.0, 11, 'Completed', 0),
(161, 2, 40011, 4.0, 11, 'Completed', 0),
(162, 2, 40016, 2.0, 11, 'Completed', 0),
(163, 2, 40020, 4.0, 11, 'Completed', 0),
(164, 2, 40023, 2.0, 12, 'Completed', 0),
(165, 2, 40025, 4.0, 12, 'Completed', 0),
(166, 2, 40026, 0.0, 12, 'Dropped', 0),
(167, 2, 40031, 3.0, 12, 'Completed', 0),
(168, 2, 40033, 4.0, 12, 'Completed', 0),
(169, 2, 40036, 2.0, 13, 'Completed', 0),
(170, 2, 40040, 3.5, 13, 'Completed', 0),
(171, 2, 40041, 2.0, 13, 'Completed', 0),
(172, 2, 50002, 3.0, 13, 'Completed', 0),
(173, 2, 50003, 2.0, 13, 'Completed', 0),
(174, 2, 50006, 4.0, 13, 'Completed', 0),
(175, 3, 10003, 3.5, 11, 'Completed', 0),
(176, 3, 10004, 3.0, 11, 'Completed', 0),
(177, 3, 10005, 1.0, 11, 'Completed', 0),
(178, 3, 10010, 2.5, 11, 'Completed', 0),
(179, 3, 10015, 2.0, 11, 'Completed', 0),
(180, 3, 10016, 1.5, 11, 'Completed', 0),
(181, 3, 10019, 2.5, 12, 'Completed', 0),
(182, 3, 10023, 3.5, 12, 'Completed', 0),
(183, 3, 10028, 3.5, 12, 'Completed', 0),
(184, 3, 10030, 3.0, 12, 'Completed', 0),
(185, 3, 20001, 1.5, 12, 'Completed', 0),
(186, 3, 20004, 2.5, 13, 'Completed', 0),
(187, 3, 20005, 2.0, 13, 'Completed', 0),
(188, 3, 20007, 0.0, 13, 'Failed', 0),
(189, 3, 20011, 1.0, 13, 'Completed', 0),
(190, 3, 20013, 2.0, 14, 'Completed', 0),
(191, 3, 20018, 3.0, 14, 'Completed', 0),
(192, 3, 20019, 3.0, 14, 'Completed', 0),
(193, 3, 20022, 3.5, 14, 'Completed', 0),
(194, 3, 20024, 2.0, 15, 'Completed', 0),
(195, 3, 20025, 3.0, 15, 'Completed', 0),
(196, 3, 20030, 1.0, 15, 'Completed', 0),
(197, 3, 20035, 4.0, 15, 'Completed', 0),
(198, 3, 20036, 2.5, 16, 'Completed', 0),
(199, 3, 20041, 2.0, 16, 'Completed', 0),
(200, 3, 20044, 1.0, 16, 'Completed', 0),
(201, 3, 20048, 3.5, 17, 'Completed', 0),
(202, 3, 20052, 2.5, 17, 'Completed', 0),
(203, 3, 30005, 4.0, 17, 'Completed', 0),
(204, 3, 30007, 2.0, 17, 'Completed', 0),
(205, 3, 30008, 4.0, 17, 'Completed', 0),
(206, 3, 30012, 3.0, 18, 'Completed', 0),
(207, 3, 30015, 2.0, 18, 'Completed', 0),
(208, 3, 30018, 4.0, 18, 'Completed', 0),
(209, 3, 30019, 2.0, 18, 'Completed', 0),
(210, 3, 30024, 3.0, 19, 'Completed', 0),
(211, 3, 30027, 1.5, 19, 'Completed', 0),
(212, 3, 30028, 2.5, 19, 'Completed', 0),
(213, 3, 30032, 4.0, 20, 'Completed', 0),
(214, 3, 30033, 1.5, 20, 'Completed', 0),
(215, 3, 30036, 4.0, 20, 'Completed', 0),
(216, 3, 30039, 2.0, 20, 'Completed', 0),
(217, 3, 30040, 3.0, 20, 'Completed', 0),
(218, 3, 30041, 1.0, 20, 'Completed', 0),
(219, 3, 30042, 2.5, 21, 'Completed', 0),
(220, 3, 30044, 1.0, 21, 'Completed', 0),
(221, 3, 30045, 2.0, 21, 'Completed', 0),
(222, 3, 40001, 1.0, 22, 'Completed', 0),
(223, 3, 40002, 2.5, 22, 'Completed', 0),
(224, 3, 40003, 4.0, 22, 'Completed', 0),
(225, 3, 40008, 3.0, 22, 'Completed', 0),
(226, 3, 40009, 3.0, 22, 'Completed', 0),
(227, 3, 40012, 2.0, 22, 'Completed', 0),
(228, 3, 40017, 1.0, 23, 'Completed', 0),
(229, 3, 40019, 1.0, 23, 'Completed', 0),
(230, 3, 40023, 4.0, 23, 'Completed', 0),
(231, 3, 40026, 3.0, 23, 'Completed', 0),
(232, 3, 40028, 4.0, 23, 'Completed', 0),
(233, 3, 40033, 4.0, 23, 'Completed', 0),
(234, 3, 40034, 1.0, 24, 'Completed', 0),
(235, 3, 40039, 0.0, 24, 'Failed', 0),
(236, 3, 40044, 1.0, 24, 'Completed', 0),
(237, 3, 50003, 3.5, 24, 'Completed', 0),
(238, 3, 50005, 1.0, 24, 'Completed', 0),
(239, 3, 50008, 4.0, 25, 'Ongoing', 0),
(240, 3, 50012, 2.5, 25, 'Ongoing', 0),
(241, 3, 50015, 1.5, 25, 'Ongoing', 0),
(242, 3, 50019, 3.0, 25, 'Ongoing', 0),
(243, 3, 50024, 2.5, 25, 'Ongoing', 0),
(244, 4, 10006, 0.0, 4, 'Dropped', 0),
(245, 4, 10010, 3.5, 4, 'Completed', 0),
(246, 4, 10015, 2.5, 4, 'Completed', 0),
(247, 4, 10016, 1.5, 4, 'Completed', 0),
(248, 4, 10020, 3.0, 5, 'Completed', 0),
(249, 4, 10024, 2.0, 5, 'Completed', 0),
(250, 4, 10028, 1.5, 5, 'Completed', 0),
(251, 4, 10030, 3.5, 5, 'Completed', 0),
(252, 4, 20005, 1.0, 5, 'Completed', 0),
(253, 4, 20006, 3.5, 5, 'Completed', 0),
(254, 4, 20008, 2.5, 5, 'Completed', 0),
(255, 4, 20009, 2.5, 6, 'Completed', 0),
(256, 4, 20012, 0.0, 6, 'Dropped', 0),
(257, 4, 20017, 3.5, 6, 'Completed', 0),
(258, 4, 20018, 1.0, 6, 'Completed', 0),
(259, 4, 20023, 2.5, 7, 'Completed', 0),
(260, 4, 20024, 3.5, 7, 'Completed', 0),
(261, 4, 20029, 2.5, 7, 'Completed', 0),
(262, 4, 20034, 2.0, 7, 'Completed', 0),
(263, 4, 20035, 2.0, 7, 'Completed', 0),
(264, 4, 20038, 2.5, 8, 'Completed', 0),
(265, 4, 20041, 3.5, 8, 'Completed', 0),
(266, 4, 20044, 0.0, 8, 'Failed', 0),
(267, 4, 20048, 2.0, 8, 'Completed', 0),
(268, 4, 20051, 1.5, 8, 'Completed', 0),
(269, 4, 30003, 4.0, 8, 'Completed', 0),
(270, 4, 30005, 3.0, 8, 'Completed', 0),
(271, 4, 30010, 1.0, 9, 'Completed', 0),
(272, 4, 20044, 3.5, 9, 'Completed', 1),
(273, 4, 30015, 3.0, 9, 'Completed', 0),
(274, 4, 30020, 2.5, 9, 'Completed', 0),
(275, 4, 30025, 1.0, 10, 'Completed', 0),
(276, 4, 30027, 3.5, 10, 'Completed', 0),
(277, 4, 30029, 4.0, 10, 'Completed', 0),
(278, 4, 30033, 1.5, 10, 'Completed', 0),
(279, 4, 30037, 0.0, 10, 'Dropped', 0),
(280, 4, 30040, 1.0, 10, 'Completed', 0),
(281, 4, 30041, 1.0, 10, 'Completed', 0),
(282, 4, 30042, 3.0, 11, 'Completed', 0),
(283, 4, 30044, 1.0, 11, 'Completed', 0),
(284, 4, 40001, 4.0, 11, 'Completed', 0),
(285, 4, 40002, 3.0, 12, 'Completed', 0),
(286, 4, 40004, 1.5, 12, 'Completed', 0),
(287, 4, 40009, 2.5, 12, 'Completed', 0),
(288, 4, 40010, 1.0, 12, 'Completed', 0),
(289, 4, 40015, 1.5, 13, 'Completed', 0),
(290, 4, 40016, 1.5, 13, 'Completed', 0),
(291, 4, 40019, 1.0, 13, 'Completed', 0),
(292, 4, 40024, 1.5, 13, 'Completed', 0),
(293, 4, 40029, 3.0, 13, 'Completed', 0),
(294, 4, 40034, 1.0, 13, 'Completed', 0),
(295, 4, 40037, 2.0, 13, 'Completed', 0),
(296, 4, 40040, 2.5, 14, 'Completed', 0),
(297, 4, 40043, 3.0, 14, 'Completed', 0),
(298, 4, 50002, 4.0, 14, 'Completed', 0),
(299, 4, 50005, 3.5, 14, 'Completed', 0),
(300, 4, 50007, 3.5, 14, 'Completed', 0),
(301, 4, 50011, 3.0, 14, 'Completed', 0),
(302, 4, 50014, 3.5, 14, 'Completed', 0),
(303, 4, 50016, 3.0, 15, 'Completed', 0),
(304, 4, 50019, 4.0, 15, 'Completed', 0),
(305, 4, 50023, 4.0, 15, 'Completed', 0),
(306, 4, 50027, 2.0, 15, 'Completed', 0),
(307, 4, 50029, 1.5, 15, 'Completed', 0),
(308, 4, 50032, 2.5, 15, 'Completed', 0),
(309, 4, 50035, 3.0, 16, 'Completed', 0),
(310, 4, 50038, 2.5, 16, 'Completed', 0),
(311, 4, 50039, 4.0, 16, 'Completed', 0),
(312, 4, 50041, 4.0, 16, 'Completed', 0),
(313, 4, 50044, 4.0, 17, 'Completed', 0),
(314, 4, 50045, 1.5, 17, 'Completed', 0),
(315, 4, 50050, 3.5, 17, 'Completed', 0),
(316, 5, 10008, 4.0, 15, 'Completed', 0),
(317, 5, 10012, 2.0, 15, 'Completed', 0),
(318, 5, 10016, 1.0, 15, 'Completed', 0),
(319, 5, 10017, 1.5, 15, 'Completed', 0),
(320, 5, 10019, 4.0, 15, 'Completed', 0),
(321, 5, 10023, 2.5, 15, 'Completed', 0),
(322, 5, 10026, 0.0, 16, 'Failed', 0),
(323, 5, 10030, 2.5, 16, 'Completed', 0),
(324, 5, 20001, 3.0, 16, 'Completed', 0),
(325, 5, 20004, 2.0, 16, 'Completed', 0),
(326, 5, 20006, 3.5, 16, 'Completed', 0),
(327, 5, 20007, 2.5, 16, 'Completed', 0),
(328, 5, 20011, 3.0, 17, 'Completed', 0),
(329, 5, 20013, 1.0, 17, 'Completed', 0),
(330, 5, 20018, 2.5, 17, 'Completed', 0),
(331, 5, 10026, 3.5, 17, 'Completed', 1),
(332, 5, 20025, 0.0, 17, 'Failed', 0),
(333, 6, 10004, 1.5, 9, 'Completed', 0),
(334, 6, 10006, 4.0, 9, 'Completed', 0),
(335, 6, 10009, 1.0, 9, 'Completed', 0),
(336, 6, 10012, 4.0, 9, 'Completed', 0),
(337, 6, 10014, 4.0, 9, 'Completed', 0),
(338, 6, 10017, 3.5, 9, 'Completed', 0),
(339, 6, 10018, 1.5, 9, 'Completed', 0),
(340, 6, 10021, 1.0, 10, 'Completed', 0),
(341, 6, 10025, 3.0, 10, 'Completed', 0),
(342, 6, 10027, 3.5, 10, 'Completed', 0),
(343, 6, 20001, 1.5, 10, 'Completed', 0),
(344, 6, 20005, 1.5, 10, 'Completed', 0),
(345, 6, 20006, 1.0, 10, 'Completed', 0),
(346, 6, 20007, 2.5, 11, 'Completed', 0),
(347, 6, 20009, 2.5, 11, 'Completed', 0),
(348, 6, 20014, 2.0, 11, 'Completed', 0),
(349, 6, 20018, 1.0, 11, 'Completed', 0),
(350, 6, 20019, 2.0, 11, 'Completed', 0),
(351, 6, 20021, 3.0, 11, 'Completed', 0),
(352, 6, 20022, 1.0, 12, 'Completed', 0),
(353, 6, 20023, 3.0, 12, 'Completed', 0),
(354, 6, 20025, 4.0, 12, 'Completed', 0),
(355, 6, 20028, 4.0, 12, 'Completed', 0),
(356, 6, 20031, 4.0, 12, 'Completed', 0),
(357, 6, 20032, 2.5, 13, 'Completed', 0),
(358, 6, 20035, 1.0, 13, 'Completed', 0),
(359, 6, 20040, 2.0, 13, 'Completed', 0),
(360, 6, 20041, 2.5, 13, 'Completed', 0),
(361, 6, 20044, 3.5, 13, 'Completed', 0),
(362, 6, 20046, 3.5, 14, 'Completed', 0),
(363, 6, 20051, 1.0, 14, 'Completed', 0),
(364, 6, 20052, 1.5, 14, 'Completed', 0),
(365, 6, 30002, 4.0, 14, 'Completed', 0),
(366, 6, 30003, 3.0, 14, 'Completed', 0),
(367, 6, 30006, 2.5, 15, 'Completed', 0),
(368, 6, 30008, 3.0, 15, 'Completed', 0),
(369, 6, 30009, 3.0, 15, 'Completed', 0),
(370, 6, 30013, 1.0, 16, 'Completed', 0),
(371, 6, 30018, 1.5, 16, 'Completed', 0),
(372, 6, 30021, 3.5, 16, 'Completed', 0),
(373, 6, 30022, 2.5, 16, 'Completed', 0),
(374, 6, 30026, 1.0, 16, 'Completed', 0),
(375, 6, 30027, 1.5, 17, 'Completed', 0),
(376, 6, 30028, 2.0, 17, 'Completed', 0),
(377, 6, 30033, 2.5, 17, 'Completed', 0),
(378, 6, 30035, 1.5, 17, 'Completed', 0),
(379, 6, 30040, 4.0, 17, 'Completed', 0),
(380, 6, 30044, 1.0, 17, 'Completed', 0),
(381, 6, 30047, 3.5, 17, 'Completed', 0),
(382, 6, 40002, 1.0, 18, 'Completed', 0),
(383, 6, 40007, 2.0, 18, 'Completed', 0),
(384, 6, 40010, 3.5, 18, 'Completed', 0),
(385, 6, 40011, 4.0, 18, 'Completed', 0),
(386, 6, 40014, 2.5, 18, 'Completed', 0),
(387, 6, 40019, 4.0, 18, 'Completed', 0),
(388, 6, 40024, 3.0, 18, 'Completed', 0),
(389, 6, 40027, 1.0, 19, 'Completed', 0),
(390, 6, 40030, 3.5, 19, 'Completed', 0),
(391, 6, 40035, 3.5, 19, 'Completed', 0),
(392, 6, 40038, 2.0, 19, 'Completed', 0),
(393, 6, 40043, 1.0, 19, 'Completed', 0),
(394, 6, 50002, 2.5, 19, 'Completed', 0),
(395, 6, 50006, 1.0, 19, 'Completed', 0),
(396, 6, 50009, 1.5, 20, 'Completed', 0),
(397, 6, 50012, 3.5, 20, 'Completed', 0),
(398, 6, 50015, 2.5, 20, 'Completed', 0),
(399, 6, 50016, 1.0, 21, 'Completed', 0),
(400, 6, 50021, 3.5, 21, 'Completed', 0),
(401, 6, 50026, 2.5, 21, 'Completed', 0),
(402, 6, 50028, 2.5, 21, 'Completed', 0),
(403, 6, 50033, 2.0, 22, 'Completed', 0),
(404, 6, 50036, 1.0, 22, 'Completed', 0),
(405, 6, 50041, 2.5, 22, 'Completed', 0),
(406, 6, 50043, 2.0, 23, 'Completed', 0),
(407, 6, 50045, 3.5, 23, 'Completed', 0),
(408, 6, 50049, 2.0, 23, 'Completed', 0),
(409, 6, 50054, 3.0, 23, 'Completed', 0),
(410, 6, 60002, 2.0, 24, 'Completed', 0),
(411, 6, 60005, 3.0, 24, 'Completed', 0),
(412, 6, 60008, 2.5, 24, 'Completed', 0),
(413, 6, 60011, 1.0, 24, 'Completed', 0),
(414, 6, 60015, 4.0, 24, 'Completed', 0),
(415, 6, 60017, 3.5, 24, 'Completed', 0),
(416, 6, 60018, 1.5, 25, 'Ongoing', 0),
(417, 6, 60019, 3.5, 25, 'Ongoing', 0),
(418, 6, 60021, 1.5, 25, 'Ongoing', 0),
(419, 6, 60026, 1.0, 25, 'Ongoing', 0),
(420, 7, 10004, 0.0, 9, 'Dropped', 0),
(421, 7, 10009, 1.5, 9, 'Completed', 0),
(422, 7, 10010, 1.0, 9, 'Completed', 0),
(423, 7, 10013, 1.5, 9, 'Completed', 0),
(424, 7, 10014, 3.5, 9, 'Completed', 0),
(425, 7, 10017, 1.5, 9, 'Completed', 0),
(426, 7, 10018, 2.5, 9, 'Completed', 0),
(427, 7, 10022, 2.5, 10, 'Completed', 0),
(428, 7, 10026, 2.0, 10, 'Completed', 0),
(429, 7, 10028, 1.0, 10, 'Completed', 0),
(430, 7, 10030, 4.0, 10, 'Completed', 0),
(431, 7, 20003, 3.0, 10, 'Completed', 0),
(432, 7, 20008, 2.5, 10, 'Completed', 0),
(433, 7, 20010, 3.0, 11, 'Completed', 0),
(434, 7, 20011, 1.5, 11, 'Completed', 0),
(435, 7, 20013, 3.0, 11, 'Completed', 0),
(436, 7, 20016, 2.5, 11, 'Completed', 0),
(437, 7, 20018, 2.0, 11, 'Completed', 0),
(438, 7, 20019, 1.0, 11, 'Completed', 0),
(439, 7, 20021, 3.0, 11, 'Completed', 0),
(440, 7, 20025, 2.0, 12, 'Completed', 0),
(441, 7, 20028, 2.0, 12, 'Completed', 0),
(442, 7, 20031, 3.0, 12, 'Completed', 0),
(443, 7, 20034, 3.5, 12, 'Completed', 0),
(444, 7, 20035, 3.5, 13, 'Completed', 0),
(445, 7, 20039, 3.5, 13, 'Completed', 0),
(446, 7, 20040, 3.5, 13, 'Completed', 0),
(447, 7, 20043, 2.5, 13, 'Completed', 0),
(448, 7, 20044, 2.5, 13, 'Completed', 0),
(449, 7, 20048, 1.0, 13, 'Completed', 0),
(450, 7, 20049, 3.5, 13, 'Completed', 0),
(451, 7, 30002, 2.5, 14, 'Completed', 0),
(452, 7, 30003, 3.5, 14, 'Completed', 0),
(453, 7, 30004, 0.0, 14, 'Dropped', 0),
(454, 7, 30005, 3.5, 14, 'Completed', 0),
(455, 7, 30008, 4.0, 14, 'Completed', 0),
(456, 7, 30013, 3.5, 14, 'Completed', 0),
(457, 7, 30015, 3.5, 14, 'Completed', 0),
(458, 7, 30017, 3.0, 15, 'Completed', 0),
(459, 7, 30020, 3.5, 15, 'Completed', 0),
(460, 7, 30021, 4.0, 15, 'Completed', 0),
(461, 7, 30022, 3.5, 15, 'Completed', 0),
(462, 7, 30024, 1.0, 16, 'Completed', 0),
(463, 7, 30027, 1.0, 16, 'Completed', 0),
(464, 7, 30029, 3.0, 16, 'Completed', 0),
(465, 7, 30034, 4.0, 16, 'Completed', 0),
(466, 7, 30035, 0.0, 17, 'Dropped', 0),
(467, 7, 30037, 0.0, 17, 'Dropped', 0),
(468, 7, 30039, 2.5, 17, 'Completed', 0),
(469, 7, 30042, 4.0, 17, 'Completed', 0),
(470, 7, 30045, 1.5, 17, 'Completed', 0),
(471, 7, 40002, 2.5, 17, 'Completed', 0),
(472, 7, 40007, 3.5, 18, 'Completed', 0),
(473, 7, 40009, 2.5, 18, 'Completed', 0),
(474, 7, 40010, 1.5, 18, 'Completed', 0),
(475, 7, 40015, 2.0, 18, 'Completed', 0),
(476, 7, 40019, 1.5, 18, 'Completed', 0),
(477, 7, 40022, 3.5, 18, 'Completed', 0),
(478, 7, 40027, 3.5, 19, 'Completed', 0),
(479, 7, 40032, 3.5, 19, 'Completed', 0),
(480, 7, 40036, 2.0, 19, 'Completed', 0),
(481, 7, 40037, 3.5, 19, 'Completed', 0),
(482, 7, 40041, 1.0, 19, 'Completed', 0),
(483, 7, 50002, 2.0, 19, 'Completed', 0),
(484, 7, 50006, 1.5, 20, 'Completed', 0),
(485, 7, 50007, 2.5, 20, 'Completed', 0),
(486, 7, 50011, 3.0, 20, 'Completed', 0),
(487, 7, 50013, 1.0, 21, 'Completed', 0),
(488, 7, 50015, 4.0, 21, 'Completed', 0),
(489, 7, 50017, 2.5, 21, 'Completed', 0),
(490, 7, 50021, 1.0, 22, 'Completed', 0),
(491, 7, 50024, 2.5, 22, 'Completed', 0),
(492, 7, 50025, 2.5, 22, 'Completed', 0),
(493, 7, 50029, 4.0, 23, 'Completed', 0),
(494, 7, 50034, 4.0, 23, 'Completed', 0),
(495, 7, 50035, 3.0, 23, 'Completed', 0),
(496, 7, 50037, 1.5, 23, 'Completed', 0),
(497, 7, 50041, 3.0, 23, 'Completed', 0),
(498, 7, 50042, 2.0, 24, 'Completed', 0),
(499, 7, 50047, 3.0, 24, 'Completed', 0),
(500, 7, 50050, 2.0, 24, 'Completed', 0),
(501, 7, 50052, 3.0, 25, 'Ongoing', 0),
(502, 7, 60001, 1.0, 25, 'Ongoing', 0),
(503, 7, 60003, 1.0, 25, 'Ongoing', 0),
(504, 7, 60006, 4.0, 25, 'Ongoing', 0),
(505, 7, 60008, 4.0, 25, 'Ongoing', 0),
(506, 7, 60013, 1.5, 25, 'Ongoing', 0),
(507, 8, 10005, 1.5, 1, 'Completed', 0),
(508, 8, 10009, 3.0, 1, 'Completed', 0),
(509, 8, 10013, 2.5, 1, 'Completed', 0),
(510, 8, 10018, 3.5, 1, 'Completed', 0),
(511, 8, 10023, 1.5, 1, 'Completed', 0),
(512, 8, 10026, 3.0, 1, 'Completed', 0),
(513, 8, 10027, 4.0, 2, 'Completed', 0),
(514, 8, 20002, 1.5, 2, 'Completed', 0),
(515, 8, 20003, 2.0, 2, 'Completed', 0),
(516, 8, 20006, 3.0, 3, 'Completed', 0),
(517, 8, 20011, 4.0, 3, 'Completed', 0),
(518, 8, 20013, 2.0, 3, 'Completed', 0),
(519, 8, 20017, 2.0, 4, 'Completed', 0),
(520, 8, 20022, 1.0, 4, 'Completed', 0),
(521, 8, 20027, 2.0, 4, 'Completed', 0),
(522, 8, 20028, 1.0, 4, 'Completed', 0),
(523, 9, 10005, 3.5, 16, 'Completed', 0),
(524, 9, 10008, 2.5, 16, 'Completed', 0),
(525, 9, 10012, 1.5, 16, 'Completed', 0),
(526, 9, 10014, 2.5, 16, 'Completed', 0),
(527, 9, 10016, 3.0, 17, 'Completed', 0),
(528, 9, 10017, 2.5, 17, 'Completed', 0),
(529, 9, 10021, 1.5, 17, 'Completed', 0),
(530, 9, 10024, 1.0, 17, 'Completed', 0),
(531, 9, 10026, 4.0, 17, 'Completed', 0),
(532, 9, 10028, 3.0, 17, 'Completed', 0),
(533, 9, 20002, 1.0, 17, 'Completed', 0),
(534, 9, 20005, 2.5, 18, 'Completed', 0),
(535, 9, 20009, 2.0, 18, 'Completed', 0),
(536, 9, 20012, 3.0, 18, 'Completed', 0),
(537, 9, 20014, 4.0, 18, 'Completed', 0),
(538, 9, 20019, 3.0, 18, 'Completed', 0),
(539, 9, 20020, 3.0, 19, 'Completed', 0),
(540, 9, 20023, 3.5, 19, 'Completed', 0),
(541, 9, 20026, 3.0, 19, 'Completed', 0),
(542, 9, 20029, 1.0, 19, 'Completed', 0),
(543, 9, 20032, 3.0, 19, 'Completed', 0),
(544, 9, 20034, 3.0, 19, 'Completed', 0),
(545, 9, 20039, 3.0, 19, 'Completed', 0),
(546, 9, 20044, 4.0, 20, 'Completed', 0),
(547, 9, 20048, 3.5, 20, 'Completed', 0),
(548, 9, 20049, 1.5, 20, 'Completed', 0),
(549, 9, 20052, 4.0, 20, 'Completed', 0),
(550, 9, 30004, 2.5, 20, 'Completed', 0),
(551, 9, 30005, 2.0, 20, 'Completed', 0),
(552, 9, 30006, 3.5, 20, 'Completed', 0),
(553, 9, 30007, 3.0, 21, 'Completed', 0),
(554, 9, 30009, 1.0, 21, 'Completed', 0),
(555, 9, 30013, 1.5, 21, 'Completed', 0),
(556, 9, 30017, 1.5, 21, 'Completed', 0),
(557, 9, 30022, 3.5, 21, 'Completed', 0),
(558, 9, 30026, 4.0, 22, 'Completed', 0),
(559, 9, 30030, 3.0, 22, 'Completed', 0),
(560, 9, 30031, 4.0, 22, 'Completed', 0),
(561, 9, 30035, 2.5, 22, 'Completed', 0),
(562, 9, 30037, 1.5, 22, 'Completed', 0),
(563, 9, 30040, 1.0, 22, 'Completed', 0),
(564, 9, 30045, 1.0, 22, 'Completed', 0),
(565, 9, 40001, 2.0, 23, 'Completed', 0),
(566, 9, 40003, 3.5, 23, 'Completed', 0),
(567, 9, 40008, 2.5, 23, 'Completed', 0),
(568, 9, 40009, 3.5, 23, 'Completed', 0),
(569, 9, 40012, 1.5, 23, 'Completed', 0),
(570, 9, 40017, 3.0, 23, 'Completed', 0),
(571, 9, 40019, 1.5, 23, 'Completed', 0),
(572, 9, 40021, 1.5, 24, 'Completed', 0),
(573, 9, 40026, 1.0, 24, 'Completed', 0),
(574, 9, 40029, 0.0, 24, 'Dropped', 0),
(575, 9, 40032, 4.0, 24, 'Completed', 0),
(576, 9, 40036, 1.0, 25, 'Ongoing', 0),
(577, 9, 40038, 1.0, 25, 'Ongoing', 0),
(578, 9, 40040, 3.5, 25, 'Ongoing', 0),
(579, 9, 40041, 1.0, 25, 'Ongoing', 0),
(580, 9, 40043, 3.0, 25, 'Ongoing', 0),
(581, 9, 50001, 1.5, 25, 'Ongoing', 0),
(582, 9, 50005, 2.0, 25, 'Ongoing', 0),
(583, 10, 10005, 1.5, 5, 'Completed', 0),
(584, 10, 10008, 4.0, 5, 'Completed', 0),
(585, 10, 10013, 3.0, 5, 'Completed', 0),
(586, 10, 10015, 1.0, 5, 'Completed', 0),
(587, 10, 10020, 2.5, 5, 'Completed', 0),
(588, 10, 10021, 3.0, 5, 'Completed', 0),
(589, 10, 10022, 1.5, 5, 'Completed', 0),
(590, 10, 10024, 3.5, 6, 'Completed', 0),
(591, 10, 10029, 2.0, 6, 'Completed', 0),
(592, 10, 20004, 1.5, 6, 'Completed', 0),
(593, 10, 20008, 1.5, 7, 'Completed', 0),
(594, 10, 20010, 2.0, 7, 'Completed', 0),
(595, 10, 20013, 3.0, 7, 'Completed', 0),
(596, 10, 20017, 3.0, 7, 'Completed', 0),
(597, 10, 20018, 1.0, 7, 'Completed', 0),
(598, 10, 20021, 2.0, 8, 'Completed', 0),
(599, 10, 20024, 2.0, 8, 'Completed', 0),
(600, 10, 20028, 1.5, 8, 'Completed', 0),
(601, 10, 20032, 1.5, 8, 'Completed', 0),
(602, 10, 20035, 4.0, 8, 'Completed', 0),
(603, 10, 20039, 4.0, 8, 'Completed', 0),
(604, 10, 20042, 3.0, 8, 'Completed', 0),
(605, 10, 20045, 2.0, 9, 'Completed', 0),
(606, 10, 20050, 4.0, 9, 'Completed', 0),
(607, 10, 30001, 2.0, 9, 'Completed', 0),
(608, 10, 30006, 2.5, 9, 'Completed', 0),
(609, 10, 30007, 1.5, 9, 'Completed', 0),
(610, 10, 30008, 2.5, 10, 'Completed', 0),
(611, 10, 30009, 4.0, 10, 'Completed', 0),
(612, 10, 30010, 4.0, 10, 'Completed', 0),
(613, 10, 30015, 3.5, 10, 'Completed', 0),
(614, 10, 30020, 3.0, 10, 'Completed', 0),
(615, 10, 30022, 2.0, 10, 'Completed', 0),
(616, 10, 30027, 4.0, 10, 'Completed', 0),
(617, 10, 30032, 1.0, 11, 'Completed', 0),
(618, 10, 30035, 3.5, 11, 'Completed', 0),
(619, 10, 30038, 2.0, 11, 'Completed', 0),
(620, 10, 30043, 4.0, 11, 'Completed', 0),
(621, 10, 30048, 2.5, 11, 'Completed', 0),
(622, 10, 40004, 2.5, 11, 'Completed', 0),
(623, 10, 40008, 1.5, 12, 'Completed', 0),
(624, 10, 40009, 2.0, 12, 'Completed', 0),
(625, 10, 40010, 1.5, 12, 'Completed', 0),
(626, 10, 40015, 2.5, 13, 'Completed', 0),
(627, 10, 40018, 1.5, 13, 'Completed', 0),
(628, 10, 40021, 2.0, 13, 'Completed', 0),
(629, 10, 40024, 2.0, 14, 'Completed', 0),
(630, 10, 40028, 2.5, 14, 'Completed', 0),
(631, 10, 40032, 1.0, 14, 'Completed', 0),
(632, 10, 40036, 3.5, 14, 'Completed', 0),
(633, 10, 40038, 1.0, 14, 'Completed', 0),
(634, 10, 40042, 3.5, 15, 'Completed', 0),
(635, 10, 50003, 3.0, 15, 'Completed', 0),
(636, 10, 50007, 3.5, 15, 'Completed', 0),
(637, 10, 50012, 1.0, 16, 'Completed', 0),
(638, 10, 50013, 2.0, 16, 'Completed', 0),
(639, 10, 50014, 2.5, 16, 'Completed', 0),
(640, 10, 50018, 0.0, 16, 'Failed', 0),
(641, 10, 50020, 4.0, 16, 'Completed', 0),
(642, 10, 50025, 3.5, 16, 'Completed', 0),
(643, 10, 50027, 3.5, 16, 'Completed', 0),
(644, 10, 50029, 2.5, 17, 'Completed', 0),
(645, 10, 50032, 1.5, 17, 'Completed', 0),
(646, 10, 50035, 2.5, 17, 'Completed', 0),
(647, 10, 50018, 2.5, 17, 'Completed', 1);

-- ---------------------------------------------------------------
-- Table retaker
-- ---------------------------------------------------------------
INSERT INTO retaker(retakerID,retakeSem,originalAttempt,attempts,reason,finalGrade,studentID)
VALUES
(40001,25,18,1,'Extenuating circumstances',2.0,11);

-- ---------------------------------------------------------------
-- Table room
-- ---------------------------------------------------------------

INSERT INTO room (roomID, roomType, mode, capacity, location)
	VALUES	(1, 'Classroom', 'Face-to-Face', 30, 'Building A, Room 101'),
			(2, 'Studio', 'Hybrid', 20, 'Building B, Room 202'),
			(3, 'None', 'Online', 50, 'Virtual Room 1'),
			(4, 'Classroom', 'Face-to-Face', 25, 'Building C, Room 303'),
			(5, 'Studio', 'Hybrid', 15, 'Building D, Room 404'),
			(6, 'None', 'Online', 40, 'Virtual Room 2'),
			(7, 'Classroom', 'Face-to-Face', 35, 'Building E, Room 505'),
			(8, 'Studio', 'Hybrid', 18, 'Building F, Room 606'),
			(9, 'None', 'Online', 45, 'Virtual Room 3'),
			(10, 'Classroom', 'Face-to-Face', 28, 'Building G, Room 707');


-- ---------------------------------------------------------------
-- Table instrument
-- ---------------------------------------------------------------

INSERT INTO instrument (instrumentID, instruName, r_room, instrumentType, instrumentLevel, r_availability, instructorID, departmentID, courseID)
	VALUES	(1, 'Acoustic Guitar', 'R101', 'String', 'Beginner', 'Available', 1, 1, 30005),
			(2, 'Trumpet', 'R202', 'Brass', 'Intermediate', 'Available', 2, 2, 30004),
			(3, 'Piano', 'R303', 'Keyboard', 'Advanced', 'Unavailable', 3, 3, 30006),
			(4, 'Drums', 'R404', 'Percussion', 'Intermediate', 'Available', 4, 4, 30007),
			(5, 'Saxophone', 'R505', 'Woodwind', 'Intermediate', 'Unavailable', 5, 5, 30002),
			(6, 'Synthesizer', 'R606', 'Electronic', 'Advanced', 'Available', 6, 6, 30003),
			(7, 'Violin', 'R707', 'String', 'Intermediate', 'Unavailable', 7, 7, 30001),
			(8, 'Trombone', 'R808', 'Brass', 'Beginner', 'Available', 8, 8, 30009),
			(9, 'Grand Piano', 'R909', 'Keyboard', 'Advanced', 'Unavailable', 9, 9, 30008),
			(10, 'Electric Drum Set', 'R10A', 'Percussion', 'Intermediate', 'Available', 10, 10, 30010);

-- ---------------------------------------------------------------
-- Table waitlist
-- ---------------------------------------------------------------

INSERT INTO waitlist (waitlistID, e_Date, w_status, studentID, program_id)
	VALUES	(1, '2023-01-10', 'Pending', 1, 1),
			(2, '2023-02-15', 'Accepted', 2, 2),
			(3, '2023-03-20', 'Denied', 3, 3),
			(4, '2023-04-25', 'Notified', 4, 4),
			(5, '2023-05-30', 'Pending', 5, 5),
			(6, '2023-06-05', 'Accepted', 6, 6),
			(7, '2023-07-10', 'Denied', 7, 7),
			(8, '2023-08-15', 'Notified', 8, 8),
			(9, '2023-09-20', 'Pending', 9, 9),
			(10, '2023-10-25', 'Accepted', 10, 10);

-- ---------------------------------------------------------------
-- Table instrumentBorrow
-- ---------------------------------------------------------------

INSERT INTO instrumentBorrow (borrowID, b_startDate, b_returnDate, b_dueDate, instrumentID, studentID)
	VALUES	(1, '2023-01-05', '2023-02-05', '2023-03-05', 1, 1),
			(2, '2023-02-10', '2023-03-10', '2023-04-10', 2, 2),
			(3, '2023-03-15', '2023-04-15', '2023-05-15', 3, 3),
			(4, '2023-04-20', '2023-05-20', '2023-06-20', 4, 4),
			(5, '2023-05-25', '2023-06-25', '2023-07-25', 5, 5),
			(6, '2023-06-30', '2023-07-30', '2023-08-30', 6, 6),
			(7, '2023-07-05', '2023-08-05', '2023-09-05', 7, 7),
			(8, '2023-08-10', '2023-09-10', '2023-10-10', 8, 8),
			(9, '2023-09-15', '2023-10-15', '2023-11-15', 9, 9),
			(10, '2023-10-20', '2023-11-20', '2023-12-20', 10, 10);

-- ---------------------------------------------------------------
-- Table account
-- ---------------------------------------------------------------

INSERT INTO account (accountID, username, password, studentID)
	VALUES	(1, 'john_doe', 'hashed_password_1', 1),
			(2, 'emma_smith', 'hashed_password_2', 2),
			(3, 'mike_jones', 'hashed_password_3', 3),
			(4, 'susan_white', 'hashed_password_4', 4),
			(5, 'peter_brown', 'hashed_password_5', 5),
			(6, 'olivia_clark', 'hashed_password_6', 6),
			(7, 'david_miller', 'hashed_password_7', 7),
			(8, 'linda_taylor', 'hashed_password_8', 8),
			(9, 'kevin_carter', 'hashed_password_9', 9),
			(10, 'sarah_adams', 'hashed_password_10', 10),
            (11, 'reko_yabusame','hashed_password_11',11);

-- ---------------------------------------------------------------
-- SELECT queries for testing
-- ---------------------------------------------------------------
/*SELECT sc.scholarID,
	   CONCAT(sp.lastName, ', ', sp.middleInitial, ' ', sp.firstname) AS 'name',
	   sp.studentID,
       ss.scholarshipName
FROM scholar sc JOIN scholarship ss ON sc.scholarshipID = ss.scholarshipID
				JOIN studentProfiles sp ON sc.studentID = sp.studentID;*/

/*SELECT c.courseID,
	   c.courseName,
	   d.departmentID,
       d.departmentName
FROM course c JOIN instructor i ON c.instructorID = i.instructorID
			  JOIN departments d ON i.departmentID = d.departmentID
ORDER BY departmentID ASC;*/
/*SELECT s.semID,
	   s.semStart,
	   s.semEnd
FROM semester s
WHERE s.semEnd BETWEEN '2018-09-02' AND '2021-05-28';*/

/*SELECT e.*,
	   s.semID,
       s.semStart AS 'start_first_semester',
       s.semEnd AS 'end_first_semester'
FROM general_enrollment e LEFT JOIN ge_change ON g.enro
WHERE e.enrollmentDate BETWEEN s.semStart AND s.semEnd
ORDER BY e.enrollmentID;*/



