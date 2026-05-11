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

    // ── Bookings ───────────────────────────────────────────
    List<Map<String, Object>> getRecentBookings(int limit);
}