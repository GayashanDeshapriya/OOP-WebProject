package com.OOPWebProject.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.OOPWebProject.model.Bill;
import com.OOPWebProject.model.RoomBillSummary;

public class PdfService {
    
    private static final Font TITLE_FONT = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.DARK_GRAY);
    private static final Font HEADER_FONT = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.BLACK);
    private static final Font NORMAL_FONT = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
    private static final Font SMALL_FONT = FontFactory.getFont(FontFactory.HELVETICA, 8, BaseColor.GRAY);
    
    private DecimalFormat df = new DecimalFormat("#,##0.00");
    private DecimalFormat dfUnits = new DecimalFormat("#,##0.0");
    
    public byte[] generateReportPdf(Bill latestBill, List<RoomBillSummary> summaries, List<Bill> recentBills) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = PdfWriter.getInstance(document, baos);
        
        // Add header and footer
        writer.setPageEvent(new HeaderFooterPageEvent());
        
        document.open();
        
        // Add title
        addTitle(document);
        
        // Add current month overview
        if (latestBill != null) {
            addCurrentMonthOverview(document, latestBill, summaries);
        }
        
        // Add room-wise breakdown
        if (summaries != null && !summaries.isEmpty()) {
            addRoomWiseBreakdown(document, summaries);
        }
        
        // Add historical trends
        if (recentBills != null && !recentBills.isEmpty()) {
            addHistoricalTrends(document, recentBills);
        }
        
        // Add energy saving recommendations
        addEnergySavingTips(document);
        
        document.close();
        return baos.toByteArray();
    }
    
    private void addTitle(Document document) throws DocumentException {
        Paragraph title = new Paragraph("Smart Boarder Electricity Usage Report", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20f);
        document.add(title);
        
        Paragraph date = new Paragraph("Generated on: " + 
            LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm")), NORMAL_FONT);
        date.setAlignment(Element.ALIGN_CENTER);
        date.setSpacingAfter(30f);
        document.add(date);
    }
    
    private void addCurrentMonthOverview(Document document, Bill latestBill, List<RoomBillSummary> summaries) throws DocumentException {
        Paragraph header = new Paragraph("Current Month Overview - " + latestBill.getBillMonth(), HEADER_FONT);
        header.setSpacingAfter(15f);
        document.add(header);
        
        // Create statistics table
        PdfPTable statsTable = new PdfPTable(4);
        statsTable.setWidthPercentage(100);
        statsTable.setSpacingAfter(20f);
        
        // Headers
        addCellToTable(statsTable, "Total Consumption", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(statsTable, "Total Bill", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(statsTable, "Average per Room", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(statsTable, "Average Cost/Room", HEADER_FONT, BaseColor.LIGHT_GRAY);
        
        // Values
        addCellToTable(statsTable, dfUnits.format(latestBill.getTotalUnits()) + " kWh", NORMAL_FONT, BaseColor.WHITE);
        addCellToTable(statsTable, "Rs. " + df.format(latestBill.getTotalBill()), NORMAL_FONT, BaseColor.WHITE);
        
        double avgUnits = summaries.size() > 0 ? latestBill.getTotalUnits() / summaries.size() : 0;
        addCellToTable(statsTable, dfUnits.format(avgUnits) + " kWh", NORMAL_FONT, BaseColor.WHITE);
        
        double avgCost = summaries.size() > 0 ? latestBill.getTotalBill() / summaries.size() : 0;
        addCellToTable(statsTable, "Rs. " + df.format(avgCost), NORMAL_FONT, BaseColor.WHITE);
        
        document.add(statsTable);
    }
    
    private void addRoomWiseBreakdown(Document document, List<RoomBillSummary> summaries) throws DocumentException {
        Paragraph header = new Paragraph("Room-wise Breakdown", HEADER_FONT);
        header.setSpacingAfter(15f);
        document.add(header);
        
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{2f, 2f, 1.5f, 1.5f, 1f, 1.5f});
        table.setSpacingAfter(20f);
        
        // Headers
        addCellToTable(table, "Room", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Occupant", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Units (kWh)", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Cost Share", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "% of Total", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Alert", HEADER_FONT, BaseColor.LIGHT_GRAY);
        
        // Data rows
        for (RoomBillSummary summary : summaries) {
            addCellToTable(table, summary.getRoomName(), NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, summary.getOccupantName() != null ? summary.getOccupantName() : "-", NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, dfUnits.format(summary.getRoomUnits()) + " kWh", NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, "Rs. " + df.format(summary.getRoomCost()), NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, df.format(summary.getUsagePercentage()) + "%", NORMAL_FONT, BaseColor.WHITE);
            
            String alertStatus = getAlertStatusText(summary.getAlertStatus());
            BaseColor alertColor = getAlertColor(summary.getAlertStatus());
            addCellToTable(table, alertStatus, NORMAL_FONT, alertColor);
        }
        
        document.add(table);
    }
    
    private void addHistoricalTrends(Document document, List<Bill> recentBills) throws DocumentException {
        Paragraph header = new Paragraph("Historical Trends (Last 6 Months)", HEADER_FONT);
        header.setSpacingAfter(15f);
        document.add(header);
        
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{2f, 1.5f, 1.5f, 1.5f, 1f});
        table.setSpacingAfter(20f);
        
        // Headers
        addCellToTable(table, "Month", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Total Units", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Total Bill", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Avg. Rate/Unit", HEADER_FONT, BaseColor.LIGHT_GRAY);
        addCellToTable(table, "Trend", HEADER_FONT, BaseColor.LIGHT_GRAY);
        
        double prevUnits = 0;
        for (int i = 0; i < recentBills.size(); i++) {
            Bill bill = recentBills.get(i);
            double avgRate = bill.getTotalUnits() > 0 ? bill.getTotalBill() / bill.getTotalUnits() : 0;
            String trend = "-";
            
            if (i > 0 && prevUnits > 0) {
                double change = ((bill.getTotalUnits() - prevUnits) / prevUnits) * 100;
                if (change > 5) {
                    trend = "↑ +" + df.format(change) + "%";
                } else if (change < -5) {
                    trend = "↓ " + df.format(change) + "%";
                } else {
                    trend = "→ " + df.format(change) + "%";
                }
            }
            
            addCellToTable(table, bill.getBillMonth(), NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, dfUnits.format(bill.getTotalUnits()) + " kWh", NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, "Rs. " + df.format(bill.getTotalBill()), NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, "Rs. " + df.format(avgRate) + "/unit", NORMAL_FONT, BaseColor.WHITE);
            addCellToTable(table, trend, NORMAL_FONT, BaseColor.WHITE);
            
            prevUnits = bill.getTotalUnits();
        }
        
        document.add(table);
    }
    
    private void addEnergySavingTips(Document document) throws DocumentException {
        document.newPage();
        
        Paragraph header = new Paragraph("Energy Saving Recommendations", HEADER_FONT);
        header.setSpacingAfter(15f);
        document.add(header);
        
        String[] tips = {
            "Air Conditioning: Set AC to 24-25°C. Each degree lower increases consumption by 6-8%. Use timer mode.",
            "Lighting: Switch to LED bulbs (85% less energy than incandescent). Turn off lights when not in use.",
            "Refrigerator: Keep fridge at 3-4°C. Avoid keeping door open. Defrost regularly for efficiency.",
            "Standby Power: Unplug chargers and devices. Standby mode can waste 5-10% of monthly consumption."
        };
        
        String[] icons = {"🌡️", "💡", "🧊", "⚡"};
        
        for (int i = 0; i < tips.length; i++) {
            Paragraph tip = new Paragraph();
            tip.add(new Chunk(icons[i] + " ", HEADER_FONT));
            tip.add(new Chunk(tips[i], NORMAL_FONT));
            tip.setSpacingAfter(10f);
            document.add(tip);
        }
    }
    
    private void addCellToTable(PdfPTable table, String content, Font font, BaseColor backgroundColor) {
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setBackgroundColor(backgroundColor);
        cell.setPadding(8f);
        table.addCell(cell);
    }
    
    private String getAlertStatusText(String status) {
        if ("critical".equals(status)) return "Critical";
        if ("high_usage".equals(status)) return "High Usage";
        return "Normal";
    }
    
    private BaseColor getAlertColor(String status) {
        if ("critical".equals(status)) return new BaseColor(248, 215, 218);
        if ("high_usage".equals(status)) return new BaseColor(255, 243, 205);
        return new BaseColor(212, 237, 218);
    }
    
    // Header and Footer Page Event
    class HeaderFooterPageEvent extends PdfPageEventHelper {
        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfContentByte cb = writer.getDirectContent();
            
            // Header
            Phrase header = new Phrase("Smart Boarder Electricity Usage Analyzer", SMALL_FONT);
            ColumnText.showTextAligned(cb, Element.ALIGN_CENTER, header,
                (document.right() - document.left()) / 2 + document.leftMargin(),
                document.top() + 10, 0);
            
            // Footer
            Phrase footer = new Phrase("Page " + document.getPageNumber(), SMALL_FONT);
            ColumnText.showTextAligned(cb, Element.ALIGN_CENTER, footer,
                (document.right() - document.left()) / 2 + document.leftMargin(),
                document.bottom() - 10, 0);
        }
    }
}