<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - OOP Web Project</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 30px;
        }

        .welcome-container {
            text-align: center;
            color: white;
            max-width: 700px;
            animation: fadeIn 1s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            font-size: 80px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        h1 {
            font-size: 48px;
            margin-bottom: 15px;
            font-weight: 700;
        }

        .subtitle {
            font-size: 20px;
            margin-bottom: 40px;
            opacity: 0.95;
        }

        .button-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 16px 40px;
            font-size: 18px;
            font-weight: 600;
            border-radius: 50px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: white;
            color: #667eea;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
        }

        .btn-secondary:hover {
            background: white;
            color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .features {
            margin-top: 60px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
        }

        .feature {
            background: rgba(255, 255, 255, 0.1);
            padding: 25px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            animation: fadeIn 1s ease;
        }

        .feature:nth-child(1) { animation-delay: 0.2s; }
        .feature:nth-child(2) { animation-delay: 0.4s; }
        .feature:nth-child(3) { animation-delay: 0.6s; }

        .feature-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .feature-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .feature-description {
            font-size: 14px;
            opacity: 0.9;
        }

        @media (max-width: 768px) {
            h1 {
                font-size: 36px;
            }

            .subtitle {
                font-size: 16px;
            }

            .logo {
                font-size: 60px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="logo">🚀</div>
        <h1>OOP Web Project</h1>
        <p class="subtitle">A modern user management system with authentication</p>

        <div class="button-group">
            <a href="login.jsp" class="btn btn-primary">Sign In</a>
            <a href="register.jsp" class="btn btn-secondary">Create Account</a>
        </div>

        <div class="features">
            <div class="feature">
                <div class="feature-icon">🔐</div>
                <div class="feature-title">Secure Authentication</div>
                <div class="feature-description">Safe and secure login system</div>
            </div>

            <div class="feature">
                <div class="feature-icon">👥</div>
                <div class="feature-title">User Management</div>
                <div class="feature-description">Complete CRUD operations</div>
            </div>

            <div class="feature">
                <div class="feature-icon">📊</div>
                <div class="feature-title">Dashboard</div>
                <div class="feature-description">Beautiful and intuitive interface</div>
            </div>
        </div>
    </div>
</body>
</html>