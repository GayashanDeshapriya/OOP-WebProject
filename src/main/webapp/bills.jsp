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

    // Fetch all bills
    BillDAO billDAO = new BillDAO();
    List<Bill> bills = billDAO.getAllBills();

    DecimalFormat df = new DecimalFormat("#,##0.00");
    DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bills & Cost Splitting - Smart Boarder Electricity Analyzer</title>
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
                    <h1>💰 Bills & Cost Splitting</h1>
                    <p class="text-secondary">Generate monthly bills and split costs fairly among rooms</p>
                </div>

                <!-- Generate New Bill Button -->
                <div class="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h3>Generate New Bill</h3>
                                <p class="text-secondary">Create a new monthly bill based on recorded usage</p>
                            </div>
                            <button class="btn btn-success" onclick="showGenerateBillForm()">
                                + Generate Bill for Current Month
                            </button>
                        </div>
                    </div>
                </div>

                <!-- CEB Tiered Rate Information -->
                <div class="card">
                    <div class="card-header">📊 CEB Tiered Rate Structure</div>
                    <div class="card-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Tier</th>
                                    <th>Unit Range</th>
                                    <th>Rate per Unit</th>
                                    <th>Example Cost</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><span class="badge badge-success">Tier 1</span></td>
                                    <td>0 - 60 kWh</td>
                                    <td>Rs. 30.00/unit</td>
                                    <td>60 units = Rs. 1,800</td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-warning">Tier 2</span></td>
                                    <td>61 - 90 kWh</td>
                                    <td>Rs. 37.00/unit</td>
                                    <td>90 units = Rs. 2,910 total</td>
                                </tr>
                                <tr>
                                    <td><span class="badge badge-danger">Tier 3</span></td>
                                    <td>>90 kWh</td>
                                    <td>Rs. 42.00/unit</td>
                                    <td>120 units = Rs. 4,170 total</td>
                                </tr>
                            </tbody>
                        </table>
                        <div style="padding: 15px; background-color:primary; border-left: 4px solid #17a2b8; border-radius: 4px; margin-top: 15px;">
                            <strong>💡 Important Note:</strong>
                            <p style="margin: 5px 0 0 0;">Rates are calculated progressively. For example, 100 units = (60×30) + (30×37) + (10×42) = Rs. 3,330</p>
                        </div>
                    </div>
                </div>

                <!-- Bills History -->
                <div class="card">
                    <div class="card-header">📋 Bills History</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Month</th>
                                        <th>Total Units</th>
                                        <th>Total Bill</th>
                                        <th>Base Fee</th>
                                        <th>Period</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (bills != null && !bills.isEmpty()) {
                                        for (Bill bill : bills) { %>
                                    <tr>
                                        <td><strong><%= bill.getBillMonth() %></strong></td>
                                        <td><%= dfUnits.format(bill.getTotalUnits()) %> kWh</td>
                                        <td>Rs. <%= df.format(bill.getTotalBill()) %></td>
                                        <td>Rs. <%= df.format(bill.getBaseFee()) %></td>
                                        <td><%= bill.getBillingPeriodStart() %> to <%= bill.getBillingPeriodEnd() %></td>
                                        <td>
                                            <% if ("finalized".equals(bill.getStatus())) { %>
                                                <span class="badge badge-success">Finalized</span>
                                            <% } else if ("paid".equals(bill.getStatus())) { %>
                                                <span class="badge badge-info">Paid</span>
                                            <% } else { %>
                                                <span class="badge badge-warning">Draft</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <a href="billDetails.jsp?id=<%= bill.getBillId() %>" class="btn btn-sm btn-primary">View Details</a>
                                            <% if ("draft".equals(bill.getStatus())) { %>
                                                <button class="btn btn-sm btn-danger" onclick="deleteBill(<%= bill.getBillId() %>)">Delete</button>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% }
                                    } else { %>
                                    <tr>
                                        <td colspan="7" class="text-center">No bills found. Generate your first bill!</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- How Bill Splitting Works -->
                <div class="card">
                    <div class="card-header">❓ How Bill Splitting Works</div>
                    <div class="card-body">
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
                            <div>
                                <h4>1️⃣ Calculate Room Units</h4>
                                <p>For each room: <br><code>total_units = Σ (wattage × hours × days) / 1000</code></p>
                            </div>
                            <div>
                                <h4>2️⃣ Apply Tiered Rates</h4>
                                <p>Calculate total bill using CEB's progressive tier system</p>
                            </div>
                            <div>
                                <h4>3️⃣ Split Proportionally</h4>
                                <p><code>room_cost = (room_units / total_units) × total_bill</code></p>
                            </div>
                            <div>
                                <h4>4️⃣ Alert High Usage</h4>
                                <p>Rooms with usage above average are flagged for attention</p>
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

    <script>
        function showGenerateBillForm() {
            window.location.href = '${pageContext.request.contextPath}/generateBill.jsp';
        }

        function deleteBill(billId) {
            if (confirm('Are you sure you want to delete this bill?')) {
                window.location.href = '${pageContext.request.contextPath}/bills?action=delete&id=' + billId;
            }
        }
    </script>
</body>
</html>