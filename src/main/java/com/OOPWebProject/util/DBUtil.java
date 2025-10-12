package com.OOPWebProject.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/oop_project_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "admin";
    private static final String PASS = "admin123";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Connector/J 8.x
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}