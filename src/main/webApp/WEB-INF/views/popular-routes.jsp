<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Popular Routes - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/popular-routes.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero image-hero">
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
                                <c:when test="${not empty r.flight_image}">
                                    <img src="${pageContext.request.contextPath}/uploads/${r.flight_image}"
                                         alt="${r.origin_city} to ${r.dest_city}">
                                </c:when>
                                <c:when test="${r.dest_city == 'Kathmandu' or r.origin_city == 'Kathmandu'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu">
                                </c:when>
                                <c:when test="${r.dest_city == 'Dubai' or r.origin_city == 'Dubai'}">
                                    <img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Dubai">
                                </c:when>
                                <c:when test="${r.dest_city == 'London' or r.origin_city == 'London'}">
                                    <img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="London">
                                </c:when>
                                <c:when test="${r.dest_city == 'New Delhi' or r.origin_city == 'New Delhi'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="Delhi">
                                </c:when>
                                <c:when test="${r.dest_city == 'Doha' or r.origin_city == 'Doha'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Doha.jpg" alt="Doha">
                                </c:when>
                                <c:when test="${r.dest_city == 'Bangkok' or r.origin_city == 'Bangkok'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Bangkok.jpg" alt="Bangkok">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Flight">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="route-card-body">
                            <h2><c:out value="${r.origin_city}"/> → <c:out value="${r.dest_city}"/></h2>
                            <p class="route-card-meta"><c:out value="${r.origin_code}"/> - <c:out value="${r.dest_code}"/> • <c:out value="${r.flight_count}"/> flights</p>
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

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
