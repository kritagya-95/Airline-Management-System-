<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Book Flights - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/book-flight.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="hero-banner"></section>

<div class="search-container">
    <div class="search-box">
        <h1 class="search-title">Search and Book for Our FLIGHTS online</h1>
        <form class="search-form" action="${pageContext.request.contextPath}/search-flights" method="get">
            <div class="search-field">
                <label>From</label>
                <div class="search-input-wrap">
                    <input type="text" name="from" placeholder="Select Origin" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>To</label>
                <div class="search-input-wrap">
                    <input type="text" name="to" placeholder="Select Destination" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>Departure</label>
                <div class="search-input-wrap">
                    <input type="date" name="departure" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>Return</label>
                <div class="search-input-wrap">
                    <input type="date" name="returnDate" class="search-input"/>
                </div>
            </div>
            <div class="search-field search-btn-wrap">
                <button type="submit" class="search-btn">SEARCH</button>
            </div>
        </form>
    </div>
</div>

<main class="booking-container" id="popular-deals">
    <h2 class="section-title">Popular Flight Deals on SkyLine Airlines</h2>

    <div class="flight-filter">
        <div class="filter-field">
            <label>From</label>
            <div class="filter-input-wrap">
                <input type="text" id="filterFrom" placeholder="Input Origin" class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
        <div class="filter-field">
            <label>To</label>
            <div class="filter-input-wrap">
                <input type="text" id="filterTo" placeholder="Input Destination" class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
    </div>

    <div class="flight-grid" id="flightGrid">
        <c:choose>
            <c:when test="${empty flights}">
                <div class="no-flights">No flights available at the moment.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="f" items="${flights}">
                    <article class="flight-card" data-from="<c:out value='${f.origin_city} ${f.origin_code}'/>" data-to="<c:out value='${f.dest_city} ${f.dest_code}'/>">
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
                            <h3 class="flight-card-title"><c:out value="${f.origin_city}"/> to <c:out value="${f.dest_city}"/></h3>
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

<script>
    function filterCards() {
        const fromValue = document.getElementById("filterFrom").value.toLowerCase().trim();
        const toValue = document.getElementById("filterTo").value.toLowerCase().trim();

        document.querySelectorAll(".flight-card").forEach(card => {
            const cardFrom = card.getAttribute("data-from") ? card.getAttribute("data-from").toLowerCase() : "";
            const cardTo = card.getAttribute("data-to") ? card.getAttribute("data-to").toLowerCase() : "";

            const matchFrom = fromValue === "" || cardFrom.includes(fromValue);
            const matchTo = toValue === "" || cardTo.includes(toValue);

            card.style.display = (matchFrom && matchTo) ? "" : "none";
        });
    }
</script>
</body>
</html>