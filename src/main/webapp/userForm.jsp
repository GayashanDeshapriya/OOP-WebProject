<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    User user = (User) request.getAttribute("user");
    boolean isEdit = (user != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit User" : "Add User" %> - OOP Web Project</title>
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
            max-width: 700px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-card {
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

        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
        }

        .form-header h1 {
            font-size: 28px;
            margin-bottom: 5px;
        }

        .form-header p {
            font-size: 14px;
            opacity: 0.9;
        }

        .form-body {
            padding: 40px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .required {
            color: #f5576c;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
            outline: none;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #999;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }

        .btn {
            flex: 1;
            padding: 14px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            text-align: center;
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

        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #1976d2;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box p {
            color: #1565c0;
            font-size: 14px;
            margin: 0;
        }

        @media (max-width: 768px) {
            .navbar-content {
                padding: 0 20px;
            }

            .form-header,
            .form-body {
                padding: 25px;
            }

            .form-actions {
                flex-direction: column;
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
        <div class="form-card">
            <div class="form-header">
                <h1><%= isEdit ? "✏️ Edit User" : "➕ Add New User" %></h1>
                <p><%= isEdit ? "Update user information" : "Create a new user account" %></p>
            </div>

            <div class="form-body">
                <% if (isEdit) { %>
                    <div class="info-box">
                        <p>💡 Note: Password cannot be changed through this form for security reasons.</p>
                    </div>
                <% } %>

                <form action="<%= isEdit ? "update" : "insert" %>" method="post">
                    <% if (isEdit) { %>
                        <input type="hidden" name="id" value="<%= user.getId() %>">
                    <% } %>

                    <div class="form-group">
                        <label for="name">Full Name <span class="required">*</span></label>
                        <input type="text" id="name" name="name" 
                               placeholder="Enter full name" 
                               value="<%= isEdit ? user.getName() : "" %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" 
                               placeholder="Enter email address" 
                               value="<%= isEdit ? user.getEmail() : "" %>"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="country">Country <span class="required">*</span></label>
                        <select id="country" name="country" required>
                            <option value="">Select country</option>
                            <option value="Sri Lanka" <%= isEdit && "Sri Lanka".equals(user.getCountry()) ? "selected" : "" %>>Sri Lanka</option>
                            <option value="India" <%= isEdit && "India".equals(user.getCountry()) ? "selected" : "" %>>India</option>
                            <option value="USA" <%= isEdit && "USA".equals(user.getCountry()) ? "selected" : "" %>>United States</option>
                            <option value="UK" <%= isEdit && "UK".equals(user.getCountry()) ? "selected" : "" %>>United Kingdom</option>
                            <option value="Canada" <%= isEdit && "Canada".equals(user.getCountry()) ? "selected" : "" %>>Canada</option>
                            <option value="Australia" <%= isEdit && "Australia".equals(user.getCountry()) ? "selected" : "" %>>Australia</option>
                            <option value="Germany" <%= isEdit && "Germany".equals(user.getCountry()) ? "selected" : "" %>>Germany</option>
                            <option value="France" <%= isEdit && "France".equals(user.getCountry()) ? "selected" : "" %>>France</option>
                            <option value="Japan" <%= isEdit && "Japan".equals(user.getCountry()) ? "selected" : "" %>>Japan</option>
                            <option value="Other" <%= isEdit && "Other".equals(user.getCountry()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <% if (!isEdit) { %>
                        <div class="form-group">
                            <label for="password">Password <span class="required">*</span></label>
                            <input type="password" id="password" name="password" 
                                   placeholder="Enter password" 
                                   required>
                        </div>
                    <% } %>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <%= isEdit ? "💾 Update User" : "✅ Create User" %>
                        </button>
                        <a href="list" class="btn btn-secondary">❌ Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
