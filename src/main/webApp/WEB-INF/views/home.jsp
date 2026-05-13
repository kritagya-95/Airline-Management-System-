<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/home.css"/>
</head>
<body>

<!-- ══ HEADER ══ -->
<header class="header">
    <div class="header-logo">
        <img src="${pageContext.request.contextPath}/static/images/logo.png"
             class="logo-image" alt="SkyLine Logo"/>
        <span class="logo-text">SkyLine</span>
    </div>

    <nav class="nav-links">
        <div class="nav-dropdown">
            <a href="#" class="nav-link"><h3>Book</h3> <span class="arrow">▾</span></a>
            <div class="dropdown-menu">
                <a href="#">Search Flights</a>
                <a href="#">Book a Flight</a>
                <a href="#">Manage Booking</a>
            </div>
        </div>
        <div class="nav-dropdown">
            <a href="#" class="nav-link"><h2>Manage</h2> <span class="arrow">▾</span></a>
            <div class="dropdown-menu">
                <a href="#">My Bookings</a>
                <a href="#">Cancel Booking</a>
                <a href="#">Flight Schedule</a>
            </div>
        </div>
        <div class="nav-dropdown">
            <a href="#" class="nav-link"><h2>Experience</h2> <span class="arrow">▾</span></a>
            <div class="dropdown-menu">
                <a href="#">Popular Routes</a>
                <a href="#">Partner Airlines</a>
                <a href="#">Travel Guide</a>
            </div>
        </div>
    </nav>

    <div class="header-right">
        <div class="header-search">
            <span class="search-icon">🔍</span>
            <input type="text" placeholder="Search" class="header-search-input"/>
        </div>
        <div class="header-auth">
            <c:choose>
                <c:when test="${not empty user}">
                    <span class="welcome-text">👤 <c:out value="${user.fullName}"/></span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-header-login">Log Out</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"
                       class="btn-header-login">Log in / Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- ══ HERO ══ -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Planning your family trip</h1>
        <h2>Fly Better, Fly With US</h2>
    </div>
</section>

<!-- ══ SEARCH BOX ══ -->
<div class="search-container">
    <div class="search-box">
        <h3 class="search-title">Search and Book for Our FLIGHTS online</h3>
        <form class="search-form" action="${pageContext.request.contextPath}/flights" method="get">
            <div class="search-field">
                <label>From</label>
                <div class="search-input-wrap">
                    <span class="field-icon">📍</span>
                    <input type="text" name="from" placeholder="Select Origin" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>To</label>
                <div class="search-input-wrap">
                    <span class="field-icon">📍</span>
                    <input type="text" name="to" placeholder="Select Destination" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>Departure</label>
                <div class="search-input-wrap">
                    <span class="field-icon">📅</span>
                    <input type="date" name="departure" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>Return</label>
                <div class="search-input-wrap">
                    <span class="field-icon">📅</span>
                    <input type="date" name="returnDate" class="search-input"/>
                </div>
            </div>
            <div class="search-field search-btn-wrap">
                <button type="submit" class="search-btn">
                    <span>🔍</span> Search
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ══ POPULAR FLIGHTS ══ -->
<section class="popular-section">
    <h2 class="section-title">Popular Flight Deals on SkyLine Airlines</h2>

    <!-- Filter row -->
    <div class="flight-filter">
        <div class="filter-field">
            <label>From</label>
            <div class="filter-input-wrap">
                <span>📍</span>
                <input type="text" id="filterFrom" placeholder="Input Origin"
                       class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
        <div class="filter-field">
            <label>To</label>
            <div class="filter-input-wrap">
                <span>📍</span>
                <input type="text" id="filterTo" placeholder="Input Destination"
                       class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
    </div>

    <!-- Flight cards from database -->
    <div class="flight-grid" id="flightGrid">
        <c:choose>
            <c:when test="${empty flights}">
                <div class="no-flights">No flights available at the moment.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="f" items="${flights}">
                    <div class="flight-card"
                         data-from="${f.origin_city}"
                         data-to="${f.dest_city}">
                        <div class="flight-card-img">
                            <img src="${pageContext.request.contextPath}/static/images/${f.dest_city}.jpg"
                                 alt="${f.dest_city}"
                                 onerror="this.src='${pageContext.request.contextPath}/static/images/Air.jpg'"/>
                        </div>
                        <div class="flight-card-body">
                            <h3 class="flight-card-title">
                                <c:out value="${f.origin_city}"/> (<c:out value="${f.origin_code}"/>)
                                to
                                <c:out value="${f.dest_city}"/> (<c:out value="${f.dest_code}"/>)
                            </h3>
                            <p class="flight-card-depart">
                                Depart: <c:out value="${f.departure_time}"/>
                            </p>
                            <p class="flight-card-price">
                                NPR <c:out value="${f.base_economy_fare}"/>
                            </p>
                            <p class="flight-card-class">One way &bull; Economy Class</p>
                            <c:choose>
                                <c:when test="${not empty user}">
                                    <a href="${pageContext.request.contextPath}/booking?flightId=${f.flight_id}">
                                        <button class="book-btn">Book Now</button>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login">
                                        <button class="book-btn">Book Now</button>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ══ INFO SECTION ══ -->
<section class="info-section">
    <div class="info-grid">
        <div class="info-col">
            <h3 class="info-heading">About Us</h3>
            <a href="#" class="info-link">About SkyLine</a>
            <a href="#" class="info-link">Information</a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Book &amp; Manage</h3>
            <a href="#" class="info-link">Search Flights</a>
            <a href="#" class="info-link">Manage Booking</a>
            <a href="#" class="info-link">Schedule</a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Where we FLY?</h3>
            <a href="#" class="info-link">Popular Flights</a>
            <a href="#" class="info-link">Partner Airlines</a>
        </div>
        <div class="info-col">
            <h3  class="info-heading">Prepare To Travel</h3>
            <a href="#" class="info-link">Luggage Guidelines</a>
            <a href="#" class="info-link">Airport Information</a>
            <a href="#" class="info-link">First Time Travelers</a>
            <a href="#" class="info-link">Visa &amp; Documents</a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ══ -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 class="footer-logo-img" alt="SkyLine"/>
            <span class="footer-logo-text"><h2>SkyLine</h2></span>
        </div>
        <p class="footer-copy">&copy; 2026 SkyLine Airlines. All Right Reserved</p>
        <div class="footer-social">
            <a href="#" class="social-link">f</a>
            <a href="#" class="social-link">ig</a>
            <a href="#" class="social-link">𝕏</a>
        </div>
    </div>
</footer>

<script>
    // Filter flight cards by from/to input
    function filterCards() {
        const from = document.getElementById("filterFrom").value.toLowerCase();
        const to   = document.getElementById("filterTo").value.toLowerCase();
        const cards = document.querySelectorAll(".flight-card");

        cards.forEach(card => {
            const cardFrom = card.dataset.from.toLowerCase();
            const cardTo   = card.dataset.to.toLowerCase();
            const matchFrom = from === "" || cardFrom.includes(from);
            const matchTo   = to   === "" || cardTo.includes(to);
            card.style.display = (matchFrom && matchTo) ? "block" : "none";
        });
    }

    // Dropdown toggle on click
    document.querySelectorAll(".nav-dropdown").forEach(dropdown => {
        dropdown.addEventListener("click", function(e) {
            e.stopPropagation();
            this.classList.toggle("open");
        });
    });

    document.addEventListener("click", () => {
        document.querySelectorAll(".nav-dropdown").forEach(d => d.classList.remove("open"));
    });
</script>

</body>
</html>
