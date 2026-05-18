<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Seat Selection - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/seatselection.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="seat-page">
    <section class="seat-hero">
        <p class="seat-kicker">Booking Flow</p>
        <h1>Seat Selection</h1>
        <p>Select one available seat before continuing to payment confirmation.</p>
    </section>

    <c:if test="${not empty param.error}">
        <div class="seat-alert error"><c:out value="${param.error}"/></div>
    </c:if>

    <c:if test="${selected == 'success'}">
        <div class="seat-alert success">Selected seat saved successfully.</div>
    </c:if>

    <c:if test="${not empty seatError}">
        <div class="seat-alert error"><c:out value="${seatError}"/></div>
    </c:if>

    <c:if test="${not empty flight}">
        <section class="flight-summary">
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
                <span>Booking</span>
                <strong><c:out value="${empty flight.booking_ref ? 'Pending' : flight.booking_ref}"/></strong>
            </div>
        </section>
    </c:if>

    <section class="seat-workspace">
        <aside class="seat-panel">
            <h2>Seat Status</h2>
            <div class="seat-legend">
                <span><i class="legend available"></i> Available seats</span>
                <span><i class="legend booked"></i> Booked seats</span>
                <span><i class="legend selected"></i> Selected by passenger</span>
            </div>

            <div class="selected-seat-box">
                <span>Selected Seat</span>
                <strong>
                    <c:choose>
                        <c:when test="${not empty selectedSeat}">
                            <c:out value="${selectedSeat.seat_number}"/>
                        </c:when>
                        <c:otherwise>None</c:otherwise>
                    </c:choose>
                </strong>
            </div>
        </aside>

        <section class="aircraft-layout">
            <div class="aircraft-nose"></div>

            <c:choose>
                <c:when test="${empty seats}">
                    <div class="no-seats">No seats available for this flight.</div>
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/seat-selection" method="post" class="seat-form">
                        <input type="hidden" name="bookingId" value="<c:out value='${bookingId}'/>"/>
                        <input type="hidden" name="flightId" value="<c:out value='${flightId}'/>"/>
                        <input type="hidden" name="next" value="<c:out value='${next}'/>"/>

                        <div class="cabin-label">Front Cabin</div>
                        <div class="seat-map">
                            <c:forEach var="s" items="${seats}">
                                <c:set var="seatUnavailable" value="${s.is_booked == 1 or s.is_available == 0}"/>
                                <c:set var="seatSelected" value="${s.is_selected == 1}"/>
                                <c:choose>
                                    <c:when test="${seatUnavailable}">
                                        <c:set var="seatStateClass" value="booked"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="seatStateClass" value="available"/>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${seatSelected}">
                                    <c:set var="seatStateClass" value="${seatStateClass} selected"/>
                                </c:if>
                                <label class="seat-cell ${seatStateClass}">
                                    <c:choose>
                                        <c:when test="${seatUnavailable}">
                                            <input type="radio"
                                                   name="seatId"
                                                   value="${s.seat_id}"
                                                   disabled="disabled"/>
                                        </c:when>
                                        <c:when test="${seatSelected}">
                                            <input type="radio"
                                                   name="seatId"
                                                   value="${s.seat_id}"
                                                   checked="checked"
                                                   required="required"/>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="radio"
                                                   name="seatId"
                                                   value="${s.seat_id}"
                                                   required="required"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <span><c:out value="${s.seat_number}"/></span>
                                    <small><c:out value="${s['class']}"/></small>
                                </label>
                            </c:forEach>
                        </div>
                        <div class="aisle-text">Aisle</div>

                        <div class="seat-actions">
                            <a href="${pageContext.request.contextPath}/book-flight" class="seat-secondary">Back to Flights</a>
                            <c:choose>
                                <c:when test="${empty bookingId}">
                                    <button type="submit" class="seat-primary" disabled="disabled">
                                        Save Seat Selection
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="seat-primary">
                                        Save Seat Selection
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${empty bookingId}">
                            <p class="seat-note">Booking ID is required before this selected seat can be saved.</p>
                        </c:if>
                    </form>
                </c:otherwise>
            </c:choose>
        </section>
    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
