-- ======================================================
-- Smart Boarder Electricity Usage Analyzer - SQL Server Version
-- Database and Table Setup Script
-- ======================================================

-- Create database if not exists
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'PowerSplit_DB')
BEGIN
    CREATE DATABASE PowerSplit_DB;
END
GO

-- Use the database
USE PowerSplit_DB;
GO

-- ======================================================
-- USERS TABLE
-- ======================================================
-- Create users table
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    created_date DATETIME DEFAULT GETDATE()
);
GO

-- Create rooms table
CREATE TABLE rooms (
    room_id INT IDENTITY(1,1) PRIMARY KEY,
    room_name NVARCHAR(100) NOT NULL,
    occupant_name NVARCHAR(100),
    user_id INT,
    floor_number INT NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('occupied', 'vacant', 'maintenance')) DEFAULT 'vacant',
    created_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);
GO

-- Create appliances table
CREATE TABLE appliances (
    appliance_id INT IDENTITY(1,1) PRIMARY KEY,
    room_id INT NOT NULL,
    appliance_name NVARCHAR(100) NOT NULL,
    wattage DECIMAL(10,2) NOT NULL,
    description NVARCHAR(255),
    status NVARCHAR(20) CHECK (status IN ('active', 'inactive', 'maintenance')) DEFAULT 'active',
    created_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);
GO

-- Create bills table
CREATE TABLE bills (
    bill_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    bill_month NVARCHAR(20) NOT NULL,
    total_units DECIMAL(10,2) NOT NULL,
    total_bill DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('pending', 'paid', 'overdue')) DEFAULT 'pending',
    generated_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
GO

-- Create room_bill_summary table
CREATE TABLE room_bill_summary (
    summary_id INT IDENTITY(1,1) PRIMARY KEY,
    bill_id INT NOT NULL,
    room_id INT NOT NULL,
    room_units DECIMAL(10,2) NOT NULL,
    room_cost DECIMAL(10,2) NOT NULL,
    usage_percentage DECIMAL(5,2),
    alert_status NVARCHAR(15) CHECK (alert_status IN ('normal', 'high_usage', 'critical')) DEFAULT 'normal',
    notes NVARCHAR(255),
    created_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    CONSTRAINT UQ_BillRoom UNIQUE (bill_id, room_id)
);
GO