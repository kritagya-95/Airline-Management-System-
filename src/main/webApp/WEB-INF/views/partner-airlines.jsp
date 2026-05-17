<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Partner Airlines - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/partner-airlines.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">SkyLine Network</span>
        <h1 class="land-hero-title">Partner <span class="land-hero-accent">Airlines</span></h1>
        <p class="land-hero-desc">Airlines currently stored in the SkyLine database.</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="partner-card-grid">
        <c:choose>
            <c:when test="${empty airlines}">
                <div class="travel-empty">No partner airlines found in the database.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="a" items="${airlines}">
                    <article class="partner-card">
                        <div class="partner-card-img">
                            <c:choose>
                                <c:when test="${a.airline_name == 'Emirates'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Emirates.jpg" alt="Emirates"/>
                                </c:when>
                                <c:when test="${a.airline_name == 'Nepal Airlines'}">
                                    <img src="${pageContext.request.contextPath}/static/images/NepalAirline.jpg" alt="Nepal Airlines"/>
                                </c:when>
                                <c:when test="${a.airline_name == 'Tropic Air'}">
                                    <img src="${pageContext.request.contextPath}/static/images/TropicAir.jpg" alt="Tropic Air"/>
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Partner"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="partner-card-body">
                            <div class="partner-card-top">
                                <span class="partner-code">${a.iata_code}</span>
                                <span class="partner-country">${a.country}</span>
                            </div>
                            <h2>${a.airline_name}</h2>
                            <p>IATA Code: <strong>${a.iata_code}</strong></p>
                            <p class="partner-note">Trusted partner for connected SkyLine journeys.</p>
                            <p class="partner-network">
                                    ${a.country == 'UAE' ? 'International Network' : 'Regional Network'}
                            </p>
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