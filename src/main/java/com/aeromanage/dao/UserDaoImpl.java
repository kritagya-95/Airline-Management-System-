package com.aeromanage.dao;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;

import java.sql.*;

/**
 * JDBC implementation of the {@link UserDao} interface.
 *
 * <p>Provides concrete database operations for user account management using
 * standard JDBC with {@link PreparedStatement} to prevent SQL injection.
 * All database resources are managed via try-with-resources to ensure
 * proper cleanup regardless of execution outcome.</p>
 *
 * @see UserDao
 * @see DBConnection
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
        String sql = "INSERT INTO users (full_name, email, password, phone, role, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql,
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());

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
     *
     * <p>Updates {@code full_name}, {@code phone}, {@code role}, and {@code status}
     * fields for the record identified by {@code user_id}. The {@code email} field
     * is intentionally excluded from mutation to preserve account identity integrity.</p>
     */
    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, role = ?, status = ? "
                + "WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getStatus());
            ps.setInt(5, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[UserDaoImpl] update error: " + e.getMessage());
            return false;
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
            System.err.println("[UserDaoImpl] saveStaffRecord error for userId "
                    + userId + ": " + e.getMessage());
        }
    }

    /**
     * Maps the current row of the provided {@link ResultSet} to a {@link User} entity.
     *
     * @param rs the {@link ResultSet} positioned at the row to map
     * @return a populated {@link User} instance
     * @throws SQLException if a database access error occurs during column retrieval
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
        return user;
    }
}