<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ page import="java.util.ArrayList,java.util.LinkedHashMap,java.util.List,java.util.Map" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    List<Map<String, Object>> hotels = new ArrayList<>();

    Map<String, Object> hotel = new LinkedHashMap<>();
    hotel.put("id", 1);
    hotel.put("name", "SkyLine Grand Kathmandu");
    hotel.put("city", "Kathmandu");
    hotel.put("stars", 5);
    hotel.put("pricePerNight", 180);
    hotel.put("description", "Central stay with quiet rooms, airport transfer desk, and late-arrival dining.");
    hotel.put("image", "Image 1");
    hotels.add(hotel);

    hotel = new LinkedHashMap<>();
    hotel.put("id", 2);
    hotel.put("name", "Thamel Transit House");
    hotel.put("city", "Kathmandu");
    hotel.put("stars", 4);
    hotel.put("pricePerNight", 95);
    hotel.put("description", "Compact city hotel near cafes, shopping streets, and onward travel counters.");
    hotel.put("image", "Image 2");
    hotels.add(hotel);

    hotel = new LinkedHashMap<>();
    hotel.put("id", 3);
    hotel.put("name", "Dubai Creek Atrium");
    hotel.put("city", "Dubai");
    hotel.put("stars", 5);
    hotel.put("pricePerNight", 240);
    hotel.put("description", "Polished creekside hotel with skyline views and quick access to business districts.");
    hotel.put("image", "Image 3");
    hotels.add(hotel);

    hotel = new LinkedHashMap<>();
    hotel.put("id", 4);
    hotel.put("name", "Marina Layover Suites");
    hotel.put("city", "Dubai");
    hotel.put("stars", 4);
    hotel.put("pricePerNight", 170);
    hotel.put("description", "Relaxed suites for short stays, family stopovers, and evening waterfront walks.");
    hotel.put("image", "Image 4");
    hotels.add(hotel);

    hotel = new LinkedHashMap<>();
    hotel.put("id", 5);
    hotel.put("name", "London Regent Rooms");
    hotel.put("city", "London");
    hotel.put("stars", 4);
    hotel.put("pricePerNight", 210);
    hotel.put("description", "Elegant rooms close to rail links, theatre nights, and classic city landmarks.");
    hotel.put("image", "Image 5");
    hotels.add(hotel);

    hotel = new LinkedHashMap<>();
    hotel.put("id", 6);
    hotel.put("name", "Bangkok Riverside Nest");
    hotel.put("city", "Bangkok");
    hotel.put("stars", 4);
    hotel.put("pricePerNight", 125);
    hotel.put("description", "Warm riverside base with market access, breakfast terrace, and flexible checkout.");
    hotel.put("image", "Image 6");
    hotels.add(hotel);

    request.setAttribute("hotels", hotels);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Hotels - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700;900&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/hotel-card.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/hotels.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="hotels-page">
    <c:set var="isLoggedIn" value="${not empty user}"/>
    <section class="hotels-hero">
        <p class="hotels-kicker">Book</p>
        <h1>Hotels</h1>
        <p>Pair your flight with a locally mocked hotel stay for your next SkyLine trip.</p>
    </section>

    <section class="hotel-search-panel">
        <div class="hotel-search-grid">
            <label>
                Destination City
                <input type="text" id="hotelCityFilter" name="destinationCity" placeholder="Kathmandu" value="<c:out value='${param.city}'/>"/>
            </label>
            <label>
                Check-in Date
                <input type="date" name="checkInDate"/>
            </label>
            <label>
                Check-out Date
                <input type="date" name="checkOutDate"/>
            </label>
            <label>
                Guests
                <input type="number" name="guests" min="1" value="1"/>
            </label>
        </div>
    </section>

    <section class="hotel-results-section">
        <div class="hotel-results-head">
            <h2>Available Stays</h2>
            <span id="hotelResultCount"></span>
        </div>
        <div class="hotel-grid" id="hotelGrid">
            <c:forEach var="hotel" items="${hotels}">
                <%@ include file="/WEB-INF/views/fragments/hotel-card.jsp" %>
            </c:forEach>
        </div>
        <p class="hotel-empty-state" id="hotelEmptyState">No hotels match that city yet.</p>
    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

<script>
    const hotelCityFilter = document.getElementById("hotelCityFilter");
    const hotelCards = Array.from(document.querySelectorAll(".hotel-card"));
    const hotelEmptyState = document.getElementById("hotelEmptyState");
    const hotelResultCount = document.getElementById("hotelResultCount");
    const hotelBookingAllowed = ${isLoggedIn ? 'true' : 'false'};
    const hotelLoginUrl = "${pageContext.request.contextPath}/login";

    function filterHotels() {
        const filterValue = hotelCityFilter.value.trim().toLowerCase();
        let visibleCount = 0;

        hotelCards.forEach(card => {
            const cardCity = (card.getAttribute("data-city") || "").toLowerCase();
            const isVisible = filterValue === "" || cardCity.includes(filterValue);
            card.style.display = isVisible ? "" : "none";
            if (isVisible) {
                visibleCount += 1;
            }
        });

        hotelEmptyState.style.display = visibleCount === 0 ? "block" : "none";
        hotelResultCount.textContent = visibleCount + " mock hotels";
    }

    hotelCityFilter.addEventListener("input", filterHotels);
    hotelCards.forEach(card => {
        const button = card.querySelector(".hotel-book-btn");
        button.addEventListener("click", () => {
            const hotelName = button.getAttribute("data-hotel-name");
            const hotelCity = button.getAttribute("data-hotel-city");
            const hotelPrice = button.getAttribute("data-hotel-price");

            if (!hotelBookingAllowed) {
                window.location.href = hotelLoginUrl + "?returnUrl=" + encodeURIComponent(window.location.pathname + window.location.search);
                return;
            }

            if (!confirm("Are you sure you want to book " + hotelName + " in " + hotelCity + "?")) {
                return;
            }

            hotelCards.forEach(item => item.classList.remove("selected"));
            card.classList.add("selected");
            if (window.skylineAddChecklistItem) {
                window.skylineAddChecklistItem({
                    id: "hotel-" + Date.now(),
                    label: "Hotel: " + hotelName + " (" + hotelCity + ") - $" + hotelPrice + "/night"
                });
            }
        });
    });
    filterHotels();
</script>
</body>
</html>
