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
    <title>My Profile - OOP Web Project</title>
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

        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            overflow: hidden;
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

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px;
            text-align: center;
            color: white;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            color: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            font-weight: 700;
            margin: 0 auto 20px;
            border: 5px solid rgba(255, 255, 255, 0.3);
        }

        .profile-name {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .profile-email {
            font-size: 16px;
            opacity: 0.9;
        }

        .profile-body {
            padding: 40px;
        }

        .info-section {
            margin-bottom: 30px;
        }

        .info-section h2 {
            color: #333;
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .info-item {
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }

        .info-label {
            font-size: 12px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 18px;
            color: #333;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #f0f0f0;
            color: #333;
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .btn-danger {
            background: #f5576c;
            color: white;
        }

        .btn-danger:hover {
            background: #e64757;
            transform: translateY(-2px);
        }

        .stats-section {
            margin-top: 30px;
            padding: 25px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border-radius: 10px;
            color: white;
        }

        .stats-section h3 {
            margin-bottom: 15px;
            font-size: 18px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 13px;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            .navbar-content {
                padding: 0 20px;
            }

            .profile-header {
                padding: 30px 20px;
            }

            .profile-body {
                padding: 30px 20px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
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
                <a href="list" class="nav-link">Users</a>
                <a href="auth?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar"><%= user.getfirstName().substring(0, 1).toUpperCase() %></div>
                <div class="profile-name"><%= user.getfirstName() %></div>
                <div class="profile-email"><%= user.getEmail() %></div>
            </div>

            <div class="profile-body">
                <div class="info-section">
                    <h2>📋 Account Information</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">User ID</div>
                            <div class="info-value">#<%= user.getId() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Full Name</div>
                            <div class="info-value"><%= user.getfirstName() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email Address</div>
                            <div class="info-value"><%= user.getEmail() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Country</div>
                            <div class="info-value"><%= user.getlastName() %></div>
                        </div>
                    </div>
                </div>

                <div class="stats-section">
                    <h3>📊 Account Statistics</h3>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-value">100%</div>
                            <div class="stat-label">Profile Complete</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">Active</div>
                            <div class="stat-label">Account Status</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">✓</div>
                            <div class="stat-label">Email Verified</div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <a href="edit?id=<%= user.getId() %>" class="btn btn-primary">✏️ Edit Profile</a>
                    <a href="dashboard.jsp" class="btn btn-secondary">← Back to Dashboard</a>
                    <button onclick="if(confirm('Are you sure you want to delete your account?')) { alert('Account deletion feature coming soon!'); }" class="btn btn-danger">🗑️ Delete Account</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
