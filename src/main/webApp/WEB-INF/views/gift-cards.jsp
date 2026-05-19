<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Gift Cards - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gift-card-buy.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gift-card-redeem.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/gift-cards.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="gift-cards-page">
    <c:set var="isLoggedIn" value="${not empty user}"/>
    <section class="gift-cards-hero">
        <p class="gift-cards-kicker">Book</p>
        <h1>Gift Cards</h1>
        <p>Send future travel credit or apply a mock SkyLine gift card to a booking.</p>
    </section>

    <section class="gift-tabs" aria-label="Gift card sections">
        <a href="#buyGiftCard" class="gift-tab active">Buy a Gift Card</a>
        <a href="#redeemGiftCard" class="gift-tab">Redeem a Gift Card</a>
    </section>

    <div class="gift-cards-stack">
        <script>
            window.skylineGiftCardPurchaseAllowed = ${isLoggedIn ? 'true' : 'false'};
            window.skylineGiftCardLoginUrl = "${pageContext.request.contextPath}/login";
        </script>
        <%@ include file="/WEB-INF/views/fragments/gift-card-buy.jsp" %>
        <%@ include file="/WEB-INF/views/fragments/gift-card-redeem.jsp" %>
    </div>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>
