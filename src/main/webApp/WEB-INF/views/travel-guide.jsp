<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Travel Guide - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/travel-guide.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Be Prepared</span>
        <h1 class="land-hero-title">Travel <span class="land-hero-accent">Guide</span></h1>
        <p class="land-hero-desc">Essential tips and information to make your journey smooth and stress-free</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="guide-grid">
        <article class="guide-card">
            <div class="guide-icon">✈️</div>
            <h2>Pre-Flight Checklist</h2>
            <ul class="guide-list">
                <li><strong>Check-In:</strong> Complete online check-in 24 to 48 hours before departure.</li>
                <li><strong>Luggage Rules:</strong> Check weight and size limits to avoid extra fees.</li>
                <li><strong>Travel Documents:</strong> Ensure passport is valid for at least 6 months and carry required visas.</li>
            </ul>
        </article>

        <article class="guide-card">
            <div class="guide-icon">🛫</div>
            <h2>Airport Navigation</h2>
            <ul class="guide-list">
                <li><strong>Arrival Timing:</strong> Arrive 2-3 hours before domestic and 3-4 hours before international flights.</li>
                <li><strong>Security:</strong> Keep ID, boarding pass ready. Follow 100ml liquid rule.</li>
                <li><strong>Check-in Closure:</strong> Usually 45 mins (domestic) and 60 mins (international).</li>
            </ul>
        </article>

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

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>