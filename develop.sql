CREATE TABLE IF NOT EXISTS Staff (
    StaffId SERIAL PRIMARY KEY, 
    StaffFirstName VARCHAR(100) NOT NULL, 
    StaffLastName VARCHAR(100) NOT NULL, 
    StaffDOB DATE NOT NULL, 
    StaffGender VARCHAR(11) NOT NULL CONSTRAINT StaffGenderCheck CHECK(StaffGender IN ('Male', 'Female', 'Transgender')), 
    StaffRole VARCHAR(12) NOT NULL CONSTRAINT StaffRoleCheck CHECK(StaffRole IN ('Doctor', 'Nurse', 'Admin', 'Pharmacist', 'LabScientist')), 
    StaffTelNo VARCHAR(11) NOT NULL, 
    StaffEmail VARCHAR(50) NOT NULL
    );

CREATE TABLE IF NOT EXISTS Doctor (
    DoctorId INT PRIMARY KEY, 
    Specialization VARCHAR(100),
    CONSTRAINT DoctorIdForKey FOREIGN KEY (DoctorId) REFERENCES Staff (StaffId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS AdminStaff (
    AdminId INT PRIMARY KEY, 
    UserName VARCHAR(20) NOT NULL,
    CONSTRAINT AdminIdForKeyAdmn FOREIGN KEY (AdminId) REFERENCES Staff (StaffId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Room (
    RoomId SERIAL PRIMARY KEY, 
    RoomType VARCHAR(40) NOT NULL,
    CONSTRAINT RoomTypeCheckRm CHECK(RoomType IN ('general wards', 'semi-private rooms', 'private rooms', 'specialized units'))
    );

    CREATE TABLE IF NOT EXISTS Shift (
    ShiftId SERIAL PRIMARY KEY, 
    CreatedBy INT, 
    ShiftDate DATE NOT NULL,
    StartTime TIME, 
    EndTime TIME, 
    WeekNo INT, 
    ShiftDayOfWeek VARCHAR(9) NOT NULL CONSTRAINT ShiftDayOfWeekCheckShft CHECK(ShiftDayOfWeek IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    CONSTRAINT CreatedByForKeyShft FOREIGN KEY (CreatedBy) REFERENCES AdminStaff (AdminId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS ShiftAssignment (
    AssignmentId SERIAL PRIMARY KEY, 
    ShiftId INT, 
    StaffId INT,
    CONSTRAINT ShiftIdForKeyShftAss FOREIGN KEY (ShiftId) REFERENCES Shift (ShiftId) ON DELETE CASCADE,
    CONSTRAINT StaffIdForKeyShftAss FOREIGN KEY (StaffId) REFERENCES Staff (StaffId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Patient (
    PatientId SERIAL PRIMARY KEY, 
    PatientFirstName VARCHAR(100) NOT NULL, 
    PatientLastName VARCHAR(100) NOT NULL, 
    PatientTelNo VARCHAR(11) NOT NULL, 
    PatientEmail VARCHAR(50) NOT NULL, 
    PatientGender VARCHAR(11) NOT NULL CONSTRAINT PatientGenderCheck CHECK(PatientGender IN ('Male', 'Female', 'Transgender'))
    );

CREATE TABLE IF NOT EXISTS Appointment (
    AppointmentId SERIAL PRIMARY KEY, 
    DoctorId INT, 
    PatientId INT, 
    ScheduledBy INT,
    AppointmentDate DATE NOT NULL, 
    AppointmentStartTime TIME NOT NULL,
    AppointmentEndTime TIME NOT NULL, 
    AppointmentStatus VARCHAR(9) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT DoctorIdForKeyApp FOREIGN KEY (DoctorId) REFERENCES Doctor (DoctorId) ON DELETE CASCADE,
    CONSTRAINT PatientIdForKeyApp FOREIGN KEY (PatientId) REFERENCES Patient (PatientId) ON DELETE CASCADE,
    CONSTRAINT ScheduledByForKeyApp FOREIGN KEY (ScheduledBy) REFERENCES AdminStaff (AdminId) ON DELETE CASCADE,
    CONSTRAINT AppointmentStatusCheck CHECK(AppointmentStatus IN ('Scheduled', 'Completed', 'Cancelled'))
    );

CREATE TABLE IF NOT EXISTS MedicalTest (
    TestId SERIAL PRIMARY KEY, 
    RequestedBy INT, 
    DoneBy INT, 
    PatientId INT, 
    TestType TEXT NOT NULL, 
    TestDate TIMESTAMP NOT NULL, 
    TestResult TEXT, 
    TestStatus VARCHAR(9) NOT NULL DEFAULT 'Scheduled',
    TestCost NUMERIC(5, 2),
    CONSTRAINT RequestedByForKeyMed FOREIGN KEY (RequestedBy) REFERENCES Doctor (DoctorId) ON DELETE CASCADE,
    CONSTRAINT DoneByForKeyMed FOREIGN KEY (DoneBy) REFERENCES Staff (StaffId) ON DELETE CASCADE,
    CONSTRAINT PatientIdForKeyMed FOREIGN KEY (PatientId) REFERENCES Patient (PatientId) ON DELETE CASCADE,
    CONSTRAINT TestStatusCheckMed CHECK(TestStatus IN ('Scheduled', 'Completed', 'Cancelled'))
    );

CREATE TABLE IF NOT EXISTS Treatment (
    TreatmentId SERIAL PRIMARY KEY, 
    PatientId INT, 
    TreatmentProcedure TEXT NOT NULL, 
    TreatmentCost NUMERIC(7, 2) NOT NULL,
    CONSTRAINT PatientIdForKeyTrmnt FOREIGN KEY (PatientId) REFERENCES Patient (PatientId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Admission (
    AdmissionId SERIAL PRIMARY KEY, 
    PatientId INT, 
    AdmissionDate TIMESTAMP, 
    TreatmentId INT, 
    RoomId INT, 
    AdmissionStatus VARCHAR(12) NOT NULL,
    CONSTRAINT PatientIdForKeyAdmssn FOREIGN KEY (PatientId) REFERENCES Patient (PatientId) ON DELETE CASCADE,
    CONSTRAINT TreatmentIdForKeyAdmssn FOREIGN KEY (TreatmentId) REFERENCES Treatment (TreatmentId) ON DELETE CASCADE,
    CONSTRAINT RoomIdForKeyAdmssn FOREIGN KEY (RoomId) REFERENCES Room (RoomId) ON DELETE CASCADE,
    CONSTRAINT AdmissionStatusCheck CHECK(AdmissionStatus IN ('Pending', 'Admitted', 'In Treatment', 'Discharged', 'Cancelled', 'Transferred'))
    );

CREATE TABLE IF NOT EXISTS Invoice (
    InvoiceNo CHAR(10) PRIMARY KEY, 
    DateGenerated TIMESTAMP, 
    GeneratedBy INT, 
    PatientId INT, 
    Amount NUMERIC(7, 2) NOT NULL, 
    Tax NUMERIC(5, 2) NOT NULL, 
    TotalAmount NUMERIC(7, 2) NOT NULL,
    CONSTRAINT GeneratedByForKeyInv FOREIGN KEY (GeneratedBy) REFERENCES AdminStaff (AdminId) ON DELETE CASCADE,
    CONSTRAINT PatientIdForKeyInv FOREIGN KEY (PatientId) REFERENCES Patient (PatientId) ON DELETE CASCADE,
    CONSTRAINT TotalAmountCheckInv CHECK(TotalAmount = Amount + Tax)
    );

CREATE TABLE IF NOT EXISTS TreatmentInvoice (
    InvoiceNo CHAR(10),
    TreatmentId INT,
    PRIMARY KEY (InvoiceNo, TreatmentId),
    CONSTRAINT InvoiceNoForKeyTrtmtInv FOREIGN KEY (InvoiceNo) REFERENCES Invoice (InvoiceNo) ON DELETE CASCADE,
    CONSTRAINT TreatmentIdForKeyTrtmtInv FOREIGN KEY (TreatmentId) REFERENCES Treatment (TreatmentId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS MedicalTestInvoice (
    InvoiceNo CHAR(10),
    TestId INT,
    PRIMARY KEY (InvoiceNo, TestId),
    CONSTRAINT InvoiceNoForKeyMedTstInv FOREIGN KEY (InvoiceNo) REFERENCES Invoice (InvoiceNo) ON DELETE CASCADE,
    CONSTRAINT TestIdForKeyMedTstInv FOREIGN KEY (TestId) REFERENCES MedicalTest (TestId) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Payment (
    PaymentId SERIAL PRIMARY KEY, 
    PaymentDate TIMESTAMP, 
    PaidBy INT,
    InvoiceNo CHAR(10), 
    PaymentMethod VARCHAR(12),
    CONSTRAINT PaidByForKeyPaymt FOREIGN KEY (PaidBy) REFERENCES Patient (PatientId) ON DELETE CASCADE,
    CONSTRAINT InvoiceNoForKeyPaymt FOREIGN KEY (InvoiceNo) REFERENCES Invoice (InvoiceNo) ON DELETE CASCADE,
    CONSTRAINT PaymentMethodCheckPaymt CHECK(PaymentMethod IN ('Cash', 'Credit Card', 'Transfer', 'Cheque', 'Debit Card'))
    );
