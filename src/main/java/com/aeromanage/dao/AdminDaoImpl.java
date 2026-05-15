package com.aeromanage.dao;

import com.aeromanage.entity.User;
import com.aeromanage.utils.DBConnection;

import java.sql.*;
import java.util.*;

/**
 * AdminDaoImpl — JDBC implementation of AdminDao.
 */
public class AdminDaoImpl implements AdminDao {

    // ── Stats ──────────────────────────────────────────────────────────────

    @Override
    public int countUsers() {
        return countQuery("SELECT COUNT(*) FROM users");
    }

    @Override
    public int countFlights() {
        return countQuery("SELECT COUNT(*) FROM flights");
    }

    @Override
    public int countBookings() {
        return countQuery("SELECT COUNT(*) FROM bookings");
    }

    @Override
    public int countPendingUsers() {
        return countQuery("SELECT COUNT(*) FROM users WHERE status = 'PENDING'");
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] countQuery error: " + e.getMessage());
        }
        return 0;
    }

    // ── Users ──────────────────────────────────────────────────────────────

    @Override
    public List<User> getPendingUsers() {
        String sql = "SELECT * FROM users WHERE status = 'PENDING' ORDER BY created_at DESC";
        return fetchUsers(sql);
    }

    @Override
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        return fetchUsers(sql);
    }

    private List<User> fetchUsers(String sql) {
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] fetchUsers error: " + e.getMessage());
        }
        return list;
    }

    @Override
    public boolean updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] updateUserStatus error: " + e.getMessage());
            return false;
        }
    }

    // ── Flights ────────────────────────────────────────────────────────────

    @Override
    public List<Map<String, Object>> getAllFlights() {
        String sql = """
            SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                   f.status, f.base_economy_fare, f.base_business_fare,
                   al.airline_name,
                   oa.iata_code AS origin_code, oa.city AS origin_city,
                   da.iata_code AS dest_code,   da.city AS dest_city,
                   ac.model AS aircraft_model
            FROM flights f
            JOIN airlines al ON al.airline_id      = f.airline_id
            JOIN airports oa ON oa.airport_id      = f.origin_airport_id
            JOIN airports da ON da.airport_id      = f.dest_airport_id
            JOIN aircraft ac ON ac.aircraft_id     = f.aircraft_id
            ORDER BY f.departure_time DESC
            """;
        return fetchMaps(sql);
    }

    // ── Bookings ───────────────────────────────────────────────────────────


    @Override
    public List<Map<String, Object>> getRecentBookings(int limit) {
        String sql = """
            SELECT b.booking_id, b.booking_ref, b.booking_status,
                   b.total_fare, b.created_at, b.class,
                   u.full_name AS passenger_name, u.email,
                   f.flight_number,
                   oa.iata_code AS from_code,
                   da.iata_code AS to_code
            FROM bookings b
            JOIN users    u  ON u.user_id     = b.user_id
            JOIN flights  f  ON f.flight_id   = b.flight_id
            JOIN airports oa ON oa.airport_id = f.origin_airport_id
            JOIN airports da ON da.airport_id = f.dest_airport_id
            ORDER BY b.created_at DESC
            LIMIT ?
            """;
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] getRecentBookings error: " + e.getMessage());
        }
        return list;
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    private List<Map<String, Object>> fetchMaps(String sql) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rowToMap(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] fetchMaps error: " + e.getMessage());
        }
        return list;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> map = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
            map.put(meta.getColumnLabel(i), rs.getObject(i));
        }
        return map;
    }
}
