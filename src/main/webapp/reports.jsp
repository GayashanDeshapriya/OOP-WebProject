<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%@ page import="com.OOPWebProject.model.Bill" %>
<%@ page import="com.OOPWebProject.model.RoomBillSummary" %>
<%@ page import="com.OOPWebProject.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    BillDAO billDAO = new BillDAO();
    RoomBillSummaryDAO summaryDAO = new RoomBillSummaryDAO();
    Bill latestBill = billDAO.getLatestBill();
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - Smart Boarder Electricity Analyzer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="wrapper">
        <!-- Header with Navigation -->
        <header class="header">
            <div class="container">
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/" class="navbar-brand">⚡ PowerSplit</a>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/dashboard.jsp" class="nav-link">Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/rooms.jsp" class="nav-link">Rooms</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/appliances.jsp" class="nav-link">Appliances</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/bills.jsp" class="nav-link">Bills</a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/reports.jsp" class="nav-link active">Reports</a>
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
                <!-- Page Header -->
                <div class="page-header">
                    <h1>📊 Reports & Analytics</h1>
                    <p class="text-secondary">Analyze consumption patterns and get insights</p>
                </div>

                <!-- Latest Month Summary -->
                <% if (latestBill != null) { 
                    List<RoomBillSummary> summaries = summaryDAO.getSummariesByBill(latestBill.getBillId());
                %>
                <div class="card">
                    <div class="card-header">
                        📈 Current Month Overview - <%= latestBill.getBillMonth() %>
                    </div>
                    <div class="card-body">
                        <div class="dashboard-stats">
                            <div class="stat-card">
                                <div class="stat-label">Total Consumption</div>
                                <div class="stat-value"><%= dfUnits.format(latestBill.getTotalUnits()) %> kWh</div>
                            </div>
                            <div class="stat-card warning">
                                <div class="stat-label">Total Bill</div>
                                <div class="stat-value">Rs. <%= df.format(latestBill.getTotalBill()) %></div>
                            </div>
                            <div class="stat-card success">
                                <div class="stat-label">Average per Room</div>
                                <div class="stat-value">
                                    <%= summaries.size() > 0 ? dfUnits.format(latestBill.getTotalUnits() / summaries.size()) : "0" %> kWh
                                </div>
                            </div>
                            <div class="stat-card info">
                                <div class="stat-label">Average Cost/Room</div>
                                <div class="stat-value">
                                    Rs. <%= summaries.size() > 0 ? df.format(latestBill.getTotalBill() / summaries.size()) : "0" %>
                                </div>
                            </div>
                        </div>

                        <% if (summaries != null && !summaries.isEmpty()) { %>
                        <h4 style="margin-top: 20px;">Room-wise Breakdown</h4>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Room</th>
                                        <th>Occupant</th>
                                        <th>Units (kWh)</th>
                                        <th>Cost Share</th>
                                        <th>% of Total</th>
                                        <th>Alert</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (RoomBillSummary summary : summaries) { %>
                                    <tr>
                                        <td><strong><%= summary.getRoomName() %></strong></td>
                                        <td><%= summary.getOccupantName() != null ? summary.getOccupantName() : "-" %></td>
                                        <td><%= dfUnits.format(summary.getRoomUnits()) %> kWh</td>
                                        <td>Rs. <%= df.format(summary.getRoomCost()) %></td>
                                        <td><%= df.format(summary.getUsagePercentage()) %>%</td>
                                        <td>
                                            <% if ("critical".equals(summary.getAlertStatus())) { %>
                                                <span class="badge badge-danger">Critical</span>
                                            <% } else if ("high_usage".equals(summary.getAlertStatus())) { %>
                                                <span class="badge badge-warning">High Usage</span>
                                            <% } else { %>
                                                <span class="badge badge-success">Normal</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } else { %>
                <div class="card">
                    <div class="card-body text-center">
                        <h3>No bills generated yet</h3>
                        <p>Generate your first bill to see reports and analytics</p>
                        <a href="${pageContext.request.contextPath}/bills.jsp" class="btn btn-primary">Go to Bills</a>
                    </div>
                </div>
                <% } %>

                <!-- Comparison & Trends -->
                <div class="card">
                    <div class="card-header">📉 Historical Trends</div>
                    <div class="card-body">
                        <%
                            List<Bill> recentBills = billDAO.getRecentBills(6);
                            if (recentBills != null && !recentBills.isEmpty()) {
                        %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Month</th>
                                        <th>Total Units</th>
                                        <th>Total Bill</th>
                                        <th>Avg. Rate/Unit</th>
                                        <th>Trend</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    double prevUnits = 0;
                                    for (int i = 0; i < recentBills.size(); i++) { 
                                        Bill bill = recentBills.get(i);
                                        double avgRate = bill.getTotalUnits() > 0 ? bill.getTotalBill() / bill.getTotalUnits() : 0;
                                        String trend = "";
                                        if (i > 0 && prevUnits > 0) {
                                            double change = ((bill.getTotalUnits() - prevUnits) / prevUnits) * 100;
                                            if (change > 5) {
                                                trend = "<span style='color: #dc3545;'>↑ +" + df.format(change) + "%</span>";
                                            } else if (change < -5) {
                                                trend = "<span style='color: #28a745;'>↓ " + df.format(change) + "%</span>";
                                            } else {
                                                trend = "<span style='color: #6c757d;'>→ " + df.format(change) + "%</span>";
                                            }
                                        }
                                        prevUnits = bill.getTotalUnits();
                                    %>
                                    <tr>
                                        <td><strong><%= bill.getBillMonth() %></strong></td>
                                        <td><%= dfUnits.format(bill.getTotalUnits()) %> kWh</td>
                                        <td>Rs. <%= df.format(bill.getTotalBill()) %></td>
                                        <td>Rs. <%= df.format(avgRate) %>/unit</td>
                                        <td><%= trend %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                        <p class="text-center">Not enough data for trend analysis. Generate more bills to see trends.</p>
                        <% } %>
                    </div>
                </div>

                <!-- Energy Saving Tips -->
                <div class="card">
                    <div class="card-header">💡 Energy Saving Recommendations</div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 15px;">
                            <div style="padding: 15px; background-color: #d1ecf1; border-left: 4px solid #17a2b8; border-radius: 4px;">
                                <strong>🌡️ Air Conditioning</strong>
                                <p>Set AC to 24-25°C. Each degree lower increases consumption by 6-8%. Use timer mode.</p>
                            </div>
                            <div style="padding: 15px; background-color: #d4edda; border-left: 4px solid #28a745; border-radius: 4px;">
                                <strong>💡 Lighting</strong>
                                <p>Switch to LED bulbs (85% less energy than incandescent). Turn off lights when not in use.</p>
                            </div>
                            <div style="padding: 15px; background-color: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px;">
                                <strong>🧊 Refrigerator</strong>
                                <p>Keep fridge at 3-4°C. Avoid keeping door open. Defrost regularly for efficiency.</p>
                            </div>
                            <div style="padding: 15px; background-color: #f8d7da; border-left: 4px solid #dc3545; border-radius: 4px;">
                                <strong>⚡ Standby Power</strong>
                                <p>Unplug chargers and devices. Standby mode can waste 5-10% of monthly consumption.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Export Options -->
                <div class="card">
                    <div class="card-header">📥 Export Reports</div>
                    <div class="card-body">
                        <div class="d-flex gap-md flex-wrap">
                            <button class="btn btn-outline" onclick="window.print()">🖨️ Print Report</button>
                            <button class="btn btn-outline" onclick="alert('CSV export feature coming soon!')">📊 Export to CSV</button>
                            <button class="btn btn-outline" onclick="alert('PDF export feature coming soon!')">📄 Export to PDF</button>
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
</body>
</html>
