package com.aeromanage.dao;

import java.util.List;
import java.util.Map;

public interface TravelInfoDao {
    List<Map<String, Object>> getPopularRoutes();
    List<Map<String, Object>> getPartnerAirlines();
}
