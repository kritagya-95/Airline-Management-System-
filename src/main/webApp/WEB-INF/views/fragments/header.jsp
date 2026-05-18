<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="header">
  <div class="header-logo">
    <a href="${pageContext.request.contextPath}/" class="logo-link">
      <span class="logo-text"><h1>SkyLine</h1></span>
    </a>
  </div>

  <nav class="nav-links">
    <div class="nav-dropdown">
      <a href="#" class="nav-link"><h2>Book</h2> <span class="arrow">▾</span></a>
      <div class="dropdown-menu">
        <a href="${pageContext.request.contextPath}/book-flight">Book a Flight</a>
        <a href="${pageContext.request.contextPath}/public-schedule">Flight Schedule</a>
        <a href="${pageContext.request.contextPath}/add-ons">Add-ons</a>
        <a href="${pageContext.request.contextPath}/seat-selection">Seat Selection</a>
      </div>
    </div>

    <div class="nav-dropdown">
      <a href="#" class="nav-link"><h2>Manage</h2> <span class="arrow">▾</span></a>
      <div class="dropdown-menu">
        <a href="${pageContext.request.contextPath}/my-bookings">My Bookings</a>
        <a href="${pageContext.request.contextPath}/cancel-booking">Cancel Booking</a>
        <a href="${pageContext.request.contextPath}/flight-schedule">My Flight Schedule</a>
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

    <div class="nav-dropdown">
      <a href="#" class="nav-link"><h2>Prepare</h2> <span class="arrow">▾</span></a>
      <div class="dropdown-menu">
        <a href="${pageContext.request.contextPath}/prepare/luggage">Luggage Guidelines</a>
        <a href="${pageContext.request.contextPath}/prepare/airport-info">Airport Information</a>
        <a href="${pageContext.request.contextPath}/prepare/first-time">First Time Travelers</a>
        <a href="${pageContext.request.contextPath}/prepare/visa-docs">Visa & Documents</a>
      </div>
    </div>
  </nav>

  <div class="header-right">
    <div class="header-search">
      <span class="search-icon"></span>
      <input type="text"
             id="globalHeaderSearch"
             placeholder="Search city or airline..."
             class="header-search-input"
             value="<c:out value='${param.query}'/>"
             onkeypress="handleHeaderSearch(event)"/>
    </div>
    <div class="header-auth">
      <c:choose>
        <c:when test="${not empty user}">
          <a href="${pageContext.request.contextPath}/profile" class="welcome-text-link">👤 <c:out value="${user.fullName}"/></a>
          <a href="${pageContext.request.contextPath}/logout" class="btn-header-login">Log Out</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="btn-header-login">Log In</a>
          <a href="${pageContext.request.contextPath}/register" class="btn-header-signup">Sign Up</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<script>
  function handleHeaderSearch(event) {
    if (event.key === 'Enter' || event.keyCode === 13) {
      const searchInput = document.getElementById('globalHeaderSearch');
      if (searchInput) {
        const queryVal = searchInput.value.trim();
        if (queryVal.length > 0) {
          window.location.href = '${pageContext.request.contextPath}/search-flights?query=' + encodeURIComponent(queryVal);
        }
      }
    }
  }
</script>