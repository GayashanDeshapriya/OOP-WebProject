package com.OOPWebProject.dao;

import java.sql.*;
import java.util.*;

import org.mindrot.jbcrypt.BCrypt;

import com.OOPWebProject.model.User;
import com.OOPWebProject.util.DBUtil;

public class UserDAO {

	private static final String INSERT_USER_SQL =
		    "INSERT INTO Users (FirstName, LastName, Email, Password) VALUES (?, ?, ?, ?)";

    private static final String SELECT_USER_BY_ID = "SELECT id, firstname,lastname, email FROM users WHERE id = ?";
    private static final String SELECT_ALL_USERS = "SELECT * FROM Users";
    private static final String DELETE_USER_SQL = "DELETE FROM users WHERE id = ?";
    private static final String UPDATE_USER_SQL = "UPDATE users SET name = ?, email = ?, country = ? WHERE id = ?";

    private static final String SELECT_USER_BY_EMAIL = "SELECT FirstName, LastName, Email, Password FROM users WHERE email = ?";

    private static final String VALIDATE_USER_SQL =
    	    "SELECT Id, FirstName, LastName, Email, Password FROM Users WHERE Email = ?";


    public void insertUser(User user) {
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT_USER_SQL)) {
        	ps.setString(1, user.getfirstName());
        	ps.setString(2, user.getlastName());
        	ps.setString(3, user.getEmail());
            ps.setString(4, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User selectUser(int id) {
        User user = null;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_USER_BY_ID)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("country"),
                    rs.getString("password")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_ALL_USERS)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(new User(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("country"),
                    rs.getString("password")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean deleteUser(int id) {
        boolean rowDeleted = false;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE_USER_SQL)) {
            ps.setInt(1, id);
            rowDeleted = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowDeleted;
    }

    public boolean updateUser(User user) {
        boolean rowUpdated = false;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_USER_SQL)) {
            ps.setString(1, user.getfirstName());
            ps.setString(3, user.getlastName());
            ps.setString(2, user.getEmail());
            ps.setInt(4, user.getId());
            rowUpdated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    // Authentication methods
    public User validateUser(String email, String password) {
        User user = null;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(VALIDATE_USER_SQL)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
				String storedHash = rs.getString("Password");
				if (BCrypt.checkpw(password, storedHash)) {
					user = new User(
						rs.getInt("Id"),
						rs.getString("FirstName"),
						rs.getString("LastName"),
						rs.getString("Email")
					);
				}
			}
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean emailExists(String email) {
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_USER_BY_EMAIL)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}