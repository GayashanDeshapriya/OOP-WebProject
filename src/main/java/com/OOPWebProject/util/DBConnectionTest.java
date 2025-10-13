package com.OOPWebProject.util;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {
    public static void main(String[] args) {
        System.out.println("Testing MS SQL Server connection...");

        try (Connection conn = DBUtil.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✓ Connection successful!");
                System.out.println("Database: " + conn.getCatalog());
                System.out.println("Driver: " + conn.getMetaData().getDriverName());
                System.out.println("Driver Version: " + conn.getMetaData().getDriverVersion());
            }
        } catch (SQLException e) {
            System.err.println("✗ Connection failed!");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
