<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
        <span class="logo-text"><h1>SkyLine</h1></span>
    </div>

    <nav class="nav-links">
        <div class="nav-dropdown">
            <a href="#" class="nav-link"><h2>Book</h2> <span class="arrow">▾</span></a>
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
                <a href="${pageContext.request.contextPath}/popular-routes">Popular Routes</a>
                <a href="${pageContext.request.contextPath}/partner-airlines">Partner Airlines</a>
                <a href="${pageContext.request.contextPath}/travel-guide">Travel Guide</a>
            </div>
        </div>
    </nav>

    <div class="header-right">
        <div class="header-search">
            <span class="search-icon"></span>
            <input type="text" placeholder="Search" class="header-search-input"/>
        </div>
        <div class="header-auth">
            <c:choose>
                <c:when test="${not empty user}">
                    <a href="${pageContext.request.contextPath}/profile"
                       class="welcome-text-link">👤 <c:out value="${user.fullName}"/></a>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn-header-login">Log Out</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"
                       class="btn-header-login">Log In</a>
                    <a href="${pageContext.request.contextPath}/register"
                       class="btn-header-signup">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<!-- ══ HERO ══ -->
<section class="hero">
    <div class="hero-overlay"></div>
    <div class="hero-content">
        <h1>Planning Your Family Trip</h1>
        <h1>Fly Better, Fly With US</h1>
    </div>
</section>

<!-- ══ SEARCH BOX ══ -->
<div class="search-container">
    <div class="search-box">
        <h1 class="search-title">Search and Book for Our FLIGHTS online</h1>
        <form class="search-form" action="${pageContext.request.contextPath}/flights" method="get">
            <div class="search-field">
                <label>From</label>
                <div class="search-input-wrap">
                    <span class="field-icon"></span>
                    <input type="text" name="from"
                           placeholder="Select Origin" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>To</label>
                <div class="search-input-wrap">
                    <span class="field-icon"></span>
                    <input type="text" name="to"
                           placeholder="Select Destination" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>Departure</label>
                <div class="search-input-wrap">
                    <span class="field-icon"></span>
                    <input type="date" name="departure" class="search-input"/>
                </div>
            </div>
            <div class="search-field">
                <label>Return</label>
                <div class="search-input-wrap">
                    <span class="field-icon"></span>
                    <input type="date" name="returnDate" class="search-input"/>
                </div>
            </div>
            <div class="search-field search-btn-wrap">
                <button type="submit" class="search-btn">
                    Search
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ══ POPULAR FLIGHTS ══ -->
<section class="popular-section">
    <h2 class="section-title">Popular Flight Deals on SkyLine Airlines</h2>

    <div class="flight-filter">
        <div class="filter-field">
            <label>From</label>
            <div class="filter-input-wrap">
                <span></span>
                <input type="text" id="filterFrom" placeholder="Input Origin"
                       class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
        <div class="filter-field">
            <label>To</label>
            <div class="filter-input-wrap">
                <span></span>
                <input type="text" id="filterTo" placeholder="Input Destination"
                       class="filter-input" oninput="filterCards()"/>
            </div>
        </div>
    </div>

    <div class="flight-grid" id="flightGrid">
        <c:choose>
            <c:when test="${empty flights}">
                <div class="no-flights">No flights available at the moment.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="f" items="${flights}">
                    <article class="flight-card"
                             data-from="${f.origin_city} ${f.origin_code}"
                             data-to="${f.dest_city} ${f.dest_code}">
                        <div class="flight-card-img">
                            <c:choose>
                                <c:when test="${f.origin_city == 'Kathmandu' && f.dest_city == 'New Delhi'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Delhi.jpg" alt="Delhi">
                                </c:when>
                                <c:when test="${f.origin_city == 'New Delhi' && f.dest_city == 'Kathmandu'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Kathmandu.jpg" alt="Kathmandu">
                                </c:when>
                                <c:when test="${f.dest_city == 'Dubai'}">
                                    <img src="${pageContext.request.contextPath}/static/images/dubai.jpg" alt="Dubai">
                                </c:when>
                                <c:when test="${f.dest_city == 'London'}">
                                    <img src="${pageContext.request.contextPath}/static/images/london.jpg" alt="London">
                                </c:when>
                                <c:when test="${f.dest_city == 'Rome'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Rome.jpg" alt="Rome">
                                </c:when>
                                <c:when test="${f.dest_city == 'Madrid'}">
                                    <img src="${pageContext.request.contextPath}/static/images/madrid.jpg" alt="Madrid">
                                </c:when>
                                <c:when test="${f.dest_city == 'Frankfurt'}">
                                    <img src="${pageContext.request.contextPath}/static/images/Frankfurt.jpg" alt="Frankfurt">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/static/images/Air.jpg" alt="Flight">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flight-card-body">
                            <h3 class="flight-card-title">
                                <c:out value="${f.origin_city}"/>
                                (<c:out value="${f.origin_code}"/>)
                                to
                                <c:out value="${f.dest_city}"/>
                                (<c:out value="${f.dest_code}"/>)
                            </h3>
                            <p class="flight-card-depart">
                                Depart: <c:out value="${f.departure_time}"/>
                            </p>
                            <p class="flight-card-price">
                                NPR <fmt:formatNumber value="${f.base_economy_fare}" pattern="#,##0.00"/>
                            </p>
                            <p class="flight-card-class">
                                One way &bull; Economy Class
                            </p>
                            <c:choose>
                                <c:when test="${not empty user}">
                                    <a class="book-btn" href="${pageContext.request.contextPath}/booking?flightId=${f.flight_id}">
                                        Book Now
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="book-btn" href="${pageContext.request.contextPath}/login">
                                        Book Now
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
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
            <a href="${pageContext.request.contextPath}/aboutus-airline" class="info-link"><h4>About SkyLine</h4></a>
            <a href="${pageContext.request.contextPath}/information" class="info-link"><h4>Information</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Book &amp; Manage</h3>
            <a href="#" class="info-link"><h4>Search Flights</h4></a>
            <a href="#" class="info-link"><h4>Manage Booking</h4></a>
            <a href="#" class="info-link"><h4>Schedule</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Where we FLY?</h3>
            <a href="${pageContext.request.contextPath}/popular-routes" class="info-link"><h4>Popular Flights</h4></a>
            <a href="${pageContext.request.contextPath}/partner-airlines" class="info-link"><h4>Partner Airlines</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Prepare To Travel</h3>
            <a href="#" class="info-link"><h4>Luggage Guidelines</h4></a>
            <a href="#" class="info-link"><h4>Airport Information</h4></a>
            <a href="#" class="info-link"><h4>First Time Travelers</h4></a>
            <a href="#" class="info-link"><h4>Visa &amp; Documents</h4></a>
        </div>
    </div>
