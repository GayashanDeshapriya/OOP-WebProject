<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<User> listUser = (List<User>) request.getAttribute("listUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Users - OOP Web Project</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }

        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .navbar-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }

        .navbar-brand {
            font-size: 24px;
            font-weight: 700;
            color: white;
            text-decoration: none;
        }

        .navbar-links {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.2);
        }

        .container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-header {
            background: white;
            border-radius: 15px;
            padding: 30px 40px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-header h1 {
            color: #333;
            font-size: 32px;
        }

        .page-header p {
            color: #666;
            font-size: 14px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .search-input {
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            width: 250px;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-input:focus {
            border-color: #667eea;
        }

        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            animation: fadeIn 0.5s ease 0.2s backwards;
        }

        .user-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .user-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .user-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .user-info {
            flex-grow: 1;
        }

        .user-name {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }

        .user-id {
            font-size: 12px;
            color: #999;
        }

        .user-details {
            margin-bottom: 20px;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 0;
            color: #666;
            font-size: 14px;
        }

        .detail-icon {
            width: 20px;
            text-align: center;
        }

        .user-actions {
            display: flex;
            gap: 10px;
            padding-top: 20px;
            border-top: 1px solid #f0f0f0;
        }

        .btn {
            flex: 1;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            border: none;
        }

        .btn-edit {
            background: #e3f2fd;
            color: #1976d2;
        }

        .btn-edit:hover {
            background: #1976d2;
            color: white;
        }

        .btn-delete {
            background: #ffebee;
            color: #c62828;
        }

        .btn-delete:hover {
            background: #c62828;
            color: white;
        }

        .current-user-badge {
            background: #4caf50;
            color: white;
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 15px;
        }

        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

        .empty-state h2 {
            color: #333;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #666;
        }

        @media (max-width: 768px) {
            .navbar-content {
                padding: 0 20px;
            }

            .page-header {
                padding: 20px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .search-box {
                width: 100%;
            }

            .search-input {
                width: 100%;
            }

            .users-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a href="dashboard.jsp" class="navbar-brand">🚀 OOP Web Project</a>
            <div class="navbar-links">
                <a href="dashboard.jsp" class="nav-link">Dashboard</a>
                <a href="profile.jsp" class="nav-link">Profile</a>
                <a href="auth?action=logout" class="nav-link">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1>👥 All Users</h1>
                <p>Manage and view all registered users</p>
            </div>
            <div class="search-box">
                <input type="text" class="search-input" id="searchInput" placeholder="Search users..." onkeyup="searchUsers()">
            </div>
        </div>

        <% if (listUser != null && !listUser.isEmpty()) { %>
            <div class="users-grid" id="usersGrid">
                <% for (User user : listUser) { %>
                    <div class="user-card" data-name="<%= user.getName().toLowerCase() %>" data-email="<%= user.getEmail().toLowerCase() %>">
                        <div class="user-header">
                            <div class="user-avatar"><%= user.getName().substring(0, 1).toUpperCase() %></div>
                            <div class="user-info">
                                <div class="user-name">
                                    <%= user.getName() %>
                                    <% if (currentUser.getId() == user.getId()) { %>
                                        <span class="current-user-badge">YOU</span>
                                    <% } %>
                                </div>
                                <div class="user-id">ID: #<%= user.getId() %></div>
                            </div>
                        </div>

                        <div class="user-details">
                            <div class="detail-item">
                                <span class="detail-icon">📧</span>
                                <span><%= user.getEmail() %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-icon">🌍</span>
                                <span><%= user.getCountry() %></span>
                            </div>
                        </div>

                        <div class="user-actions">
                            <a href="edit?id=<%= user.getId() %>" class="btn btn-edit">✏️ Edit</a>
                            <a href="delete?id=<%= user.getId() %>" 
                               class="btn btn-delete" 
                               onclick="return confirm('Are you sure you want to delete <%= user.getName() %>?')">
                               🗑️ Delete
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="empty-state">
                <div class="empty-state-icon">😔</div>
                <h2>No Users Found</h2>
                <p>There are no registered users in the system yet.</p>
            </div>
        <% } %>
    </div>

    <script>
        function searchUsers() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const cards = document.querySelectorAll('.user-card');

            cards.forEach(card => {
                const name = card.getAttribute('data-name');
                const email = card.getAttribute('data-email');
                
                if (name.includes(filter) || email.includes(filter)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
