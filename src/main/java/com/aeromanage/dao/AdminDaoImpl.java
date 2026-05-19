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
    public List<Map<String, Object>> getLimitedFlights(int limit) {
        String sql = """
        SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
               f.base_economy_fare, f.status,
               oa.city AS origin_city, da.city AS dest_city,
               oa.iata_code AS origin_code, da.iata_code AS dest_code,
               al.airline_name
        FROM flights f
        JOIN airports oa ON oa.airport_id = f.origin_airport_id
        JOIN airports da ON da.airport_id = f.dest_airport_id
        JOIN airlines al ON al.airline_id = f.airline_id
        WHERE f.status = 'SCHEDULED'
        ORDER BY f.departure_time ASC
        LIMIT ?
        """;

        List<Map<String, Object>> flights = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    flights.add(rowToMap(rs));   // reuse your existing rowToMap if available
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] getLimitedFlights error: " + e.getMessage());
        }
        return flights;
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
        ensureFlightImageColumn();
        String sql = """
            SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                   f.status, f.base_economy_fare, f.base_business_fare,
                   f.flight_image,
                   al.airline_name,
                   f.airline_id, f.aircraft_id,
                   oa.iata_code AS origin_code, oa.city AS origin_city, oa.country AS origin_country,
                   da.iata_code AS dest_code,   da.city AS dest_city, da.country AS dest_country,
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

    @Override
    public List<Map<String, Object>> getAllAirlines() {
        return fetchMaps("SELECT airline_id, airline_name, iata_code FROM airlines ORDER BY airline_name ASC");
    }

    @Override
    public List<Map<String, Object>> getAllAircraft() {
        String sql = """
            SELECT ac.aircraft_id, ac.registration, ac.model, al.airline_name
            FROM aircraft ac
            JOIN airlines al ON al.airline_id = ac.airline_id
            ORDER BY al.airline_name ASC, ac.model ASC
            """;
        return fetchMaps(sql);
    }

    @Override
    public boolean addFlight(int airlineId, int aircraftId, String flightNumber,
                             String originCode, String originCity, String originCountry,
                             String destCode, String destCity, String destCountry,
                             Timestamp departureTime, Timestamp arrivalTime, String status,
                             double economyFare, double businessFare, String flightImage) {
        ensureFlightImageColumn();
        String sql = """
            INSERT INTO flights (airline_id, aircraft_id, flight_number, origin_airport_id,
                                 dest_airport_id, departure_time, arrival_time, status,
                                 base_economy_fare, base_business_fare, flight_image)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int originAirportId = getOrCreateAirport(conn, originCode, originCity, originCountry);
                int destAirportId = getOrCreateAirport(conn, destCode, destCity, destCountry);

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    bindFlight(ps, airlineId, aircraftId, flightNumber, originAirportId, destAirportId,
                            departureTime, arrivalTime, status, economyFare, businessFare, flightImage);
                    boolean success = ps.executeUpdate() > 0;
                    conn.commit();
                    return success;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] addFlight error: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean updateFlight(int flightId, int airlineId, int aircraftId, String flightNumber,
                                String originCode, String originCity, String originCountry,
                                String destCode, String destCity, String destCountry,
                                Timestamp departureTime, Timestamp arrivalTime, String status,
                                double economyFare, double businessFare, String flightImage) {
        ensureFlightImageColumn();
        String sql = """
            UPDATE flights
            SET airline_id = ?, aircraft_id = ?, flight_number = ?, origin_airport_id = ?,
                dest_airport_id = ?, departure_time = ?, arrival_time = ?, status = ?,
                base_economy_fare = ?, base_business_fare = ?,
                flight_image = COALESCE(?, flight_image)
            WHERE flight_id = ?
            """;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int originAirportId = getOrCreateAirport(conn, originCode, originCity, originCountry);
                int destAirportId = getOrCreateAirport(conn, destCode, destCity, destCountry);

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    bindFlight(ps, airlineId, aircraftId, flightNumber, originAirportId, destAirportId,
                            departureTime, arrivalTime, status, economyFare, businessFare, flightImage);
                    ps.setInt(12, flightId);
                    boolean success = ps.executeUpdate() > 0;
                    conn.commit();
                    return success;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] updateFlight error: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<Map<String, Object>> searchFlights(String from, String to, String departureDate) {
        ensureFlightImageColumn();
        String sql = """
            SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                   f.status, f.base_economy_fare, f.base_business_fare,
                   f.flight_image,
                   al.airline_name,
                   f.airline_id, f.aircraft_id,
                   oa.iata_code AS origin_code, oa.city AS origin_city, oa.country AS origin_country,
                   da.iata_code AS dest_code,   da.city AS dest_city, da.country AS dest_country,
                   ac.model AS aircraft_model
            FROM flights f
            JOIN airlines al ON al.airline_id      = f.airline_id
            JOIN airports oa ON oa.airport_id      = f.origin_airport_id
            JOIN airports da ON da.airport_id      = f.dest_airport_id
            JOIN aircraft ac ON ac.aircraft_id     = f.aircraft_id
            WHERE (oa.city LIKE ? OR oa.iata_code LIKE ?)
              AND (da.city LIKE ? OR da.iata_code LIKE ?)
              AND DATE(f.departure_time) = ?
            ORDER BY f.departure_time DESC
            """;

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String wildcardFrom = "%" + from + "%";
            String wildcardTo = "%" + to + "%";

            ps.setString(1, wildcardFrom);
            ps.setString(2, wildcardFrom);
            ps.setString(3, wildcardTo);
            ps.setString(4, wildcardTo);
            ps.setString(5, departureDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] searchFlights error: " + e.getMessage());
        }
        return list;
    }

    @Override
    public List<Map<String, Object>> searchFlightsByKeyword(String keyword) {
        ensureFlightImageColumn();
        // Leverages standard structural joins while running wildcards against city, airport code, and airline name
        String sql = """
            SELECT f.flight_id, f.flight_number, f.departure_time, f.arrival_time,
                   f.status, f.base_economy_fare, f.base_business_fare,
                   f.flight_image,
                   al.airline_name,
                   f.airline_id, f.aircraft_id,
                   oa.iata_code AS origin_code, oa.city AS origin_city, oa.country AS origin_country,
                   da.iata_code AS dest_code,   da.city AS dest_city, da.country AS dest_country,
                   ac.model AS aircraft_model
            FROM flights f
            JOIN airlines al ON al.airline_id      = f.airline_id
            JOIN airports oa ON oa.airport_id      = f.origin_airport_id
            JOIN airports da ON da.airport_id      = f.dest_airport_id
            JOIN aircraft ac ON ac.aircraft_id     = f.aircraft_id
            WHERE oa.city LIKE ? 
               OR oa.iata_code LIKE ?
               OR da.city LIKE ? 
               OR da.iata_code LIKE ?
               OR al.airline_name LIKE ?
            ORDER BY f.departure_time DESC
            """;

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String wildcard = "%" + keyword + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ps.setString(4, wildcard);
            ps.setString(5, wildcard);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rowToMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] searchFlightsByKeyword error: " + e.getMessage());
        }
        return list;
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

    private void ensureFlightImageColumn() {
        String withAfter = "ALTER TABLE flights ADD COLUMN flight_image VARCHAR(255) NULL AFTER base_first_fare";
        String withoutAfter = "ALTER TABLE flights ADD COLUMN flight_image VARCHAR(255) NULL";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(withAfter)) {
                ps.executeUpdate();
                return;
            } catch (SQLException firstError) {
                String firstMessage = firstError.getMessage() == null ? "" : firstError.getMessage().toLowerCase();
                if (firstMessage.contains("duplicate column")) {
                    return;
                }
                try (PreparedStatement ps = conn.prepareStatement(withoutAfter)) {
                    ps.executeUpdate();
                } catch (SQLException secondError) {
                    String secondMessage = secondError.getMessage() == null ? "" : secondError.getMessage().toLowerCase();
                    if (!secondMessage.contains("duplicate column")) {
                        System.err.println("[AdminDaoImpl] ensureFlightImageColumn error: " + secondError.getMessage());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[AdminDaoImpl] ensureFlightImageColumn connection error: " + e.getMessage());
        }
    }

    private int getOrCreateAirport(Connection conn, String code, String city, String country) throws SQLException {
        String normalizedCode = code.trim().toUpperCase();
        String selectSql = "SELECT airport_id FROM airports WHERE iata_code = ?";
        try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setString(1, normalizedCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("airport_id");
                }
            }
        }

        String insertSql = """
            INSERT INTO airports (iata_code, airport_name, city, country, timezone)
            VALUES (?, ?, ?, ?, 'UTC')
            """;
        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, normalizedCode);
            ps.setString(2, city.trim() + " Airport");
            ps.setString(3, city.trim());
            ps.setString(4, country.trim().isEmpty() ? "Unknown" : country.trim());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Unable to create airport for " + normalizedCode);
    }

    private void bindFlight(PreparedStatement ps, int airlineId, int aircraftId, String flightNumber,
                            int originAirportId, int destAirportId, Timestamp departureTime,
                            Timestamp arrivalTime, String status, double economyFare,
                            double businessFare, String flightImage) throws SQLException {
        ps.setInt(1, airlineId);
        ps.setInt(2, aircraftId);
        ps.setString(3, flightNumber.trim().toUpperCase());
        ps.setInt(4, originAirportId);
        ps.setInt(5, destAirportId);
        ps.setTimestamp(6, departureTime);
        ps.setTimestamp(7, arrivalTime);
        ps.setString(8, status);
        ps.setDouble(9, economyFare);
        ps.setDouble(10, businessFare);
        ps.setString(11, flightImage);
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
