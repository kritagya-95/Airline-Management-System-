<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Flight Schedule - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/flightschedule.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

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

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>