package com.OOPWebProject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class UsageRecord {
    private int recordId;
    private int applianceId;
    private int roomId;
    private Date usageDate;
    private double hoursPerDay; // Hours used per day
    private int daysUsed; // Days used in the period
    private String notes;
    private Timestamp createdDate;
    
    // For display purposes
    private String applianceName;
    private String roomName;
    private double wattage;
    
    // Constructors
    public UsageRecord() {}
    
    public UsageRecord(int applianceId, int roomId, Date usageDate, 
                      double hoursPerDay, int daysUsed) {
        this.applianceId = applianceId;
        this.roomId = roomId;
        this.usageDate = usageDate;
        this.hoursPerDay = hoursPerDay;
        this.daysUsed = daysUsed;
    }
    
    public UsageRecord(int recordId, int applianceId, int roomId, Date usageDate, 
                      double hoursPerDay, int daysUsed, String notes) {
        this.recordId = recordId;
        this.applianceId = applianceId;
        this.roomId = roomId;
        this.usageDate = usageDate;
        this.hoursPerDay = hoursPerDay;
        this.daysUsed = daysUsed;
        this.notes = notes;
    }
    
    // Calculate units consumed
    public double calculateUnits() {
        if (wattage > 0) {
            return (wattage * hoursPerDay * daysUsed) / 1000.0;
        }
        return 0;
    }
    
    // Getters and Setters
    public int getRecordId() {
        return recordId;
    }
    
    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }
    
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
    
    public Date getUsageDate() {
        return usageDate;
    }
    
    public void setUsageDate(Date usageDate) {
        this.usageDate = usageDate;
    }
    
    public double getHoursPerDay() {
        return hoursPerDay;
    }
    
    public void setHoursPerDay(double hoursPerDay) {
        this.hoursPerDay = hoursPerDay;
    }
    
    public int getDaysUsed() {
        return daysUsed;
    }
    
    public void setDaysUsed(int daysUsed) {
        this.daysUsed = daysUsed;
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
    
    public String getApplianceName() {
        return applianceName;
    }
    
    public void setApplianceName(String applianceName) {
        this.applianceName = applianceName;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public double getWattage() {
        return wattage;
    }
    
    public void setWattage(double wattage) {
        this.wattage = wattage;
    }
    
    @Override
    public String toString() {
        return "UsageRecord{" +
                "recordId=" + recordId +
                ", applianceId=" + applianceId +
                ", roomId=" + roomId +
                ", hoursPerDay=" + hoursPerDay +
                ", daysUsed=" + daysUsed +
                '}';
    }
}
