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
    <title>Welcome - PowerSplit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>⚡ PowerSplit</h1>
                    <p>Smart Electricity Bill Splitting for Boarding Houses</p>
                </div>

                <div class="card-body text-center">
                    <p class="mb-4">Fairly track and split electricity costs among multiple tenants based on actual appliance usage and meter readings.</p>

                    <div class="d-flex flex-column gap-md">
                        <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-primary btn-lg">
                            Sign In
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/register.jsp" class="btn btn-outline btn-lg">
                            Create New Account
                        </a>
                    </div>
                </div>

                <div class="auth-footer">
                    <div class="text-center">
                        <h6 class="mb-3">Key Features</h6>
                        <div class="d-flex flex-column gap-sm text-left">
                            <span>⚡ Automatic Bill Calculation with CEB Tiered Rates</span>
                            <span>📊 Fair Cost Splitting Based on Usage</span>
                            <span>🏠 Room & Appliance Management</span>
                            <span>📈 Usage Reports & Analytics</span>
                            <span>⚠️ High Usage Alerts</span>
                            <span>💡 Energy Saving Recommendations</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4" style="color: white;">
                <p>&copy; 2025 PowerSplit. All rights reserved.</p>
            </div>
        </div>
    </div>
</body>
</html>