</section>

<!-- ══ FOOTER ══ -->
<footer class="prof-footer">
    <div class="prof-footer-inner">
        <div class="prof-footer-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 class="prof-footer-logo-img" alt="SkyLine"/>
            <span class="prof-footer-logo-text">SkyLine</span>
        </div>
        <p class="prof-footer-copy">&copy; 2026 SkyLine Airlines. All rights reserved.</p>
        <div class="prof-footer-social">
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/facebook.png"
                     alt="Facebook" width="20"/>
            </a>
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/twitter.png"
                     alt="Twitter" width="20"/>
            </a>
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/instagram.png"
                     alt="Instagram" width="20"/>
            </a>
        </div>
    </div>
</footer>
<script>
    function filterCards() {
        const from  = document.getElementById("filterFrom").value.toLowerCase();
        const to    = document.getElementById("filterTo").value.toLowerCase();
        const cards = document.querySelectorAll(".flight-card");
        cards.forEach(card => {
            const cf = card.dataset.from.toLowerCase();
            const ct = card.dataset.to.toLowerCase();
            card.style.display =
                (from === "" || cf.includes(from)) &&
                (to   === "" || ct.includes(to))
                    ? "block" : "none";
        });
    }

    document.querySelectorAll(".nav-dropdown").forEach(dd => {
        dd.addEventListener("click", function(e) {
            e.stopPropagation();
            this.classList.toggle("open");
        });
    });

    document.addEventListener("click", () => {
        document.querySelectorAll(".nav-dropdown").forEach(d =>
            d.classList.remove("open"));
    });
</script>

</body>
</html>
