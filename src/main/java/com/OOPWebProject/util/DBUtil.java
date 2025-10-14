package com.OOPWebProject.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Correct JDBC URL format for MS SQL Server
    private static final String URL = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=PowerSplit_DB;encrypt=false;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "12345";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
