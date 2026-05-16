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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/book-flight.css"/>
</head>
<body>

<header class="header">
    <div class="header-logo">
        <a href="${pageContext.request.contextPath}/home" class="logo-link">
            <span class="logo-text"><h1>SkyLine</h1></span>
        </a>
    </div>
    <nav class="nav-links">
        <div class="nav-dropdown">
            <a href="#" class="nav-link"><h2>Book</h2> <span class="arrow">▾</span></a>
            <div class="dropdown-menu">
                <a href="${pageContext.request.contextPath}/book-flight">Book a Flight</a>
                <a href="#">Manage Booking</a>
            </div>
        </div>
    </nav>
    <div class="header-right">
        <div class="header-auth">
            <c:choose>
                <c:when test="${not empty user}">
                    <a href="#" class="welcome-text-link">👤 <c:out value="${user.fullName}"/></a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn-header-login">Log In</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<section class="hero-banner"></section>

<div class="search-container">
    <div class="search-box">
        <h1 class="search-title">Search and Book for Our FLIGHTS online</h1>
        <form class="search-form" action="${pageContext.request.contextPath}/search-flights" method="get">
            <div class="search-field">
                <label>From</label>
                <div class="search-input-wrap">
                    <input type="text" name="from" value="<c:out value='${searchedFrom}'/>" placeholder="Select Origin" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>To</label>
                <div class="search-input-wrap">
                    <input type="text" name="to" value="<c:out value='${searchedTo}'/>" placeholder="Select Destination" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>Departure</label>
                <div class="search-input-wrap">
                    <input type="date" name="departure" value="<c:out value='${searchedDate}'/>" class="search-input" required/>
                </div>
            </div>
            <div class="search-field">
                <label>Return</label>
                <div class="search-input-wrap">
                    <input type="date" name="returnDate" value="<c:out value='${param.returnDate}'/>" class="search-input"/>
                </div>
            </div>
            <div class="search-field search-btn-wrap">
                <button type="submit" class="search-btn">SEARCH</button>
            </div>
        </form>
    </div>
</div>

<main class="booking-container">
    <h2 class="section-title">Matching Search Results</h2>

    <div class="flight-grid">
        <c:choose>
            <c:when test="${empty flights}">
                <div class="no-flights" style="text-align: center; width: 100%; font-size: 1.2rem; margin: 2rem 0;">
                    ❌ No flights found matching your criteria. Try adjusting your destinations or dates.
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
                            <h3 class="flight-card-title"><c:out value="${f.origin_city}"/> to <c:out value="${f.dest_city}"/></h3>
                            <p class="flight-card-depart">Depart: <c:out value="${f.departure_time}"/></p>
                            <p class="flight-card-price">NPR <fmt:formatNumber value="${f.base_economy_fare}" pattern="#,##0.00"/></p>
                            <a class="book-btn" href="${pageContext.request.contextPath}/booking?flightId=${f.flight_id}">Book Now</a>
                        </div>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

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