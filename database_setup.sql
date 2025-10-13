-- Database Setup Script for OOP Web Project
-- This script creates the database and users table with authentication support

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS oop_project_db;

-- Use the database
USE oop_project_db;

-- Drop existing users table if it exists (to recreate with password field)
DROP TABLE IF EXISTS users;

-- Create users table with password field
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);


  CREATE TRIGGER trg_UpdateUsers
ON Users
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Users
    SET UpdatedAt = GETDATE()
    FROM Users U
    INNER JOIN inserted i ON U.Id = i.Id;
END;


-- Insert sample users for testing
INSERT INTO users (name, email, country, password) VALUES
('Admin User', 'admin@test.com', 'Sri Lanka', 'admin123'),
('John Doe', 'john@example.com', 'USA', 'password123'),
('Jane Smith', 'jane@example.com', 'UK', 'password123'),
('Raj Kumar', 'raj@example.com', 'India', 'password123'),
('Maria Garcia', 'maria@example.com', 'Canada', 'password123');

-- Display all users
SELECT * FROM users;

-- Note: In production, passwords should be hashed using bcrypt or similar algorithms
-- This is a simple implementation for demonstration purposes
