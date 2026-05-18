<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Airport Information - SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/airport-information.css"/>
</head>
<body>
<header class="land-header"> ... (same header as above) </header>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Travel with Confidence</span>
        <h1 class="land-hero-title">Airport <span class="land-hero-accent">Information</span></h1>
        <p class="land-hero-desc">Important information about terminals, check-in, and services</p>
    </div>
</section>

<section class="travel-page-section">
    <h2 class="section-title">Major Airports We Operate</h2>
    <div class="airport-grid">
        <div class="airport-card"><h3>Kathmandu (KTM)</h3><p>International Terminal • Row C</p></div>
        <div class="airport-card"><h3>Doha (DOH)</h3><p>Terminal 1</p></div>
        <div class="airport-card"><h3>Bangkok (BKK)</h3><p>Terminal 2</p></div>
        <div class="airport-card"><h3>Madrid (MAD)</h3><p>Terminal 4</p></div>
        <div class="airport-card"><h3>Frankfurt (FRA)</h3><p>Terminal 1</p></div>
        <div class="airport-card"><h3>London (LHR)</h3><p>Terminal 2</p></div>
    </div>

    <h2 class="section-title">Check-In Information</h2>
    <div class="info-grid">
        <div class="info-card">Online Check-In Available 24 hours before departure</div>
        <div class="info-card">Airport Check-In - Bring valid passport/ID</div>
    </div>

    <h2 class="section-title">Security & Travel Guidelines</h2>
    <div class="info-grid">
        <div class="info-card">Arrive early for security screening</div>
        <div class="info-card">Keep travel documents ready</div>
        <div class="info-card">Follow liquids & safety rules</div>
    </div>

    <h2 class="section-title">Customer Support</h2>
    <div class="support-box">
        <p><strong>Phone:</strong> 7894561230</p>
        <p><strong>Email:</strong> skyline@skyline.com</p>
    </div>
</section>

<jsp:include page="/WEB-INF/views/partials/landing-footer.jsp"/>
</body>
</html>