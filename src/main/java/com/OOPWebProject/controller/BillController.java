package com.OOPWebProject.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.BillDAO;
import com.OOPWebProject.dao.RoomDAO;
import com.OOPWebProject.dao.RoomBillSummaryDAO;
import com.OOPWebProject.model.Bill;
import com.OOPWebProject.model.Room;
import com.OOPWebProject.model.RoomBillSummary;
import com.OOPWebProject.model.User;
import com.OOPWebProject.service.BillingService;

@WebServlet("/bills/*")
public class BillController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillDAO billDAO;
    private RoomDAO roomDAO;
    private RoomBillSummaryDAO summaryDAO;

    public void init() {
        billDAO = new BillDAO();
        roomDAO = new RoomDAO();
        summaryDAO = new RoomBillSummaryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listBills(request, response);
                    break;
                case "view":
                    viewBillDetails(request, response);
                    break;
                case "generate":
                    showGenerateForm(request, response);
                    break;
                case "delete":
                    deleteBill(request, response);
                    break;
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "generate":
                    generateBill(request, response);
                    break;
                case "finalize":
                    finalizeBill(request, response);
                    break;
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listBills(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Bill> bills = billDAO.getAllBills();
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/bills.jsp").forward(request, response);
    }

    private void viewBillDetails(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int billId = Integer.parseInt(request.getParameter("id"));
        Bill bill = billDAO.getBillById(billId);
        List<RoomBillSummary> summaries = summaryDAO.getSummariesByBill(billId);

        request.setAttribute("bill", bill);
        request.setAttribute("summaries", summaries);
        request.getRequestDispatcher("/billDetails.jsp").forward(request, response);
    }

    private void showGenerateForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/generateBill.jsp").forward(request, response);
    }

    private void generateBill(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        // Get user from session
        User user = (User) request.getSession().getAttribute("user");

        String billMonth = request.getParameter("billMonth");
        double totalBillAmount = Double.parseDouble(request.getParameter("totalBill"));
        double baseFee = Double.parseDouble(request.getParameter("baseFee"));
        String periodStart = request.getParameter("periodStart");
        String periodEnd = request.getParameter("periodEnd");

        // Get room usage data from DAO
        Map<Integer, Double> roomUnitsMap = billDAO.getRoomUnitsForMonth(billMonth);

        // Calculate total units
        double totalUnits = 0;
        for (double units : roomUnitsMap.values()) {
            totalUnits += units;
        }

        // Create bill with user_id
        Bill bill = new Bill(user.getId(),billMonth, totalUnits, totalBillAmount, baseFee);
        bill.setBillingPeriodStart(Date.valueOf(periodStart));
        bill.setBillingPeriodEnd(Date.valueOf(periodEnd));
        bill.setStatus("draft");

        int billId = billDAO.insertBill(bill);


        // Calculate average for alert detection
        double averageUnits = totalUnits / roomUnitsMap.size();

        // Generate room summaries
        for (Map.Entry<Integer, Double> entry : roomUnitsMap.entrySet()) {
            int roomId = entry.getKey();
            double roomUnits = entry.getValue();

            // Calculate room cost
            double roomCost = BillingService.calculateRoomCost(roomUnits, totalUnits, totalBillAmount);
            double usagePercentage = BillingService.calculateUsagePercentage(roomUnits, totalUnits);
            String alertStatus = BillingService.determineAlertStatus(roomUnits, averageUnits);

            RoomBillSummary summary = new RoomBillSummary(billId, roomId, roomUnits, roomCost);
            summary.setUsagePercentage(usagePercentage);
            summary.setAlertStatus(alertStatus);

            summaryDAO.insertSummary(summary);
        }

        response.sendRedirect(request.getContextPath() + "/bills?action=view&id=" + billId + "&success=Bill generated successfully");
    }

    private void finalizeBill(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int billId = Integer.parseInt(request.getParameter("billId"));
        Bill bill = billDAO.getBillById(billId);
        bill.setStatus("finalized");
        billDAO.updateBill(bill);

        response.sendRedirect(request.getContextPath() + "/bills?action=view&id=" + billId + "&success=Bill finalized successfully");
    }

    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int billId = Integer.parseInt(request.getParameter("id"));
        billDAO.deleteBill(billId);
        response.sendRedirect(request.getContextPath() + "/bills?action=list&success=Bill deleted successfully");
    }
}