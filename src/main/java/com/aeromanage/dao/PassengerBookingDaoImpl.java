package com.aeromanage.dao;

import com.aeromanage.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class PassengerBookingDaoImpl implements PassengerBookingDao {

    private static final String BOOKING_SELECT = """
            SELECT b.booking_id, b.booking_ref, b.class, b.num_passengers,
                   b.total_fare, b.booking_status, b.created_at,
                   f.flight_number, f.departure_time, f.arrival_time, f.status AS flight_status,
                   al.airline_name,
                   oa.iata_code AS origin_code, oa.city AS origin_city,
                   da.iata_code AS dest_code, da.city AS dest_city,
                   p.status AS payment_status
            FROM bookings b
            JOIN flights f ON f.flight_id = b.flight_id
            JOIN airlines al ON al.airline_id = f.airline_id
            JOIN airports oa ON oa.airport_id = f.origin_airport_id
            JOIN airports da ON da.airport_id = f.dest_airport_id
            LEFT JOIN payments p ON p.booking_id = b.booking_id
            WHERE b.user_id = ?
            """;

    @Override
    public List<Map<String, Object>> getCurrentBookings(int userId) {
        String sql = BOOKING_SELECT + """
                AND f.departure_time >= NOW()
                AND b.booking_status <> 'CANCELLED'
                ORDER BY f.departure_time ASC
                """;
        return fetchBookings(sql, userId);
    }

    @Override
    public List<Map<String, Object>> getRecentBookings(int userId) {
        String sql = BOOKING_SELECT + """
                ORDER BY b.created_at DESC
                LIMIT 10
                """;
        return fetchBookings(sql, userId);
    }

    @Override
    public List<Map<String, Object>> getPastBookings(int userId) {
        String sql = BOOKING_SELECT + """
                AND f.departure_time < NOW()
                ORDER BY f.departure_time DESC
                """;
        return fetchBookings(sql, userId);
    }

    @Override
    public List<Map<String, Object>> getCancelledBookings(int userId) {
        String sql = """
                SELECT b.booking_id, b.booking_ref, b.class, b.num_passengers,
                       b.total_fare, b.booking_status, b.created_at,
                       f.flight_number, f.departure_time, f.arrival_time, f.status AS flight_status,
                       al.airline_name,
                       oa.iata_code AS origin_code, oa.city AS origin_city,
                       da.iata_code AS dest_code, da.city AS dest_city,
                       c.reason, c.cancellation_status, c.requested_at, c.processed_at
                FROM bookings b
                JOIN flights f ON f.flight_id = b.flight_id
                JOIN airlines al ON al.airline_id = f.airline_id
                JOIN airports oa ON oa.airport_id = f.origin_airport_id
                JOIN airports da ON da.airport_id = f.dest_airport_id
                LEFT JOIN cancellations c ON c.booking_id = b.booking_id
                WHERE b.user_id = ?
                  AND (b.booking_status = 'CANCELLED' OR c.cancellation_id IS NOT NULL)
                ORDER BY COALESCE(c.requested_at, b.created_at) DESC
                """;
        return fetchBookings(sql, userId);
    }

    @Override
    public boolean createBooking(int userId, int flightId, String ticketClass, double totalFare) {
        String insertBooking = """
                INSERT INTO bookings (user_id, flight_id, booking_ref, class, num_passengers, total_fare, booking_status)
                VALUES (?, ?, ?, ?, 1, ?, 'CONFIRMED')
                """;

        // Generate a 10-character unique alphanumeric booking confirmation string
        String bookingRef = UUID.randomUUID().toString()
                .replace("-", "")
                .substring(0, 10)
                .toUpperCase();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertBooking)) {

            ps.setInt(1, userId);
            ps.setInt(2, flightId);
            ps.setString(3, bookingRef);
            ps.setString(4, ticketClass.toUpperCase());
            ps.setDouble(5, totalFare);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PassengerBookingDaoImpl] createBooking database transaction error: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean cancelBooking(int userId, int bookingId, String reason) {
        String findBooking = """
                SELECT booking_id
                FROM bookings
                WHERE booking_id = ?
                  AND user_id = ?
                  AND booking_status <> 'CANCELLED'
                """;
        String updateBooking = """
                UPDATE bookings
                SET booking_status = 'CANCELLED'
                WHERE booking_id = ?
                  AND user_id = ?
                """;
        String insertCancellation = """
                INSERT INTO cancellations (booking_id, cancelled_by, reason, cancellation_status)
                VALUES (?, ?, ?, 'REQUESTED')
                ON DUPLICATE KEY UPDATE
                    reason = VALUES(reason),
                    cancellation_status = VALUES(cancellation_status),
                    requested_at = CURRENT_TIMESTAMP
                """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                try (PreparedStatement ps = conn.prepareStatement(findBooking)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }

                try (PreparedStatement ps = conn.prepareStatement(updateBooking)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(insertCancellation)) {
                    ps.setInt(1, bookingId);
                    ps.setInt(2, userId);
                    ps.setString(3, reason);
                    ps.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[PassengerBookingDaoImpl] cancelBooking error: " + e.getMessage());
            return false;
        }
    }

    private List<Map<String, Object>> fetchBookings(String sql, int userId) {
        List<Map<String, Object>> bookings = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[PassengerBookingDaoImpl] fetchBookings mapping error: " + e.getMessage());
        }

        return bookings;
    }

    private Map<String, Object> rowToMap(ResultSet rs) throws SQLException {
        Map<String, Object> row = new LinkedHashMap<>();
        ResultSetMetaData meta = rs.getMetaData();

        for (int i = 1; i <= meta.getColumnCount(); i++) {
            row.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
        }

        return row;
    }
}