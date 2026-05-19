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

<section class="land-hero image-hero">
    <div class="land-hero-inner">
        <span class="land-hero-tag">Travel Smart</span>
        <h1 class="land-hero-title">Luggage <span class="land-hero-accent">Guidelines</span></h1>
        <p class="land-hero-desc">Everything you need to know about baggage allowances and restrictions</p>
    </div>
</section>

<section class="travel-page-section">
    <div class="luggage-grid">
        <div class="luggage-card">
            <div class="luggage-card-image">Hand Baggage</div>
            <h2>Hand Baggage (Carry-On) Rules</h2>
            <div class="rule-item"><strong>Allowance:</strong> 1 carry-on bag + 1 small personal item</div>
            <div class="rule-item"><strong>Liquids:</strong> Max 100ml per container in a clear 20×20 cm bag</div>
            <div class="rule-item"><strong>Prohibited:</strong> Sharp objects, flammable materials, loose lithium batteries</div>
            <div class="rule-item"><strong>Recommended Size:</strong> Keep cabin bags compact enough to fit in the overhead bin or under the seat.</div>
            <div class="rule-item"><strong>Essentials:</strong> Carry medicine, documents, chargers, and valuables in your personal item.</div>
        </div>

        <div class="luggage-card">
            <div class="luggage-card-image">Checked Baggage</div>
            <h2>Checked Baggage (Hold Luggage) Rules</h2>
            <div class="rule-item"><strong>Standard Dimensions:</strong> Max 157 linear cm (L+W+H)</div>
            <div class="rule-item"><strong>Weight Limits:</strong> 23 kg (Economy) | 30-32 kg (Business)</div>
            <div class="rule-item"><strong>Banned Items:</strong> Valuables, lithium batteries, prohibited goods</div>
            <div class="rule-item"><strong>Label Your Bag:</strong> Add your name, phone number, and destination address before check-in.</div>
            <div class="rule-item"><strong>Fragile Items:</strong> Pack fragile items securely and inform the check-in counter if special handling is needed.</div>
        </div>
    </div>

    <div class="luggage-info-grid">
        <div class="luggage-info-card">
            <h2>Extra Baggage</h2>
            <p>Extra baggage is subject to route, cabin class, and aircraft capacity. Purchase extra allowance before arriving at the airport to avoid counter delays.</p>
        </div>
        <div class="luggage-info-card">
            <h2>Sports & Special Items</h2>
            <p>Golf kits, musical instruments, strollers, and mobility aids may require special packaging or advance notice. Keep receipts and approval notes with you.</p>
        </div>
        <div class="luggage-info-card">
            <h2>Delayed or Damaged Bags</h2>
            <p>Report missing or damaged baggage before leaving the arrival hall. Keep your baggage tag and boarding pass until the case is resolved.</p>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
