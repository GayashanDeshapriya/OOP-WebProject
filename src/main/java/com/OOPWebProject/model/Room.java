package com.OOPWebProject.model;

import java.sql.Timestamp;

public class Room {
    private int roomId;
    private String roomName;
    private String occupantName;
    private Integer userId;
    private int floorNumber;
    private String status; // 'occupied', 'vacant'
    private Timestamp createdDate;
    
    // Constructors
    public Room() {}
    
    public Room(int roomId, String roomName, String occupantName) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.occupantName = occupantName;
    }
    
    public Room(String roomName, String occupantName, int floorNumber) {
        this.roomName = roomName;
        this.occupantName = occupantName;
        this.floorNumber = floorNumber;
        this.status = "vacant";
    }
    
    public Room(int roomId, String roomName, String occupantName, Integer userId, 
                int floorNumber, String status) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.occupantName = occupantName;
        this.userId = userId;
        this.floorNumber = floorNumber;
        this.status = status;
    }
    
    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }
    
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public String getOccupantName() {
        return occupantName;
    }
    
    public void setOccupantName(String occupantName) {
        this.occupantName = occupantName;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public int getFloorNumber() {
        return floorNumber;
    }
    
    public void setFloorNumber(int floorNumber) {
        this.floorNumber = floorNumber;
    }
    
    public String getStatus() {
        return status != null ? status : "vacant";
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    @Override
    public String toString() {
        return "Room{" +
                "roomId=" + roomId +
                ", roomName='" + roomName + '\'' +
                ", occupantName='" + occupantName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
