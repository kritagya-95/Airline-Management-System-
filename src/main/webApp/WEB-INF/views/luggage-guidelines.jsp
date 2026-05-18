<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Luggage Guidelines - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/landing.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/luggage-guidelines.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<section class="land-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Travel Smart</span>
        <h1 class="land-hero-title">Luggage <span class="land-hero-accent">Guidelines</span></h1>
        <p class="land-hero-desc">Everything you need to know about baggage allowances and restrictions</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="luggage-grid">
        <div class="luggage-card">
            <h2>Hand Baggage (Carry-On) Rules</h2>
            <div class="rule-item"><strong>Allowance:</strong> 1 carry-on bag + 1 small personal item</div>
            <div class="rule-item"><strong>Liquids:</strong> Max 100ml per container in a clear 20×20 cm bag</div>
            <div class="rule-item"><strong>Prohibited:</strong> Sharp objects, flammable materials, loose lithium batteries</div>
        </div>

        <div class="luggage-card">
            <h2>Checked Baggage (Hold Luggage) Rules</h2>
            <div class="rule-item"><strong>Standard Dimensions:</strong> Max 157 linear cm (L+W+H)</div>
            <div class="rule-item"><strong>Weight Limits:</strong> 23 kg (Economy) | 30-32 kg (Business)</div>
            <div class="rule-item"><strong>Banned Items:</strong> Valuables, lithium batteries, prohibited goods</div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>