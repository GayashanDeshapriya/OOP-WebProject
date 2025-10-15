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

                <!-- Error/Success Messages -->
                <%
                    String error = request.getParameter("error");
                    String success = request.getParameter("success");
                    if (error != null) {
                %>
                <div class="alert alert-danger">
                    <%= error %>
                </div>
                <%
                    }
                    if (success != null) {
                %>
                <div class="alert alert-success">
                    <%= success %>
                </div>
                <%
                    }
                %>

                <!-- Add New Room Button -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>Room List</span>
                        <button class="btn btn-primary" onclick="showAddRoomModal()">+ Add New Room</button>
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

    <!-- Add/Edit Room Modal -->
<div id="roomModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Add New Room</h2>
            <span class="close" onclick="closeRoomModal()">&times;</span>
        </div>
        <div class="modal-body">
            <form id="roomForm" method="post" action="${pageContext.request.contextPath}/rooms">
                <input type="hidden" id="roomId" name="id">
                <input type="hidden" id="action" name="action" value="add">

                <div class="form-group">
                    <label for="roomName">Room Name *</label>
                    <input type="text" id="roomName" name="roomName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="floorNumber">Floor Number *</label>
                    <input type="number" id="floorNumber" name="floorNumber" class="form-control" min="1" required>
                </div>

                <div class="form-group">
                    <label for="occupantName">Occupant Name</label>
                    <input type="text" id="occupantName" name="occupantName" class="form-control">
                </div>

                <div class="form-group">
                    <label for="status">Status *</label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="vacant">Vacant</option>
                        <option value="occupied">Occupied</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeRoomModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Room</button>
                </div>
            </form>
        </div>
    </div>
</div>



    <script>

        function showAddRoomModal() {
            document.getElementById('modalTitle').textContent = 'Add New Room';
            document.getElementById('roomForm').reset();
            document.getElementById('roomId').value = '';
            document.getElementById('roomModal').classList.add('show');
        }

        function closeRoomModal() {
            document.getElementById('roomModal').classList.remove('show');
        }


        function editRoom(roomId) {
        	debugger;
            document.getElementById('modalTitle').textContent = 'Edit Room';
            document.getElementById('action').value = 'update';

            // Fetch room data via AJAX
            fetch('${pageContext.request.contextPath}/rooms?action=get&id=' + roomId)
                .then(response => response.json())
                .then(data => {
                    // Populate form fields with existing data
                    document.getElementById('roomId').value = data.roomId;
                    document.getElementById('roomName').value = data.roomName;
                    document.getElementById('floorNumber').value = data.floorNumber;
                    document.getElementById('occupantName').value = data.occupantName || '';
                    document.getElementById('status').value = data.status;

                    // Show the modal
                    document.getElementById('roomModal').classList.add('show');
                })
                .catch(error => {
                    console.error('Error fetching room data:', error);
                    alert('Error loading room data. Please try again.');
                });
        }


        function closeRoomModal() {
            document.getElementById('roomModal').classList.remove('show');
        }

        function deleteRoom(roomId) {
            if (confirm('Are you sure you want to delete this room?')) {
                window.location.href = '${pageContext.request.contextPath}/rooms?action=delete&id=' + roomId;
            }
        }


        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('roomModal');
            if (event.target == modal) {
                closeRoomModal();
            }
        }
    </script>
</body>
</html>