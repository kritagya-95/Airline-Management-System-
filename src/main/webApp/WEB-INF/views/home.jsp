<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Planning Your Family Trip</h1>
        <h1>Fly Better, Fly With US</h1>
    </div>
</section>

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
                <button type="submit" class="search-btn">Search</button>
            </div>
        </form>
    </div>
</div>

<section class="popular-section">
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
                                <c:when test="${not empty f.flight_image}"><img src="${pageContext.request.contextPath}/uploads/${f.flight_image}" alt="Flight Path"></c:when>
                                <c:when test="${f.dest_city == 'Dubai'}"><img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Dubai"></c:when>
                                <c:when test="${f.dest_city == 'London'}"><img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="London"></c:when>
                                <c:when test="${f.dest_city == 'Kathmandu'}"><img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu"></c:when>
                                <c:when test="${f.dest_city == 'New Delhi'}"><img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="Delhi"></c:when>
                                <c:when test="${f.dest_city == 'Doha'}"><img src="${pageContext.request.contextPath}/static/images/Doha.jpg" alt="Doha"></c:when>
                                <c:when test="${f.dest_city == 'Bangkok'}"><img src="${pageContext.request.contextPath}/static/images/Bangkok.jpg" alt="Bangkok"></c:when>
                                <c:when test="${f.dest_city == 'Frankfurt'}"><img src="${pageContext.request.contextPath}/static/images/Frankfurt.jpg" alt="Frankfurt"></c:when>
                                <c:when test="${f.dest_city == 'Madrid'}"><img src="${pageContext.request.contextPath}/static/images/madrid.jpg" alt="Madrid"></c:when>
                                <c:when test="${f.dest_city == 'Rome'}"><img src="${pageContext.request.contextPath}/static/images/Rome.jpg" alt="Rome"></c:when>
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
</section>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

<script>
    function filterCards() {
        const from = document.getElementById("filterFrom").value.toLowerCase().trim();
        const to = document.getElementById("filterTo").value.toLowerCase().trim();
        document.querySelectorAll(".flight-card").forEach(card => {
            const cf = card.getAttribute("data-from") ? card.getAttribute("data-from").toLowerCase() : "";
            const ct = card.getAttribute("data-to") ? card.getAttribute("data-to").toLowerCase() : "";
            card.style.display = ((from === "" || cf.includes(from)) && (to === "" || ct.includes(to))) ? "" : "none";
        });
    }
</script>
</body>
</html>
