<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>About SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero" id="book" style="background: linear-gradient(rgba(74, 13, 13, 0.55), rgba(20, 3, 3, 0.75)), url('${pageContext.request.contextPath}/static/images/hero.jpg') no-repeat center center; background-size: cover;">
    <div class="land-hero-inner">
        <span class="land-hero-tag" style="background-color: rgba(255, 255, 255, 0.15); color: #ffcccc; padding: 6px 16px; border-radius: 20px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; display: inline-block; margin-bottom: 15px; font-size: 13px;">About SkyLine Airlines</span>
        <h1 class="land-hero-title" style="font-family: 'Cinzel', serif; font-size: 42px; color: #ffffff; margin: 0 0 15px 0;">
            Connecting journeys<br/>
            <span class="land-hero-accent" style="color: #e74c3c;">with care</span>
        </h1>
        <div class="land-hero-desc" style="font-family: 'Chivo', sans-serif; font-size: 16px; color: #eaedd1; opacity: 0.9; margin-bottom: 30px;">
            SkyLine Airlines brings together reliable operations, attentive service,
            and a growing route network for travelers across the globe.
        </div>

        <div class="land-stats">
            <div class="land-stat">
                <span class="land-stat-num">150+</span>
                <span class="land-stat-label">Destinations</span>
            </div>
            <div class="land-stat">
                <span class="land-stat-num">5M+</span>
                <span class="land-stat-label">Happy Travelers</span>
            </div>
            <div class="land-stat">
                <span class="land-stat-num">4.9/5</span>
                <span class="land-stat-label">Rating</span>
            </div>
        </div>
    </div>
</section>

<section class="land-why" id="features">
    <div class="land-section-inner">
        <h2 class="land-section-title">
            Why Choose <span class="land-accent">SkyLine?</span>
        </h2>
        <p class="land-section-sub">
            Experience premium travel with world-class service and unbeatable convenience
        </p>

        <div class="land-features-grid">
            <div class="land-feature-card">
                <div class="land-feature-icon">🌏</div>
                <h2>Global Network</h2>
                <p>Access to 150+ destinations worldwide with seamless connections</p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🛡️</div>
                <h2>Safe &amp; Secure</h2>
                <p>Top-rated safety standards with comprehensive travel insurance</p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🤝</div>
                <h2>24/7 Support</h2>
                <p>Round-the-clock customer service for all your travel needs</p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">💵</div>
                <h2>Best Prices</h2>
                <p>Competitive fares with exclusive deals and loyalty rewards</p>
            </div>
        </div>
    </div>
</section>

<section class="land-everything" id="benefits">
    <div class="land-everything-inner">
        <div class="land-everything-text">
            <h2>Everything You Need for a <span class="land-accent">Perfect Flight</span></h2>
            <p>Join millions of travelers who trust SkyLine for their journey around the world.</p>

            <div class="land-checklist">
                <div class="land-check-col">
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Instant booking confirmation
                    </div>
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Free seat selection
                    </div>
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Earn rewards on every flight
                    </div>
                </div>
                <div class="land-check-col">
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Flexible cancellation policy
                    </div>
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Priority boarding available
                    </div>
                    <div class="land-check-item">
                        <span class="land-check-icon">🎯</span> Mobile boarding passes
                    </div>
                </div>
            </div>
        </div>

        <div class="land-everything-img">
            <img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="SkyLine flight view"/>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>