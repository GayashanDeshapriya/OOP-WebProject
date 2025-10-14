# CSS Styling Guide - OOP Web Project

## Overview
This guide explains how to use the centralized CSS system (`style.css`) to maintain a consistent, professional appearance across your entire web application.

## Including the CSS File

Add this line in the `<head>` section of all your JSP pages:

```html
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
```

## Color Scheme

The system uses CSS variables for consistent theming:

- **Primary Color**: Blue (#2563eb) - Used for main actions, links, navigation
- **Success**: Green (#10b981) - For success messages, positive actions
- **Danger**: Red (#ef4444) - For errors, delete actions
- **Warning**: Orange (#f59e0b) - For warnings, caution actions
- **Info**: Cyan (#06b6d4) - For informational messages

## Page Layout Structure

### Basic Page Template

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
        <!-- Header with Navigation -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="#" class="navbar-brand">OOP Web Project</a>
                    <ul class="navbar-nav">
                        <li class="nav-item"><a href="#" class="nav-link active">Dashboard</a></li>
                        <li class="nav-item"><a href="#" class="nav-link">Users</a></li>
                        <li class="nav-item"><a href="#" class="nav-link">Profile</a></li>
                        <li class="nav-item"><a href="#" class="nav-link">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Your content here -->
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <p class="footer-text">&copy; 2025 OOP Web Project. All rights reserved.</p>
                    <ul class="footer-links">
                        <li><a href="#">Privacy</a></li>
                        <li><a href="#">Terms</a></li>
                        <li><a href="#">Contact</a></li>
                    </ul>
                </div>
            </div>
        </footer>
    </div>
</body>
</html>
```

## Component Usage

### 1. Buttons

```html
<!-- Primary button -->
<button class="btn btn-primary">Save</button>

<!-- Other button variants -->
<button class="btn btn-secondary">Cancel</button>
<button class="btn btn-success">Approve</button>
<button class="btn btn-danger">Delete</button>
<button class="btn btn-warning">Warning</button>
<button class="btn btn-outline">Outline</button>

<!-- Button sizes -->
<button class="btn btn-primary btn-sm">Small</button>
<button class="btn btn-primary">Normal</button>
<button class="btn btn-primary btn-lg">Large</button>

<!-- Full width button -->
<button class="btn btn-primary btn-block">Full Width Button</button>

<!-- Disabled button -->
<button class="btn btn-primary" disabled>Disabled</button>
```

### 2. Forms

```html
<form class="auth-form">
    <div class="form-group">
        <label class="form-label" for="username">Username</label>
        <input type="text" id="username" name="username" class="form-control" 
               placeholder="Enter username" required>
        <span class="form-text">Choose a unique username</span>
    </div>

    <div class="form-group">
        <label class="form-label" for="email">Email</label>
        <input type="email" id="email" name="email" class="form-control" 
               placeholder="Enter email" required>
    </div>

    <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control" 
               placeholder="Enter password" required>
        <div class="invalid-feedback">Password must be at least 8 characters</div>
    </div>

    <div class="form-check">
        <input type="checkbox" id="remember" class="form-check-input">
        <label class="form-check-label" for="remember">Remember me</label>
    </div>

    <button type="submit" class="btn btn-primary btn-block">Submit</button>
</form>
```

### 3. Cards

```html
<div class="card">
    <div class="card-header">
        Card Title
    </div>
    <div class="card-body">
        <h5 class="card-title">Content Title</h5>
        <p class="card-text">Card content goes here.</p>
        <a href="#" class="btn btn-primary">Action</a>
    </div>
    <div class="card-footer">
        Footer content
    </div>
</div>
```

### 4. Tables

```html
<div class="table-responsive">
    <table class="table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td>John Doe</td>
                <td>john@example.com</td>
                <td><span class="badge badge-success">Admin</span></td>
                <td class="action-buttons">
                    <a href="#" class="btn btn-sm btn-primary">Edit</a>
                    <a href="#" class="btn btn-sm btn-danger">Delete</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
```

### 5. Alerts

```html
<!-- Success Alert -->
<div class="alert alert-success">
    Operation completed successfully!
</div>

<!-- Error Alert -->
<div class="alert alert-danger">
    An error occurred. Please try again.
</div>

<!-- Warning Alert -->
<div class="alert alert-warning">
    Warning: This action cannot be undone.
</div>

<!-- Info Alert -->
<div class="alert alert-info">
    Information: New features available.
</div>

<!-- Dismissible Alert -->
<div class="alert alert-success alert-dismissible">
    Success message here.
    <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
</div>
```

### 6. Badges

```html
<span class="badge badge-primary">Primary</span>
<span class="badge badge-success">Active</span>
<span class="badge badge-danger">Inactive</span>
<span class="badge badge-warning">Pending</span>
<span class="badge badge-info">New</span>
```

### 7. Dashboard Stats

```html
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
    
    <div class="stat-card danger">
        <div class="stat-label">Inactive Users</div>
        <div class="stat-value">247</div>
        <div class="stat-change negative">↓ 3% from last month</div>
    </div>
</div>
```

### 8. Authentication Pages

```html
<div class="auth-wrapper">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>Welcome Back</h1>
                <p>Sign in to your account</p>
            </div>
            <form class="auth-form">
                <!-- Form fields here -->
            </form>
            <div class="auth-footer">
                <p>Don't have an account? <a href="#">Sign up</a></p>
            </div>
        </div>
    </div>
</div>
```

### 9. Pagination

```html
<div class="pagination">
    <a href="#" class="pagination-item disabled">Previous</a>
    <a href="#" class="pagination-item active">1</a>
    <a href="#" class="pagination-item">2</a>
    <a href="#" class="pagination-item">3</a>
    <a href="#" class="pagination-item">Next</a>
</div>
```

### 10. Loading Spinner

```html
<div class="spinner"></div>
<div class="spinner spinner-sm"></div>
<div class="spinner spinner-lg"></div>

<!-- Full page loading -->
<div class="loading-overlay">
    <div class="spinner spinner-lg"></div>
</div>
```

## Utility Classes

### Text Alignment
```html
<p class="text-left">Left aligned text</p>
<p class="text-center">Center aligned text</p>
<p class="text-right">Right aligned text</p>
```

### Text Colors
```html
<p class="text-primary">Primary color text</p>
<p class="text-success">Success color text</p>
<p class="text-danger">Danger color text</p>
<p class="text-warning">Warning color text</p>
<p class="text-muted">Muted text</p>
```

### Display
```html
<div class="d-none">Hidden</div>
<div class="d-block">Block</div>
<div class="d-flex">Flex container</div>
<div class="d-grid">Grid container</div>
```

### Flexbox
```html
<div class="d-flex justify-content-center align-items-center gap-md">
    <button class="btn btn-primary">Button 1</button>
    <button class="btn btn-secondary">Button 2</button>
</div>
```

### Spacing
```html
<!-- Margins -->
<div class="mt-1">Margin top small</div>
<div class="mt-2">Margin top medium</div>
<div class="mb-3">Margin bottom large</div>

<!-- Padding -->
<div class="p-2">Padding medium</div>
<div class="p-3">Padding large</div>
```

### Shadows
```html
<div class="card shadow-sm">Small shadow</div>
<div class="card shadow-md">Medium shadow</div>
<div class="card shadow-lg">Large shadow</div>
```

### Border Radius
```html
<div class="rounded">Rounded corners</div>
<div class="rounded-lg">Large rounded corners</div>
<div class="rounded-full">Fully rounded (circle)</div>
```

## Responsive Design

The system automatically adjusts for different screen sizes:

- **Desktop**: Full layout (> 768px)
- **Tablet**: Adjusted layout (481px - 768px)
- **Mobile**: Stacked layout (≤ 480px)

On mobile devices:
- Navigation becomes vertical
- Tables become scrollable
- Action buttons stack vertically
- Grid layouts become single column

## Best Practices

1. **Always use the container class** for proper width and centering
2. **Use semantic HTML** with appropriate CSS classes
3. **Combine utility classes** for quick styling adjustments
4. **Test on different screen sizes** to ensure responsiveness
5. **Use consistent spacing** with provided spacing utilities
6. **Follow the color scheme** for consistent branding
7. **Add proper labels** to all form inputs for accessibility
8. **Use appropriate button variants** based on action type

## Dark Mode

The system includes automatic dark mode support based on user's system preferences. You can test this by changing your operating system's theme settings.

## Print Styles

The system automatically optimizes for printing by hiding navigation, buttons, and adjusting colors.

## Accessibility Features

- Focus states for keyboard navigation
- Screen reader-only content with `.sr-only`
- Proper color contrast ratios
- Semantic HTML support

## Example: Complete User List Page

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User List - OOP Web Project</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/" class="navbar-brand">OOP Web Project</a>
                    <ul class="navbar-nav">
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Dashboard</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/users" class="nav-link active">Users</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/profile" class="nav-link">Profile</a></li>
                        <li class="nav-item"><a href="${pageContext.request.contextPath}/logout" class="nav-link">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <main class="main-content">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>User Management</h1>
                    <a href="${pageContext.request.contextPath}/users/new" class="btn btn-primary">Add New User</a>
                </div>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success alert-dismissible">
                        <%= request.getAttribute("message") %>
                        <button class="alert-close" onclick="this.parentElement.remove()">&times;</button>
                    </div>
                <% } %>

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
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>${user.name}</td>
                                            <td>${user.email}</td>
                                            <td><span class="badge badge-primary">${user.role}</span></td>
                                            <td><span class="badge badge-success">Active</span></td>
                                            <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/users/edit?id=${user.id}" 
                                                   class="btn btn-sm btn-primary">Edit</a>
                                                <a href="${pageContext.request.contextPath}/users/delete?id=${user.id}" 
                                                   class="btn btn-sm btn-danger" 
                                                   onclick="return confirm('Are you sure?')">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>

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
```

## Need Help?

Refer to the `CSS_TROUBLESHOOTING.md` file for common issues and solutions.