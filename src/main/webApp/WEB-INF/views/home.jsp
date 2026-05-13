<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkyLine - Airlines</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css" />
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Chivo:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<!-- ==================== HEADER ==================== -->
<header class="header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="SkyLine" class="logo-image">
        <span>SkyLine</span>
    </div>

    <nav class="nav-menu">
        <a href="#">Book</a>
        <a href="#">Manage</a>
        <a href="#">Experience</a>
    </nav>

    <div class="header-right">
        <a href="${pageContext.request.contextPath}/login" class="btn-login">Log In</a>
        <a href="${pageContext.request.contextPath}/register" class="btn-signup">Sign Up</a>
    </div>
</header>

<!-- ==================== HERO SECTION ==================== -->
<section class="hero">
    <img src="${pageContext.request.contextPath}/static/images/Air.jpg"
         alt="SkyLine Plane" class="hero-image">

    <div class="hero-content">
        <h1>Planning your family trip</h1>
        <h2>Fly Better, Fly With US</h2>
    </div>
</section>

<!-- ==================== SEARCH BAR ==================== -->
<div class="search-container">
    <div class="search-box">
        <h3>Search and Book for Our Flights Online</h3>
        <div class="search-form">
            <input type="text" placeholder="From" class="search-input">
            <input type="text" placeholder="To" class="search-input">
            <input type="date" class="search-input">
            <input type="date" class="search-input">
            <button class="search-btn">Search</button>
        </div>
    </div>
</div>

<!-- ==================== POPULAR FLIGHTS ==================== -->
<section class="popular-flights">
    <h2>Popular Flight Deals on SkyLine Airlines</h2>

    <div class="flight-grid">
        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu to Frankfurt">
            <h3>Kathmandu (KTM) to Frankfurt (FRA)</h3>
            <p>Depart: 2025-06-08</p>
            <p class="price">NPR 560,375</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/madrid.jpg" alt="Kathmandu to Madrid">
            <h3>Kathmandu (KTM) to Madrid (MAD)</h3>
            <p>Depart: 2025-06-07</p>
            <p class="price">NPR 410,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Rome.jpg" alt="Kathmandu to Rome">
            <h3>Kathmandu (KTM) to Rome (FCO)</h3>
            <p>Depart: 2025-06-06</p>
            <p class="price">NPR 345,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="Kathmandu to London">
            <h3>Kathmandu (KTM) to London (LHR)</h3>
            <p>Depart: 2025-06-05</p>
            <p class="price">NPR 338,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Kathmandu to Dubai">
            <h3>Kathmandu (KTM) to Dubai (DXB)</h3>
            <p>Depart: 2025-06-02</p>
            <p class="price">NPR 450,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="New Delhi to Kathmandu">
            <h3>New Delhi (DEL) to Kathmandu (KTM)</h3>
            <p>Depart: 2025-06-01</p>
            <p class="price">NPR 85,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>
    </div>
</section>

<!-- ==================== FOOTER ==================== -->
<footer class="footer">
    <div class="footer-content">
        <div class="footer-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="SkyLine" class="footer-logo-img">
            <span>SkyLine</span>
        </div>

        <div class="footer-links">
            <div>
                <h4>About Us</h4>
                <p>About SkyLine</p>
                <p>Information</p>
            </div>
            <div>
                <h4>Book & Manage</h4>
                <p>Search Flights</p>
                <p>Manage Booking</p>
                <p>Schedule</p>
            </div>
            <div>
                <h4>Where We Fly?</h4>
                <p>Popular Flights</p>
                <p>Partner Airlines</p>
            </div>
            <div>
                <h4>Prepare To Travel</h4>
                <p>Luggage Guidelines</p>
                <p>Airport Information</p>
            </div>
        </div>
    </div>

    <div class="footer-bottom">
        <p>© 2026 SkyLine Airlines. All Rights Reserved.</p>
        <div class="social-icons">
            <a href="#">📘</a>
            <a href="#">🐦</a>
            <a href="#">📷</a>
        </div>
    </div>
</footer>

</body>
</html>