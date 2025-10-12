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
    <title>Dashboard - OOP Web Project</title>
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
        }

        .navbar-user {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            background: white;
            color: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
        }

        .user-details {
            text-align: right;
        }

        .user-name {
            font-weight: 600;
            font-size: 15px;
        }

        .user-email {
            font-size: 12px;
            opacity: 0.9;
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-logout:hover {
            background: white;
            color: #667eea;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .welcome-section {
            background: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
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

        .welcome-section h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }

        .welcome-section p {
            color: #666;
            font-size: 16px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeIn 0.5s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .stat-card.purple {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .stat-card.pink {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }

        .stat-card.green {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }

        .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .stat-title {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
        }

        .actions-section {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            animation: fadeIn 0.5s ease 0.2s backwards;
        }

        .actions-section h2 {
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .action-btn {
            padding: 20px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #333;
            display: block;
        }

        .action-btn:hover {
            border-color: #667eea;
            background: #f8f9ff;
            transform: translateY(-3px);
        }

        .action-btn .icon {
            font-size: 36px;
            margin-bottom: 10px;
        }

        .action-btn .title {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .action-btn .description {
            font-size: 13px;
            color: #999;
        }

        .info-card {
            background: #fff9e6;
            border-left: 4px solid #ffa726;
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
            animation: fadeIn 0.5s ease 0.4s backwards;
        }

        .info-card h3 {
            color: #e65100;
            margin-bottom: 10px;
            font-size: 18px;
        }

        .info-card p {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
        }

        @media (max-width: 768px) {
            .navbar-content {
                padding: 0 20px;
            }

            .navbar-brand {
                font-size: 20px;
            }

            .user-details {
                display: none;
            }

            .welcome-section {
                padding: 25px;
            }

            .welcome-section h1 {
                font-size: 24px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-section {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <div class="navbar-brand">🚀 OOP Web Project</div>
            <div class="navbar-user">
                <div class="user-info">
                    <div class="user-avatar"><%= user.getName().substring(0, 1).toUpperCase() %></div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getName() %></div>
                        <div class="user-email"><%= user.getEmail() %></div>
                    </div>
                </div>
                <a href="auth?action=logout" class="btn-logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="welcome-section">
            <h1>Welcome back, <%= user.getName() %>! 👋</h1>
            <p>Here's what's happening with your account today.</p>
        </div>

        <div class="stats-grid">
            <div class="stat-card purple">
                <div class="stat-icon">👤</div>
                <div class="stat-title">Account Status</div>
                <div class="stat-value">Active</div>
            </div>

            <div class="stat-card pink">
                <div class="stat-icon">🌍</div>
                <div class="stat-title">Location</div>
                <div class="stat-value"><%= user.getCountry() %></div>
            </div>

            <div class="stat-card green">
                <div class="stat-icon">📧</div>
                <div class="stat-title">Email Verified</div>
                <div class="stat-value">Yes</div>
            </div>
        </div>

        <div class="actions-section">
            <h2>Quick Actions</h2>
            <div class="action-buttons">
                <a href="profile.jsp" class="action-btn">
                    <div class="icon">👤</div>
                    <div class="title">My Profile</div>
                    <div class="description">View and edit your profile</div>
                </a>

                <a href="list" class="action-btn">
                    <div class="icon">📋</div>
                    <div class="title">All Users</div>
                    <div class="description">View all registered users</div>
                </a>

                <a href="settings.jsp" class="action-btn">
                    <div class="icon">⚙️</div>
                    <div class="title">Settings</div>
                    <div class="description">Manage your settings</div>
                </a>

                <a href="#" class="action-btn" onclick="alert('Help documentation coming soon!'); return false;">
                    <div class="icon">❓</div>
                    <div class="title">Help & Support</div>
                    <div class="description">Get help and support</div>
                </a>
            </div>

            <div class="info-card">
                <h3>💡 Pro Tip</h3>
                <p>Keep your account secure by using a strong password and never sharing your credentials with anyone.</p>
            </div>
        </div>
    </div>
</body>
</html>
