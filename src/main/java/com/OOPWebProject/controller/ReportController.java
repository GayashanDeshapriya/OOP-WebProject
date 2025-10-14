package com.OOPWebProject.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.BillDAO;
import com.OOPWebProject.dao.RoomBillSummaryDAO;
import com.OOPWebProject.model.RoomBillSummary;

@WebServlet("/reports/*")
public class ReportController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillDAO billDAO;
    private RoomBillSummaryDAO summaryDAO;

    public void init() {
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

        String action = request.getParameter("action");
        if (action == null) action = "monthly";

        try {
            switch (action) {
                case "monthly":
                    generateMonthlyReport(request, response);
                    break;
                case "yearly":
                    generateYearlyReport(request, response);
                    break;
                case "comparison":
                    generateComparisonReport(request, response);
                    break;
                case "room":
                    generateRoomReport(request, response);
                    break;
                default:
                    generateMonthlyReport(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void generateMonthlyReport(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String month = request.getParameter("month");
        if (month == null) {
            month = java.time.YearMonth.now().toString();
        }
        
        List<RoomBillSummary> monthlySummaries = summaryDAO.getSummariesByMonth(month);
        Map<String, Object> statistics = summaryDAO.getMonthlyStatistics(month);
        
        request.setAttribute("month", month);
        request.setAttribute("summaries", monthlySummaries);
        request.setAttribute("statistics", statistics);
        request.setAttribute("reportType", "monthly");
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    private void generateYearlyReport(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String year = request.getParameter("year");
        if (year == null) {
            year = String.valueOf(java.time.Year.now().getValue());
        }
        
        List<Map<String, Object>> yearlyData = summaryDAO.getYearlyStatistics(year);
        
        request.setAttribute("year", year);
        request.setAttribute("yearlyData", yearlyData);
        request.setAttribute("reportType", "yearly");
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    private void generateComparisonReport(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String month1 = request.getParameter("month1");
        String month2 = request.getParameter("month2");
        
        if (month1 == null) month1 = java.time.YearMonth.now().minusMonths(1).toString();
        if (month2 == null) month2 = java.time.YearMonth.now().toString();
        
        Map<String, Object> comparison = summaryDAO.compareMonths(month1, month2);
        
        request.setAttribute("month1", month1);
        request.setAttribute("month2", month2);
        request.setAttribute("comparison", comparison);
        request.setAttribute("reportType", "comparison");
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }

    private void generateRoomReport(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String period = request.getParameter("period");
        if (period == null) period = "6"; // Last 6 months
        
        List<RoomBillSummary> roomHistory = summaryDAO.getRoomHistory(roomId, Integer.parseInt(period));
        
        request.setAttribute("roomId", roomId);
        request.setAttribute("roomHistory", roomHistory);
        request.setAttribute("reportType", "room");
        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
}
