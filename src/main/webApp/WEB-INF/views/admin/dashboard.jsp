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

    <!-- ══ SIDEBAR ══ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine" class="sidebar-logo-img"/>
            <span>SkyLine</span>
        </div>

        <nav class="sidebar-nav">
            <a href="#section-stats"   class="nav-item active">📊 Dashboard</a>
            <a href="#section-pending" class="nav-item">
                ⏳ Pending Approvals
                <c:if test="${pendingUsers > 0}">
                    <span class="badge">${pendingUsers}</span>
                </c:if>
            </a>
            <a href="#section-users"    class="nav-item">👥 All Users</a>
            <a href="#section-flights"  class="nav-item">✈️ Flights</a>
            <a href="#section-bookings" class="nav-item">🎫 Recent Bookings</a>
        </nav>

        <div class="sidebar-footer">
            <p class="admin-name">👤 <c:out value="${admin.fullName}"/></p>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn-logout">Log Out</a>
        </div>
    </aside>

    <!-- ══ MAIN CONTENT ══ -->
    <main class="admin-main">

        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1 class="page-title">Admin Dashboard</h1>
            <p class="page-sub">Welcome back, <c:out value="${admin.fullName}"/></p>
        </div>

        <!-- ── STATS CARDS ── -->
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

        <!-- ── PENDING APPROVALS ── -->
        <section id="section-pending" class="admin-section">
            <div class="section-header">
                <h2>⏳ Pending User Approvals</h2>
            </div>

            <c:choose>
                <c:when test="${empty pendingUserList}">
                    <div class="empty-state">
                        ✅ No pending approvals — all caught up!
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${pendingUserList}"
                                       varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${u.fullName}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><c:out value="${u.phone}"/></td>
                                    <td>
                                            <span class="role-badge ${u.role.toLowerCase()}">
                                                    ${u.role}
                                            </span>
                                    </td>
                                    <td class="action-btns">
                                        <form action="${pageContext.request.contextPath}/admin/users"
                                              method="post" style="display:inline">
                                            <input type="hidden" name="userId" value="${u.userId}"/>
                                            <input type="hidden" name="action" value="approve"/>
                                            <button type="submit" class="btn-approve">
                                                ✓ Approve
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/users"
                                              method="post" style="display:inline">
                                            <input type="hidden" name="userId" value="${u.userId}"/>
                                            <input type="hidden" name="action" value="reject"/>
                                            <button type="submit" class="btn-reject">
                                                ✗ Reject
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── ALL USERS ── -->
        <section id="section-users" class="admin-section">
            <div class="section-header">
                <h2>👥 All Users</h2>
                <span class="section-count">
                    Total: <strong>${totalUsers}</strong> users
                </span>
            </div>

            <c:choose>
                <c:when test="${empty userList}">
                    <div class="empty-state">No users found.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${userList}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${u.fullName}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><c:out value="${u.phone}"/></td>
                                    <td>
                                            <span class="role-badge ${u.role.toLowerCase()}">
                                                    ${u.role}
                                            </span>
                                    </td>
                                    <td>
                                            <span class="status-badge ${u.status.toLowerCase()}">
                                                    ${u.status}
                                            </span>
                                    </td>
                                    <td class="action-btns">
                                        <c:if test="${u.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="approve"/>
                                                <button type="submit" class="btn-approve">
                                                    ✓ Approve
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'APPROVED'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="reject"/>
                                                <button type="submit" class="btn-reject">
                                                    ✗ Reject
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'REJECTED'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="approve"/>
                                                <button type="submit" class="btn-approve">
                                                    ↺ Re-approve
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── FLIGHTS ── -->
        <section id="section-flights" class="admin-section">
            <div class="section-header">
                <h2>✈️ All Flights</h2>
                <span class="section-count">
                    Total: <strong>${totalFlights}</strong> flights
                </span>
            </div>

            <c:choose>
                <c:when test="${empty flightList}">
                    <div class="empty-state">
                        No flights found in the database.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Flight No.</th>
                                <th>Airline</th>
                                <th>Aircraft</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Economy (NPR)</th>
                                <th>Business (NPR)</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="f" items="${flightList}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><strong>${f.flight_number}</strong></td>
                                    <td>${f.airline_name}</td>
                                    <td>${f.aircraft_model}</td>
                                    <td>
                                        <strong>${f.origin_code}</strong>
                                        <br/>
                                        <small style="color:#888">
                                                ${f.origin_city}
                                        </small>
                                    </td>
                                    <td>
                                        <strong>${f.dest_code}</strong>
                                        <br/>
                                        <small style="color:#888">
                                                ${f.dest_city}
                                        </small>
                                    </td>
                                    <td>${f.departure_time}</td>
                                    <td>${f.arrival_time}</td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${f.base_economy_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${f.base_business_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                            <span class="status-badge ${f.status.toLowerCase()}">
                                                    ${f.status}
                                            </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── RECENT BOOKINGS ── -->
        <section id="section-bookings" class="admin-section">
            <div class="section-header">
                <h2>🎫 Recent Bookings</h2>
                <span class="section-count">
                    Total: <strong>${totalBookings}</strong> bookings
                </span>
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
                                    <td>${b['class']}</td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${b.total_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                            <span class="status-badge ${b.booking_status.toLowerCase()}">
                                                    ${b.booking_status}
                                            </span>
                                    </td>
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

<script>
    // Highlight active sidebar link on scroll
    const sections = document.querySelectorAll(
        '#section-stats, #section-pending, #section-users, #section-flights, #section-bookings'
    );
    const navItems = document.querySelectorAll('.nav-item');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(section => {
            if (window.scrollY >= section.offsetTop - 120) {
                current = section.id;
            }
        });
        navItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href') === '#' + current) {
                item.classList.add('active');
            }
        });
    });
</script>

</body>
</html>