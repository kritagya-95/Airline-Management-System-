package com.aeromanage.dao;

import com.aeromanage.utils.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * StaffDaoImpl — JDBC Implementation
 */
public class StaffDaoImpl implements StaffDao {

    @Override
    public int countPassengersToday() {
        String sql = """
            SELECT COUNT(DISTINCT bp.passenger_id)
            FROM bookings b
            JOIN booking_passengers bp ON b.booking_id = bp.booking_id
            JOIN flights f ON b.flight_id = f.flight_id
            WHERE DATE(f.departure_time) = CURDATE()
            """;
        return countQuery(sql);
    }

    @Override
    public int countTodayFlights() {
        return countQuery("SELECT COUNT(*) FROM flights WHERE DATE(departure_time) = CURDATE()");
    }

    @Override
    public List<Map<String, Object>> getTodayFlights() {
        String sql = """
            SELECT f.flight_id, f.flight_number, al.airline_name,
                   oa.iata_code AS origin_code, oa.city AS origin_city,
                   da.iata_code AS dest_code, da.city AS dest_city,
                   f.departure_time, f.arrival_time, f.status,
                   (SELECT COUNT(*) FROM flight_seat_availability 
                    WHERE flight_id = f.flight_id AND is_available = 0) AS booked_seats
            FROM flights f
            JOIN airlines al ON al.airline_id = f.airline_id
            JOIN airports oa ON oa.airport_id = f.origin_airport_id
            JOIN airports da ON da.airport_id = f.dest_airport_id
            WHERE DATE(f.departure_time) = CURDATE()
            ORDER BY f.departure_time ASC
            """;
        return fetchMaps(sql);
    }

    @Override
    public Map<String, Object> findBookingByReference(String bookingRef) {
        String sql = """
            SELECT b.booking_id, b.booking_ref, b.class, b.num_passengers, 
                   b.total_fare, b.booking_status, u.full_name AS passenger_name,
                   f.flight_number, f.departure_time, f.arrival_time, f.status
            FROM bookings b
            JOIN users u ON b.user_id = u.user_id
            JOIN flights f ON b.flight_id = f.flight_id
            WHERE b.booking_ref = ?
            """;
        return findSingleRow(sql, bookingRef);
    }

    @Override
    public boolean updateFlightStatus(int flightId, String newStatus, int staffUserId, String reason) {
        String sql = "UPDATE flights SET status = ? WHERE flight_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, flightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== HELPER METHODS ====================
    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private List<Map<String, Object>> fetchMaps(String sql) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rowToMap(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Map<String, Object> findSingleRow(String sql, String param) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rowToMap(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> map = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();
        for (int i = 1; i <= meta.getColumnCount(); i++) {
            map.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        }
        return map;
    }
}