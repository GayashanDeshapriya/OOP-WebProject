<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    int totalRooms = (Integer) request.getAttribute("totalRooms");
    int occupiedRooms = (Integer) request.getAttribute("occupiedRooms");
    int totalAppliances = (Integer) request.getAttribute("totalAppliances");
    double currentMonthTotal = (Double) request.getAttribute("currentMonthTotal");
    List<Bill> recentBills = (List<Bill>) request.getAttribute("recentBills");
    List<RoomBillSummary> highUsageRooms = (List<RoomBillSummary>) request.getAttribute("highUsageRooms");

    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PowerSplit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
        <!-- Header with Navigation -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/dashboard" class="navbar-brand">⚡ PowerSplit</a>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/rooms?action=list" class="nav-link">Rooms</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/appliances?action=list" class="nav-link">Appliances</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/bills?action=list" class="nav-link">Bills</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/reports?action=monthly" class="nav-link">Reports</a>
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
                <!-- Page Title -->
                <div class="dashboard-header">
                    <h1>⚡ Electricity Usage Dashboard</h1>
                    <p class="text-secondary">Smart Electricity Bill Splitting - Track, Split & Save</p>
                </div>

                <!-- Statistics Cards -->
                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-label">Total Rooms</div>
                        <div class="stat-value"><%= totalRooms %></div>
                        <div class="stat-change">Occupied: <%= occupiedRooms %></div>
                    </div>

                    <div class="stat-card success">
                        <div class="stat-label">Total Appliances</div>
                        <div class="stat-value"><%= totalAppliances %></div>
                        <div class="stat-change">Active devices</div>
                    </div>

                    <div class="stat-card warning">
                        <div class="stat-label">This Month's Bill</div>
                        <div class="stat-value">Rs. <%= df.format(currentMonthTotal) %></div>
                        <div class="stat-change">Current billing period</div>
                    </div>

                    <div class="stat-card info">
                        <div class="stat-label">High Usage Alerts</div>
                        <div class="stat-value"><%= highUsageRooms != null ? highUsageRooms.size() : 0 %></div>
                        <div class="stat-change">Needs attention</div>
                    </div>
                </div>

                <!-- Recent Bills & Alerts -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3>📊 Recent Bills</h3>
                            </div>
                            <div class="card-body">
                                <% if (recentBills != null && !recentBills.isEmpty()) { %>
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Month</th>
                                                <th>Units</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Bill bill : recentBills) { %>
                                                <tr>
                                                    <td><%= bill.getBillMonth() %></td>
                                                    <td><%= dfUnits.format(bill.getTotalUnits()) %> kWh</td>
                                                    <td>Rs. <%= df.format(bill.getTotalBill()) %></td>
                                                    <td><span class="badge badge-<%= bill.getStatus() %>"><%= bill.getStatus() %></span></td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                <% } else { %>
                                    <p class="text-center text-secondary">No bills generated yet.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h3>⚠️ High Usage Alerts</h3>
                            </div>
                            <div class="card-body">
                                <% if (highUsageRooms != null && !highUsageRooms.isEmpty()) { %>
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Room</th>
                                                <th>Units</th>
                                                <th>Alert</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (RoomBillSummary summary : highUsageRooms) { %>
                                                <tr>
                                                    <td><%= summary.getRoomName() %></td>
                                                    <td><%= dfUnits.format(summary.getRoomUnits()) %> kWh</td>
                                                    <td><span class="badge badge-<%= summary.getAlertStatus() %>"><%= summary.getAlertStatus() %></span></td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                <% } else { %>
                                    <p class="text-center text-secondary">✅ All rooms have normal usage!</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h3>🚀 Quick Actions</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/rooms?action=list" class="btn btn-primary btn-block">
                                    🏠 Manage Rooms
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/appliances?action=list" class="btn btn-success btn-block">
                                    💡 Add Appliances
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/bills?action=generate" class="btn btn-warning btn-block">
                                    📝 Generate Bill
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/reports?action=monthly" class="btn btn-info btn-block">
                                    📊 View Reports
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Information -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h3>ℹ️ How PowerSplit Works</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <h5>1️⃣ Track Usage</h5>
                                <p>Register rooms and appliances with their power consumption (watts). Record daily usage hours.</p>
                            </div>
                            <div class="col-md-4">
                                <h5>2️⃣ Calculate Bills</h5>
                                <p>System calculates units consumed per room using: (watts × hours × days) / 1000</p>
                            </div>
                            <div class="col-md-4">
                                <h5>3️⃣ Fair Splitting</h5>
                                <p>Total bill is split proportionally: (room_units / total_units) × total_bill</p>
                            </div>
                        </div>
                        <hr>
                        <div class="text-center">
                            <p><strong>CEB Tiered Rates:</strong> 0-60 units @ Rs.30/unit | 61-90 units @ Rs.37/unit | >90 units @ Rs.42/unit</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="container text-center">
                <p>&copy; 2025 PowerSplit - Smart Electricity Bill Splitting System</p>
            </div>
        </footer>
    </div>
</body>
</html>
