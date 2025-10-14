package com.OOPWebProject.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.ApplianceDAO;
import com.OOPWebProject.dao.BillDAO;
import com.OOPWebProject.dao.RoomBillSummaryDAO;
import com.OOPWebProject.dao.RoomDAO;
import com.OOPWebProject.model.Bill;
import com.OOPWebProject.model.Room;
import com.OOPWebProject.model.RoomBillSummary;
import com.OOPWebProject.model.User;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RoomDAO roomDAO;
    private ApplianceDAO applianceDAO;
    private BillDAO billDAO;
    private RoomBillSummaryDAO summaryDAO;

    public void init() {
        roomDAO = new RoomDAO();
        applianceDAO = new ApplianceDAO();
        billDAO = new BillDAO();
        summaryDAO = new RoomBillSummaryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            User user = (User) session.getAttribute("user");

            // Get dashboard statistics with default values
            int totalRooms = 0;
            int occupiedRooms = 0;
            int totalAppliances = 0;
            double currentMonthTotal = 0.0;

            try {
                totalRooms = roomDAO.getTotalRoomsCount();
            } catch (Exception e) {
                System.err.println("Error getting total rooms: " + e.getMessage());
            }

            try {
                occupiedRooms = roomDAO.getOccupiedRoomsCount();
            } catch (Exception e) {
                System.err.println("Error getting occupied rooms: " + e.getMessage());
            }

            try {
                totalAppliances = applianceDAO.getTotalAppliancesCount();
            } catch (Exception e) {
                System.err.println("Error getting total appliances: " + e.getMessage());
            }

            // Get recent bills
            List<Bill> recentBills = null;
            try {
                recentBills = billDAO.getRecentBills(5);
            } catch (Exception e) {
                System.err.println("Error getting recent bills: " + e.getMessage());
                recentBills = new java.util.ArrayList<>();
            }

            // Get high usage alerts
            List<RoomBillSummary> highUsageRooms = null;
            try {
                highUsageRooms = summaryDAO.getHighUsageAlerts();
            } catch (Exception e) {
                System.err.println("Error getting high usage alerts: " + e.getMessage());
                highUsageRooms = new java.util.ArrayList<>();
            }

            // Calculate current month statistics if available
            try {
                Bill currentBill = billDAO.getCurrentMonthBill();
                if (currentBill != null) {
                    currentMonthTotal = currentBill.getTotalBill();
                }
            } catch (Exception e) {
                System.err.println("Error getting current month bill: " + e.getMessage());
            }

            // Set attributes - ensure no nulls
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("totalAppliances", totalAppliances);
            request.setAttribute("recentBills", recentBills != null ? recentBills : new java.util.ArrayList<>());
            request.setAttribute("highUsageRooms", highUsageRooms != null ? highUsageRooms : new java.util.ArrayList<>());
            request.setAttribute("currentMonthTotal", currentMonthTotal);
            request.setAttribute("user", user);

            // Role-based dashboard
            if ("admin".equals(user.getRole())) {
                // Admin dashboard - show all data
                try {
                    List<Room> allRooms = roomDAO.getAllRooms();
                    request.setAttribute("rooms", allRooms != null ? allRooms : new java.util.ArrayList<>());
                } catch (Exception e) {
                    System.err.println("Error getting all rooms: " + e.getMessage());
                    request.setAttribute("rooms", new java.util.ArrayList<>());
                }
            } else {
                // Tenant dashboard - show only their room data
                try {
                    Integer userId = user.getId();
                    Room userRoom = roomDAO.getRoomByUserId(userId);
                    if (userRoom != null) {
                        request.setAttribute("userRoom", userRoom);
                        List<RoomBillSummary> userBillHistory = summaryDAO.getSummariesByRoom(userRoom.getRoomId());
                        request.setAttribute("userBillHistory", userBillHistory != null ? userBillHistory : new java.util.ArrayList<>());
                    }
                } catch (Exception e) {
                    System.err.println("Error getting user room data: " + e.getMessage());
                }
            }

            request.getRequestDispatcher("/dashboard/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        }
    }
}