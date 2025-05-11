import psycopg2
import yaml
import csv
import pandas as pd

def Connect():
    with open(r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\conn.yml', 'r') as file:
        config = yaml.safe_load(file)
        dbname = config['dbname']
        user = config['admin']
        password = config['passwd']
        host = config['server']
        port = config['port']
        conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
    return conn

def DevelopDB():
    conn = None
    curr = None
    try:
        conn = Connect()
        curr = conn.cursor()
        sql_script_path = r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\hospital_data_management_system\develop.sql'
        with open(sql_script_path) as f:
            sql_script = f.read()
            curr.execute(sql_script)
    except (psycopg2.DatabaseError) as e:
        print(f'error occured: {e}')
        if conn:
            conn.rollback()
    conn.commit()
    curr.close
    conn.close
    return None

def LoadData():
    conn = Connect()
    curr = conn.cursor()
    staff_file_path = r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\hospital_data_management_system\staff.csv'
    adminstaff_file_path = r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\hospital_data_management_system\adminstaff.csv'
    doctor_file_path = r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\hospital_data_management_system\doctor.csv'
    room_file_path = r'C:\Users\hp\Desktop\Data-Engineering\Hospital_Database_Model_and_Development\hospital_data_management_system\room.csv'
    with open(staff_file_path, 'r', encoding='utf-8-sig') as staff_file:
        reader1 = csv.reader(staff_file)
        # reader = csv.reader(csv_doc)
        next(reader1)
        for s in [tuple(row) for row in reader1]:
            populate_table1 = """
                                INSERT INTO ChironaSchema.Staff (StaffId, StaffFirstName, StaffLastName, StaffDOB, StaffGender, StaffRole, StaffTelNo, StaffEmail) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
            curr.execute(populate_table1, s)

    with open(adminstaff_file_path, 'r', encoding='utf-8-sig') as adminstaff_file:
        reader2 = csv.reader(adminstaff_file)
        # reader = csv.reader(csv_doc)
        next(reader2)
        for a in [tuple(row) for row in reader2]:
            populate_table2 = """
                                INSERT INTO ChironaSchema.AdminStaff (AdminId, UserName) VALUES (%s, %s)"""
            curr.execute(populate_table2, a)

    with open(doctor_file_path, 'r', encoding='utf-8-sig') as doctor_file:
        reader3 = csv.reader(doctor_file)
        # reader = csv.reader(csv_doc)
        next(reader3)
        for d in [tuple(row) for row in reader3]:
            
            populate_table3 = """
                                INSERT INTO ChironaSchema.Doctor (DoctorId, Specialization) VALUES (%s, %s)"""
            curr.execute(populate_table3, d)

    with open(room_file_path, 'r', encoding='utf-8-sig') as room_file:
        reader4 = csv.reader(room_file)
        # reader = csv.reader(csv_doc)
        next(reader4)
        for r in [tuple(row) for row in reader4]:
            
            populate_table4 = """
                                INSERT INTO ChironaSchema.Room (RoomId, RoomType) VALUES (%s, %s)"""
            curr.execute(populate_table4, r)
    conn.commit()
    curr.close
    conn.close