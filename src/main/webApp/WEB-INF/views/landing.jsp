<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SkyLine Airlines — Fly Beyond Imagination</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
</head>
<body>

<!-- ══ HEADER ══ -->
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
        <a href="#book"      class="land-nav-link"><h2>Book</h2></a>
    </nav>

    <div class="land-header-auth">
        <a href="${pageContext.request.contextPath}/login"
           class="land-btn-login">Log In</a>
        <a href="${pageContext.request.contextPath}/register"
           class="land-btn-signup">Sign Up</a>
    </div>
</header>

<!-- ══ HERO ══ -->
<section class="land-hero" id="book">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Your Journey Begins Here</span>
        <h1 class="land-hero-title">
            Fly Beyond<br/>
            <span class="land-hero-accent">Imagination</span>
        </h1>
        <p class="land-hero-desc">
           <h2> Experience seamless travel with SkyLine. Book your next adventure with exclusive deals,
            premium service, and destinations across the globe.</h2>
        </p>
        <div class="land-hero-btns">
            <a href="${pageContext.request.contextPath}/register"
               class="land-btn-primary">Book a Flight →</a>
            <a href="${pageContext.request.contextPath}/login"
               class="land-btn-outline">Explore Deals</a>
        </div>

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

<!-- ══ WHY CHOOSE SKYLINE ══ -->
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
                <div class="land-feature-icon">🛫</div>
                <h2>Global Network</h2>
                <p><h4>Access to 150+ destinations worldwide with seamless connections</h4></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🛡️</div>
                <h2>Safe &amp; Secure</h2>
                <p><h4>Top-rated safety standards with comprehensive travel insurance</h4></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">🕛</div>
                <h2>24/7 Support</h2>
                <p><h4>Round-the-clock customer service for all your travel needs</h4></p>
            </div>
            <div class="land-feature-card">
                <div class="land-feature-icon">💵</div>
                <h2>Best Prices</h2>
                <p><h4>Competitive fares with exclusive deals and loyalty rewards</h4></p>
            </div>
        </div>
    </div>
</section>

<!-- ══ EVERYTHING YOU NEED ══ -->
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

<!-- ══ INFO / FOOTER LINKS ══ -->
<section class="land-info-section">
    <div class="land-info-grid">
        <div class="land-info-col">
            <h3 class="land-info-heading">About Us</h3>
            <a href="#" class="land-info-link">About SkyLine</a>
            <a href="#" class="land-info-link">Newsroom</a>
            <a href="#" class="land-info-link">Corporate Information</a>
            <a href="#" class="land-info-link">Tenders</a>
            <a href="#" class="land-info-link">Careers</a>
        </div>
        <div class="land-info-col">
            <h3 class="land-info-heading">Book &amp; Manage</h3>
            <a href="#" class="land-info-link">Search Flights</a>
            <a href="#" class="land-info-link">Manage Booking</a>
            <a href="#" class="land-info-link">Flight Schedule</a>
            <a href="#" class="land-info-link">Cargo</a>
        </div>
        <div class="land-info-col">
            <h3 class="land-info-heading">Where We Fly?</h3>
            <a href="#" class="land-info-link">Route Map</a>
            <a href="#" class="land-info-link">Nonstop Flights</a>
            <a href="#" class="land-info-link">Popular Flights</a>
            <a href="#" class="land-info-link">Partner Airlines</a>
        </div>
        <div class="land-info-col">
            <h3 class="land-info-heading">Prepare To Travel</h3>
            <a href="#" class="land-info-link">Baggage Guidelines</a>
            <a href="#" class="land-info-link">Airport Information</a>
            <a href="#" class="land-info-link">First-time Travellers</a>
            <a href="#" class="land-info-link">Visas &amp; Documents</a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ══ -->
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
