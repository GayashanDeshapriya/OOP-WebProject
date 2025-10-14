package com.OOPWebProject.dao;

import com.OOPWebProject.model.RoomBillSummary;
import com.OOPWebProject.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomBillSummaryDAO {

    /**
     * Get all summaries for a bill
     */
    public List<RoomBillSummary> getSummariesByBill(int billId) throws SQLException {
        List<RoomBillSummary> summaries = new ArrayList<>();
        String query = "SELECT rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.bill_id = ? " +
                      "ORDER BY r.room_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                summaries.add(extractSummaryFromResultSet(rs));
            }
        }
        return summaries;
    }

    /**
     * Get summaries for a room
     */
    public List<RoomBillSummary> getSummariesByRoom(int roomId) throws SQLException {
        List<RoomBillSummary> summaries = new ArrayList<>();
        String query = "SELECT rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.room_id = ? " +
                      "ORDER BY b.bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                summaries.add(extractSummaryFromResultSet(rs));
            }
        }
        return summaries;
    }

    /**
     * Get high usage alerts
     */
    public List<RoomBillSummary> getHighUsageAlerts(int billId) throws SQLException {
        List<RoomBillSummary> summaries = new ArrayList<>();
        String query = "SELECT rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.bill_id = ? AND rbs.alert_status IN ('high_usage', 'critical') " +
                      "ORDER BY rbs.room_units DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                summaries.add(extractSummaryFromResultSet(rs));
            }
        }
        return summaries;
    }

    /**
     * Get all high usage alerts (latest bill)
     */
    public List<RoomBillSummary> getHighUsageAlerts() throws SQLException {
        List<RoomBillSummary> summaries = new ArrayList<>();
        String query = "SELECT TOP 10 rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.alert_status IN ('high_usage', 'critical') " +
                      "ORDER BY b.bill_month DESC, rbs.room_units DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                summaries.add(extractSummaryFromResultSet(rs));
            }
        }
        return summaries;
    }

    /**
     * Insert new summary
     */
    public boolean insertSummary(RoomBillSummary summary) throws SQLException {
        String query = "INSERT INTO room_bill_summary (bill_id, room_id, room_units, room_cost, " +
                      "usage_percentage, alert_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, summary.getBillId());
            pstmt.setInt(2, summary.getRoomId());
            pstmt.setDouble(3, summary.getRoomUnits());
            pstmt.setDouble(4, summary.getRoomCost());
            pstmt.setDouble(5, summary.getUsagePercentage());
            pstmt.setString(6, summary.getAlertStatus());
            pstmt.setString(7, summary.getNotes());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Update summary
     */
    public boolean updateSummary(RoomBillSummary summary) throws SQLException {
        String query = "UPDATE room_bill_summary SET room_units = ?, room_cost = ?, " +
                      "usage_percentage = ?, alert_status = ?, notes = ? " +
                      "WHERE summary_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setDouble(1, summary.getRoomUnits());
            pstmt.setDouble(2, summary.getRoomCost());
            pstmt.setDouble(3, summary.getUsagePercentage());
            pstmt.setString(4, summary.getAlertStatus());
            pstmt.setString(5, summary.getNotes());
            pstmt.setInt(6, summary.getSummaryId());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete summary
     */
    public boolean deleteSummary(int summaryId) throws SQLException {
        String query = "DELETE FROM room_bill_summary WHERE summary_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, summaryId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get summary by bill and room
     */
    public RoomBillSummary getSummaryByBillAndRoom(int billId, int roomId) throws SQLException {
        String query = "SELECT rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.bill_id = ? AND rbs.room_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, billId);
            pstmt.setInt(2, roomId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractSummaryFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Get summaries by month
     */
    public List<RoomBillSummary> getSummariesByMonth(String month) throws SQLException {
        List<RoomBillSummary> summaries = new ArrayList<>();
        String query = "SELECT rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE b.bill_month = ? " +
                      "ORDER BY r.room_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, month);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                summaries.add(extractSummaryFromResultSet(rs));
            }
        }
        return summaries;
    }

    /**
     * Get monthly statistics
     */
    public java.util.Map<String, Object> getMonthlyStatistics(String month) throws SQLException {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();

        String query = "SELECT " +
                      "COUNT(DISTINCT rbs.room_id) as total_rooms, " +
                      "SUM(rbs.room_units) as total_units, " +
                      "SUM(rbs.room_cost) as total_cost, " +
                      "AVG(rbs.room_units) as avg_units, " +
                      "MAX(rbs.room_units) as max_units, " +
                      "MIN(rbs.room_units) as min_units " +
                      "FROM room_bill_summary rbs " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE b.bill_month = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, month);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                stats.put("totalRooms", rs.getInt("total_rooms"));
                stats.put("totalUnits", rs.getDouble("total_units"));
                stats.put("totalCost", rs.getDouble("total_cost"));
                stats.put("avgUnits", rs.getDouble("avg_units"));
                stats.put("maxUnits", rs.getDouble("max_units"));
                stats.put("minUnits", rs.getDouble("min_units"));
            }
        }
        return stats;
    }

    /**
     * Get yearly statistics
     */
    public List<java.util.Map<String, Object>> getYearlyStatistics(String year) throws SQLException {
        List<java.util.Map<String, Object>> yearlyData = new ArrayList<>();

        String query = "SELECT b.bill_month, " +
                      "SUM(rbs.room_units) as total_units, " +
                      "SUM(rbs.room_cost) as total_cost " +
                      "FROM room_bill_summary rbs " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE b.bill_month LIKE ? " +
                      "GROUP BY b.bill_month " +
                      "ORDER BY b.bill_month";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, year + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                java.util.Map<String, Object> monthData = new java.util.HashMap<>();
                monthData.put("month", rs.getString("bill_month"));
                monthData.put("totalUnits", rs.getDouble("total_units"));
                monthData.put("totalCost", rs.getDouble("total_cost"));
                yearlyData.add(monthData);
            }
        }
        return yearlyData;
    }

    /**
     * Compare two months
     */
    public java.util.Map<String, Object> compareMonths(String month1, String month2) throws SQLException {
        java.util.Map<String, Object> comparison = new java.util.HashMap<>();

        java.util.Map<String, Object> stats1 = getMonthlyStatistics(month1);
        java.util.Map<String, Object> stats2 = getMonthlyStatistics(month2);

        comparison.put("month1", month1);
        comparison.put("month2", month2);
        comparison.put("stats1", stats1);
        comparison.put("stats2", stats2);

        // Calculate differences
        double units1 = (Double) stats1.getOrDefault("totalUnits", 0.0);
        double units2 = (Double) stats2.getOrDefault("totalUnits", 0.0);
        double cost1 = (Double) stats1.getOrDefault("totalCost", 0.0);
        double cost2 = (Double) stats2.getOrDefault("totalCost", 0.0);

        comparison.put("unitsDifference", units2 - units1);
        comparison.put("costDifference", cost2 - cost1);
        comparison.put("unitsPercentChange", units1 > 0 ? ((units2 - units1) / units1) * 100 : 0);
        comparison.put("costPercentChange", cost1 > 0 ? ((cost2 - cost1) / cost1) * 100 : 0);

        return comparison;
    }

    /**
     * Get room history for last N months
     */
    public List<RoomBillSummary> getRoomHistory(int roomId, int months) throws SQLException {
        List<RoomBillSummary> history = new ArrayList<>();
        String query = "SELECT TOP (?) rbs.*, r.room_name, r.occupant_name, b.bill_month " +
                      "FROM room_bill_summary rbs " +
                      "JOIN rooms r ON rbs.room_id = r.room_id " +
                      "JOIN bills b ON rbs.bill_id = b.bill_id " +
                      "WHERE rbs.room_id = ? " +
                      "ORDER BY b.bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, months);
            pstmt.setInt(2, roomId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                history.add(extractSummaryFromResultSet(rs));
            }
        }
        return history;
    }

    /**
     * Extract RoomBillSummary object from ResultSet
     */
    private RoomBillSummary extractSummaryFromResultSet(ResultSet rs) throws SQLException {
        RoomBillSummary summary = new RoomBillSummary();
        summary.setSummaryId(rs.getInt("summary_id"));
        summary.setBillId(rs.getInt("bill_id"));
        summary.setRoomId(rs.getInt("room_id"));
        summary.setRoomUnits(rs.getDouble("room_units"));
        summary.setRoomCost(rs.getDouble("room_cost"));
        summary.setUsagePercentage(rs.getDouble("usage_percentage"));
        summary.setAlertStatus(rs.getString("alert_status"));
        summary.setNotes(rs.getString("notes"));
        summary.setCreatedDate(rs.getTimestamp("created_date"));

        // Additional fields from JOIN
        try {
            summary.setRoomName(rs.getString("room_name"));
            summary.setOccupantName(rs.getString("occupant_name"));
            summary.setBillMonth(rs.getString("bill_month"));
        } catch (SQLException e) {
            // These fields might not be in all queries
        }

        return summary;
    }
}