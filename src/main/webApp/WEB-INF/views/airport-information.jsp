<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Airport Information - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/airport-information.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero image-hero" style="background: linear-gradient(rgba(74, 13, 13, 0.55), rgba(20, 3, 3, 0.75)), url('${pageContext.request.contextPath}/static/images/hero.jpg') no-repeat center center; background-size: cover;">
    <div class="land-hero-inner">
        <span class="land-hero-tag" style="background-color: rgba(255, 255, 255, 0.15); color: #ffcccc; padding: 6px 16px; border-radius: 20px; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; display: inline-block; margin-bottom: 15px; font-size: 13px;">Travel with Confidence</span>
        <h1 class="land-hero-title" style="font-family: 'Cinzel', serif; font-size: 42px; color: #ffffff; margin: 0 0 15px 0;">Airport <span class="land-hero-accent" style="color: #e74c3c;">Information</span></h1>
        <p class="land-hero-desc" style="font-family: 'Chivo', sans-serif; font-size: 16px; color: #eaedd1; opacity: 0.9;">Important information about terminals, check-in, and services</p>
    </div>
</section>

<main class="airport-info-body">
    <section class="travel-page-section">

        <h2 class="section-title">Major Airports We Operate</h2>
        <div class="airport-grid">
            <div class="airport-card"><div class="airport-card-image">Kathmandu (KTM)</div><h3>Kathmandu (KTM)</h3><p>International Terminal • Row C</p></div>
            <div class="airport-card"><div class="airport-card-image">Doha (DOH)</div><h3>Doha (DOH)</h3><p>Terminal 1</p></div>
            <div class="airport-card"><div class="airport-card-image">Bangkok (BKK)</div><h3>Bangkok (BKK)</h3><p>Terminal 2</p></div>
            <div class="airport-card"><div class="airport-card-image">Madrid (MAD)</div><h3>Madrid (MAD)</h3><p>Terminal 4</p></div>
            <div class="airport-card"><div class="airport-card-image">Frankfurt (FRA)</div><h3>Frankfurt (FRA)</h3><p>Terminal 1</p></div>
            <div class="airport-card"><div class="airport-card-image">London (LHR)</div><h3>London (LHR)</h3><p>Terminal 2</p></div>
        </div>

        <h2 class="section-title">Check-In Information</h2>
        <div class="info-grid">
            <div class="info-card"><div class="info-card-image">Online Check-In</div>Online Check-In Available 24 hours before departure</div>
            <div class="info-card"><div class="info-card-image">Airport Check-In</div>Airport Check-In - Bring valid passport/ID</div>
            <div class="info-card"><div class="info-card-image">Boarding Gates</div>Boarding gates can change, so recheck the airport display screens after security.</div>
            <div class="info-card"><div class="info-card-image">Counter Closure</div>Check-in counters may close before departure, especially for international routes.</div>
        </div>

        <h2 class="section-title">Security & Travel Guidelines</h2>
        <div class="info-grid">
            <div class="info-card"><div class="info-card-image">Security Screening</div>Arrive early for security screening</div>
            <div class="info-card"><div class="info-card-image">Travel Documents</div>Keep travel documents ready</div>
            <div class="info-card"><div class="info-card-image">Safety Rules</div>Follow liquids & safety rules</div>
            <div class="info-card"><div class="info-card-image">Connecting Flights</div>For connections, follow transfer signs and keep enough time between flights.</div>
            <div class="info-card"><div class="info-card-image">Airport Lounges</div>Lounges may be available depending on cabin class, loyalty benefits, or paid access.</div>
            <div class="info-card"><div class="info-card-image">Special Assistance</div>Passengers needing mobility or medical assistance should request support before travel.</div>
        </div>

        <h2 class="section-title">Customer Support</h2>
        <div class="support-box">
            <p><strong>Phone:</strong> 7894561230</p>
            <p><strong>Email:</strong> skyline@skyline.com</p>
        </div>

    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>