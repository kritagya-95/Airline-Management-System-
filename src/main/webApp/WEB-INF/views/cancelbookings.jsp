<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Cancel Booking - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/cancelbookings.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="cancel-page">
    <section class="cancel-hero">
        <p class="cancel-kicker">Manage</p>
        <h1>Cancelled Bookings</h1>
        <p>Your cancelled flight details are listed below.</p>
    </section>

    <c:if test="${not empty sessionScope.bookingSuccess}">
        <div class="cancel-alert success" data-dismissible-alert>
            <span><c:out value="${sessionScope.bookingSuccess}"/></span>
            <button type="button" class="cancel-alert-close" aria-label="Close message">&times;</button>
        </div>
        <c:remove var="bookingSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.bookingError}">
        <div class="cancel-alert error" data-dismissible-alert>
            <span><c:out value="${sessionScope.bookingError}"/></span>
            <button type="button" class="cancel-alert-close" aria-label="Close message">&times;</button>
        </div>
        <c:remove var="bookingError" scope="session"/>
    </c:if>

    <section class="cancel-section">
        <c:choose>
            <c:when test="${empty cancelledBookings}">
                <div class="cancel-empty">
                    <h2>No cancelled bookings yet</h2>
                    <p>Cancelled flight records will appear here after a booking is cancelled.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cancel-table-wrap">
                    <table class="cancel-table">
                        <thead>
                        <tr>
                            <th>Reference</th>
                            <th>Flight</th>
                            <th>Route</th>
                            <th>Departure</th>
                            <th>Fare</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Requested At</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${cancelledBookings}">
                            <tr>
                                <td><strong><c:out value="${b.booking_ref}"/></strong></td>
                                <td><c:out value="${b.flight_number}"/></td>
                                <td><c:out value="${b.origin_code}"/> to <c:out value="${b.dest_code}"/></td>
                                <td><c:out value="${b.departure_time}"/></td>
                                <td>NPR <fmt:formatNumber value="${b.total_fare}" pattern="#,##0.00"/></td>
                                <td><c:out value="${empty b.reason ? 'Not provided' : b.reason}"/></td>
                                <td><span class="cancel-badge"><c:out value="${b.booking_status}"/></span></td>
                                <td><c:out value="${b.requested_at}"/></td>
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

<script>
    document.querySelectorAll('[data-dismissible-alert]').forEach(function (alert) {
        var closeButton = alert.querySelector('.cancel-alert-close');
        var hide = function () {
            alert.style.display = 'none';
        };

        if (closeButton) {
            closeButton.addEventListener('click', hide);
        }

        window.setTimeout(hide, 6000);
    });
</script>

</body>
</html>
