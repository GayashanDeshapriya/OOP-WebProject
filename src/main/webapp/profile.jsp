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
    <title>My Profile - OOP Web Project</title>
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
                            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="nav-link">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/listUsers.jsp" class="nav-link">Users</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link active">Profile</a>
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
                <!-- Profile Header -->
                <div class="profile-header">
                    <img src="https://ui-avatars.com/api/?name=<%= user.getfirstName() %>+<%= user.getlastName() %>&size=120&background=2563eb&color=fff"
                         alt="Profile Avatar" class="profile-avatar">
                    <div class="profile-info">
                        <h2><%= user.getfirstName() %> <%= user.getlastName() %></h2>
                        <p class="text-secondary"><%= user.getEmail() %></p>
                        <div class="profile-meta">
                            <span><strong>Role:</strong> <span class="badge badge-primary"><%= user.getRole() %></span></span>
                            <span><strong>Status:</strong> <span class="badge badge-success"><%= user.getStatus() %></span></span>
                            <span><strong>Joined:</strong> <%= user.getCreatedDate() %></span>
                        </div>
                    </div>
                </div>

                <!-- Profile Tabs -->
                <div class="profile-tabs">
                    <button class="profile-tab active" onclick="showTab('info')">Personal Information</button>
                    <button class="profile-tab" onclick="showTab('security')">Security</button>
                    <button class="profile-tab" onclick="showTab('activity')">Activity Log</button>
                </div>

                <!-- Tab Content: Personal Information -->
                <div id="info-tab" class="tab-content">
                    <div class="card">
                        <div class="card-header">
                            Personal Information
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/profile/update" method="post">
                                <div class="form-group">
                                    <label class="form-label" for="firstName">First Name</label>
                                    <input type="text" id="firstName" name="firstName" class="form-control"
                                           value="<%= user.getfirstName() %>" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="lastName">Last Name</label>
                                    <input type="text" id="lastName" name="lastName" class="form-control"
                                           value="<%= user.getlastName() %>" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="email">Email Address</label>
                                    <input type="email" id="email" name="email" class="form-control"
                                           value="<%= user.getEmail() %>" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="phone">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" class="form-control"
                                           value="<%= user.getPhone() %>">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="address">Address</label>
                                    <textarea id="address" name="address" class="form-control"
                                              rows="3"><%= user.getAddress() %></textarea>
                                </div>

                                <button type="submit" class="btn btn-primary">Save Changes</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tab Content: Security -->
                <div id="security-tab" class="tab-content d-none">
                    <div class="card">
                        <div class="card-header">
                            Change Password
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/profile/change-password" method="post">
                                <div class="form-group">
                                    <label class="form-label" for="currentPassword">Current Password</label>
                                    <input type="password" id="currentPassword" name="currentPassword"
                                           class="form-control" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="newPassword">New Password</label>
                                    <input type="password" id="newPassword" name="newPassword"
                                           class="form-control" minlength="8" required>
                                    <span class="form-text">Password must be at least 8 characters</span>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="confirmNewPassword">Confirm New Password</label>
                                    <input type="password" id="confirmNewPassword" name="confirmNewPassword"
                                           class="form-control" required>
                                </div>

                                <button type="submit" class="btn btn-primary">Update Password</button>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Tab Content: Activity Log -->
                <div id="activity-tab" class="tab-content d-none">
                    <div class="card">
                        <div class="card-header">
                            Recent Activity
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Action</th>
                                            <th>Date & Time</th>
                                            <th>IP Address</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>Login</td>
                                            <td>2025-10-14 10:30 AM</td>
                                            <td>192.168.1.100</td>
                                            <td><span class="badge badge-success">Success</span></td>
                                        </tr>
                                        <tr>
                                            <td>Profile Updated</td>
                                            <td>2025-10-13 03:15 PM</td>
                                            <td>192.168.1.100</td>
                                            <td><span class="badge badge-success">Success</span></td>
                                        </tr>
                                        <tr>
                                            <td>Password Changed</td>
                                            <td>2025-10-10 09:00 AM</td>
                                            <td>192.168.1.100</td>
                                            <td><span class="badge badge-success">Success</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
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
                </div>
            </div>
        </footer>
    </div>

    <script>
        function showTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.add('d-none');
            });

            // Remove active class from all tab buttons
            document.querySelectorAll('.profile-tab').forEach(btn => {
                btn.classList.remove('active');
            });

            // Show selected tab
            document.getElementById(tabName + '-tab').classList.remove('d-none');

            // Add active class to clicked button
            event.target.classList.add('active');
        }
    </script>
</body>
</html>