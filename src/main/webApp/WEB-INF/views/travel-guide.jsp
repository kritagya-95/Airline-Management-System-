<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Travel Guide - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
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
        <span class="land-hero-tag">Prepare To Travel</span>
        <h1 class="land-hero-title">Travel <span class="land-hero-accent">Guide</span></h1>
        <p class="land-hero-desc">Quick guidance for smoother SkyLine trips from planning to arrival.</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="travel-card-grid">
        <article class="travel-card">
            <div class="travel-card-img"><img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Before departure"/></div>
            <div class="travel-card-body"><h2>Before Departure</h2><p>Review your route, travel documents, and flight time before leaving for the airport.</p></div>
        </article>
        <article class="travel-card">
            <div class="travel-card-img"><img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Airport arrival"/></div>
            <div class="travel-card-body"><h2>Airport Arrival</h2><p>Reach the airport early enough for check-in, security, and boarding procedures.</p></div>
        </article>
        <article class="travel-card">
            <div class="travel-card-img"><img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Baggage"/></div>
            <div class="travel-card-body"><h2>Baggage Basics</h2><p>Pack essentials clearly and keep valuables, documents, and medicine in cabin baggage.</p></div>
        </article>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>
</body>
</html>
