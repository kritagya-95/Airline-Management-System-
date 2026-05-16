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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/travel-guide.css"/>
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
        <span class="land-hero-tag">Be Prepared</span>
        <h1 class="land-hero-title">Travel <span class="land-hero-accent">Guide</span></h1>
        <p class="land-hero-desc">Essential tips and information to make your journey smooth and stress-free</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="guide-grid">
        <!-- Card 1 -->
        <article class="guide-card">
            <div class="guide-icon">✈️</div>
            <h2>Pre-Flight Checklist</h2>
            <ul class="guide-list">
                <li><strong>Check-In:</strong> Complete online check-in 24 to 48 hours before departure.</li>
                <li><strong>Luggage Rules:</strong> Check weight and size limits to avoid extra fees.</li>
                <li><strong>Travel Documents:</strong> Ensure passport is valid for at least 6 months and carry required visas.</li>
            </ul>
        </article>

        <!-- Card 2 -->
        <article class="guide-card">
            <div class="guide-icon">🛫</div>
            <h2>Airport Navigation</h2>
            <ul class="guide-list">
                <li><strong>Arrival Timing:</strong> Arrive 2-3 hours before domestic and 3-4 hours before international flights.</li>
                <li><strong>Security:</strong> Keep ID, boarding pass ready. Follow 100ml liquid rule.</li>
                <li><strong>Check-in Closure:</strong> Usually 45 mins (domestic) and 60 mins (international).</li>
            </ul>
        </article>

        <!-- Card 3 -->
        <article class="guide-card">
            <div class="guide-icon">🛩️</div>
            <h2>In-Flight Services & Rights</h2>
            <ul class="guide-list">
                <li><strong>Amenities:</strong> Complimentary drinks, meals & entertainment on long-haul flights.</li>
                <li><strong>Passenger Rights:</strong> Know your rights for delays, cancellations & compensation.</li>
                <li><strong>Comfort Tip:</strong> Stay hydrated and move around during long flights.</li>
            </ul>
        </article>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>
</body>
</html>