-- List all doctors and their specializations
SELECT 
    s.StaffId, s.StaffFirstName, s.StaffLastName, d.Specialization
FROM 
    ChironaSchema.Staff s
JOIN 
    ChironaSchema.Doctor d ON s.StaffId = d.DoctorId;


--Find all appointment scheduled at the current date (today)

SELECT
    a.AppointmentId, s.StaffFirstName || ' ' || s.StaffLastName AS DoctorName,
    p.PatientFirstName || ' ' || p.PatientLastName AS PatientName,
    a.AppointmentDate, a.AppointmentStartTime, a.AppointmentStatus
FROM
    ChironaSchema.Appointment a
JOIN
    ChironaSchema.Doctor d ON a.DoctorId = d.DoctorId
JOIN
    ChironaSchema.Staff s ON d.DoctorId = s.StaffId
JOIN
    ChironaSchema.Patient p ON a.PatientId = p.PatientId
WHERE
    a.AppointmentDate = CURRENT_DATE;


-- Get total payment made by each patient
SELECT 
    p.PatientId, p.PatientFirstName || ' ' || p.PatientLastName AS PatientName,
    SUM(i.TotalAmount) AS TotalBilled,
    COUNT(pay.PaymentId) AS NumberOfPayments
FROM 
    ChironaSchema.Patient p
JOIN 
    ChironaSchema.Invoice i ON p.PatientId = i.PatientId
LEFT JOIN 
    ChironaSchema.Payment pay ON i.InvoiceNo = pay.InvoiceNo
GROUP BY 
    p.PatientId, PatientName;
