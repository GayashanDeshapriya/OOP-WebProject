<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - OOP Web Project</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }

        .navbar-links {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .settings-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 25px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .settings-header {
            padding: 30px 40px;
            border-bottom: 2px solid #f0f0f0;
        }

        .settings-header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 5px;
        }

        .settings-header p {
            color: #666;
            font-size: 14px;
        }

        .settings-section {
            padding: 30px 40px;
        }

        .settings-section h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
        }

        .setting-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .setting-info {
            flex-grow: 1;
        }

        .setting-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .setting-description {
            font-size: 13px;
            color: #666;
        }

        .setting-action {
            margin-left: 20px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-danger {
            background: #f5576c;
            color: white;
        }

        .btn-danger:hover {
            background: #e64757;
            transform: translateY(-2px);
        }

        .toggle-switch {
            position: relative;
            width: 50px;
            height: 26px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #667eea;
        }

        input:checked + .slider:before {
            transform: translateX(24px);
        }

        @media (max-width: 768px) {
            .navbar-content {
                padding: 0 20px;
            }

            .settings-header,
            .settings-section {
                padding: 20px;
            }

            .setting-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .setting-action {
                margin-left: 0;
                width: 100%;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="dashboard.jsp" class="navbar-brand">🚀 OOP Web Project</a>
            <div class="navbar-links">
                <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="profile.jsp" class="nav-link">Profile</a>
                <a href="list" class="nav-link">Users</a>
                <a href="auth?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="settings-card">
            <div class="settings-header">
                <h1>⚙️ Settings</h1>
                <p>Manage your account settings and preferences</p>
            </div>

            <div class="settings-section">
                <h2>Account Settings</h2>
                
                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-title">Edit Profile</div>
                        <div class="setting-description">Update your personal information</div>
                    </div>
                    <div class="setting-action">
                        <a href="edit?id=<%= user.getId() %>" class="btn btn-primary">Edit</a>
                    </div>
                </div>

                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-title">Email Notifications</div>
                        <div class="setting-description">Receive notifications via email</div>
                    </div>
                    <div class="setting-action">
                        <label class="toggle-switch">
                            <input type="checkbox" checked onclick="alert('Email notifications feature coming soon!')">
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>

                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-title">Two-Factor Authentication</div>
                        <div class="setting-description">Add an extra layer of security to your account</div>
                    </div>
                    <div class="setting-action">
                        <label class="toggle-switch">
                            <input type="checkbox" onclick="alert('2FA feature coming soon!')">
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
            </div>

            <div class="settings-section">
                <h2>Security</h2>
                
                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-title">Change Password</div>
                        <div class="setting-description">Update your password regularly for better security</div>
                    </div>
                    <div class="setting-action">
                        <button class="btn btn-primary" onclick="alert('Change password feature coming soon!')">Change</button>
                    </div>
                </div>

                <div class="setting-item">
                    <div class="setting-info">
                        <div class="setting-title">Session Management</div>
                        <div class="setting-description">Manage your active sessions</div>
                    </div>
                    <div class="setting-action">
                        <button class="btn btn-primary" onclick="alert('Active Sessions: 1')">View</button>
                    </div>
                </div>
            </div>

            <div class="settings-section">
                <h2>Danger Zone</h2>
                
                <div class="setting-item" style="border: 2px solid #f5576c;">
                    <div class="setting-info">
                        <div class="setting-title" style="color: #f5576c;">Delete Account</div>
                        <div class="setting-description">Permanently delete your account and all data</div>
                    </div>
                    <div class="setting-action">
                        <button class="btn btn-danger" 
                                onclick="if(confirm('Are you sure you want to delete your account? This action cannot be undone!')) { alert('Account deletion feature coming soon!'); }">
                            Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
