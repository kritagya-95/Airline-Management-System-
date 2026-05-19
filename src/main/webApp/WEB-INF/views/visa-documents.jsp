<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Visa & Documents - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/visa-documents.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero image-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Important Documents</span>
        <h1 class="land-hero-title">Visa & <span class="land-hero-accent">Documents</span></h1>
        <p class="land-hero-desc">Make sure you have all required travel documents before your journey</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="visa-grid">
        <div class="visa-card">
            <div class="visa-card-image">Passport Requirements</div>
            <h2>Passport Requirements</h2>
            <p>Passport must be valid for at least 6 months from the date of return.</p>
            <p>Make sure the name on your ticket matches your passport exactly, including spelling and middle names where required.</p>
        </div>
        <div class="visa-card">
            <div class="visa-card-image">Visa Information</div>
            <h2>Visa Information</h2>
            <p>Check visa requirements for your destination country before booking.</p>
            <p>Transit visas may be required even when you are not leaving the airport, depending on the country and itinerary.</p>
        </div>
        <div class="visa-card">
            <div class="visa-card-image">Other Documents</div>
            <h2>Other Documents</h2>
            <p>Boarding pass, vaccination certificate (if required), and travel insurance.</p>
            <p>Carry hotel confirmations, return tickets, and emergency contact details for immigration checks.</p>
        </div>
    </div>

</section>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
