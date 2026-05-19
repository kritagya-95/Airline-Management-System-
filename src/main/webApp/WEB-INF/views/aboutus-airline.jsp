<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>About SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
</head>
<body>

<!-- HEADER -->
<header class="land-header">
    <div class="land-logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png"
             class="land-logo-img" alt="SkyLine"/>
        <span class="land-logo-text"><h1>SkyLine</h1></span>
    </div>

    <nav class="land-nav">
        <a href="#features"  class="land-nav-link"><h2>Features</h2></a>
        <a href="#benefits"  class="land-nav-link"><h2>Benefits</h2></a>
        <a href="#flights"   class="land-nav-link"><h2>Flights</h2></a>
        <a href="${pageContext.request.contextPath}/home" class="land-nav-link"><h2>Home</h2></a>
    </nav>

</header>

<!-- HERO -->
<section class="land-hero" id="book">
    <div class="land-hero-inner">
        <span class="land-hero-tag">About SkyLine Airlines</span>
        <h1 class="land-hero-title">
            Connecting journeys<br/>
            <span class="land-hero-accent">with care</span>
        </h1>
        <p class="land-hero-desc">
           <h2>SkyLine Airlines brings together reliable operations, attentive service,
            and a growing route network for travelers across the globe.</h2>
        </p>

        <!-- Stats -->
        <div class="land-stats">
            <div class="land-stat">
                <span class="land-stat-num">150+</span>
                <span class="land-stat-label"><h3>Destinations</h3></span>
            </div>
            <div class="land-stat">
                <span class="land-stat-num">5M+</span>
                <span class="land-stat-label"><h3>Happy Travelers</h3></span>
            </div>
            <div class="land-stat">
                <span class="land-stat-num">4.9/5</span>
                <span class="land-stat-label"><h3>Rating</h3></span>
            </div>
        </div>
    </div>
</section>

<!-- WHY CHOOSE SKYLINE-->
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
                <p><h5>Access to 150+ destinations worldwide with seamless connections</h5></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🛡️</div>
                <h2>Safe &amp; Secure</h2>
                <p><h5>Top-rated safety standards with comprehensive travel insurance</h5></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🤝</div>
                <h2>24/7 Support</h2>
                <p><h5>Round-the-clock customer service for all your travel needs</h5></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">💵</div>
                <h2>Best Prices</h2>
                <p><h5>Competitive fares with exclusive deals and loyalty rewards</h5></p>
            </div>
        </div>
    </div>
</section>

<!-- EVERYTHING YOU NEED -->
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
            <img src="${pageContext.request.contextPath}/static/images/Air.jpg"
                 alt="SkyLine flight view"/>
        </div>
    </div>
</section>

<!-- INFO / FOOTER LINKS -->
<section class="land-info-section">
    <div class="land-info-grid">
        <div class="land-info-col">
            <h2 class="land-info-heading">About Us</h2>
            <a href="${pageContext.request.contextPath}/aboutus-airline" class="land-info-link"><h4>About SkyLine</h4></a>
            <a href="${pageContext.request.contextPath}/information" class="land-info-link"><h4>Information</h4></a>

        </div>
        <div class="land-info-col">
            <h2 class="land-info-heading">Book &amp; Manage</h2>
            <a href="#" class="land-info-link"><h4>Search Flights</h4></a>
            <a href="#" class="land-info-link"><h4>Manage Booking</h4></a>
            <a href="#" class="land-info-link"><h4>Schedule</h4></a>
        </div>
        <div class="land-info-col">
            <h2 class="land-info-heading">Where We Fly?</h2>
            <a href="${pageContext.request.contextPath}/popular-routes" class="land-info-link"><h4>Popular Flights</h4></a>
            <a href="${pageContext.request.contextPath}/partner-airlines" class="land-info-link"><h4>Partner Airlines</h4></a>
        </div>
        <div class="land-info-col">
            <h2 class="land-info-heading">Prepare To Travel</h2>
            <a href="#" class="land-info-link"><h4>Baggage Guidelines</h4></a>
            <a href="#" class="land-info-link"><h4>Airport Information</h4></a>
            <a href="#" class="land-info-link"><h4>First-time Travellers</h4></a>
            <a href="#" class="land-info-link"><h4>Visas &amp; Documents</h4></a>
        </div>
    </div>
</section>

<!--  FOOTER  -->
<footer class="land-footer">
    <div class="land-footer-inner">
        <div class="land-footer-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 class="land-footer-logo-img" alt="SkyLine"/>
            <span class="land-footer-logo-text"><h1>SkyLine</h1></span>
        </div>
        <p class="land-footer-copy">&copy; 2026 SkyLine Airlines. All rights reserved.</p>
        <div class="land-footer-social">
            <a href="#" class="land-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/facebook.png"
                     alt="Facebook" width="22"/>
            </a>
            <a href="#" class="land-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/twitter.png"
                     alt="Twitter" width="22"/>
            </a>
            <a href="#" class="land-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/instagram.png"
                     alt="Instagram" width="22"/>
            </a>
        </div>
    </div>
</footer>

</body>
</html>
