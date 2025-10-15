<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String currentPage = request.getRequestURI();
%>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">⚡ PowerSplit</a>
    <ul class="navbar-nav">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="nav-link <%= currentPage.contains("dashboard") ? "active" : "" %>">
               Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/rooms"
               class="nav-link <%= currentPage.contains("rooms") ? "active" : "" %>">
               Rooms
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/appliances"
               class="nav-link <%= currentPage.contains("appliances") ? "active" : "" %>">
               Appliances
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/bills"
               class="nav-link <%= currentPage.contains("bills") ? "active" : "" %>">
               Bills
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports"
               class="nav-link <%= currentPage.contains("reports") ? "active" : "" %>">
               Reports
            </a>
        </li>
        <li class="nav-item">
              <a href="${pageContext.request.contextPath}/auth/logout"
              class="nav-link">Logout</a>
        </li>
    </ul>
</nav>
