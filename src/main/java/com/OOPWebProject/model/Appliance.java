package com.OOPWebProject.model;

import java.sql.Timestamp;

public class Appliance {
    private int applianceId;
    private int roomId;
    private String applianceName;
    private double wattage; // Power consumption in watts
    private String description;
    private String status; // 'active', 'inactive'
    private Timestamp createdDate;
    
    // For display purposes
    private String roomName;
    
    // Constructors
    public Appliance() {}
    
    public Appliance(int roomId, String applianceName, double wattage) {
        this.roomId = roomId;
        this.applianceName = applianceName;
        this.wattage = wattage;
        this.status = "active";
    }
    
    public Appliance(int roomId, String applianceName, double wattage, String description) {
        this.roomId = roomId;
        this.applianceName = applianceName;
        this.wattage = wattage;
        this.description = description;
        this.status = "active";
    }
    
    public Appliance(int applianceId, int roomId, String applianceName, double wattage, 
                     String description, String status) {
        this.applianceId = applianceId;
        this.roomId = roomId;
        this.applianceName = applianceName;
        this.wattage = wattage;
        this.description = description;
        this.status = status;
    }
    
    // Getters and Setters
    public int getApplianceId() {
        return applianceId;
    }
    
    public void setApplianceId(int applianceId) {
        this.applianceId = applianceId;
    }
    
    public int getRoomId() {
        return roomId;
    }
    
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    
    public String getApplianceName() {
        return applianceName;
    }
    
    public void setApplianceName(String applianceName) {
        this.applianceName = applianceName;
    }
    
    public double getWattage() {
        return wattage;
    }
    
    public void setWattage(double wattage) {
        this.wattage = wattage;
    }
    
    public String getDescription() {
        return description != null ? description : "";
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getStatus() {
        return status != null ? status : "active";
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
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    @Override
    public String toString() {
        return "Appliance{" +
                "applianceId=" + applianceId +
                ", applianceName='" + applianceName + '\'' +
                ", wattage=" + wattage +
                ", roomId=" + roomId +
                '}';
    }
}
