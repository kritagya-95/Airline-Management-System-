package com.aeromanage.dao;

import java.util.List;
import java.util.Map;

public interface FlightScheduleDao {
    /**
     * Searches for public flight schedules based on optional origin and destination criteria.
     * Maps perfectly to fields within the database view v_flight_search.
     */
    List<Map<String, Object>> searchPublicSchedules(String origin, String dest);
}