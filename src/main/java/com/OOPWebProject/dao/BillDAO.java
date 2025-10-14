package com.OOPWebProject.dao;

import com.OOPWebProject.model.Bill;
import com.OOPWebProject.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    /**
     * Get all bills
     */
    public List<Bill> getAllBills() throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT * FROM bills ORDER BY bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                bills.add(extractBillFromResultSet(rs));
            }
        }
        return bills;
    }

    /**
     * Get bill by ID
     */
    public Bill getBillById(int billId) throws SQLException {
        String query = "SELECT * FROM bills WHERE bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, billId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBillFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Get bill by month
     */
    public Bill getBillByMonth(String billMonth) throws SQLException {
        String query = "SELECT * FROM bills WHERE bill_month = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, billMonth);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBillFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Insert new bill
     */
    public int insertBill(Bill bill) throws SQLException {
        String query = "INSERT INTO bills (bill_month, total_units, total_bill, base_fee, tax_amount, " +
                      "billing_period_start, billing_period_end, status) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, bill.getBillMonth());
            pstmt.setDouble(2, bill.getTotalUnits());
            pstmt.setDouble(3, bill.getTotalBill());
            pstmt.setDouble(4, bill.getBaseFee());
            pstmt.setDouble(5, bill.getTaxAmount());
            pstmt.setDate(6, bill.getBillingPeriodStart());
            pstmt.setDate(7, bill.getBillingPeriodEnd());
            pstmt.setString(8, bill.getStatus());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    /**
     * Update bill
     */
    public boolean updateBill(Bill bill) throws SQLException {
        String query = "UPDATE bills SET bill_month = ?, total_units = ?, total_bill = ?, " +
                      "base_fee = ?, tax_amount = ?, billing_period_start = ?, billing_period_end = ?, " +
                      "status = ? WHERE bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, bill.getBillMonth());
            pstmt.setDouble(2, bill.getTotalUnits());
            pstmt.setDouble(3, bill.getTotalBill());
            pstmt.setDouble(4, bill.getBaseFee());
            pstmt.setDouble(5, bill.getTaxAmount());
            pstmt.setDate(6, bill.getBillingPeriodStart());
            pstmt.setDate(7, bill.getBillingPeriodEnd());
            pstmt.setString(8, bill.getStatus());
            pstmt.setInt(9, bill.getBillId());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete bill
     */
    public boolean deleteBill(int billId) throws SQLException {
        String query = "DELETE FROM bills WHERE bill_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, billId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get recent bills (for prediction)
     */
    public List<Bill> getRecentBills(int count) throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT TOP (?) * FROM bills WHERE status = 'finalized' " +
                      "ORDER BY bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, count);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                bills.add(extractBillFromResultSet(rs));
            }
        }
        return bills;
    }

    /**
     * Get latest bill
     */
    public Bill getLatestBill() throws SQLException {
        String query = "SELECT TOP 1 * FROM bills ORDER BY bill_month DESC";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                return extractBillFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Get current month bill
     */
    public Bill getCurrentMonthBill() throws SQLException {
        String currentMonth = java.time.YearMonth.now().toString();
        return getBillByMonth(currentMonth);
    }

    /**
     * Get room units for a specific month (from usage_records)
     */
    public java.util.Map<Integer, Double> getRoomUnitsForMonth(String billMonth) throws SQLException {
        java.util.Map<Integer, Double> roomUnitsMap = new java.util.HashMap<>();

        // Parse billMonth (YYYY-MM) to get start and end dates
        String query = "SELECT ur.room_id, " +
                      "SUM((a.wattage * ur.hours_per_day * ur.days_used) / 1000.0) as total_units " +
                      "FROM usage_records ur " +
                      "JOIN appliances a ON ur.appliance_id = a.appliance_id " +
                      "WHERE FORMAT(ur.usage_date, 'yyyy-MM') = ? " +
                      "GROUP BY ur.room_id";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, billMonth);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int roomId = rs.getInt("room_id");
                double units = rs.getDouble("total_units");
                roomUnitsMap.put(roomId, units);
            }
        }
        return roomUnitsMap;
    }

    /**
     * Extract Bill object from ResultSet
     */
    private Bill extractBillFromResultSet(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setBillMonth(rs.getString("bill_month"));
        bill.setTotalUnits(rs.getDouble("total_units"));
        bill.setTotalBill(rs.getDouble("total_bill"));
        bill.setBaseFee(rs.getDouble("base_fee"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setBillingPeriodStart(rs.getDate("billing_period_start"));
        bill.setBillingPeriodEnd(rs.getDate("billing_period_end"));
        bill.setStatus(rs.getString("status"));
        bill.setCreatedDate(rs.getTimestamp("created_date"));

        return bill;
    }
}