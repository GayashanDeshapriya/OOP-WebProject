<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - OOP Web Project</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .register-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
            animation: slideIn 0.5s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .register-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .register-header h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .register-header p {
            font-size: 14px;
            opacity: 0.9;
        }

        .register-body {
            padding: 40px 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
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
            border-color: #f093fb;
            box-shadow: 0 0 0 3px rgba(240, 147, 251, 0.1);
        }

        .form-group input::placeholder {
            color: #999;
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: 10px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(240, 147, 251, 0.3);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            animation: fadeIn 0.3s ease;
        }

        .alert-error {
            background-color: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }

        .divider::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 100%;
            height: 1px;
            background: #e0e0e0;
        }

        .divider span {
            background: white;
            padding: 0 15px;
            position: relative;
            color: #999;
            font-size: 14px;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .login-link a {
            color: #f5576c;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: #f093fb;
            text-decoration: underline;
        }

        .password-strength {
            height: 4px;
            margin-top: 8px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
            display: none;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
        }

        .password-strength.weak .password-strength-bar {
            width: 33%;
            background: #f5576c;
        }

        .password-strength.medium .password-strength-bar {
            width: 66%;
            background: #ffa726;
        }

        .password-strength.strong .password-strength-bar {
            width: 100%;
            background: #66bb6a;
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle input {
            padding-right: 45px;
        }

        .password-toggle .toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
        }

        .password-toggle .toggle-btn:hover {
            color: #f093fb;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        @media (max-width: 480px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join us today and get started</p>
        </div>

        <div class="register-body">
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="alert alert-error">
                    <%= errorMessage %>
                </div>
            <% } %>

            <form action="auth" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label for="name">First Name</label>
                    <input type="text" id="fname" name="fname"
                           placeholder="Enter your first name"
                           value="<%= request.getAttribute("fname") != null ? request.getAttribute("fname") : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="name">Last Name</label>
                    <input type="text" id="lname" name="lname"
                           placeholder="Enter your last name"
                           value="<%= request.getAttribute("lname") != null ? request.getAttribute("lname") : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email"
                           placeholder="Enter your email"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                           required>
                </div>

<!--                 <div class="form-group"> -->
<!--                     <label for="country">Country</label> -->
<!--                     <select id="country" name="country" required> -->
<!--                         <option value="">Select your country</option> -->
<%--                         <option value="Sri Lanka" <%= "Sri Lanka".equals(request.getAttribute("country")) ? "selected" : "" %>>Sri Lanka</option> --%>
<%--                         <option value="India" <%= "India".equals(request.getAttribute("country")) ? "selected" : "" %>>India</option> --%>
<%--                         <option value="USA" <%= "USA".equals(request.getAttribute("country")) ? "selected" : "" %>>United States</option> --%>
<%--                         <option value="UK" <%= "UK".equals(request.getAttribute("country")) ? "selected" : "" %>>United Kingdom</option> --%>
<%--                         <option value="Canada" <%= "Canada".equals(request.getAttribute("country")) ? "selected" : "" %>>Canada</option> --%>
<%--                         <option value="Australia" <%= "Australia".equals(request.getAttribute("country")) ? "selected" : "" %>>Australia</option> --%>
<%--                         <option value="Germany" <%= "Germany".equals(request.getAttribute("country")) ? "selected" : "" %>>Germany</option> --%>
<%--                         <option value="France" <%= "France".equals(request.getAttribute("country")) ? "selected" : "" %>>France</option> --%>
<%--                         <option value="Japan" <%= "Japan".equals(request.getAttribute("country")) ? "selected" : "" %>>Japan</option> --%>
<%--                         <option value="Other" <%= "Other".equals(request.getAttribute("country")) ? "selected" : "" %>>Other</option> --%>
<!--                     </select> -->
<!--                 </div> -->

                <div class="form-group password-toggle">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Create a password"
                           oninput="checkPasswordStrength()" required>
                    <button type="button" class="toggle-btn" onclick="togglePassword('password')">👁️</button>
                    <div class="password-strength" id="passwordStrength">
                        <div class="password-strength-bar"></div>
                    </div>
                </div>

                <div class="form-group password-toggle">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Confirm your password" required>
                    <button type="button" class="toggle-btn" onclick="togglePassword('confirmPassword')">👁️</button>
                </div>

                <button type="submit" class="btn-register">Create Account</button>
            </form>

            <div class="divider">
                <span>OR</span>
            </div>

            <div class="login-link">
                Already have an account? <a href="login.jsp">Sign In</a>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(fieldId) {
            var passwordField = document.getElementById(fieldId);
            var toggleBtn = event.target;

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleBtn.textContent = '🙈';
            } else {
                passwordField.type = 'password';
                toggleBtn.textContent = '👁️';
            }
        }

        function checkPasswordStrength() {
            var password = document.getElementById('password').value;
            var strengthBar = document.getElementById('passwordStrength');

            if (password.length === 0) {
                strengthBar.style.display = 'none';
                strengthBar.className = 'password-strength';
                return;
            }

            strengthBar.style.display = 'block';

            var strength = 0;
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;

            strengthBar.className = 'password-strength';
            if (strength <= 2) {
                strengthBar.classList.add('weak');
            } else if (strength === 3) {
                strengthBar.classList.add('medium');
            } else {
                strengthBar.classList.add('strong');
            }
        }

        function validateForm() {
        	debugger;
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }

            if (password.length < 6) {
                alert('Password must be at least 6 characters long!');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
