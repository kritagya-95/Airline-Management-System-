<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Flight Schedule - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/flightschedule.css"/>
</head>
<body>

<header class="header">
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/" class="logo-link"><span class="logo-text"><h1>SkyLine</h1></span></a>
    </div>
    <div class="nav-dropdown">
        <a href="#" class="nav-link"><h2>Book</h2> <span class="arrow">&#9662;</span></a>
        <div class="dropdown-menu">
            <a href="${pageContext.request.contextPath}/search-flights">Search Flights</a>
            <a href="${pageContext.request.contextPath}/book-flight">Book a Flight</a>
            <a href="${pageContext.request.contextPath}/booking/manage">Manage Booking</a>
        </div>
    </div>
    <div class="nav-dropdown">
        <a href="#" class="nav-link"><h2>Manage</h2> <span class="arrow">&#9662;</span></a>
        <div class="dropdown-menu">
            <a href="${pageContext.request.contextPath}/my-bookings">My Bookings</a>
            <a href="${pageContext.request.contextPath}/cancel-booking">Cancel Booking</a>
            <a href="${pageContext.request.contextPath}/flight-schedule">Flight Schedule</a>
        </div>
    </div>
    <div class="nav-dropdown">
        <a href="#" class="nav-link"><h2>Experience</h2> <span class="arrow">&#9662;</span></a>
        <div class="dropdown-menu">
            <a href="${pageContext.request.contextPath}/popular-routes">Popular Routes</a>
            <a href="${pageContext.request.contextPath}/partner-airlines">Partner Airlines</a>
            <a href="${pageContext.request.contextPath}/travel-guide">Travel Guide</a>
        </div>
    </div>
    <div class="header-right">
        <div class="header-search"><span class="search-icon"></span><input type="text" placeholder="Search" class="header-search-input"/></div>
        <div class="header-auth">
            <a href="${pageContext.request.contextPath}/profile" class="welcome-text-link"><c:out value="${user.fullName}"/></a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-header-login">Log Out</a>
        </div>
    </div>
</header>

<main class="schedule-page">
    <section class="schedule-hero">
        <p class="schedule-kicker">Manage</p>
        <h1>Flight Schedule</h1>
        <p>Timetable for your current, recent, and past bookings.</p>
    </section>

    <c:if test="${empty currentBookings and empty recentBookings and empty pastBookings}">
        <section class="schedule-empty">
            <h2>No booked flights yet</h2>
            <p>Your flight timetable will appear here once bookings are available.</p>
        </section>
    </c:if>

    <section class="schedule-section">
        <h2>Current Booking Schedule</h2>
        <c:choose>
            <c:when test="${empty currentBookings}">
                <p class="schedule-muted">No booking schedule found.</p>
            </c:when>
            <c:otherwise>
                <div class="schedule-table-wrap">
                    <table class="schedule-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Airline</th>
                            <th>Flight</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${currentBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${b.airline_name}"/></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_city}"/> (<c:out value="${b.origin_code}"/>)</td>
                                <td><c:out value="${b.dest_city}"/> (<c:out value="${b.dest_code}"/>)</td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td><c:out value="${b.arrival_time}"/></td>
                                <td><span class="schedule-badge"><c:out value="${b.flight_status}"/></span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="schedule-section">
        <h2>Recent Booking Schedule</h2>
        <c:choose>
            <c:when test="${empty recentBookings}">
                <p class="schedule-muted">No booking schedule found.</p>
            </c:when>
            <c:otherwise>
                <div class="schedule-table-wrap">
                    <table class="schedule-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Airline</th>
                            <th>Flight</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${recentBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${b.airline_name}"/></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_city}"/> (<c:out value="${b.origin_code}"/>)</td>
                                <td><c:out value="${b.dest_city}"/> (<c:out value="${b.dest_code}"/>)</td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td><c:out value="${b.arrival_time}"/></td>
                                <td><span class="schedule-badge"><c:out value="${b.flight_status}"/></span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="schedule-section">
        <h2>Past Booking Schedule</h2>
        <c:choose>
            <c:when test="${empty pastBookings}">
                <p class="schedule-muted">No booking schedule found.</p>
            </c:when>
            <c:otherwise>
                <div class="schedule-table-wrap">
                    <table class="schedule-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Airline</th>
                            <th>Flight</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${pastBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${b.airline_name}"/></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_city}"/> (<c:out value="${b.origin_code}"/>)</td>
                                <td><c:out value="${b.dest_city}"/> (<c:out value="${b.dest_code}"/>)</td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td><c:out value="${b.arrival_time}"/></td>
                                <td><span class="schedule-badge"><c:out value="${b.flight_status}"/></span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<footer class="prof-footer">
    <div class="prof-footer-inner">
        <div class="prof-footer-logo"><span class="prof-footer-logo-text">SkyLine</span></div>
        <p class="prof-footer-copy">&copy; 2026 SkyLine Airlines. All rights reserved.</p>
        <div class="prof-footer-social">
            <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/facebook.png" alt="Facebook" width="20"/></a>
            <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/twitter.png" alt="Twitter" width="20"/></a>
            <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/instagram.png" alt="Instagram" width="20"/></a>
        </div>
    </div>
</footer>

<script>
    document.querySelectorAll(".nav-dropdown").forEach(dd => {
        dd.addEventListener("click", function(e) {
            e.stopPropagation();
            this.classList.toggle("open");
        });
    });
    document.addEventListener("click", () => {
        document.querySelectorAll(".nav-dropdown").forEach(d => d.classList.remove("open"));
    });
</script>

</body>
</html>
