# 🏥 Hospital Data Management System

## Overview

This project provides a centralized, scalable, and relational database system to manage hospital operations such as staff scheduling, patient care, appointments, treatments, room assignments, billing, and payments. The solution is designed for deployment on **Azure Database for PostgreSQL** and is structured for seamless integration with BI tools and future EMR systems.

---

## 🔧 Tech Stack & Tools

| Component         | Technology                     |
|------------------|---------------------------------|
| **Database**      | PostgreSQL (Hosted on Azure)    |
| **Cloud Platform**| Azure Database for PostgreSQL   |
| **Programming**   | Python 3.10+                    |
| **ORM / DB Driver** | `psycopg2` for PostgreSQL       |
| **Scripting**     | SQL (DDL inside Python script)  |
| **Config Mgmt**   | YAML (`conn.yml` for DB creds)  |
| **Data Handling** | `csv`, `pandas` (for ETL ops)   |
| **Schema**        | `ChironaSchema` (Logical grouping) |
| **OS**            | Cross-platform (Linux/Windows)  |
| **Deployment**    | Manual via script execution     |

---

## 📌 Problem Statement

The hospital currently lacks a unified system for tracking operational and clinical data. Information silos, manual processes, and fragmented billing are leading to inefficiencies and risks in patient care. This project solves that by introducing a normalized database system that ensures data integrity, real-time access, and cross-departmental visibility.

---

## 🎯 Project Objectives

- Design a robust, normalized relational schema for hospital management.
- Support scheduling, treatment records, and financial transactions.
- Ensure referential integrity and query performance.
- Provide a future-proof foundation for analytics and third-party system integration.

---

## ⚙️ Functional Scope

### 1. Patient Management
- Store patient demographic and contact data.
- Track admissions, discharges, and transfers.

### 2. Doctor & Staff Management
- Maintain records for staff with roles and specializations.
- Schedule shifts and manage staff allocations.

### 3. Appointments & Scheduling
- Manage doctor-patient appointment workflows.
- Avoid booking conflicts and enforce availability.

### 4. Diagnosis & Treatment
- Store test results, diagnoses, medications, and procedures.
- Link treatments to invoices and room admissions.

### 5. Billing & Payments
- Generate and track invoices for treatments and tests.
- Record payments, payment methods, and tax calculations.

---

## 🧱 Database Schema Highlights

The schema is implemented under a dedicated PostgreSQL schema: `ChironaSchema`.

### Key Tables:
- `Staff`, `Doctor`, `AdminStaff`
- `Patient`, `Appointment`, `MedicalTest`, `Treatment`, `Admission`
- `Invoice`, `TreatmentInvoice`, `MedicalTestInvoice`, `Payment`
- `Room`, `Shift`, `ShiftAssignment`

All constraints are enforced through:
- Foreign keys
- Check constraints
- Default values

---

## 📂 Project Files

| File                | Description |
|---------------------|-------------|
| `script.py`         | Python script to connect to Azure PostgreSQL, create schema and tables, and populate initial data. |
| `develop.sql`       | SQL schema definition (also embedded within `script.py`). |
| `staff.csv`         | Staff data (doctors, admin, nurses, etc.). |
| `doctor.csv`        | Doctor specialization mapping. |
| `adminstaff.csv`    | Admin staff usernames. |
| `room.csv`          | Room types and availability. |
| `conn.yml`          | Configuration file for database credentials (not shared here for security). |

---

## ☁️ Azure Deployment Instructions

1. **Provision Azure PostgreSQL**
   - Use Azure Portal to create a PostgreSQL flexible server.
   - Enable SSL and set firewall rules to allow your IP.

2. **Upload Credentials**
   - Create `conn.yml` with the following format:
     ```yaml
     dbname: your_db_name
     admin: your_username
     passwd: your_password
     server: your_server_name.postgres.database.azure.com
     port: 5432
     ```

3. **Run the Python Script**
   ```bash
   python script.py
