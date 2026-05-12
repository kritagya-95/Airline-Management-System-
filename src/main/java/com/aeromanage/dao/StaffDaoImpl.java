package com.aeromanage.dao;

import com.aeromanage.utils.DBConnection;

import java.sql.*;
import java.util.*;

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
        return countQuery(
                "SELECT COUNT(*) FROM flights WHERE DATE(departure_time) = CURDATE()"
        );
    }

    @Override
    public List<Map<String, Object>> getTodayFlights() {
        String sql = """
            SELECT f.flight_id, f.flight_number, al.airline_name,
                   oa.iata_code AS origin_code, oa.city AS origin_city,
                   da.iata_code AS dest_code,   da.city AS dest_city,
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
                   b.total_fare, b.booking_status,
                   u.full_name AS passenger_name,
                   f.flight_number, f.departure_time, f.arrival_time, f.status
            FROM bookings b
            JOIN users   u ON b.user_id   = u.user_id
            JOIN flights f ON b.flight_id = f.flight_id
            WHERE b.booking_ref = ?
            """;
        return findSingleRow(sql, bookingRef);
    }

    @Override
    public boolean updateFlightStatus(int flightId, String newStatus,
                                      int staffUserId, String reason) {
        String getOld   = "SELECT status FROM flights WHERE flight_id = ?";
        String update   = "UPDATE flights SET status = ? WHERE flight_id = ?";
        String insertLog =
                "INSERT INTO flight_status_log " +
                        "(flight_id, old_status, new_status, changed_by, reason) " +
                        "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            // Step 1 — get current status
            String oldStatus = "UNKNOWN";
            try (PreparedStatement ps = conn.prepareStatement(getOld)) {
                ps.setInt(1, flightId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) oldStatus = rs.getString("status");
            }

            // Step 2 — update flight
            try (PreparedStatement ps = conn.prepareStatement(update)) {
                ps.setString(1, newStatus);
                ps.setInt(2, flightId);
                ps.executeUpdate();
            }

            // Step 3 — log the change
            try (PreparedStatement ps = conn.prepareStatement(insertLog)) {
                ps.setInt(1, flightId);
                ps.setString(2, oldStatus);
                ps.setString(3, newStatus);
                ps.setInt(4, staffUserId);
                ps.setString(5, reason);
                ps.executeUpdate();
            }

            return true;

        } catch (SQLException e) {
            System.err.println("[StaffDaoImpl] updateFlightStatus error: "
                    + e.getMessage());
            return false;
        }
    }

    // ── Helpers ───────────────────────────────────────────────────

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[StaffDaoImpl] countQuery error: " + e.getMessage());
        }
        return 0;
    }

    private List<Map<String, Object>> fetchMaps(String sql) {
        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rowToMap(rs));
        } catch (SQLException e) {
            System.err.println("[StaffDaoImpl] fetchMaps error: " + e.getMessage());
        }
        return list;
    }

    private Map<String, Object> findSingleRow(String sql, String param) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rowToMap(rs);
            }
        } catch (SQLException e) {
            System.err.println("[StaffDaoImpl] findSingleRow error: " + e.getMessage());
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

    @Override
    public List<Map<String, Object>> getAllFlights() {
        String sql = """
        SELECT f.flight_id, f.flight_number, al.airline_name,
               oa.iata_code AS origin_code, oa.city AS origin_city,
               da.iata_code AS dest_code,   da.city AS dest_city,
               f.departure_time, f.arrival_time, f.status,
               f.base_economy_fare, f.base_business_fare,
               (SELECT COUNT(*) FROM flight_seat_availability
                WHERE flight_id = f.flight_id AND is_available = 0) AS booked_seats
        FROM flights f
        JOIN airlines al ON al.airline_id = f.airline_id
        JOIN airports oa ON oa.airport_id = f.origin_airport_id
        JOIN airports da ON da.airport_id = f.dest_airport_id
        ORDER BY f.departure_time DESC
        """;
        return fetchMaps(sql);
    }

    @Override
    public List<Map<String, Object>> getFlightStatusHistory() {
        String sql = """
        SELECT fsl.log_id, fsl.old_status, fsl.new_status,
               fsl.reason, fsl.changed_at,
               f.flight_number,
               oa.iata_code AS origin_code,
               da.iata_code AS dest_code,
               u.full_name  AS changed_by_name
        FROM flight_status_log fsl
        JOIN flights  f  ON f.flight_id  = fsl.flight_id
        JOIN airports oa ON oa.airport_id = f.origin_airport_id
        JOIN airports da ON da.airport_id = f.dest_airport_id
        LEFT JOIN users u ON u.user_id   = fsl.changed_by
        ORDER BY fsl.changed_at DESC
        LIMIT 50
        """;
        return fetchMaps(sql);
    }

    @Override
    public List<Map<String, Object>> getAllPassengers() {
        String sql = """
        SELECT u.user_id, u.full_name, u.email, u.phone,
               u.status, u.created_at,
               COUNT(b.booking_id) AS total_bookings
        FROM users u
        LEFT JOIN bookings b ON b.user_id = u.user_id
        WHERE u.role = 'PASSENGER'
        GROUP BY u.user_id
        ORDER BY u.created_at DESC
        """;
        return fetchMaps(sql);
    }

    @Override
    public List<Map<String, Object>> getRecentBookings() {
        String sql = """
        SELECT b.booking_id, b.booking_ref, b.booking_status,
               b.class, b.num_passengers, b.total_fare, b.created_at,
               u.full_name  AS passenger_name, u.email,
               f.flight_number, f.departure_time,
               oa.iata_code AS from_code,
               da.iata_code AS to_code
        FROM bookings b
        JOIN users    u  ON u.user_id     = b.user_id
        JOIN flights  f  ON f.flight_id   = b.flight_id
        JOIN airports oa ON oa.airport_id = f.origin_airport_id
        JOIN airports da ON da.airport_id = f.dest_airport_id
        ORDER BY b.created_at DESC
        LIMIT 20
        """;
        return fetchMaps(sql);
    }

    @Override
    public List<Map<String, Object>> getCancelledBookings() {
        String sql = """
        SELECT b.booking_id, b.booking_ref, b.total_fare,
               b.class, b.created_at,
               u.full_name  AS passenger_name, u.email,
               f.flight_number, f.departure_time,
               oa.iata_code AS from_code,
               da.iata_code AS to_code,
               c.reason, c.cancellation_status, c.requested_at
        FROM bookings b
        JOIN users        u  ON u.user_id     = b.user_id
        JOIN flights      f  ON f.flight_id   = b.flight_id
        JOIN airports     oa ON oa.airport_id = f.origin_airport_id
        JOIN airports     da ON da.airport_id = f.dest_airport_id
        LEFT JOIN cancellations c ON c.booking_id = b.booking_id
        WHERE b.booking_status = 'CANCELLED'
        ORDER BY b.created_at DESC
        """;
        return fetchMaps(sql);
    }
}