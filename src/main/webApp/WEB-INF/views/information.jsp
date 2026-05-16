<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Developers - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/information.css"/>
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
        <span class="land-hero-tag">Project Team</span>
        <h1 class="land-hero-title">Meet the <span class="land-hero-accent">Developers</span></h1>
        <p class="land-hero-desc">The team behind SkyLine Airline Reservation and Management System.</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="developer-grid">
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Krits.jpg" alt="Kritagya Shrestha"/>
                <span>CEO</span>
            </div>
            <div><h2>Kritagya Shrestha</h2><p>Drives the product vision and strategy for SkyLine Airlines, ensuring the platform delivers a seamless, user-friendly, and innovative travel experience while keeping customer satisfaction and business goals at the center of development.</p></div>
        </article>
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/SujalP.jpg" alt="Sujal Pariyar"/>
                <span>Co-Founder</span>
            </div>
            <div><h2>Sujal Pariyar</h2><p>Shapes core workflows and helps turn team ideas into usable application features.</p></div>
        </article>
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/SujalT.jpg" alt="Sujal Tiwari"/>
                <span>Lead Backend Developer</span>
            </div>
            <div><h2>Sujal Tiwari</h2><p>Works on server-side logic, database coordination, and reliable request handling.</p></div>
        </article>
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Binod.jpg" alt="Binod Tamang"/>
                <span>UI/UX Lead</span>
            </div>
            <div><h2>Binod Tamang</h2><p>Focuses on clean screens, approachable layouts, and a polished visual direction.</p></div>
        </article>
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Prajesh.jpg" alt="Prajesh Thapa"/>
                <span>Database Engineer</span>
            </div>
            <div><h2>Prajesh Thapa</h2><p>Maintains data structure, route information, and the booking system foundation.</p></div>
        </article>
        <article class="developer-card">
            <div class="developer-photo">
                <img src="${pageContext.request.contextPath}/static/images/Aditya.jpg" alt="Aditya Ale Magar"/>
                <span>Quality Analyst</span>
            </div>
            <div><h2>Aditya Ale Magar</h2><p>Reviews behavior, checks edge cases, and helps keep the final system dependable.</p></div>
        </article>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>
</body>
</html>