<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - SkyLine</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/staff.css"/>
</head>
<body>

<div class="staff-layout">
    <!-- Sidebar -->
    <aside class="staff-sidebar">
        <div style="padding: 25px; text-align: center; font-size: 24px; font-weight: bold; border-bottom: 1px solid rgba(255,255,255,0.2);">
            🛫 SkyLine Staff
        </div>

        <nav style="padding: 20px;">
            <a href="${pageContext.request.contextPath}/staff/dashboard" class="nav-item active">📊 Dashboard</a>
            <a href="#" class="nav-item">🎫 Ticket Verification</a>
            <a href="#" class="nav-item">✈️ Flights</a>
            <a href="#" class="nav-item">📢 Announcements</a>
        </nav>

        <div style="position:absolute; bottom:40px; left:20px; right:20px;">
            <p style="margin:0 0 15px 0;">👋 <strong>${staff.fullName}</strong></p>
            <a href="${pageContext.request.contextPath}/logout"
               style="background:#dc2626; color:white; padding:12px; border-radius:8px; text-align:center; display:block; text-decoration:none;">
                Logout
            </a>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="staff-main">
        <h1>Welcome, ${staff.fullName}!</h1>
        <p>Staff Dashboard • Today's Overview</p>

        <!-- Stats -->
        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(250px,1fr)); gap:20px; margin:30px 0;">
            <div class="staff-card">
                <h2>${totalTodayFlights}</h2>
                <p>Flights Today</p>
            </div>
            <div class="staff-card">
                <h2>${totalPassengersToday}</h2>
                <p>Passengers Today</p>
            </div>
        </div>

        <!-- Today's Flights -->
        <div class="staff-card">
            <h2>Today's Flights</h2>
            <table class="admin-table staff-table" style="width:100%">
                <thead>
                <tr>
                    <th>Flight No</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Booked</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="f" items="${todayFlights}">
                    <tr>
                        <td><strong>${f.flight_number}</strong></td>
                        <td>${f.origin_code} → ${f.dest_code}</td>
                        <td>${f.departure_time}</td>
                        <td>${f.arrival_time}</td>
                        <td>${f.booked_seats}</td>
                        <td><span class="status-badge">${f.status}</span></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</div>

</body>
</html>