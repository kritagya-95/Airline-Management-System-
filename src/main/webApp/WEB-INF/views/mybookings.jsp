<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Bookings - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/mybookings.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="booking-page">
    <section class="booking-hero">
        <p class="booking-kicker">Manage</p>
        <h1>My Bookings</h1>
        <p>View your current, recent, and past flight bookings from SkyLine Airlines.</p>
    </section>

    <c:if test="${not empty sessionScope.bookingSuccess}">
        <div class="booking-alert success"><c:out value="${sessionScope.bookingSuccess}"/></div>
        <c:remove var="bookingSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.bookingError}">
        <div class="booking-alert error"><c:out value="${sessionScope.bookingError}"/></div>
        <c:remove var="bookingError" scope="session"/>
    </c:if>

    <c:if test="${empty currentBookings and empty recentBookings and empty pastBookings}">
        <section class="booking-empty">
            <h2>No booked flights yet</h2>
            <p>Your booking history will appear here once a flight is booked.</p>
        </section>
    </c:if>

    <section class="booking-section">
        <div class="booking-section-head">
            <h2>Current Bookings</h2>
            <span>${currentBookings.size()} active</span>
        </div>
        <c:choose>
            <c:when test="${empty currentBookings}">
                <p class="booking-muted">No current bookings found.</p>
            </c:when>
            <c:otherwise>
                <div class="booking-table-wrap">
                    <table class="booking-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Passenger</th>
                            <th>Flight</th>
                            <th>Route</th>
                            <th>Departure</th>
                            <th>Class</th>
                            <th>Status</th>
                            <th>Fare</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${currentBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${empty b.passenger_name ? 'Passenger' : b.passenger_name}"/></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_code}"/> to <c:out value="${b.dest_code}"/></td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td><c:out value="${b['class']}"/></td>
                                <td><span class="booking-badge"><c:out value="${b.booking_status}"/></span></td>
                                <td>NPR <fmt:formatNumber value="${b.total_fare}" pattern="#,##0.00"/></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/my-bookings"
                                          method="post"
                                          class="cancel-form"
                                          onsubmit="return confirm('Do you want to cancel your booking for flight ${b.flight_number} (${b.origin_code} to ${b.dest_code})?');">
                                        <input type="hidden" name="bookingId" value="${b.booking_id}"/>
                                        <input type="hidden" name="reason" value="Cancelled by passenger"/>
                                        <button type="submit" class="cancel-btn">Cancel</button>
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

    <section class="booking-section">
        <div class="booking-section-head">
            <h2>Recent Bookings</h2>
            <span>Latest ${recentBookings.size()}</span>
        </div>
        <c:choose>
            <c:when test="${empty recentBookings}">
                <p class="booking-muted">No recent bookings found.</p>
            </c:when>
            <c:otherwise>
                <div class="booking-card-grid">
                    <c:forEach var="b" items="${recentBookings}">
                        <article class="booking-card">
                            <h3><c:out value="${b.booking_ref}"/></h3>
                            <p><c:out value="${b.airline_name}"/> - <c:out value="${b.flight_number}"/></p>
                            <p><c:out value="${b.origin_city}"/> to <c:out value="${b.dest_city}"/></p>
                            <span><c:out value="${b.booking_status}"/></span>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <section class="booking-section">
        <div class="booking-section-head">
            <h2>Past Bookings</h2>
            <span>${pastBookings.size()} completed</span>
        </div>
        <c:choose>
            <c:when test="${empty pastBookings}">
                <p class="booking-muted">No past bookings found.</p>
            </c:when>
            <c:otherwise>
                <div class="booking-table-wrap">
                    <table class="booking-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Flight</th>
                            <th>Route</th>
                            <th>Departure</th>
                            <th>Arrival</th>
                            <th>Status</th>
                            <th>Fare</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${pastBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_code}"/> to <c:out value="${b.dest_code}"/></td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td><c:out value="${b.arrival_time}"/></td>
                                <td><span class="booking-badge muted"><c:out value="${b.booking_status}"/></span></td>
                                <td>NPR <fmt:formatNumber value="${b.total_fare}" pattern="#,##0.00"/></td>
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
