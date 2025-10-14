<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%@ page import="com.OOPWebProject.model.Appliance" %>
<%@ page import="com.OOPWebProject.model.Room" %>
<%@ page import="com.OOPWebProject.dao.ApplianceDAO" %>
<%@ page import="com.OOPWebProject.dao.RoomDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // Fetch all appliances
    ApplianceDAO applianceDAO = new ApplianceDAO();
    RoomDAO roomDAO = new RoomDAO();

    String roomIdParam = request.getParameter("roomId");
    List<Appliance> appliances;
    Room selectedRoom = null;

    if (roomIdParam != null && !roomIdParam.isEmpty()) {
        int roomId = Integer.parseInt(roomIdParam);
        appliances = applianceDAO.getAppliancesByRoom(roomId);
        selectedRoom = roomDAO.getRoomById(roomId);
    } else {
        appliances = applianceDAO.getAllAppliances();
    }

    List<Room> allRooms = roomDAO.getAllRooms();
    DecimalFormat df = new DecimalFormat("#,##0.0");
    
    // Check if we're editing an appliance
    Appliance applianceToEdit = (Appliance) request.getAttribute("appliance");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Appliances - Smart Boarder Electricity Analyzer</title>
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
                    <h1>🔌 Manage Appliances</h1>
                    <p class="text-secondary">
                        <% if (selectedRoom != null) { %>
                            Viewing appliances for <%= selectedRoom.getRoomName() %>
                            <a href="appliances.jsp" class="btn btn-sm btn-outline">View All</a>
                        <% } else { %>
                            Add, edit, and manage electrical appliances
                        <% } %>
                    </p>
                </div>

                <!-- Filter by Room -->
                <div class="card">
                    <div class="card-body">
                        <form method="get" action="appliances.jsp" style="display: flex; gap: 10px; align-items: center;">
                            <label for="roomFilter">Filter by Room:</label>
                            <select name="roomId" id="roomFilter" class="form-control" style="width: auto;" onchange="this.form.submit()">
                                <option value="">All Rooms</option>
                                <% for (Room room : allRooms) { %>
                                    <option value="<%= room.getRoomId() %>"
                                        <%= (roomIdParam != null && roomIdParam.equals(String.valueOf(room.getRoomId()))) ? "selected" : "" %>>
                                        <%= room.getRoomName() %>
                                    </option>
                                <% } %>
                            </select>
                        </form>
                    </div>
                </div>

                <!-- Appliances List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <span>Appliance List</span>
                        <button class="btn btn-primary" onclick="showAddApplianceForm()">+ Add New Appliance</button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Appliance Name</th>
                                        <th>Room</th>
                                        <th>Wattage (W)</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (appliances != null && !appliances.isEmpty()) {
                                        for (Appliance appliance : appliances) { %>
                                    <tr>
                                        <td><strong><%= appliance.getApplianceName() %></strong></td>
                                        <td><%= appliance.getRoomName() != null ? appliance.getRoomName() : "Room " + appliance.getRoomId() %></td>
                                        <td><%= df.format(appliance.getWattage()) %> W</td>
                                        <td><%= appliance.getDescription() %></td>
                                        <td>
                                            <% if ("active".equals(appliance.getStatus())) { %>
                                                <span class="badge badge-success">Active</span>
                                            <% } else { %>
                                                <span class="badge badge-secondary">Inactive</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" onclick="editAppliance(<%= appliance.getApplianceId() %>)">Edit</button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteAppliance(<%= appliance.getApplianceId() %>)">Delete</button>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr>
                                        <td colspan="6" class="text-center">No appliances found. Add your first appliance!</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Common Appliances Reference -->
                <div class="card">
                    <div class="card-header">💡 Common Appliance Wattage Reference</div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="padding: 10px; background-color: primary; border-radius: 4px;">
                                <strong>Lighting:</strong> LED Bulb: 10-15W, CFL: 15-20W, Tube Light: 40W
                            </div>
                            <div style="padding: 10px; background-color: primary; border-radius: 4px;">
                                <strong>Fans:</strong> Ceiling Fan: 70-80W, Table Fan: 50-60W
                            </div>
                            <div style="padding: 10px; background-color: primary; border-radius: 4px;">
                                <strong>Electronics:</strong> TV (LED): 80-120W, Laptop: 50-65W
                            </div>
                            <div style="padding: 10px; background-color: primary; border-radius: 4px;">
                                <strong>Cooling:</strong> AC (1.5 ton): 1500W, Refrigerator: 150-200W
                            </div>
                        </div>
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

    <!-- Add/Edit Appliance Modal -->
    <div id="applianceModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Add New Appliance</h2>
                <span class="close" onclick="closeApplianceModal()">&times;</span>
            </div>
            <div class="modal-body">
                <form id="applianceForm" method="post" action="${pageContext.request.contextPath}/appliances">
                    <input type="hidden" id="applianceId" name="applianceId">
                    <input type="hidden" id="action" name="action" value="add">

                    <div class="form-group">
                        <label for="applianceName">Appliance Name *</label>
                        <input type="text" id="applianceName" name="applianceName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="roomId">Room *</label>
                        <select id="roomId" name="roomId" class="form-control" required>
                            <option value="">Select Room</option>
                            <% for (Room room : allRooms) { %>
                                <option value="<%= room.getRoomId() %>"><%= room.getRoomName() %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="wattage">Wattage (W) *</label>
                        <input type="number" id="wattage" name="wattage" class="form-control" step="0.1" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="3"></textarea>
                    </div>

                    <div class="form-group">
                        <label for="status">Status *</label>
                        <select id="status" name="status" class="form-control" required>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeApplianceModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Appliance</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function showAddApplianceForm() {
            document.getElementById('modalTitle').textContent = 'Add New Appliance';
            document.getElementById('applianceForm').reset();
            document.getElementById('applianceId').value = '';
            document.getElementById('action').value = 'add';
            document.getElementById('applianceModal').classList.add('show');
        }

        function closeApplianceModal() {
            document.getElementById('applianceModal').classList.remove('show');
        }

        function editAppliance(applianceId) {
            // Redirect to edit page that will populate the form
            window.location.href = '${pageContext.request.contextPath}/appliances?action=edit&id=' + applianceId;
        }

        function deleteAppliance(applianceId) {
            if (confirm('Are you sure you want to delete this appliance?')) {
                window.location.href = '${pageContext.request.contextPath}/appliances?action=delete&id=' + applianceId;
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('applianceModal');
            if (event.target == modal) {
                closeApplianceModal();
            }
        }

        // Populate modal for editing
        <% if (applianceToEdit != null) { %>
            document.getElementById('modalTitle').textContent = 'Edit Appliance';
            document.getElementById('applianceId').value = '<%= applianceToEdit.getApplianceId() %>';
            document.getElementById('applianceName').value = '<%= applianceToEdit.getApplianceName() %>';
            document.getElementById('roomId').value = '<%= applianceToEdit.getRoomId() %>';
            document.getElementById('wattage').value = '<%= applianceToEdit.getWattage() %>';
            document.getElementById('description').value = '<%= applianceToEdit.getDescription() != null ? applianceToEdit.getDescription() : "" %>';
            document.getElementById('status').value = '<%= applianceToEdit.getStatus() %>';
            document.getElementById('action').value = 'update';
            document.getElementById('applianceModal').classList.add('show');
        <% } %>
    </script>
</body>
</html>