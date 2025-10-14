<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - OOP Web Project</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
        <!-- Header with Navigation -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/" class="navbar-brand">OOP Web Project</a>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="nav-link active">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/listUsers.jsp" class="nav-link">Users</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/settings.jsp" class="nav-link">Settings</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">Logout</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Page Title -->
                <div class="dashboard-header">
                    <div class="container">
                        <h1>Dashboard</h1>
                        <p class="text-secondary">Welcome back! Here's what's happening today.</p>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-label">Total Users</div>
                        <div class="stat-value">1,234</div>
                        <div class="stat-change positive">↑ 12% from last month</div>
                    </div>

                    <div class="stat-card success">
                        <div class="stat-label">Active Users</div>
                        <div class="stat-value">987</div>
                        <div class="stat-change positive">↑ 8% from last month</div>
                    </div>

                    <div class="stat-card warning">
                        <div class="stat-label">Pending Approvals</div>
                        <div class="stat-value">45</div>
                        <div class="stat-change">Needs attention</div>
                    </div>

                    <div class="stat-card info">
                        <div class="stat-label">New Registrations</div>
                        <div class="stat-value">23</div>
                        <div class="stat-change">Today</div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>Recent Activity</span>
                        <a href="${pageContext.request.contextPath}/listUsers.jsp" class="btn btn-sm btn-primary">View All</a>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>User</th>
                                        <th>Action</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>John Doe</td>
                                        <td>Created new account</td>
                                        <td>2 hours ago</td>
                                        <td><span class="badge badge-success">Completed</span></td>
                                    </tr>
                                    <tr>
                                        <td>Jane Smith</td>
                                        <td>Updated profile</td>
                                        <td>4 hours ago</td>
                                        <td><span class="badge badge-success">Completed</span></td>
                                    </tr>
                                    <tr>
                                        <td>Mike Johnson</td>
                                        <td>Password reset request</td>
                                        <td>6 hours ago</td>
                                        <td><span class="badge badge-warning">Pending</span></td>
                                    </tr>
                                    <tr>
                                        <td>Sarah Williams</td>
                                        <td>Login attempt failed</td>
                                        <td>8 hours ago</td>
                                        <td><span class="badge badge-danger">Failed</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-header">Quick Actions</div>
                    <div class="card-body">
                        <div class="d-flex gap-md flex-wrap">
                            <a href="${pageContext.request.contextPath}/userForm.jsp" class="btn btn-primary">
                                Add New User
                            </a>
                            <a href="${pageContext.request.contextPath}/listUsers.jsp" class="btn btn-secondary">
                                Manage Users
                            </a>
                            <a href="${pageContext.request.contextPath}/settings.jsp" class="btn btn-outline">
                                System Settings
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <p class="footer-text">&copy; 2025 OOP Web Project. All rights reserved.</p>
                    <ul class="footer-links">
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                        <li><a href="#">Contact Us</a></li>
                    </ul>
                </div>
            </div>
        </footer>
    </div>
</body>
</html>