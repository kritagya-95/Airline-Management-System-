package com.aeromanage.dao;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;

import java.sql.*;

/**
 * UserDaoImpl - JDBC implementation of UserDao
 */
public class UserDaoImpl implements UserDao {

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean save(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql,
                     PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStatus());

            int rowsAffected = ps.executeUpdate();

            // ── Get generated user_id and set it back on the user object ──
            if (rowsAffected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setUserId(keys.getInt(1));
                    }
                }
            }

            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User findById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET full_name=?, phone=?, role=?, status=? " +
                "WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getStatus());
            ps.setInt(5, user.getUserId());
            ps.setString(6, user.getEmail());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}