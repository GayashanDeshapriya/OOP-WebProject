<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    List<User> listUser = (List<User>) request.getAttribute("listUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - OOP Web Project</title>
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
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1>User Management</h1>
                        <p class="text-secondary">Manage all users in the system</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/userForm.jsp" class="btn btn-primary">
                        Add New User
                    </a>
                </div>

                <!-- Success/Error Messages -->
                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success alert-dismissible">
                        <%= request.getAttribute("message") %>
                        <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                    </div>
                <% } %>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible">
                        <%= request.getAttribute("error") %>
                        <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                    </div>
                <% } %>

                <!-- Search and Filter -->
                <div class="filter-section">
                    <form method="get" action="${pageContext.request.contextPath}/users/search">
                        <div class="filter-group">
                            <div class="search-bar">
                                <span class="search-icon">🔍</span>
                                <input type="text" name="search" class="form-control"
                                       placeholder="Search by name or email...">
                            </div>
                            <select name="role" class="form-control">
                                <option value="">All Roles</option>
                                <option value="admin">Admin</option>
                                <option value="user">User</option>
                                <option value="moderator">Moderator</option>
                            </select>
                            <select name="status" class="form-control">
                                <option value="">All Status</option>
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Search</button>
                        </div>
                    </form>
                </div>

                <!-- Users Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listUser != null && !listUser.isEmpty()) { %>
                                        <% for (User user : listUser) { %>
                                            <tr>
                                                <td>#<%= user.getId() %></td>
                                                <td>
                                                    <%= user.getfirstName() %>
                                                    <% if (currentUser.getId() == user.getId()) { %>
                                                        <span class="badge badge-success">YOU</span>
                                                    <% } %>
                                                </td>
                                                <td><%= user.getEmail() %></td>
                                                <td><span class="badge badge-primary"><%= user.getRole() %></span></td>
                                                <td>
                                                    <span class="badge
                                                    <%= user.getStatus().equals("active") ? "badge-success" : "badge-secondary" %>">
                                                    <%= user.getStatus() %>
                                                    </span>
                                                </td>
                                                <td><%= user.getCreatedDate() %></td>
                                                <td class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/users/view?id=<%= user.getId() %>"
                                                       class="btn btn-sm btn-info" title="View">View</a>
                                                    <a href="${pageContext.request.contextPath}/userForm.jsp?id=<%= user.getId() %>"
                                                       class="btn btn-sm btn-primary" title="Edit">Edit</a>
                                                    <a href="${pageContext.request.contextPath}/users/delete?id=<%= user.getId() %>"
                                                       class="btn btn-sm btn-danger" title="Delete"
                                                       onclick="return confirm('Are you sure you want to delete <%= user.getfirstName() %>?')">
                                                       Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        <% } %>
                                    <% } else { %>
                                        <tr>
                                            <td colspan="7" class="text-center">
                                                <div class="empty-state">
                                                    <div class="empty-state-icon">😔</div>
                                                    <h3>No Users Found</h3>
                                                    <p>There are no registered users in the system yet.</p>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="pagination">
                    <a href="#" class="pagination-item disabled">Previous</a>
                    <a href="#" class="pagination-item active">1</a>
                    <a href="#" class="pagination-item">2</a>
                    <a href="#" class="pagination-item">3</a>
                    <a href="#" class="pagination-item">Next</a>
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