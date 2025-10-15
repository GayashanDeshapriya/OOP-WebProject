package com.OOPWebProject.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Bill {
    private int billId;
    private int userId;
    private String billMonth; // Format: YYYY-MM
    private double totalUnits; // Total kWh consumed
    private double totalBill; // Total bill amount
    private double baseFee; // Fixed charge
    private double taxAmount;
    private Date billingPeriodStart;
    private Date billingPeriodEnd;
    private String status; // 'draft', 'finalized', 'paid'
    private Timestamp createdDate;

    // Constructors
    public Bill() {}

    public Bill(int userId,String billMonth, double totalUnits, double totalBill, double baseFee) {
    	this.userId = userId;
        this.billMonth = billMonth;
        this.totalUnits = totalUnits;
        this.totalBill = totalBill;
        this.baseFee = baseFee;
        this.status = "draft";
    }

    public Bill(int userId,int billId, String billMonth, double totalUnits, double totalBill,
                double baseFee, Date billingPeriodStart, Date billingPeriodEnd, String status) {
    	this.userId = userId;
        this.billId = billId;
        this.billMonth = billMonth;
        this.totalUnits = totalUnits;
        this.totalBill = totalBill;
        this.baseFee = baseFee;
        this.billingPeriodStart = billingPeriodStart;
        this.billingPeriodEnd = billingPeriodEnd;
        this.status = status;
    }

    // Getters and Setters
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getBillMonth() {
        return billMonth;
    }

    public void setBillMonth(String billMonth) {
        this.billMonth = billMonth;
    }

    public double getTotalUnits() {
        return totalUnits;
    }

    public void setTotalUnits(double totalUnits) {
        this.totalUnits = totalUnits;
    }

    public double getTotalBill() {
        return totalBill;
    }

    public void setTotalBill(double totalBill) {
        this.totalBill = totalBill;
    }

    public double getBaseFee() {
        return baseFee;
    }

    public void setBaseFee(double baseFee) {
        this.baseFee = baseFee;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }

    public Date getBillingPeriodStart() {
        return billingPeriodStart;
    }

    public void setBillingPeriodStart(Date billingPeriodStart) {
        this.billingPeriodStart = billingPeriodStart;
    }

    public Date getBillingPeriodEnd() {
        return billingPeriodEnd;
    }

    public void setBillingPeriodEnd(Date billingPeriodEnd) {
        this.billingPeriodEnd = billingPeriodEnd;
    }

    public String getStatus() {
        return status != null ? status : "draft";
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
        return "Bill{" +
                "billId=" + billId +
                ", billMonth='" + billMonth + '\'' +
                ", totalUnits=" + totalUnits +
                ", totalBill=" + totalBill +
                ", status='" + status + '\'' +
                '}';
    }
}
