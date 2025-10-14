<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.OOPWebProject.model.User" %>
<%@ page import="com.OOPWebProject.model.Bill" %>
<%@ page import="com.OOPWebProject.model.RoomBillSummary" %>
<%@ page import="com.OOPWebProject.dao.BillDAO" %>
<%@ page import="com.OOPWebProject.dao.RoomBillSummaryDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // Get bill ID from parameter
    String billIdParam = request.getParameter("id");
    if (billIdParam == null) {
        response.sendRedirect(request.getContextPath() + "/bills.jsp");
        return;
    }

    int billId = Integer.parseInt(billIdParam);

    // Fetch bill and summaries
    BillDAO billDAO = new BillDAO();
    RoomBillSummaryDAO summaryDAO = new RoomBillSummaryDAO();

    Bill bill = billDAO.getBillById(billId);
    List<RoomBillSummary> summaries = summaryDAO.getSummariesByBill(billId);

    if (bill == null) {
        response.sendRedirect(request.getContextPath() + "/bills.jsp");
        return;
    }

    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Details - <%= bill.getBillMonth() %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .print-button {
            float: right;
        }
        @media print {
            .no-print { display: none; }
            .print-button { display: none; }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- Header with Navigation -->
        <header class="header no-print">
            <div class="container">
                <jsp:include page="/WEB-INF/includes/navbar.jsp" />
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1>📄 Bill Details - <%= bill.getBillMonth() %></h1>
                    <div class="no-print">
                        <button onclick="window.print()" class="btn btn-primary print-button">🖨️ Print Bill</button>
                        <a href="${pageContext.request.contextPath}/bills.jsp" class="btn btn-secondary">← Back to Bills</a>
                        <% if ("draft".equals(bill.getStatus())) { %>
                            <button onclick="finalizeBill(<%= billId %>)" class="btn btn-success">✓ Finalize Bill</button>
                        <% } %>
                    </div>
                </div>

                <!-- Bill Summary Card -->
                <div class="card">
                    <div class="card-header" style="background-color: #0066cc; color: white;">
                        <h2 style="margin: 0;">💰 Bill Summary</h2>
                    </div>
                    <div class="card-body">
                        <div class="dashboard-stats">
                            <div class="stat-card">
                                <div class="stat-label">Billing Month</div>
                                <div class="stat-value" style="font-size: 24px;"><%= bill.getBillMonth() %></div>
                            </div>
                            <div class="stat-card warning">
                                <div class="stat-label">Total Units Consumed</div>
                                <div class="stat-value"><%= dfUnits.format(bill.getTotalUnits()) %> kWh</div>
                            </div>
                            <div class="stat-card danger">
                                <div class="stat-label">Total Bill Amount</div>
                                <div class="stat-value">Rs. <%= df.format(bill.getTotalBill()) %></div>
                            </div>
                            <div class="stat-card success">
                                <div class="stat-label">Status</div>
                                <div class="stat-value" style="font-size: 18px;">
                                    <% if ("finalized".equals(bill.getStatus())) { %>
                                        <span class="badge badge-success">Finalized</span>
                                    <% } else if ("paid".equals(bill.getStatus())) { %>
                                        <span class="badge badge-info">Paid</span>
                                    <% } else { %>
                                        <span class="badge badge-warning">Draft</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>

                        <div style="margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 4px;">
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                                <div>
                                    <strong>Billing Period:</strong> <%= bill.getBillingPeriodStart() %> to <%= bill.getBillingPeriodEnd() %>
                                </div>
                                <div>
                                    <strong>Base Fee:</strong> Rs. <%= df.format(bill.getBaseFee()) %>
                                </div>
                                <div>
                                    <strong>Generated On:</strong> <%= bill.getCreatedDate() %>
                                </div>
                                <div>
                                    <strong>Number of Rooms:</strong> <%= summaries.size() %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Room-wise Cost Breakdown -->
                <div class="card">
                    <div class="card-header">🏠 Room-wise Cost Breakdown</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Room Name</th>
                                        <th>Occupant</th>
                                        <th>Units Consumed (kWh)</th>
                                        <th>Usage %</th>
                                        <th>Cost Allocated (Rs.)</th>
                                        <th>Alert Status</th>
                                        <th class="no-print">Notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    double totalRoomCosts = 0;
                                    for (RoomBillSummary summary : summaries) {
                                        totalRoomCosts += summary.getRoomCost();

                                        String alertBadge = "";
                                        String alertClass = "";
                                        if ("critical".equals(summary.getAlertStatus())) {
                                            alertBadge = "<span class='badge badge-danger'>⚠️ Critical</span>";
                                            alertClass = "style='background-color: #f8d7da;'";
                                        } else if ("high_usage".equals(summary.getAlertStatus())) {
                                            alertBadge = "<span class='badge badge-warning'>⚡ High Usage</span>";
                                            alertClass = "style='background-color: #fff3cd;'";
                                        } else {
                                            alertBadge = "<span class='badge badge-success'>✓ Normal</span>";
                                        }
                                    %>
                                    <tr <%= alertClass %>>
                                        <td><strong><%= summary.getRoomName() != null ? summary.getRoomName() : "Room " + summary.getRoomId() %></strong></td>
                                        <td><%= summary.getOccupantName() != null ? summary.getOccupantName() : "-" %></td>
                                        <td><%= dfUnits.format(summary.getRoomUnits()) %> kWh</td>
                                        <td><%= df.format(summary.getUsagePercentage()) %>%</td>
                                        <td><strong>Rs. <%= df.format(summary.getRoomCost()) %></strong></td>
                                        <td><%= alertBadge %></td>
                                        <td class="no-print"><%= summary.getNotes() %></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot style="background-color: #f8f9fa; font-weight: bold;">
                                    <tr>
                                        <td colspan="2">TOTAL</td>
                                        <td><%= dfUnits.format(bill.getTotalUnits()) %> kWh</td>
                                        <td>100%</td>
                                        <td><strong>Rs. <%= df.format(totalRoomCosts) %></strong></td>
                                        <td colspan="2">-</td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Cost Breakdown Chart -->
                <div class="card">
                    <div class="card-header">📊 Visual Cost Distribution</div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
                            <% for (RoomBillSummary summary : summaries) {
                                String barColor = "#28a745"; // green
                                if ("critical".equals(summary.getAlertStatus())) {
                                    barColor = "#dc3545"; // red
                                } else if ("high_usage".equals(summary.getAlertStatus())) {
                                    barColor = "#ffc107"; // yellow
                                }
                            %>
                            <div style="padding: 15px; border: 1px solid #ddd; border-radius: 4px; text-align: center;">
                                <strong><%= summary.getRoomName() != null ? summary.getRoomName() : "Room " + summary.getRoomId() %></strong>
                                <div style="margin: 10px 0; height: 100px; background-color: #f0f0f0; border-radius: 4px; position: relative; overflow: hidden;">
                                    <div style="position: absolute; bottom: 0; width: 100%; height: <%= summary.getUsagePercentage() %>%; background-color: <%= barColor %>; transition: height 0.3s;"></div>
                                </div>
                                <div style="font-size: 18px; font-weight: bold; color: <%= barColor %>;">
                                    <%= df.format(summary.getUsagePercentage()) %>%
                                </div>
                                <div style="font-size: 14px; color: #666;">
                                    Rs. <%= df.format(summary.getRoomCost()) %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Billing Instructions -->
                <div class="card no-print">
                    <div class="card-header">📝 Next Steps</div>
                    <div class="card-body">
                        <ol style="line-height: 2;">
                            <li><strong>Review</strong> - Verify all room costs and usage percentages are correct</li>
                            <li><strong>Notify</strong> - Share bill details with room occupants</li>
                            <li><strong>Collect</strong> - Collect payments from each occupant based on their allocated cost</li>
                            <% if ("draft".equals(bill.getStatus())) { %>
                                <li><strong>Finalize</strong> - Click "Finalize Bill" to lock this bill (cannot be edited after finalization)</li>
                            <% } %>
                            <li><strong>Print/Export</strong> - Use the print button to save as PDF for records</li>
                        </ol>
                    </div>
                </div>

                <!-- Alert Explanation -->
                <div class="card">
                    <div class="card-header">⚠️ Alert Status Guide</div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
                            <div style="padding: 15px; background-color: primary; border-left: 4px solid #28a745; border-radius: 4px;">
                                <strong>✓ Normal</strong>
                                <p style="margin: 5px 0 0 0;">Usage is within or below average</p>
                            </div>
                            <div style="padding: 15px; background-color: primary; border-left: 4px solid #ffc107; border-radius: 4px;">
                                <strong>⚡ High Usage</strong>
                                <p style="margin: 5px 0 0 0;">Usage is above average (>100% of avg)</p>
                            </div>
                            <div style="padding: 15px; background-color: primary; border-left: 4px solid #dc3545; border-radius: 4px;">
                                <strong>⚠️ Critical</strong>
                                <p style="margin: 5px 0 0 0;">Usage is significantly high (>150% of avg)</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer no-print">
            <div class="container">
                <div class="footer-content">
                    <p class="footer-text">&copy; 2025 Smart Boarder Electricity Usage Analyzer. All rights reserved.</p>
                </div>
            </div>
        </footer>
    </div>

    <script>
        function finalizeBill(billId) {
            if (confirm('Finalize this bill?\n\nOnce finalized, the bill cannot be edited or deleted.\n\nContinue?')) {
                // Create a form and submit
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/bills';

                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'finalize';

                var billIdInput = document.createElement('input');
                billIdInput.type = 'hidden';
                billIdInput.name = 'billId';
                billIdInput.value = billId;

                form.appendChild(actionInput);
                form.appendChild(billIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
