<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%@ page import="com.OOPWebProject.model.Room" %>
<%@ page import="com.OOPWebProject.dao.RoomDAO" %>
<%@ page import="java.util.List" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // Fetch all rooms
    RoomDAO roomDAO = new RoomDAO();
    List<Room> rooms = roomDAO.getAllRooms();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms - Smart Boarder Electricity Analyzer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
    <!-- Header with Navigation -->
        <header class="header">
            <div class="container">
                <jsp:include page="/WEB-INF/includes/navbar.jsp" />
            </div>
        </header>
        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>🏠 Manage Rooms</h1>
                    <p class="text-secondary">Add, edit, and manage boarding rooms</p>
                </div>

                <!-- Add New Room Button -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>Room List</span>
                        <button class="btn btn-primary" onclick="showAddRoomForm()">+ Add New Room</button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Room Name</th>
                                        <th>Occupant</th>
                                        <th>Floor</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (rooms != null && !rooms.isEmpty()) {
                                        for (Room room : rooms) { %>
                                    <tr>
                                        <td><strong><%= room.getRoomName() %></strong></td>
                                        <td><%= room.getOccupantName() != null ? room.getOccupantName() : "-" %></td>
                                        <td>Floor <%= room.getFloorNumber() %></td>
                                        <td>
                                            <% if ("occupied".equals(room.getStatus())) { %>
                                                <span class="badge badge-success">Occupied</span>
                                            <% } else { %>
                                                <span class="badge badge-secondary">Vacant</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="appliances.jsp?roomId=<%= room.getRoomId() %>" class="btn btn-sm btn-secondary">View Appliances</a>
                                            <button class="btn btn-sm btn-primary" onclick="editRoom(<%= room.getRoomId() %>)">Edit</button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteRoom(<%= room.getRoomId() %>)">Delete</button>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr>
                                        <td colspan="5" class="text-center">No rooms found. Add your first room!</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Room Statistics -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-label">Total Rooms</div>
                        <div class="stat-value"><%= rooms.size() %></div>
                    </div>
                    <div class="stat-card success">
                        <div class="stat-label">Occupied</div>
                        <div class="stat-value"><%= roomDAO.getOccupiedRoomsCount() %></div>
                    </div>
                    <div class="stat-card warning">
                        <div class="stat-label">Vacant</div>
                        <div class="stat-value"><%= rooms.size() - roomDAO.getOccupiedRoomsCount() %></div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <p class="footer-text">&copy; 2025 Smart Boarder Electricity Usage Analyzer. All rights reserved.</p>
                </div>
            </div>
        </footer>
    </div>

    <script>
        function showAddRoomForm() {
            window.location.href = '${pageContext.request.contextPath}/roomForm.jsp';
        }

        function editRoom(roomId) {
            window.location.href = '${pageContext.request.contextPath}/roomForm.jsp?id=' + roomId;
        }

        function deleteRoom(roomId) {
            if (confirm('Are you sure you want to delete this room?')) {
                window.location.href = '${pageContext.request.contextPath}/room?action=delete&id=' + roomId;
            }
        }
    </script>
</body>
</html>
