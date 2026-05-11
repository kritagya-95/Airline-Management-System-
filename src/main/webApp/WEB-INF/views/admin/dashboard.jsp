<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SkyLine — Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css"/>
</head>
<body>

<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="SkyLine" class="sidebar-logo-img"/>
            <span>SkyLine</span>
        </div>

        <nav class="sidebar-nav">
            <a href="#section-stats" class="nav-item active">📊 Dashboard</a>
            <a href="#section-pending" class="nav-item">⏳ Pending Approvals
                <c:if test="${pendingUsers > 0}">
                    <span class="badge">${pendingUsers}</span>
                </c:if>
            </a>
            <a href="#section-users" class="nav-item">👥 All Users</a>
            <a href="#section-flights" class="nav-item">✈️ Flights</a>
            <a href="#section-bookings" class="nav-item">🎫 Recent Bookings</a>
        </nav>

        <div class="sidebar-footer">
            <p class="admin-name">👤 <c:out value="${admin.fullName}"/></p>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Log Out</a>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="admin-main">

        <div class="admin-topbar">
            <h1 class="page-title">Admin Dashboard</h1>
            <p class="page-sub">Welcome back, <c:out value="${admin.fullName}"/></p>
        </div>

        <!-- Stats Cards -->
        <section id="section-stats" class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-info">
                    <p class="stat-value">${totalUsers}</p>
                    <p class="stat-label">Total Users</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✈️</div>
                <div class="stat-info">
                    <p class="stat-value">${totalFlights}</p>
                    <p class="stat-label">Total Flights</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">🎫</div>
                <div class="stat-info">
                    <p class="stat-value">${totalBookings}</p>
                    <p class="stat-label">Total Bookings</p>
                </div>
            </div>
            <div class="stat-card highlight">
                <div class="stat-icon">⏳</div>
                <div class="stat-info">
                    <p class="stat-value">${pendingUsers}</p>
                    <p class="stat-label">Pending Approvals</p>
                </div>
            </div>
        </section>

        <!-- Pending Approvals -->
        <section id="section-pending" class="admin-section">
            <div class="section-header">
                <h2>⏳ Pending User Approvals</h2>
            </div>
            <!-- ... (your existing pending users table is fine) ... -->
            <!-- Keep your existing pending users table here -->
        </section>

        <!-- Recent Bookings - FIXED -->
        <section id="section-bookings" class="admin-section">
            <div class="section-header">
                <h2>🎫 Recent Bookings</h2>
            </div>

            <c:choose>
                <c:when test="${empty recentBookings}">
                    <div class="empty-state">No bookings yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Passenger</th>
                                <th>Email</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Class</th>
                                <th>Total (NPR)</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="b" items="${recentBookings}">
                                <tr>
                                    <td><strong>${b.booking_ref}</strong></td>
                                    <td><c:out value="${b.passenger_name}"/></td>
                                    <td><c:out value="${b.email}"/></td>
                                    <td>${b.flight_number}</td>
                                    <td>${b.from_code} → ${b.to_code}</td>
                                    <td>${b['class']}</td>           <!-- FIXED HERE -->
                                    <td>NPR ${b.total_fare}</td>
                                    <td><span class="status-badge ${b.booking_status.toLowerCase()}">${b.booking_status}</span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>
</div>

</body>
</html>