package com.OOPWebProject.dao;

import com.OOPWebProject.model.Room;
import com.OOPWebProject.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    /**
     * Get all rooms
     */
    public List<Room> getAllRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms ORDER BY room_name";

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                rooms.add(extractRoomFromResultSet(rs));
            }
        }
        return rooms;
    }

    /**
     * Get room by ID
     */
    public Room getRoomById(int roomId) throws SQLException {
        String query = "SELECT * FROM rooms WHERE room_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractRoomFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Get rooms by status
     */
    public List<Room> getRoomsByStatus(String status) throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms WHERE status = ? ORDER BY room_name";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                rooms.add(extractRoomFromResultSet(rs));
            }
        }
        return rooms;
    }

    /**
     * Insert new room
     */
    public boolean insertRoom(Room room) throws SQLException {
        String query = "INSERT INTO rooms (room_name, occupant_name, user_id, floor_number, status) " +
                      "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, room.getRoomName());
            pstmt.setString(2, room.getOccupantName());
            if (room.getUserId() != null) {
                pstmt.setInt(3, room.getUserId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            pstmt.setInt(4, room.getFloorNumber());
            pstmt.setString(5, room.getStatus());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Update room
     */
    public boolean updateRoom(Room room) throws SQLException {
        String query = "UPDATE rooms SET room_name = ?, occupant_name = ?, user_id = ?, " +
                      "floor_number = ?, status = ? WHERE room_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, room.getRoomName());
            pstmt.setString(2, room.getOccupantName());
            if (room.getUserId() != null) {
                pstmt.setInt(3, room.getUserId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            pstmt.setInt(4, room.getFloorNumber());
            pstmt.setString(5, room.getStatus());
            pstmt.setInt(6, room.getRoomId());

            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Delete room
     */
    public boolean deleteRoom(int roomId) throws SQLException {
        String query = "DELETE FROM rooms WHERE room_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, roomId);
            return pstmt.executeUpdate() > 0;
        }
    }

    /**
     * Get total room count
     */
    public int getTotalRoomsCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM rooms";

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
     * Get occupied room count
     */
    public int getOccupiedRoomsCount() throws SQLException {
        String query = "SELECT COUNT(*) FROM rooms WHERE status = 'occupied'";

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
     * Get room by user ID
     */
    public Room getRoomByUserId(int userId) throws SQLException {
        String query = "SELECT * FROM rooms WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractRoomFromResultSet(rs);
            }
        }
        return null;
    }

    /**
     * Extract Room object from ResultSet
     */
    private Room extractRoomFromResultSet(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomName(rs.getString("room_name"));
        room.setOccupantName(rs.getString("occupant_name"));

        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            room.setUserId(userId);
        }

        room.setFloorNumber(rs.getInt("floor_number"));
        room.setStatus(rs.getString("status"));
        room.setCreatedDate(rs.getTimestamp("created_date"));

        return room;
    }
}