package com.aeromanage.entity;

import java.util.Date;

public class Flight {
    private int flightId;
    private String originCity;
    private String originCode;
    private String destCity;
    private String destCode;
    private Date departureTime;
    private double baseEconomyFare;

    // Getters and Setters
    public int getFlightId() { return flightId; }
    public void setFlightId(int flightId) { this.flightId = flightId; }

    public String getOriginCity() { return originCity; }
    public void setOriginCity(String originCity) { this.originCity = originCity; }

    public String getOriginCode() { return originCode; }
    public void setOriginCode(String originCode) { this.originCode = originCode; }

    public String getDestCity() { return destCity; }
    public void setDestCity(String destCity) { this.destCity = destCity; }

    public String getDestCode() { return destCode; }
    public void setDestCode(String destCode) { this.destCode = destCode; }

    public Date getDepartureTime() { return departureTime; }
    public void setDepartureTime(Date departureTime) { this.departureTime = departureTime; }

    public double getBaseEconomyFare() { return baseEconomyFare; }
    public void setBaseEconomyFare(double baseEconomyFare) { this.baseEconomyFare = baseEconomyFare; }
}