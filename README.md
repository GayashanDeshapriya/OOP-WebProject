# OOP Web Project - User Registration and Login System

## Overview
This is a complete Java web application with user registration and login functionality, built using JSP, Servlets, and MySQL.

## Features
✅ User Registration with validation
✅ User Login with session management
✅ Secure authentication system
✅ User Dashboard with statistics
✅ User Profile management
✅ View all users with search functionality
✅ Edit and delete users
✅ Settings page
✅ Responsive and attractive UI
✅ Session-based security

## Technologies Used
- Java (JDK 8 or higher)
- JSP & Servlets
- MySQL Database
- Apache Tomcat 9.0
- JDBC (MySQL Connector/J 9.4.0)
- HTML5, CSS3, JavaScript

## Project Structure
```
OOPWebProject/
├── src/main/java/com/OOPWebProject/
│   ├── controller/
│   │   ├── AuthController.java      # Handles login/register/logout
│   │   └── UserController.java      # Handles user CRUD operations
│   ├── dao/
│   │   └── UserDAO.java             # Database access layer
│   ├── model/
│   │   └── User.java                # User entity
│   └── util/
│       └── DBUtil.java              # Database connection utility
├── src/main/webapp/
│   ├── login.jsp                    # Login page
│   ├── register.jsp                 # Registration page
│   ├── dashboard.jsp                # User dashboard
│   ├── profile.jsp                  # User profile page
│   ├── listUsers.jsp                # All users list
│   ├── userForm.jsp                 # Add/Edit user form
│   ├── settings.jsp                 # Settings page
│   └── WEB-INF/
│       └── lib/
│           └── mysql-connector-j-9.4.0.jar
└── database_setup.sql               # Database setup script
```

## Setup Instructions

### 1. Database Setup
1. Make sure MySQL is installed and running
2. Open MySQL command line or MySQL Workbench
3. Run the `database_setup.sql` script:
   ```sql
   source C:/Users/Gayashan Pathirana/eclipse-workspace/OOPWebProject/database_setup.sql
   ```
   OR manually execute the SQL commands in the file

4. Verify the database is created:
   ```sql
   USE oop_project_db;
   SHOW TABLES;
   SELECT * FROM users;
   ```

### 2. Database Configuration
Update the database credentials in `DBUtil.java` if needed:
```java
private static final String URL = "jdbc:mysql://localhost:3306/oop_project_db?useSSL=false&serverTimezone=UTC";
private static final String USER = "admin";
private static final String PASS = "admin123";
```

### 3. Deploy to Tomcat
1. Make sure Apache Tomcat 9.0 is installed
2. In Eclipse:
   - Right-click on project → Run As → Run on Server
   - Select Tomcat v9.0 Server
   - Click Finish

### 4. Access the Application
Once deployed, open your browser and navigate to:
```
http://localhost:8080/OOPWebProject/login.jsp
```

## Default Test Accounts
Use these credentials to login (from database_setup.sql):

| Email | Password | Name |
|-------|----------|------|
| admin@test.com | admin123 | Admin User |
| john@example.com | password123 | John Doe |
| jane@example.com | password123 | Jane Smith |

## Usage Guide

### Registration
1. Go to the login page
2. Click "Create Account"
3. Fill in all required fields:
   - Full Name
   - Email Address
   - Country
   - Password
   - Confirm Password
4. Click "Create Account"
5. You'll be redirected to login page

### Login
1. Enter your email and password
2. Click "Sign In"
3. You'll be redirected to the dashboard

### Dashboard Features
- View account statistics
- Quick access to profile, users list, and settings
- See welcome message with user info

### Profile Management
- View your profile details
- Edit your information
- See account statistics

### User Management
- View all registered users in a card layout
- Search users by name or email
- Edit or delete users
- See which user is currently logged in

### Settings
- Manage account preferences
- Enable/disable notifications (coming soon)
- Change password (coming soon)
- Two-factor authentication (coming soon)

## Security Features
- Session-based authentication
- Protected routes (redirect to login if not authenticated)
- Email uniqueness validation
- Password confirmation on registration
- Session invalidation on logout

## UI Features
- Modern gradient designs
- Smooth animations
- Responsive layout (mobile-friendly)
- Password visibility toggle
- Password strength indicator
- Search functionality
- Interactive cards and buttons
- Professional color schemes

## API Endpoints

### Authentication
- `POST /auth?action=register` - Register new user
- `POST /auth?action=login` - Login user
- `GET /auth?action=logout` - Logout user

### User Management
- `GET /list` - View all users
- `GET /edit?id={id}` - Edit user form
- `POST /update` - Update user
- `GET /delete?id={id}` - Delete user
- `POST /insert` - Create new user

## Future Enhancements
- Password hashing with BCrypt
- Email verification
- Forgot password functionality
- Two-factor authentication
- Profile picture upload
- Activity logs
- Admin role management
- Advanced search and filtering
- Export user data

## Troubleshooting

### Database Connection Error
- Verify MySQL is running
- Check database credentials in DBUtil.java
- Ensure database exists: `SHOW DATABASES;`

### 404 Error
- Check Tomcat server is running
- Verify project is deployed correctly
- Check URL path is correct

### Login Not Working
- Verify user exists in database
- Check email and password match database records
- Clear browser cache and cookies

## Notes
⚠️ **Important**: This is a demonstration project. For production use:
- Implement password hashing (BCrypt, Argon2, etc.)
- Add HTTPS/SSL support
- Implement CSRF protection
- Add input sanitization
- Use prepared statements (already implemented)
- Add logging and error handling
- Implement rate limiting for login attempts

## Author
Developed for OOP Web Project

## License
This project is for educational purposes.
