package com.OOPWebProject.service;

import java.util.HashMap;
import java.util.Map;

/**
 * Service class for electricity billing calculations
 * Implements CEB tiered rate logic and fair bill splitting
 */
public class BillingService {
    
    // Tiered rates (CEB Logic) - can be loaded from database
    private static final double[][] TIERED_RATES = {
        {0, 60, 30.00},      // Tier 1: 0-60 units @ Rs. 30/unit
        {60, 90, 37.00},     // Tier 2: 61-90 units @ Rs. 37/unit
        {90, Double.MAX_VALUE, 42.00}  // Tier 3: >90 units @ Rs. 42/unit
    };
    
    /**
     * Calculate total units consumed for a room
     * Formula: total_units = Σ (appliance_watt × hours_per_day × days) / 1000
     */
    public static double calculateRoomUnits(Map<String, Double> applianceUsage) {
        double totalUnits = 0;
        for (Map.Entry<String, Double> entry : applianceUsage.entrySet()) {
            // Entry value should be: (wattage * hours * days) / 1000
            totalUnits += entry.getValue();
        }
        return totalUnits;
    }
    
    /**
     * Calculate bill using tiered rates
     * @param totalUnits Total units consumed
     * @return Total bill amount
     */
    public static double calculateTieredBill(double totalUnits) {
        double bill = 0;
        double remainingUnits = totalUnits;
        
        for (double[] tier : TIERED_RATES) {
            double minUnits = tier[0];
            double maxUnits = tier[1];
            double rate = tier[2];
            
            if (remainingUnits <= 0) break;
            
            double tierRange = maxUnits - minUnits;
            double unitsInThisTier = Math.min(remainingUnits, tierRange);
            
            bill += unitsInThisTier * rate;
            remainingUnits -= unitsInThisTier;
        }
        
        return bill;
    }
    
    /**
     * Calculate room's share of the total bill
     * Formula: room_cost = (room_units / total_units) × total_bill
     */
    public static double calculateRoomCost(double roomUnits, double totalUnits, double totalBill) {
        if (totalUnits == 0) return 0;
        return (roomUnits / totalUnits) * totalBill;
    }
    
    /**
     * Calculate usage percentage
     */
    public static double calculateUsagePercentage(double roomUnits, double totalUnits) {
        if (totalUnits == 0) return 0;
        return (roomUnits / totalUnits) * 100;
    }
    
    /**
     * Determine alert status based on usage
     * High usage = room usage > average room usage
     */
    public static String determineAlertStatus(double roomUnits, double averageRoomUnits) {
        if (roomUnits > averageRoomUnits * 1.5) {
            return "critical";
        } else if (roomUnits > averageRoomUnits) {
            return "high_usage";
        }
        return "normal";
    }
    
    /**
     * Split bill among multiple rooms
     * @param roomUnitsMap Map of room ID to units consumed
     * @param totalBill Total bill amount from CEB
     * @return Map of room ID to cost allocation
     */
    public static Map<Integer, Double> splitBill(Map<Integer, Double> roomUnitsMap, double totalBill) {
        Map<Integer, Double> costAllocation = new HashMap<>();
        
        // Calculate total units
        double totalUnits = 0;
        for (double units : roomUnitsMap.values()) {
            totalUnits += units;
        }
        
        // Calculate each room's share
        for (Map.Entry<Integer, Double> entry : roomUnitsMap.entrySet()) {
            int roomId = entry.getKey();
            double roomUnits = entry.getValue();
            double roomCost = calculateRoomCost(roomUnits, totalUnits, totalBill);
            costAllocation.put(roomId, roomCost);
        }
        
        return costAllocation;
    }
    
    /**
     * Calculate units from appliance usage
     * Formula: (wattage × hours_per_day × days_used) / 1000
     */
    public static double calculateUnitsFromUsage(double wattage, double hoursPerDay, int daysUsed) {
        return (wattage * hoursPerDay * daysUsed) / 1000.0;
    }
    
    /**
     * Predict next month's bill based on average of last N months
     */
    public static double predictNextMonthBill(double[] lastMonthsBills) {
        if (lastMonthsBills == null || lastMonthsBills.length == 0) return 0;
        
        double sum = 0;
        for (double bill : lastMonthsBills) {
            sum += bill;
        }
        return sum / lastMonthsBills.length;
    }
    
    /**
     * Get tier information for a given unit consumption
     */
    public static String getTierInfo(double units) {
        if (units <= 60) {
            return "Tier 1 (0-60 units) @ Rs. 30.00/unit";
        } else if (units <= 90) {
            return "Tier 2 (61-90 units) @ Rs. 37.00/unit";
        } else {
            return "Tier 3 (>90 units) @ Rs. 42.00/unit";
        }
    }
    
    /**
     * Calculate savings recommendation
     * Returns recommended hours to reduce per day to reach target units
     */
    public static double calculateSavingsRecommendation(double currentUnits, double targetUnits, 
                                                        double totalWattage, int daysInMonth) {
        if (currentUnits <= targetUnits) return 0;
        
        double unitsToSave = currentUnits - targetUnits;
        double kwhToSave = unitsToSave;
        double whToSave = kwhToSave * 1000;
        
        // Calculate hours to reduce per day
        double hoursToReduce = whToSave / (totalWattage * daysInMonth);
        return Math.round(hoursToReduce * 10.0) / 10.0; // Round to 1 decimal
    }
}
