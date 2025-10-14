<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
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
    <title><%= isEdit ? "Edit User" : "Add New User" %> - OOP Web Project</title>
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
                            <a href="${pageContext.request.contextPath}/listUsers.jsp" class="nav-link active">Users</a>
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
                <!-- Breadcrumb -->
                <ul class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard.jsp">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/listUsers.jsp">Users</a></li>
                    <li class="breadcrumb-item active"><%= isEdit ? "Edit User" : "Add New User" %></li>
                </ul>

                <!-- Page Header -->
                <div class="mb-4">
                    <h1><%= isEdit ? "Edit User" : "Add New User" %></h1>
                    <p class="text-secondary"><%= isEdit ? "Update user information" : "Fill in the details to create a new user" %></p>
                </div>

                <!-- User Form Card -->
                <div class="card">
                    <div class="card-header">
                        User Information
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/users/<%= isEdit ? "update" : "insert" %>"
                              method="post">

                            <% if (isEdit) { %>
                                <input type="hidden" name="id" value="<%= user.getId() %>">
                            <% } %>

                            <div class="form-group">
                                <label class="form-label" for="firstName">First Name *</label>
                                <input type="text" id="firstName" name="firstName" class="form-control"
                                       value="<%= isEdit ? user.getfirstName() : "" %>"
                                       placeholder="Enter first name" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="lastName">Last Name *</label>
                                <input type="text" id="lastName" name="lastName" class="form-control"
                                       value="<%= isEdit ? user.getlastName() : "" %>"
                                       placeholder="Enter last name" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="email">Email Address *</label>
                                <input type="email" id="email" name="email" class="form-control"
                                       value="<%= isEdit ? user.getEmail() : "" %>"
                                       placeholder="user@example.com" required>
                                <span class="form-text">We'll never share this email with anyone else</span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="phone">Phone Number</label>
                                <input type="tel" id="phone" name="phone" class="form-control"
                                       value="<%= isEdit ? user.getPhone() : "" %>"
                                       placeholder="+1 (555) 123-4567">
                            </div>

                            <% if (!isEdit) { %>
                                <div class="form-group">
                                    <label class="form-label" for="password">Password *</label>
                                    <input type="password" id="password" name="password" class="form-control"
                                           placeholder="Create a secure password" required minlength="8">
                                    <span class="form-text">Password must be at least 8 characters long</span>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="confirmPassword">Confirm Password *</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                                           placeholder="Re-enter password" required>
                                </div>
                            <% } %>

                            <div class="form-group">
                                <label class="form-label" for="role">Role *</label>
                                <select id="role" name="role" class="form-control" required>
                                    <option value="">Select Role</option>
                                    <option value="admin" <%= isEdit && "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                                    <option value="user" <%= isEdit && "user".equals(user.getRole()) ? "selected" : "" %>>User</option>
                                    <option value="moderator" <%= isEdit && "moderator".equals(user.getRole()) ? "selected" : "" %>>Moderator</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="status">Status *</label>
                                <select id="status" name="status" class="form-control" required>
                                    <option value="active" <%= isEdit && "active".equals(user.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="inactive" <%= isEdit && "inactive".equals(user.getStatus()) ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="address">Address</label>
                                <textarea id="address" name="address" class="form-control"
                                          rows="3" placeholder="Enter full address"><%= isEdit ? user.getAddress() : "" %></textarea>
                            </div>

                            <div class="d-flex gap-md mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <%= isEdit ? "Update User" : "Create User" %>
                                </button>
                                <a href="${pageContext.request.contextPath}/listUsers.jsp" class="btn btn-secondary">
                                    Cancel
                                </a>
                                <% if (isEdit) { %>
                                    <button type="button" class="btn btn-warning ml-auto"
                                            onclick="if(confirm('Send password reset email to this user?')) alert('Password reset email sent!')">
                                        Reset Password
                                    </button>
                                <% } %>
                            </div>
                        </form>
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
</body>
</html>