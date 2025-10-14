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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>🎉 OOP Web Project</h1>
                    <p>Modern User Management System</p>
                </div>

                <div class="card-body text-center">
                    <p class="mb-4">Welcome to our comprehensive user management system built with Java, JSP, and modern CSS.</p>

                    <div class="d-flex flex-column gap-md">
                        <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-primary btn-lg">
                            Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline btn-lg">
                            Create New Account
                        </a>
                    </div>
                </div>

                <div class="auth-footer">
                    <div class="text-center">
                        <h6 class="mb-3">Features</h6>
                        <div class="d-flex flex-column gap-sm text-left">
                            <span>✅ Modern, Responsive Design</span>
                            <span>✅ User Authentication & Authorization</span>
                            <span>✅ Complete CRUD Operations</span>
                            <span>✅ Profile Management</span>
                            <span>✅ System Settings</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4" style="color: white;">
                <p>&copy; 2025 OOP Web Project. All rights reserved.</p>
            </div>
        </div>
    </div>
</body>
</html>