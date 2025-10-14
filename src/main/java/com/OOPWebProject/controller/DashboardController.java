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
            
            // Get dashboard statistics
            int totalRooms = roomDAO.getTotalRoomsCount();
            int occupiedRooms = roomDAO.getOccupiedRoomsCount();
            int totalAppliances = applianceDAO.getTotalAppliancesCount();
            
            // Get recent bills
            List<Bill> recentBills = billDAO.getRecentBills(5);
            
            // Get high usage alerts
            List<RoomBillSummary> highUsageRooms = summaryDAO.getHighUsageAlerts();
            
            // Calculate current month statistics if available
            Bill currentBill = billDAO.getCurrentMonthBill();
            double currentMonthTotal = 0;
            if (currentBill != null) {
                currentMonthTotal = currentBill.getTotalBill();
            }
            
            // Set attributes
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("occupiedRooms", occupiedRooms);
            request.setAttribute("totalAppliances", totalAppliances);
            request.setAttribute("recentBills", recentBills);
            request.setAttribute("highUsageRooms", highUsageRooms);
            request.setAttribute("currentMonthTotal", currentMonthTotal);
            
            // Role-based dashboard
            if ("admin".equals(user.getRole())) {
                // Admin dashboard - show all data
                List<Room> allRooms = roomDAO.getAllRooms();
                request.setAttribute("rooms", allRooms);
            } else {
                // Tenant dashboard - show only their room data
                Integer userId = user.getId();
                Room userRoom = roomDAO.getRoomByUserId(userId);
                if (userRoom != null) {
                    request.setAttribute("userRoom", userRoom);
                    List<RoomBillSummary> userBillHistory = summaryDAO.getSummariesByRoom(userRoom.getRoomId());
                    request.setAttribute("userBillHistory", userBillHistory);
                }
            }
            
            request.getRequestDispatcher("/dashboard-view.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}