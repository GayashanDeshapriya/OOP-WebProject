<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%@ page import="com.OOPWebProject.model.Room" %>
<%@ page import="com.OOPWebProject.dao.RoomDAO" %>
<%@ page import="com.OOPWebProject.dao.BillDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // Initialize DAOs
    RoomDAO roomDAO = new RoomDAO();
    BillDAO billDAO = new BillDAO();

    // Get current month
    YearMonth currentMonth = YearMonth.now();
    String billMonth = currentMonth.toString(); // Format: YYYY-MM

    // Get first and last day of month
    LocalDate firstDay = currentMonth.atDay(1);
    LocalDate lastDay = currentMonth.atEndOfMonth();

    // Get room usage data for current month
    Map<Integer, Double> roomUnitsMap = null;
    List<Room> allRooms = null;
    String errorMessage = null;

    try {
        roomUnitsMap = billDAO.getRoomUnitsForMonth(billMonth);
        allRooms = roomDAO.getAllRooms();
    } catch (Exception e) {
        errorMessage = "Error loading usage data: " + e.getMessage();
        roomUnitsMap = new java.util.HashMap<Integer, Double>();
        allRooms = new java.util.ArrayList<Room>();
    }

    // Calculate total units
    double totalUnits = 0;
    if (roomUnitsMap != null) {
        for (double units : roomUnitsMap.values()) {
            totalUnits += units;
        }
    }

    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Bill - Smart Boarder Electricity Analyzer</title>
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
                    <h1>📊 Generate Bill for <%= currentMonth.getMonth() %> <%= currentMonth.getYear() %></h1>
                    <p class="text-secondary">Review usage data and generate monthly bill</p>
                </div>

                <!-- Usage Summary -->
                <div class="card">
                    <div class="card-header">📈 Usage Summary for <%= billMonth %></div>
                    <div class="card-body">
                        <div class="dashboard-stats">
                            <div class="stat-card">
                                <div class="stat-label">Total Units Consumed</div>
                                <div class="stat-value"><%= dfUnits.format(totalUnits) %> kWh</div>
                            </div>
                            <div class="stat-card success">
                                <div class="stat-label">Active Rooms</div>
                                <div class="stat-value"><%= roomUnitsMap.size() %></div>
                            </div>
                            <div class="stat-card warning">
                                <div class="stat-label">Billing Period</div>
                                <div class="stat-value"><%= firstDay %> to <%= lastDay %></div>
                            </div>
                        </div>

                        <!-- Room-wise Usage Breakdown -->
                        <h3 style="margin-top: 30px;">Room-wise Usage Breakdown</h3>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Room Name</th>
                                        <th>Occupant</th>
                                        <th>Units Consumed (kWh)</th>
                                        <th>Usage %</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    double averageUnits = totalUnits / (roomUnitsMap.size() > 0 ? roomUnitsMap.size() : 1);
                                    for (Room room : allRooms) {
                                        Double roomUnits = roomUnitsMap.get(room.getRoomId());
                                        if (roomUnits != null && roomUnits > 0) {
                                            double usagePercent = (roomUnits / totalUnits) * 100;
                                            String alertBadge = "";
                                            if (roomUnits > averageUnits * 1.5) {
                                                alertBadge = "<span class='badge badge-danger'>Critical</span>";
                                            } else if (roomUnits > averageUnits) {
                                                alertBadge = "<span class='badge badge-warning'>High Usage</span>";
                                            } else {
                                                alertBadge = "<span class='badge badge-success'>Normal</span>";
                                            }
                                    %>
                                    <tr>
                                        <td><strong><%= room.getRoomName() %></strong></td>
                                        <td><%= room.getOccupantName() != null ? room.getOccupantName() : "-" %></td>
                                        <td><%= dfUnits.format(roomUnits) %> kWh</td>
                                        <td><%= df.format(usagePercent) %>%</td>
                                        <td><%= alertBadge %></td>
                                    </tr>
                                    <%
                                        }
                                    }
                                    if (roomUnitsMap.isEmpty()) {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center">No usage data recorded for this month yet.</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr style="font-weight: bold; background-color: primary;">
                                        <td colspan="2">TOTAL</td>
                                        <td><%= dfUnits.format(totalUnits) %> kWh</td>
                                        <td>100%</td>
                                        <td>-</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Generate Bill Form -->
                <div class="card">
                    <div class="card-header">💰 Enter Bill Details</div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/bills" onsubmit="return validateBillForm()">
                            <input type="hidden" name="action" value="generate">
                            <input type="hidden" name="billMonth" value="<%= billMonth %>">
                            <input type="hidden" name="periodStart" value="<%= firstDay %>">
                            <input type="hidden" name="periodEnd" value="<%= lastDay %>">

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                <div class="form-group">
                                    <label for="totalUnitsDisplay">Total Units Consumed (kWh) *</label>
                                    <input type="text" id="totalUnitsDisplay" class="form-control" value="<%= dfUnits.format(totalUnits) %>" readonly>
                                    <small class="text-secondary">Calculated from usage records</small>
                                </div>

                                <div class="form-group">
                                    <label for="totalBill">Total Bill Amount (Rs.) *</label>
                                    <input type="number" id="totalBill" name="totalBill" class="form-control" step="0.01" required>
                                    <small class="text-secondary">Enter the amount from your CEB bill</small>
                                </div>

                                <div class="form-group">
                                    <label for="baseFee">Fixed/Base Fee (Rs.) *</label>
                                    <input type="number" id="baseFee" name="baseFee" class="form-control" step="0.01" value="0" required>
                                    <small class="text-secondary">Monthly fixed charge (if any)</small>
                                </div>

                                <div class="form-group">
                                    <label for="estimatedBill">Estimated Bill (Auto-calculated)</label>
                                    <input type="text" id="estimatedBill" class="form-control" readonly>
                                    <small class="text-secondary">Based on CEB tiered rates</small>
                                </div>
                            </div>

                            <div style="padding: 15px; background-color: primary; border-left: 4px solid #0066cc; border-radius: 4px; margin: 20px 0;">
                                <strong>💡 Bill Calculation:</strong>
                                <p style="margin: 5px 0 0 0;">
                                    The system will split the total bill amount proportionally among rooms based on their usage percentage.
                                </p>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/bills.jsp" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-success">Generate Bill & Split Costs</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- CEB Rate Calculator -->
                <div class="card">
                    <div class="card-header">🧮 CEB Tiered Rate Calculator</div>
                    <div class="card-body">
                        <p>Calculate estimated bill based on CEB's tiered rate structure:</p>
                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-top: 15px;">
                            <div style="padding: 15px; background-color: primary; border-radius: 4px; text-align: center;">
                                <strong>Tier 1 (0-60 kWh)</strong>
                                <div style="font-size: 24px; margin: 10px 0;">Rs. 30.00/unit</div>
                            </div>
                            <div style="padding: 15px; background-color: primary; border-radius: 4px; text-align: center;">
                                <strong>Tier 2 (61-90 kWh)</strong>
                                <div style="font-size: 24px; margin: 10px 0;">Rs. 37.00/unit</div>
                            </div>
                            <div style="padding: 15px; background-color: primary; border-radius: 4px; text-align: center;">
                                <strong>Tier 3 (>90 kWh)</strong>
                                <div style="font-size: 24px; margin: 10px 0;">Rs. 42.00/unit</div>
                            </div>
                        </div>

                        <div id="calculationBreakdown" style="margin-top: 20px; padding: 15px; background-color: primary; border-radius: 4px;">
                            <h4>Calculation Breakdown:</h4>
                            <p id="breakdownText">Enter total bill amount to see the breakdown</p>
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

    <script>
        // Calculate estimated bill based on tiered rates
        function calculateEstimatedBill(units) {
            let bill = 0;
            let remaining = units;
            let breakdown = "";

            // Tier 1: 0-60 @ Rs. 30
            if (remaining > 0) {
                let tier1Units = Math.min(remaining, 60);
                let tier1Cost = tier1Units * 30;
                bill += tier1Cost;
                breakdown += "Tier 1: " + tier1Units.toFixed(1) + " units × Rs. 30 = Rs. " + tier1Cost.toFixed(2) + "<br>";
                remaining -= tier1Units;
            }

            // Tier 2: 61-90 @ Rs. 37
            if (remaining > 0) {
                let tier2Units = Math.min(remaining, 30);
                let tier2Cost = tier2Units * 37;
                bill += tier2Cost;
                breakdown += "Tier 2: " + tier2Units.toFixed(1) + " units × Rs. 37 = Rs. " + tier2Cost.toFixed(2) + "<br>";
                remaining -= tier2Units;
            }

            // Tier 3: >90 @ Rs. 42
            if (remaining > 0) {
                let tier3Cost = remaining * 42;
                bill += tier3Cost;
                breakdown += "Tier 3: " + remaining.toFixed(1) + " units × Rs. 42 = Rs. " + tier3Cost.toFixed(2) + "<br>";
            }

            breakdown += "<strong>Total Estimated: Rs. " + bill.toFixed(2) + "</strong>";
            return { bill: bill, breakdown: breakdown };
        }

        // Auto-calculate on page load
        window.onload = function() {
            const totalUnits = <%= totalUnits %>;
            const result = calculateEstimatedBill(totalUnits);

            document.getElementById('estimatedBill').value = "Rs. " + result.bill.toFixed(2);
            document.getElementById('breakdownText').innerHTML = result.breakdown;

            // Pre-fill total bill with estimated amount
            document.getElementById('totalBill').value = result.bill.toFixed(2);
        };

        function validateBillForm() {
            const totalBill = parseFloat(document.getElementById('totalBill').value);
            const baseFee = parseFloat(document.getElementById('baseFee').value);

            if (totalBill <= 0) {
                alert('Total bill amount must be greater than 0');
                return false;
            }

            if (baseFee < 0) {
                alert('Base fee cannot be negative');
                return false;
            }

            // Confirm before generating
            return confirm('Generate bill for <%= billMonth %>?\n\nTotal Units: <%= dfUnits.format(totalUnits) %> kWh\nTotal Bill: Rs. ' + totalBill.toFixed(2) + '\n\nThis will split costs among all rooms.');
        }
    </script>
</body>
</html>