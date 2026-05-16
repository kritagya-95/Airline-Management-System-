package com.aeromanage.dao;

import com.aeromanage.entity.User;
import java.util.List;
import java.util.Map;

/**
 * AdminDao — defines all data access operations for the admin dashboard.
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

    /**
     * Searches and filters live flight paths based on passenger criteria.
     * @param from The origin city name or airport code filter parameter
     * @param to The destination city name or airport code filter parameter
     * @param departureDate The target travel date formatted as YYYY-MM-DD
     * @return A list of database rows containing matching flight details
     */
    List<Map<String, Object>> searchFlights(String from, String to, String departureDate);

    //List<Map<String, Object>> getPopularFlights(int limit);

    // ── Bookings ───────────────────────────────────────────
    List<Map<String, Object>> getRecentBookings(int limit);
}