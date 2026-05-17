<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Search Results - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/book-flight.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="hero-banner" style="height: 180px; background: #8B0000; display: flex; align-items: center; justify-content: center;"></section>

<main class="booking-container" style="padding-top: 40px; min-height: 400px;">
    <h2 class="section-title">Available Flights Found</h2>

    <p style="text-align: center; color: #555; font-family: 'Chivo', sans-serif; margin-bottom: 30px;">
        Showing matches for:
        <strong><c:out value="${param.from}"/></strong> to
        <strong><c:out value="${param.to}"/></strong>
    </p>

    <div class="flight-grid" id="flightGrid">
        <c:choose>
            <c:when test="${empty flights}">
                <div class="no-flights" style="grid-column: 1/-1; text-align: center; padding: 60px; color: #666; font-family: 'Chivo', sans-serif;">
                    No direct flight matching your structural filters or parameters was found. Please modify your request.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="f" items="${flights}">
                    <article class="flight-card">
                        <div class="flight-card-img">
                            <c:choose>
                                <c:when test="${f.dest_city == 'Dubai'}"><img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Dubai"></c:when>
                                <c:when test="${f.dest_city == 'London'}"><img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="London"></c:when>
                                <c:when test="${f.dest_city == 'Kathmandu'}"><img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu"></c:when>
                                <c:when test="${f.dest_city == 'New Delhi'}"><img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="Delhi"></c:when>
                                <c:otherwise><img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Flight Path"></c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flight-card-body">
                            <h3 class="flight-card-title"><c:out value="${f.origin_city}"/> (<c:out value="${f.origin_code}"/>) to <c:out value="${f.dest_city}"/> (<c:out value="${f.dest_code}"/>)</h3>
                            <p class="flight-card-depart">Depart: <c:out value="${f.departure_time}"/></p>
                            <p class="flight-card-price">NPR <fmt:formatNumber value="${f.base_economy_fare}" pattern="#,##0.00"/></p>

                            <c:choose>
                                <c:when test="${not empty user}">
                                    <a class="book-btn" href="${pageContext.request.contextPath}/booking?flightId=${f.flight_id}">Book Now</a>
                                </c:when>
                                <c:otherwise>
                                    <a class="book-btn" href="${pageContext.request.contextPath}/login?redirect=booking&flightId=${f.flight_id}">Book Now</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>