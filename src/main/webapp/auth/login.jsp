<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - PowerSplit</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
	<div class="auth-wrapper">
		<div class="auth-container">
			<div class="auth-card">
				<div class="auth-header">
					<h1>⚡ Welcome Back to PowerSplit</h1>
					<p>Sign in to manage your electricity billing</p>
				</div>

				<%
				if (request.getAttribute("error") != null) {
				%>
				<div class="alert alert-danger">
					<%=request.getAttribute("error")%>
				</div>
				<%
				}
				%>

				<%
				if (request.getAttribute("success") != null) {
				%>
				<div class="alert alert-success">
					<%=request.getAttribute("success")%>
				</div>
				<%
				}
				%>

				<form action="${pageContext.request.contextPath}/auth/login"
					method="post" class="auth-form">
					<div class="form-group">
						<label class="form-label" for="email">Email Address</label> <input
							type="email" id="email" name="email" class="form-control"
							placeholder="Enter your email" required autofocus>
					</div>

					<div class="form-group">
						<label class="form-label" for="password">Password</label> <input
							type="password" id="password" name="password"
							class="form-control" placeholder="Enter your password" required>
					</div>

					<div class="auth-links">
						<div class="form-check">
							<input type="checkbox" id="remember" name="remember"
								class="form-check-input"> <label
								class="form-check-label" for="remember">Remember me</label>
						</div>
						<a href="${pageContext.request.contextPath}/forgot-password.jsp">Forgot
							password?</a>
					</div>

					<button type="submit" class="btn btn-primary btn-block btn-lg">Sign
						In</button>
				</form>

				<div class="auth-footer">
					<p>
						Don't have an account? <a
							href="${pageContext.request.contextPath}/auth/register.jsp">Create
							one now</a>
					</p>
				</div>
			</div>
		</div>
	</div>
</body>
</html>