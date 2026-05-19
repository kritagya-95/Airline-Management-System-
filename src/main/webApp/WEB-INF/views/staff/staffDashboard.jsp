<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Staff Dashboard — SkyLine</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/staff.css"/>
</head>
<body>

<div class="staff-layout">

    <!-- ══ SIDEBAR ══ -->
    <aside class="staff-sidebar">
        <div class="staff-sidebar-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine" class="staff-logo-img"/>
            <span>SkyLine Staff</span>
        </div>

        <nav class="staff-nav">
            <a href="${pageContext.request.contextPath}/staff/dashboard"
               class="staff-nav-item active"> Dashboard</a>
            <a href="#section-ticket"   class="staff-nav-item"> Ticket Verification</a>
            <a href="#section-flights"  class="staff-nav-item"> Today's Flights</a>
            <a href="#section-status"   class="staff-nav-item"> Update Status</a>
            <a href="#section-all-flights"   class="staff-nav-item"> All Flights</a>
            <a href="#section-history"  class="staff-nav-item"> Status History</a>
            <a href="#section-passengers" class="staff-nav-item"> All Passengers</a>
            <a href="#section-bookings" class="staff-nav-item"> Recent Bookings</a>
            <a href="#section-cancelled" class="staff-nav-item"> Cancellations</a>
        </nav>

        <div class="staff-sidebar-footer">
            <!-- Clickable Staff Profile -->
            <a href="${pageContext.request.contextPath}/staff/profile" class="staff-user-link">
                <span class="user-icon"></span>
                <span class="staff-name"><strong><c:out value="${staff.fullName}"/></strong></span>
            </a>

            <p class="staff-role">STAFF</p>

            <a href="${pageContext.request.contextPath}/logout"
               class="staff-btn-logout">Log Out</a>
        </div>
    </aside>

    <!-- ══ MAIN CONTENT ══ -->
    <main class="staff-main">

        <div class="staff-topbar">
            <h1 class="staff-page-title">Staff Dashboard</h1>
            <p class="staff-page-sub">
                Welcome, <c:out value="${staff.fullName}"/>
                &nbsp;•&nbsp; Today's Overview
            </p>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.flashSuccess}">
            <div class="flash-success">
                 <c:out value="${sessionScope.flashSuccess}"/>
            </div>
            <c:remove var="flashSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.flashError}">
            <div class="flash-error">
                <c:out value="${sessionScope.flashError}"/>
            </div>
            <c:remove var="flashError" scope="session"/>
        </c:if>

        <!-- ── STATS ── -->
        <div class="staff-stats-grid">
            <div class="staff-stat-card">
                <div class="staff-stat-icon"></div>
                <div class="staff-stat-info">
                    <p class="staff-stat-value">${totalTodayFlights}</p>
                    <p class="staff-stat-label">Flights Today</p>
                </div>
            </div>
            <div class="staff-stat-card">
                <div class="staff-stat-icon"></div>
                <div class="staff-stat-info">
                    <p class="staff-stat-value">${totalPassengersToday}</p>
                    <p class="staff-stat-label">Passengers Today</p>
                </div>
            </div>
            <div class="staff-stat-card">
                <div class="staff-stat-icon"></div>
                <div class="staff-stat-info">
                    <p class="staff-stat-value">${recentBookings.size()}</p>
                    <p class="staff-stat-label">Recent Bookings</p>
                </div>
            </div>
            <div class="staff-stat-card">
                <div class="staff-stat-icon"></div>
                <div class="staff-stat-info">
                    <p class="staff-stat-value">${cancelledBookings.size()}</p>
                    <p class="staff-stat-label">Cancellations</p>
                </div>
            </div>
        </div>

        <!-- ── TICKET VERIFICATION ── -->
        <section id="section-ticket" class="staff-section">
            <div class="staff-section-header">
                <h2> Ticket Verification</h2>
            </div>
            <div class="staff-section-body">
                <form action="${pageContext.request.contextPath}/staff/booking"
                      method="get" class="staff-search-form">
                    <input type="text" name="ref"
                           placeholder="Enter Booking Reference e.g. SKY-A1B2C3"
                           value="<c:out value='${searchRef}'/>"
                           class="staff-search-input" required/>
                    <button type="submit" class="staff-btn-search"> Search</button>
                </form>

                <c:if test="${not empty bookingError}">
                    <div class="flash-error" style="margin-top:16px">
                         <c:out value="${bookingError}"/>
                    </div>
                </c:if>

                <c:if test="${not empty booking}">
                    <div class="booking-result">
                        <div class="booking-result-header">
                            <span class="booking-ref-tag">
                                 <c:out value="${booking.booking_ref}"/>
                            </span>
                            <span class="status-badge ${booking.booking_status.toLowerCase()}">
                                <c:out value="${booking.booking_status}"/>
                            </span>
                        </div>
                        <div class="booking-result-grid">
                            <div class="booking-detail">
                                <p class="detail-label">Passenger</p>
                                <p class="detail-value"><c:out value="${booking.passenger_name}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Flight</p>
                                <p class="detail-value"><c:out value="${booking.flight_number}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Class</p>
                                <p class="detail-value"><c:out value="${booking['class']}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Passengers</p>
                                <p class="detail-value"><c:out value="${booking.num_passengers}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Departure</p>
                                <p class="detail-value"><c:out value="${booking.departure_time}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Arrival</p>
                                <p class="detail-value"><c:out value="${booking.arrival_time}"/></p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Total Fare</p>
                                <p class="detail-value" style="color:#8B0000;font-weight:700">
                                    NPR <c:out value="${booking.total_fare}"/>
                                </p>
                            </div>
                            <div class="booking-detail">
                                <p class="detail-label">Flight Status</p>
                                <p class="detail-value">
                                    <span class="status-badge ${booking.status.toLowerCase()}">
                                        <c:out value="${booking.status}"/>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>

        <!-- ── TODAY'S FLIGHTS ── -->
        <section id="section-flights" class="staff-section">
            <div class="staff-section-header">
                <h2> Today's Flights</h2>
                <span class="staff-section-count">
                    <strong>${totalTodayFlights}</strong> scheduled
                </span>
            </div>
            <c:choose>
                <c:when test="${empty todayFlights}">
                    <div class="staff-empty">No flights scheduled for today.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>Flight No.</th>
                                <th>Airline</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Booked</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="f" items="${todayFlights}">
                                <tr>
                                    <td><strong><c:out value="${f.flight_number}"/></strong></td>
                                    <td><c:out value="${f.airline_name}"/></td>
                                    <td>
                                        <strong><c:out value="${f.origin_code}"/></strong>
                                        <br/><small><c:out value="${f.origin_city}"/></small>
                                    </td>
                                    <td>
                                        <strong><c:out value="${f.dest_code}"/></strong>
                                        <br/><small><c:out value="${f.dest_city}"/></small>
                                    </td>
                                    <td><c:out value="${f.departure_time}"/></td>
                                    <td><c:out value="${f.arrival_time}"/></td>
                                    <td><c:out value="${f.booked_seats}"/></td>
                                    <td>
                                            <span class="status-badge ${f.status.toLowerCase()}">
                                                <c:out value="${f.status}"/>
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

        <!-- ── UPDATE FLIGHT STATUS ── -->
        <section id="section-status" class="staff-section">
            <div class="staff-section-header">
                <h2> Update Flight Status</h2>
            </div>
            <div class="staff-section-body">
                <c:choose>
                    <c:when test="${empty todayFlights}">
                        <div class="staff-empty">No flights available to update today.</div>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/staff/flights"
                              method="post" class="status-update-form">
                            <div class="status-form-grid">
                                <div class="form-field">
                                    <label>Select Flight</label>
                                    <select name="flightId" class="staff-select" required>
                                        <option value="">-- Choose a flight --</option>
                                        <c:forEach var="f" items="${todayFlights}">
                                            <option value="${f.flight_id}">
                                                    ${f.flight_number} —
                                                    ${f.origin_code} → ${f.dest_code}
                                                (${f.status})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label>New Status</label>
                                    <select name="newStatus" class="staff-select" required>
                                        <option value="">-- Select status --</option>
                                        <option value="SCHEDULED">SCHEDULED</option>
                                        <option value="BOARDING">BOARDING</option>
                                        <option value="DEPARTED">DEPARTED</option>
                                        <option value="ARRIVED">ARRIVED</option>
                                        <option value="DELAYED">DELAYED</option>
                                        <option value="CANCELLED">CANCELLED</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-field" style="margin-top:16px">
                                <label>Reason / Announcement</label>
                                <textarea name="reason" class="staff-textarea"
                                          placeholder="e.g. Delayed due to weather conditions..."
                                          rows="3"></textarea>
                            </div>
                            <button type="submit" class="staff-btn-update">
                                 Update Status
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- ── ALL FLIGHTS ── -->
        <section id="section-all-flights" class="staff-section">
            <div class="staff-section-header">
                <h2> All Flights</h2>
                <span class="staff-section-count">
                    <strong>${allFlights.size()}</strong> total flights
                </span>
            </div>
            <c:choose>
                <c:when test="${empty allFlights}">
                    <div class="staff-empty">No flights found.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Flight No.</th>
                                <th>Airline</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Economy (NPR)</th>
                                <th>Business (NPR)</th>
                                <th>Booked</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="f" items="${allFlights}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><strong><c:out value="${f.flight_number}"/></strong></td>
                                    <td><c:out value="${f.airline_name}"/></td>
                                    <td>
                                        <strong><c:out value="${f.origin_code}"/></strong>
                                        <br/><small><c:out value="${f.origin_city}"/></small>
                                    </td>
                                    <td>
                                        <strong><c:out value="${f.dest_code}"/></strong>
                                        <br/><small><c:out value="${f.dest_city}"/></small>
                                    </td>
                                    <td><c:out value="${f.departure_time}"/></td>
                                    <td><c:out value="${f.arrival_time}"/></td>
                                    <td>NPR <c:out value="${f.base_economy_fare}"/></td>
                                    <td>NPR <c:out value="${f.base_business_fare}"/></td>
                                    <td><c:out value="${f.booked_seats}"/></td>
                                    <td>
                                            <span class="status-badge ${f.status.toLowerCase()}">
                                                <c:out value="${f.status}"/>
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

        <!-- ── FLIGHT STATUS HISTORY ── -->
        <section id="section-history" class="staff-section">
            <div class="staff-section-header">
                <h2> Flight Status Change History</h2>
                <span class="staff-section-count">Last 50 changes</span>
            </div>
            <c:choose>
                <c:when test="${empty statusHistory}">
                    <div class="staff-empty">No status changes recorded yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Old Status</th>
                                <th>New Status</th>
                                <th>Changed By</th>
                                <th>Reason</th>
                                <th>Changed At</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="h" items="${statusHistory}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><strong><c:out value="${h.flight_number}"/></strong></td>
                                    <td>
                                        <c:out value="${h.origin_code}"/> →
                                        <c:out value="${h.dest_code}"/>
                                    </td>
                                    <td>
                                            <span class="status-badge ${h.old_status.toLowerCase()}">
                                                <c:out value="${h.old_status}"/>
                                            </span>
                                    </td>
                                    <td>
                                            <span class="status-badge ${h.new_status.toLowerCase()}">
                                                <c:out value="${h.new_status}"/>
                                            </span>
                                    </td>
                                    <td><c:out value="${h.changed_by_name}"/></td>
                                    <td><c:out value="${h.reason}"/></td>
                                    <td><c:out value="${h.changed_at}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── ALL PASSENGERS ── -->
        <section id="section-passengers" class="staff-section">
            <div class="staff-section-header">
                <h2> All Passengers</h2>
                <span class="staff-section-count">
                    <strong>${passengerList.size()}</strong> registered passengers
                </span>
            </div>
            <c:choose>
                <c:when test="${empty passengerList}">
                    <div class="staff-empty">No passengers registered yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Status</th>
                                <th>Total Bookings</th>
                                <th>Registered</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="p" items="${passengerList}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${p.full_name}"/></td>
                                    <td><c:out value="${p.email}"/></td>
                                    <td><c:out value="${p.phone}"/></td>
                                    <td>
                                            <span class="status-badge ${p.status.toLowerCase()}">
                                                <c:out value="${p.status}"/>
                                            </span>
                                    </td>
                                    <td><c:out value="${p.total_bookings}"/></td>
                                    <td><c:out value="${p.created_at}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── RECENT BOOKINGS ── -->
        <section id="section-bookings" class="staff-section">
            <div class="staff-section-header">
                <h2> Recent Bookings</h2>
                <span class="staff-section-count">Last 20 bookings</span>
            </div>
            <c:choose>
                <c:when test="${empty recentBookings}">
                    <div class="staff-empty">No bookings found.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Passenger</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Class</th>
                                <th>Pax</th>
                                <th>Fare (NPR)</th>
                                <th>Status</th>
                                <th>Booked On</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="b" items="${recentBookings}">
                                <tr>
                                    <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                    <td>
                                        <c:out value="${b.passenger_name}"/>
                                        <br/>
                                        <small><c:out value="${b.email}"/></small>
                                    </td>
                                    <td><c:out value="${b.flight_number}"/></td>
                                    <td>
                                        <c:out value="${b.from_code}"/> →
                                        <c:out value="${b.to_code}"/>
                                    </td>
                                    <td><c:out value="${b['class']}"/></td>
                                    <td><c:out value="${b.num_passengers}"/></td>
                                    <td>NPR <c:out value="${b.total_fare}"/></td>
                                    <td>
                                            <span class="status-badge ${b.booking_status.toLowerCase()}">
                                                <c:out value="${b.booking_status}"/>
                                            </span>
                                    </td>
                                    <td><c:out value="${b.created_at}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── CANCELLED BOOKINGS ── -->
        <section id="section-cancelled" class="staff-section">
            <div class="staff-section-header">
                <h2> Cancelled Bookings</h2>
                <span class="staff-section-count">
                    <strong>${cancelledBookings.size()}</strong> cancellations
                </span>
            </div>
            <c:choose>
                <c:when test="${empty cancelledBookings}">
                    <div class="staff-empty">No cancelled bookings found.</div>
                </c:when>
                <c:otherwise>
                    <div class="staff-table-wrap">
                        <table class="staff-table">
                            <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Passenger</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Class</th>
                                <th>Fare (NPR)</th>
                                <th>Cancellation Reason</th>
                                <th>Cancelled On</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="c" items="${cancelledBookings}">
                                <tr>
                                    <td><strong><c:out value="${c.booking_ref}"/></strong></td>
                                    <td>
                                        <c:out value="${c.passenger_name}"/>
                                        <br/>
                                        <small><c:out value="${c.email}"/></small>
                                    </td>
                                    <td><c:out value="${c.flight_number}"/></td>
                                    <td>
                                        <c:out value="${c.from_code}"/> →
                                        <c:out value="${c.to_code}"/>
                                    </td>
                                    <td><c:out value="${c['class']}"/></td>
                                    <td>NPR <c:out value="${c.total_fare}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty c.reason}">
                                                <c:out value="${c.reason}"/>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${c.requested_at}"/></td>
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
    const sections = document.querySelectorAll(
        '#section-ticket, #section-flights, #section-status, ' +
        '#section-all-flights, #section-history, ' +
        '#section-passengers, #section-bookings, #section-cancelled'
    );
    const navItems = document.querySelectorAll('.staff-nav-item');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(s => {
            if (window.scrollY >= s.offsetTop - 120) current = s.id;
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