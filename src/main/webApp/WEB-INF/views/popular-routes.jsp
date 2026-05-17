<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Popular Routes - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/popular-routes.css"/>
</head>
<body>
<header class="land-header">
    <div class="land-logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png" class="land-logo-img" alt="SkyLine"/>
        <span class="land-logo-text"><h1>SkyLine</h1></span>
    </div>
    <nav class="land-nav">
        <a href="${pageContext.request.contextPath}/popular-routes" class="land-nav-link"><h2>Routes</h2></a>
        <a href="${pageContext.request.contextPath}/partner-airlines" class="land-nav-link"><h2>Airlines</h2></a>
        <a href="${pageContext.request.contextPath}/travel-guide" class="land-nav-link"><h2>Travel Guide</h2></a>
        <a href="${pageContext.request.contextPath}/home" class="land-nav-link"><h2>Home</h2></a>
    </nav>
</header>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Where We Fly</span>
        <h1 class="land-hero-title">Popular <span class="land-hero-accent">Routes</span></h1>
        <p class="land-hero-desc">Explore active SkyLine routes built from the current flight schedule.</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="route-card-grid">
        <c:choose>
            <c:when test="${empty routes}">
                <div class="travel-empty">No popular routes found in the database.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${routes}">
                    <article class="route-card">
                        <div class="route-card-img">
                            <c:choose>
                                <c:when test="${r.dest_city == 'Kathmandu'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'Dubai'}">
                                    <img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Dubai"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'London'}">
                                    <img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="London"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'Rome'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Rome.jpg" alt="Rome"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'Madrid'}">
                                    <img src="${pageContext.request.contextPath}/static/images/madrid.jpg" alt="Madrid"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'Frankfurt'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Frankfurt.jpg" alt="Frankfurt"/>
                                </c:when>
                                <c:when test="${r.dest_city == 'Doha'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Doha.jpg" alt="Doha">
                                </c:when>
                                <c:when test="${r.dest_city == 'Bangkok'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Bangkok.jpg" alt="Bangkok">
                                </c:when>
                                <c:when test="${r.dest_city == 'New Delhi'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="Bangkok">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Flight"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="route-card-body">
                            <h2>${r.origin_city} → ${r.dest_city}</h2>
                            <p class="route-card-meta">${r.origin_code} - ${r.dest_code} • ${r.flight_count} flights</p>
                            <p class="route-card-price">NPR <fmt:formatNumber value="${r.starting_fare}" pattern="#,##0.00"/></p>
                            <p class="route-card-class">One way • Economy Class</p>
                            <a href="${pageContext.request.contextPath}/home" class="route-card-btn">Book Now</a>
                        </div>
                    </article>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>
</body>
</html>