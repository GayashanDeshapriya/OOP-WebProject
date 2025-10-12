-- Database Setup Script for OOP Web Project
-- This script creates the database and users table with authentication support

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS oop_project_db;

-- Use the database
USE oop_project_db;

-- Drop existing users table if it exists (to recreate with password field)
DROP TABLE IF EXISTS users;

-- Create users table with password field
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    country VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

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
