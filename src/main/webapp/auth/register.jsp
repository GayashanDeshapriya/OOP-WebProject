<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - OOP Web Project</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-wrapper">
        <div class="auth-container">
            <div class="auth-card">
                <div class="auth-header">
                    <h1>Create Account</h1>
                    <p>Sign up to get started</p>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth/register" method="post" class="auth-form">
                    <div class="form-group">
                        <label class="form-label" for="name">First Name</label>
                        <input type="text" id="fname" name="fname" class="form-control"
                               placeholder="Enter your first name" required autofocus>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="name">Last Name</label>
                        <input type="text" id="lname" name="lname" class="form-control"
                               placeholder="Enter your last name" required autofocus>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="Enter your email" required>
                        <span class="form-text">We'll never share your email with anyone else</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Create a password" required minlength="8">
                        <span class="form-text">Password must be at least 8 characters</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Confirm your password" required>
                    </div>

                    <div class="form-check mb-3">
                        <input type="checkbox" id="terms" name="terms" class="form-check-input" required>
                        <label class="form-check-label" for="terms">
                            I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">Create Account</button>
                </form>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/auth/login.jsp">Sign in here</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>