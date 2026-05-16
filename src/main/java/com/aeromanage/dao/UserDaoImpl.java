package com.aeromanage.dao;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * JDBC implementation of the UserDao interface.
 */
public class UserDaoImpl implements UserDao {

    /**
     * {@inheritDoc}
     */
    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] findByEmail error: " + e.getMessage());
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean save(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role, status, profile_image) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());
            ps.setString(7, user.getProfileImage());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setUserId(keys.getInt(1));
                    }
                }
            }
            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] save error: " + e.getMessage());
            return false;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] findById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean update(User user) {
        String sql = """
            UPDATE users 
            SET full_name = ?, 
                email = ?, 
                phone = ?
            WHERE user_id = ? 
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone() != null ? user.getPhone() : null);
            ps.setInt(4, user.getUserId());

            int rows = ps.executeUpdate();

            System.out.println("[SUCCESS] Profile updated for User ID: " + user.getUserId()
                    + " | Role: " + user.getRole() + " | Rows affected: " + rows);

            return rows > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to update profile for user " + user.getUserId());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] updatePassword error for userId " + userId + ": " + e.getMessage());
            return false;
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean deletePassengerAccount(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Delete related records (same as before)
                deleteRows(conn, "DELETE FROM refunds WHERE cancellation_id IN (SELECT cancellation_id FROM cancellations WHERE booking_id IN (SELECT booking_id FROM bookings WHERE user_id = ?))", userId);
                deleteRows(conn, "DELETE FROM cancellations WHERE booking_id IN (SELECT booking_id FROM bookings WHERE user_id = ?)", userId);
                deleteRows(conn, "DELETE FROM payments WHERE booking_id IN (SELECT booking_id FROM bookings WHERE user_id = ?)", userId);
                deleteRows(conn, "DELETE FROM booking_passengers WHERE booking_id IN (SELECT booking_id FROM bookings WHERE user_id = ?)", userId);
                deleteRows(conn, "DELETE FROM bookings WHERE user_id = ?", userId);
                deleteRows(conn, "DELETE FROM notifications WHERE user_id = ?", userId);

                int deleted = deleteRows(conn, "DELETE FROM users WHERE user_id = ? AND role = 'PASSENGER'", userId);

                conn.commit();
                return deleted > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] deletePassengerAccount error: " + e.getMessage());
            return false;
        }
    }

    private int deleteRows(Connection conn, String sql, int userId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void saveStaffRecord(int userId) {
        String sql = "INSERT INTO staff (user_id, employee_code, designation, department, hire_date) "
                + "VALUES (?, ?, ?, ?, CURDATE())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, "EMP" + String.format("%03d", userId));
            ps.setString(3, "Staff Member");
            ps.setString(4, "Operations");

            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] saveStaffRecord error: " + e.getMessage());
        }
    }

    // ==================== NEW PROFILE IMAGE METHODS ====================

    @Override
    public boolean updateProfileImage(int userId, String imageName) {
        String sql = "UPDATE users SET profile_image = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, imageName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] updateProfileImage error: " + e.getMessage());
            return false;
        }
    }

    @Override
    public String getProfileImage(int userId) {
        String sql = "SELECT profile_image FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String img = rs.getString("profile_image");
                    return (img != null && !img.isEmpty()) ? img : "default-avatar.png";
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] getProfileImage error: " + e.getMessage());
        }
        return "default-avatar.png";
    }

    /**
     * Maps ResultSet row to User object (Updated with profile_image)
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setProfileImage(rs.getString("profile_image"));   // NEW
        return user;
    }
}