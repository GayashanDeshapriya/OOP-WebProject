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
    <title>Settings - OOP Web Project</title>
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
                            <a href="${pageContext.request.contextPath}/profile.jsp" class="nav-link">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/settings.jsp" class="nav-link active">Settings</a>
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
                <h1>System Settings</h1>
                <p class="text-secondary mb-4">Manage your application settings and preferences</p>

                <!-- General Settings -->
                <div class="card">
                    <div class="card-header">
                        General Settings
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/settings/update" method="post">
                            <div class="form-group">
                                <label class="form-label" for="siteName">Site Name</label>
                                <input type="text" id="siteName" name="siteName" class="form-control" 
                                       value="OOP Web Project">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="siteDescription">Site Description</label>
                                <textarea id="siteDescription" name="siteDescription" class="form-control" 
                                          rows="3">A modern user management system built with Java and JSP</textarea>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="adminEmail">Admin Email</label>
                                <input type="email" id="adminEmail" name="adminEmail" class="form-control" 
                                       value="admin@oopwebproject.com">
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" id="maintenanceMode" name="maintenanceMode" 
                                       class="form-check-input">
                                <label class="form-check-label" for="maintenanceMode">
                                    Enable Maintenance Mode
                                </label>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Settings</button>
                        </form>
                    </div>
                </div>

                <!-- Email Settings -->
                <div class="card">
                    <div class="card-header">
                        Email Configuration
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/settings/email" method="post">
                            <div class="form-group">
                                <label class="form-label" for="smtpHost">SMTP Host</label>
                                <input type="text" id="smtpHost" name="smtpHost" class="form-control" 
                                       placeholder="smtp.gmail.com">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="smtpPort">SMTP Port</label>
                                <input type="number" id="smtpPort" name="smtpPort" class="form-control" 
                                       placeholder="587">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="smtpUsername">SMTP Username</label>
                                <input type="text" id="smtpUsername" name="smtpUsername" class="form-control">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="smtpPassword">SMTP Password</label>
                                <input type="password" id="smtpPassword" name="smtpPassword" class="form-control">
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" id="enableSSL" name="enableSSL" class="form-check-input" checked>
                                <label class="form-check-label" for="enableSSL">
                                    Enable SSL/TLS
                                </label>
                            </div>

                            <div class="d-flex gap-md">
                                <button type="submit" class="btn btn-primary">Save Configuration</button>
                                <button type="button" class="btn btn-outline" 
                                        onclick="alert('Test email sent! Check your inbox.')">
                                    Send Test Email
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Security Settings -->
                <div class="card">
                    <div class="card-header">
                        Security Settings
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/settings/security" method="post">
                            <div class="form-group">
                                <label class="form-label" for="sessionTimeout">Session Timeout (minutes)</label>
                                <input type="number" id="sessionTimeout" name="sessionTimeout" 
                                       class="form-control" value="30" min="5" max="1440">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="maxLoginAttempts">Max Login Attempts</label>
                                <input type="number" id="maxLoginAttempts" name="maxLoginAttempts" 
                                       class="form-control" value="5" min="3" max="10">
                            </div>

                            <div class="form-check mb-2">
                                <input type="checkbox" id="requireStrongPassword" name="requireStrongPassword" 
                                       class="form-check-input" checked>
                                <label class="form-check-label" for="requireStrongPassword">
                                    Require Strong Passwords
                                </label>
                            </div>

                            <div class="form-check mb-2">
                                <input type="checkbox" id="twoFactorAuth" name="twoFactorAuth" 
                                       class="form-check-input">
                                <label class="form-check-label" for="twoFactorAuth">
                                    Enable Two-Factor Authentication
                                </label>
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" id="emailVerification" name="emailVerification" 
                                       class="form-check-input" checked>
                                <label class="form-check-label" for="emailVerification">
                                    Require Email Verification
                                </label>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Security Settings</button>
                        </form>
                    </div>
                </div>

                <!-- Database Backup -->
                <div class="card">
                    <div class="card-header">
                        Database Backup
                    </div>
                    <div class="card-body">
                        <p class="card-text">Create a backup of your database or restore from a previous backup.</p>
                        
                        <div class="alert alert-info">
                            <strong>Last Backup:</strong> October 14, 2025 at 2:30 PM
                        </div>

                        <div class="d-flex gap-md">
                            <button type="button" class="btn btn-success" 
                                    onclick="alert('Database backup started...')">
                                Create Backup
                            </button>
                            <button type="button" class="btn btn-warning" 
                                    onclick="if(confirm('Are you sure you want to restore? This will overwrite current data.')) alert('Restore initiated...')">
                                Restore Backup
                            </button>
                            <button type="button" class="btn btn-outline">
                                Schedule Automatic Backups
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Danger Zone -->
                <div class="card">
                    <div class="card-header" style="background-color: #fee2e2; border-color: #fecaca;">
                        <span style="color: #991b1b;">⚠️ Danger Zone</span>
                    </div>
                    <div class="card-body">
                        <h5>Clear All Data</h5>
                        <p class="card-text text-secondary">
                            This will permanently delete all users, logs, and system data. This action cannot be undone.
                        </p>
                        <button type="button" class="btn btn-danger" 
                                onclick="if(confirm('WARNING: This will delete ALL data! Are you absolutely sure?')) alert('Data clearing process initiated...')">
                            Clear All Data
                        </button>
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