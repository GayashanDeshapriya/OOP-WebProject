package com.OOPWebProject.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.OOPWebProject.dao.BillDAO;
import com.OOPWebProject.dao.RoomBillSummaryDAO;
import com.OOPWebProject.model.Bill;
import com.OOPWebProject.model.RoomBillSummary;
import com.OOPWebProject.model.User;
import com.OOPWebProject.service.PdfService;

@WebServlet("/exportPdf")
public class PdfExportController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BillDAO billDAO;
    private RoomBillSummaryDAO summaryDAO;
    private PdfService pdfService;
    
    @Override
    public void init() throws ServletException {
        billDAO = new BillDAO();
        summaryDAO = new RoomBillSummaryDAO();
        pdfService = new PdfService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        try {
            // Get report data
            Bill latestBill = billDAO.getLatestBill();
            List<RoomBillSummary> summaries = null;
            if (latestBill != null) {
                summaries = summaryDAO.getSummariesByBill(latestBill.getBillId());
            }
            List<Bill> recentBills = billDAO.getRecentBills(6);
            
            // Generate PDF
            byte[] pdfBytes = pdfService.generateReportPdf(latestBill, summaries, recentBills);
            
            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setContentLength(pdfBytes.length);
            
            String filename = "electricity_report_" + 
                (latestBill != null ? latestBill.getBillMonth().replace(" ", "_") : "current") + ".pdf";
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
            
            // Write PDF to response
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error generating PDF: " + e.getMessage());
        }
    }
}