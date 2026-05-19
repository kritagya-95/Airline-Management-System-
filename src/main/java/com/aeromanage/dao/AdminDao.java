package com.aeromanage.dao;

import com.aeromanage.entity.User;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

/**
 * AdminDao — defines all data access operations for the admin dashboard and flight routing.
 */
public interface AdminDao {

    // ── Stats ──────────────────────────────────────────────
    int countUsers();
    int countFlights();
    int countBookings();
    int countPendingUsers();

    // ── Users ──────────────────────────────────────────────
    List<User> getPendingUsers();
    List<User> getAllUsers();
    boolean updateUserStatus(int userId, String status);

    // ── Flights ────────────────────────────────────────────
    List<Map<String, Object>> getAllFlights();
    List<Map<String, Object>> getAllAirlines();
    List<Map<String, Object>> getAllAircraft();
    boolean addFlight(int airlineId, int aircraftId, String flightNumber,
                      String originCode, String originCity, String originCountry,
                      String destCode, String destCity, String destCountry,
                      Timestamp departureTime, Timestamp arrivalTime, String status,
                      double economyFare, double businessFare, String flightImage);
    boolean updateFlight(int flightId, int airlineId, int aircraftId, String flightNumber,
                         String originCode, String originCity, String originCountry,
                         String destCode, String destCity, String destCountry,
                         Timestamp departureTime, Timestamp arrivalTime, String status,
                         double economyFare, double businessFare, String flightImage);

    /**
     * Searches and filters live flight paths based on passenger criteria.
     * @param from The origin city name or airport code filter parameter
     * @param to The destination city name or airport code filter parameter
     * @param departureDate The target travel date formatted as YYYY-MM-DD
     * @return A list of database rows containing matching flight details
     */
    List<Map<String, Object>> searchFlights(String from, String to, String departureDate);

    /**
     * Searches across live flight paths using a broad keyword string against
     * origin cities, destination cities, airport codes, or partner airline names.
     * @param keyword The user-submitted string from the global header search input
     * @return A list of database rows containing matching flight details
     */
    List<Map<String, Object>> searchFlightsByKeyword(String keyword);

    //List<Map<String, Object>> getPopularFlights(int limit);

    // ── Bookings ───────────────────────────────────────────
    List<Map<String, Object>> getRecentBookings(int limit);

    List<Map<String, Object>> getLimitedFlights(int i);
}
