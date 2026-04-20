<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkyLine - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css" />
</head>
<body>

<!-- Top Navigation -->
<header class="header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png"
             alt="SkyLine" class="logo-image">
        <h1>SKYLINE</h1>
    </div>
    <nav>
        <a href="#">Book</a>
        <a href="#">Manage</a>
        <a href="#">Experience</a>
        <input type="text" placeholder="Search flights..." class="search-bar">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Log Out</a>
    </nav>
</header>

<!-- Hero Section with Air.png as Background + Dim Red Overlay -->
<section class="hero">
    <div class="hero-background"></div>
    <div class="hero-content">
        <h1>PLANNING YOUR FAMILY TRIP</h1>
        <h2>FLY BETTER, FLY WITH US</h2>
    </div>
</section>

<!-- Flight Search Bar -->
<div class="search-container">
    <div class="search-box">
        <h3>SEARCH AND BOOK FOR OUR FLIGHTS ONLINE</h3>
        <div class="search-form">
            <input type="text" placeholder="From" class="search-input">
            <input type="text" placeholder="To" class="search-input">
            <input type="date" class="search-input">
            <input type="date" class="search-input">
            <button class="search-btn">Search</button>
        </div>
    </div>
</div>

<!-- Popular Flights Section -->
<section class="popular-flights">
    <h2>POPULAR FLIGHT DEALS ON SKYLINE AIRLINES</h2>

    <div class="flight-grid">
        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Air.png" alt="Flight">
            <h3>Nepal (Nep) to London (UK)</h3>
            <p>Depart: May 24</p>
            <p class="price">NPR 338,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Air.png" alt="Flight">
            <h3>Nepal (Nep) to Italy (IT)</h3>
            <p>Depart: June 01</p>
            <p class="price">NPR 345,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>

        <div class="flight-card">
            <img src="${pageContext.request.contextPath}/static/images/Air.png" alt="Flight">
            <h3>Nepal (Nep) to Spain (ES)</h3>
            <p>Depart: June 10</p>
            <p class="price">NPR 410,000</p>
            <p class="class">One way • Economy Class</p>
            <button class="book-btn">Book Now</button>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="footer-bottom">
        <p>&copy; 2026 SkyLine Airlines. All Rights Reserved.</p>
    </div>
</footer>

</body>
</html>