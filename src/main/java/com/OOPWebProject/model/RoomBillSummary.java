package com.OOPWebProject.model;

import java.sql.Timestamp;

public class RoomBillSummary {
    private int summaryId;
    private int billId;
    private int roomId;
    private double roomUnits; // Units consumed by this room
    private double roomCost; // Cost allocated to this room
    private double usagePercentage; // Percentage of total usage
    private String alertStatus; // 'normal', 'high_usage', 'critical'
    private String notes;
    private Timestamp createdDate;
    
    // For display purposes
    private String roomName;
    private String occupantName;
    private String billMonth;
    
    // Constructors
    public RoomBillSummary() {}
    
    public RoomBillSummary(int billId, int roomId, double roomUnits, double roomCost) {
        this.billId = billId;
        this.roomId = roomId;
        this.roomUnits = roomUnits;
        this.roomCost = roomCost;
        this.alertStatus = "normal";
    }
    
    public RoomBillSummary(int summaryId, int billId, int roomId, double roomUnits, 
                          double roomCost, double usagePercentage, String alertStatus) {
        this.summaryId = summaryId;
        this.billId = billId;
        this.roomId = roomId;
        this.roomUnits = roomUnits;
        this.roomCost = roomCost;
        this.usagePercentage = usagePercentage;
        this.alertStatus = alertStatus;
    }
    
    // Getters and Setters
    public int getSummaryId() {
        return summaryId;
    }
    
    public void setSummaryId(int summaryId) {
        this.summaryId = summaryId;
    }
    
    public int getBillId() {
        return billId;
    }
    
    public void setBillId(int billId) {
        this.billId = billId;
    }
    
    public int getRoomId() {
        return roomId;
    }
    
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    
    public double getRoomUnits() {
        return roomUnits;
    }
    
    public void setRoomUnits(double roomUnits) {
        this.roomUnits = roomUnits;
    }
    
    public double getRoomCost() {
        return roomCost;
    }
    
    public void setRoomCost(double roomCost) {
        this.roomCost = roomCost;
    }
    
    public double getUsagePercentage() {
        return usagePercentage;
    }
    
    public void setUsagePercentage(double usagePercentage) {
        this.usagePercentage = usagePercentage;
    }
    
    public String getAlertStatus() {
        return alertStatus != null ? alertStatus : "normal";
    }
    
    public void setAlertStatus(String alertStatus) {
        this.alertStatus = alertStatus;
    }
    
    public String getNotes() {
        return notes != null ? notes : "";
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
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
    
    public String getOccupantName() {
        return occupantName;
    }
    
    public void setOccupantName(String occupantName) {
        this.occupantName = occupantName;
    }
    
    public String getBillMonth() {
        return billMonth;
    }
    
    public void setBillMonth(String billMonth) {
        this.billMonth = billMonth;
    }
    
    @Override
    public String toString() {
        return "RoomBillSummary{" +
                "summaryId=" + summaryId +
                ", roomId=" + roomId +
                ", roomUnits=" + roomUnits +
                ", roomCost=" + roomCost +
                ", alertStatus='" + alertStatus + '\'' +
                '}';
    }
}
