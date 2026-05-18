<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Book Now - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/booknow.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="booknow-page">
    <section class="booknow-hero">
        <p class="booknow-kicker">Book Now</p>
        <h1>Complete Your Flight Booking</h1>
        <p>Flight selection, passenger details, seat selection, confirmation, payment, and ticket success.</p>
    </section>

    <section class="flow-steps">
        <span class="${step == 'passenger' ? 'active' : ''}">Flight Selection</span>
        <span class="${step == 'passenger' ? 'active' : ''}">Passenger Details</span>
        <span>Seat Selection</span>
        <span class="${step == 'confirmation' ? 'active' : ''}">Booking Confirmation</span>
        <span class="${step == 'payment' ? 'active' : ''}">Payment Page</span>
        <span class="${step == 'success' ? 'active' : ''}">Success</span>
    </section>

    <c:if test="${not empty param.error}">
        <div class="booknow-alert error">
            <c:choose>
                <c:when test="${param.error == 'missing'}">Please fill all required passenger details.</c:when>
                <c:when test="${param.error == 'save'}">Booking could not be created. Please try again.</c:when>
                <c:when test="${param.error == 'payment'}">Payment could not be completed. Please try again.</c:when>
                <c:otherwise>Something went wrong. Please try again.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty flight}">
        <section class="flight-card-summary">
            <div>
                <span>Flight</span>
                <strong><c:out value="${flight.flight_number}"/></strong>
            </div>
            <div>
                <span>Airline</span>
                <strong><c:out value="${flight.airline_name}"/></strong>
            </div>
            <div>
                <span>Route</span>
                <strong><c:out value="${flight.origin_code}"/> to <c:out value="${flight.dest_code}"/></strong>
            </div>
            <div>
                <span>Departure</span>
                <strong><c:out value="${flight.departure_time}"/></strong>
            </div>
            <div>
                <span>Status</span>
                <strong><c:out value="${flight.status}"/></strong>
            </div>
        </section>
    </c:if>

    <c:choose>
        <c:when test="${step == 'passenger'}">
            <section class="booknow-panel">
                <h2>Passenger Details</h2>
                <form action="${pageContext.request.contextPath}/booking" method="post" class="booknow-form">
                    <input type="hidden" name="action" value="create"/>
                    <input type="hidden" name="flightId" value="<c:out value='${flight.flight_id}'/>"/>

                    <div class="form-grid">
                        <label>
                            Full Name
                            <input type="text" name="fullName" value="<c:out value='${user.fullName}'/>" required/>
                        </label>
                        <label>
                            Passport Number
                            <input type="text" name="passportNo" placeholder="Optional"/>
                        </label>
                        <label>
                            Date of Birth
                            <input type="date" name="dob"/>
                        </label>
                        <label>
                            Nationality
                            <input type="text" name="nationality" placeholder="Nepali"/>
                        </label>
                        <label>
                            Class
                            <select name="ticketClass" required>
                                <option value="ECONOMY">Economy - NPR <fmt:formatNumber value="${flight.base_economy_fare}" pattern="#,##0.00"/></option>
                                <option value="BUSINESS">Business - NPR <fmt:formatNumber value="${flight.base_business_fare}" pattern="#,##0.00"/></option>
                                <option value="FIRST">First - NPR <fmt:formatNumber value="${flight.base_first_fare}" pattern="#,##0.00"/></option>
                            </select>
                        </label>
                    </div>

                    <div class="booknow-actions">
                        <a href="${pageContext.request.contextPath}/book-flight" class="secondary-btn">Back to Flights</a>
                        <button type="submit" class="primary-btn">Continue to Seat Selection</button>
                    </div>
                </form>
            </section>
        </c:when>

        <c:when test="${step == 'confirmation'}">
            <section class="booknow-panel">
                <h2>Booking Confirmation</h2>
                <div class="confirm-grid">
                    <div><span>Booking Reference</span><strong><c:out value="${booking.booking_ref}"/></strong></div>
                    <div><span>Passenger</span><strong><c:out value="${booking.passenger_name}"/></strong></div>
                    <div><span>Class</span><strong><c:out value="${booking['class']}"/></strong></div>
                    <div><span>Seats</span><strong>
                        <c:forEach var="seat" items="${selectedSeats}" varStatus="status">
                            <c:if test="${not status.first}">, </c:if>
                            <c:out value="${seat.seat_number}"/>
                        </c:forEach>
                    </strong></div>
                    <div><span>Total Fare</span><strong>NPR <fmt:formatNumber value="${booking.total_fare}" pattern="#,##0.00"/></strong></div>
                    <div><span>Status</span><strong><c:out value="${booking.booking_status}"/></strong></div>
                </div>

                <form action="${pageContext.request.contextPath}/booking" method="post" class="booknow-actions">
                    <input type="hidden" name="action" value="confirm"/>
                    <input type="hidden" name="bookingId" value="<c:out value='${booking.booking_id}'/>"/>
                    <a href="${pageContext.request.contextPath}/seat-selection?bookingId=${booking.booking_id}&flightId=${booking.flight_id}&next=/booking?step=confirmation%26bookingId=${booking.booking_id}" class="secondary-btn">
                        Change Seat
                    </a>
                    <button type="submit" class="primary-btn">Confirm Booking</button>
                </form>
            </section>
        </c:when>

        <c:when test="${step == 'payment'}">
            <section class="booknow-panel">
                <h2>Payment Page</h2>
                <p class="panel-copy">Choose your payment method to complete this booking.</p>
                <form action="${pageContext.request.contextPath}/booking" method="post" class="payment-grid">
                    <input type="hidden" name="action" value="pay"/>
                    <input type="hidden" name="bookingId" value="<c:out value='${booking.booking_id}'/>"/>

                    <button type="submit" name="paymentMethod" value="ESEWA" class="payment-option esewa">
                        <span>eSewa</span>
                        <strong>NPR <fmt:formatNumber value="${booking.total_fare}" pattern="#,##0.00"/></strong>
                    </button>

                    <button type="submit" name="paymentMethod" value="KHALTI" class="payment-option khalti">
                        <span>Khalti</span>
                        <strong>NPR <fmt:formatNumber value="${booking.total_fare}" pattern="#,##0.00"/></strong>
                    </button>
                </form>
            </section>
        </c:when>

        <c:when test="${step == 'success'}">
            <section class="booknow-panel success-panel">
                <h2>Booking Successful</h2>
                <p>Your payment is complete and your ticket has been generated.</p>

                <div class="confirm-grid">
                    <div><span>Booking Reference</span><strong><c:out value="${booking.booking_ref}"/></strong></div>
                    <div><span>Ticket Number</span><strong><c:out value="${ticket.ticket_number}"/></strong></div>
                    <div><span>Payment Status</span><strong><c:out value="${payment.status}"/></strong></div>
                    <div><span>Method</span><strong><c:out value="${payment.method}"/></strong></div>
                    <div><span>Seats</span><strong>
                        <c:forEach var="seat" items="${selectedSeats}" varStatus="status">
                            <c:if test="${not status.first}">, </c:if>
                            <c:out value="${seat.seat_number}"/>
                        </c:forEach>
                    </strong></div>
                    <div><span>Booking Status</span><strong><c:out value="${booking.booking_status}"/></strong></div>
                </div>

                <div class="booknow-actions">
                    <a href="${pageContext.request.contextPath}/my-bookings" class="primary-link">View My Bookings</a>
                    <a href="${pageContext.request.contextPath}/flight-schedule" class="secondary-btn">My Flight Schedule</a>
                </div>
            </section>
        </c:when>
    </c:choose>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
