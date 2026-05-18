<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<section class="info-section">
    <div class="info-grid">
        <div class="info-col">
            <h3 class="info-heading">About Us</h3>
            <a href="${pageContext.request.contextPath}/aboutus-airline" class="info-link"><h4>About SkyLine</h4></a>
            <a href="${pageContext.request.contextPath}/information" class="info-link"><h4>Information</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Book &amp; Manage</h3>
            <a href="${pageContext.request.contextPath}/search-flights" class="info-link"><h4>Search Flights</h4></a>
            <a href="${pageContext.request.contextPath}/my-bookings" class="info-link"><h4>Manage Booking</h4></a>
            <a href="${pageContext.request.contextPath}/flight-schedule" class="info-link"><h4>Schedule</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Where we FLY?</h3>
            <a href="${pageContext.request.contextPath}/popular-routes" class="info-link"><h4>Popular Flights</h4></a>
            <a href="${pageContext.request.contextPath}/partner-airlines" class="info-link"><h4>Partner Airlines</h4></a>
        </div>
        <div class="info-col">
            <h3 class="info-heading">Prepare To Travel</h3>
            <a href="${pageContext.request.contextPath}/luggage-guidelines" class="info-link"><h4>Luggage Guidelines</h4></a>
            <a href="${pageContext.request.contextPath}/airport-information" class="info-link"><h4>Airport Information</h4></a>
            <a href="${pageContext.request.contextPath}/visa-documents" class="info-link"><h4>Visa & Documents</h4></a>
        </div>
    </div>
</section>

<footer class="prof-footer">
    <div class="prof-footer-inner">
        <div class="prof-footer-logo">
            <span class="prof-footer-logo-text">SkyLine</span>
        </div>
        <p class="prof-footer-copy">&copy; 2026 SkyLine Airlines. All rights reserved.</p>
        <div class="prof-footer-social">
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/facebook.png" alt="Facebook" width="20"/>
            </a>
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/twitter.png" alt="Twitter" width="20"/>
            </a>
            <a href="#" class="prof-social-link" target="_blank">
                <img src="${pageContext.request.contextPath}/static/images/instagram.png" alt="Instagram" width="20"/>
            </a>
        </div>
    </div>
</footer>

<script>
    document.querySelectorAll(".nav-dropdown").forEach(dd => {
        dd.addEventListener("click", function(e) {
            e.stopPropagation();
            this.classList.toggle("open");
        });
    });

    document.addEventListener("click", () => {
        document.querySelectorAll(".nav-dropdown").forEach(d => d.classList.remove("open"));
    });
</script>