package com.OOPWebProject.dao;

import com.OOPWebProject.model.Appliance;
import com.OOPWebProject.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplianceDAO {
    
    /**
     * Get all appliances
     */
    public List<Appliance> getAllAppliances() throws SQLException {
        List<Appliance> appliances = new ArrayList<>();
        String query = "SELECT a.*, r.room_name FROM appliances a " +
                      "LEFT JOIN rooms r ON a.room_id = r.room_id " +
                      "ORDER BY r.room_name, a.appliance_name";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                appliances.add(extractApplianceFromResultSet(rs));
            }
        }
        return appliances;
    }
    
    /**
     * Get appliances by room ID
     */
    public List<Appliance> getAppliancesByRoom(int roomId) throws SQLException {
        List<Appliance> appliances = new ArrayList<>();
        String query = "SELECT a.*, r.room_name FROM appliances a " +
                      "LEFT JOIN rooms r ON a.room_id = r.room_id " +
                      "WHERE a.room_id = ? AND a.status = 'active' " +
                      "ORDER BY a.appliance_name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                appliances.add(extractApplianceFromResultSet(rs));
            }
        }
        return appliances;
    }
    
    /**
     * Get appliance by ID
     */
    public Appliance getApplianceById(int applianceId) throws SQLException {
        String query = "SELECT a.*, r.room_name FROM appliances a " +
                      "LEFT JOIN rooms r ON a.room_id = r.room_id " +
                      "WHERE a.appliance_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, applianceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractApplianceFromResultSet(rs);
            }
        }
        return null;
    }
    
    /**
     * Insert new appliance
     */
    public boolean insertAppliance(Appliance appliance) throws SQLException {
        String query = "INSERT INTO appliances (room_id, appliance_name, wattage, description, status) " +
                      "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appliance.getRoomId());
            pstmt.setString(2, appliance.getApplianceName());
            pstmt.setDouble(3, appliance.getWattage());
            pstmt.setString(4, appliance.getDescription());
            pstmt.setString(5, appliance.getStatus());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Update appliance
     */
    public boolean updateAppliance(Appliance appliance) throws SQLException {
        String query = "UPDATE appliances SET room_id = ?, appliance_name = ?, wattage = ?, " +
                      "description = ?, status = ? WHERE appliance_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, appliance.getRoomId());
            pstmt.setString(2, appliance.getApplianceName());
            pstmt.setDouble(3, appliance.getWattage());
            pstmt.setString(4, appliance.getDescription());
            pstmt.setString(5, appliance.getStatus());
            pstmt.setInt(6, appliance.getApplianceId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete appliance
     */
    public boolean deleteAppliance(int applianceId) throws SQLException {
        String query = "DELETE FROM appliances WHERE appliance_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, applianceId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get total appliance count
     */
    public int getTotalAppliancesCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM appliances WHERE status = 'active'";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Get appliance count by room
     */
    public int getApplianceCountByRoom(int roomId) throws SQLException {
        String query = "SELECT COUNT(*) FROM appliances WHERE room_id = ? AND status = 'active'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Extract Appliance object from ResultSet
     */
    private Appliance extractApplianceFromResultSet(ResultSet rs) throws SQLException {
        Appliance appliance = new Appliance();
        appliance.setApplianceId(rs.getInt("appliance_id"));
        appliance.setRoomId(rs.getInt("room_id"));
        appliance.setApplianceName(rs.getString("appliance_name"));
        appliance.setWattage(rs.getDouble("wattage"));
        appliance.setDescription(rs.getString("description"));
        appliance.setStatus(rs.getString("status"));
        appliance.setCreatedDate(rs.getTimestamp("created_date"));
        
        // Set room name if available from JOIN
        try {
            appliance.setRoomName(rs.getString("room_name"));
        } catch (SQLException e) {
            // Room name not in result set, ignore
        }
        
        return appliance;
    }
}