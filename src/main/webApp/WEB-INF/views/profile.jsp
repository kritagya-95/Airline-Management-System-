<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Profile — SkyLine</title>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/profile.css"/>
</head>
<body>

<!-- ══ HEADER ══ -->
<header class="prof-header">
  <div class="prof-header-logo">
    <a href="${pageContext.request.contextPath}/home" class="prof-logo-link">
      <img src="${pageContext.request.contextPath}/static/images/logo.png"
           class="prof-logo-img" alt="SkyLine"/>
      <span class="prof-logo-text">SkyLine</span>
    </a>
  </div>

  <nav class="prof-nav">
    <a href="${pageContext.request.contextPath}/home"    class="prof-nav-link">Book Flights</a>
    <a href="${pageContext.request.contextPath}/home"    class="prof-nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/profile" class="prof-nav-link active">My Profile</a>
  </nav>

  <a href="${pageContext.request.contextPath}/logout" class="prof-btn-logout">
    ⎋ Logout
  </a>
</header>

<!-- ══ PROFILE BANNER ══ -->
<div class="prof-banner">
  <div class="prof-banner-inner">
    <%-- Generate initials from full name --%>
    <div class="prof-avatar">
      <c:set var="nameParts" value="${fn:split(user.fullName, ' ')}"/>
      <c:choose>
        <c:when test="${fn:length(nameParts) >= 2}">
          ${fn:substring(nameParts[0], 0, 1)}${fn:substring(nameParts[1], 0, 1)}
        </c:when>
        <c:otherwise>
          ${fn:substring(user.fullName, 0, 2)}
        </c:otherwise>
      </c:choose>
    </div>
    <h1 class="prof-banner-name">
      <c:out value="${user.fullName}"/>
    </h1>
  </div>
</div>

<!-- ══ TABS ══ -->
<div class="prof-tabs-wrap">
  <div class="prof-tabs">
    <button class="prof-tab active" onclick="showTab('overview', this)">Overview</button>
    <button class="prof-tab"        onclick="showTab('myflights', this)">My Flights</button>
    <button class="prof-tab"        onclick="showTab('settings', this)">Settings</button>
  </div>
</div>

<!-- ══ TAB CONTENT ══ -->
<div class="prof-content">

  <!-- OVERVIEW TAB -->
  <div id="tab-overview" class="prof-tab-panel active">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">Personal Information</h2>
        <button class="prof-btn-edit" onclick="toggleEdit()">✏️ Edit</button>
      </div>

      <!-- VIEW MODE -->
      <div id="view-mode" class="prof-info-grid">
        <div class="prof-info-item">
          <span class="prof-info-label">👤 First Name</span>
          <span class="prof-info-value" id="view-firstname">
                        <%-- Split full name to get first name --%>
                        <c:out value="${fn:split(user.fullName, ' ')[0]}"/>
                    </span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">👤 Last Name</span>
          <span class="prof-info-value" id="view-lastname">
                        <c:choose>
                          <c:when test="${fn:length(fn:split(user.fullName, ' ')) >= 2}">
                            <c:out value="${fn:split(user.fullName, ' ')[1]}"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">✉️ Email</span>
          <span class="prof-info-value"><c:out value="${user.email}"/></span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">📞 Phone</span>
          <span class="prof-info-value">
                        <c:choose>
                          <c:when test="${not empty user.phone}">
                            <c:out value="${user.phone}"/>
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
        </div>
      </div>

      <!-- EDIT MODE (hidden by default) -->
      <form id="edit-mode" class="prof-edit-form"
            action="${pageContext.request.contextPath}/profile/update"
            method="post" style="display:none;">

        <c:if test="${not empty successMsg}">
          <div class="prof-flash-success">✅ <c:out value="${successMsg}"/></div>
        </c:if>
        <c:if test="${not empty errorMsg}">
          <div class="prof-flash-error">❌ <c:out value="${errorMsg}"/></div>
        </c:if>

        <div class="prof-edit-grid">
          <div class="prof-edit-field">
            <label>First Name</label>
            <input type="text" name="firstName"
                   value="<c:out value='${fn:split(user.fullName, " ")[0]}'/>"
                   required/>
          </div>
          <div class="prof-edit-field">
            <label>Last Name</label>
            <input type="text" name="lastName"
                   value="<c:choose>
                                   <c:when test='${fn:length(fn:split(user.fullName, \" \")) >= 2}'>${fn:split(user.fullName, ' ')[1]}</c:when>
                                   <c:otherwise></c:otherwise>
                               </c:choose>"/>
          </div>
          <div class="prof-edit-field">
            <label>Email</label>
            <input type="email" name="email"
                   value="<c:out value='${user.email}'/>" required/>
          </div>
          <div class="prof-edit-field">
            <label>Phone</label>
            <input type="tel" name="phone"
                   value="<c:out value='${user.phone}'/>"/>
          </div>
        </div>
        <div class="prof-edit-actions">
          <button type="submit" class="prof-btn-save">Save Changes</button>
          <button type="button" class="prof-btn-cancel"
                  onclick="toggleEdit()">Cancel</button>
        </div>
      </form>
    </div>
  </div>

  <!-- MY FLIGHTS TAB -->
  <div id="tab-myflights" class="prof-tab-panel" style="display:none;">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">My Flights</h2>
      </div>
      <div class="prof-empty-state">
        <div class="prof-empty-icon">✈️</div>
        <p>No flights booked yet.</p>
        <a href="${pageContext.request.contextPath}/home"
           class="prof-btn-book">Book a Flight</a>
      </div>
    </div>
  </div>

  <!-- SETTINGS TAB -->
  <div id="tab-settings" class="prof-tab-panel" style="display:none;">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">Settings</h2>
      </div>
      <div class="prof-settings-list">
        <div class="prof-setting-item">
          <div>
            <p class="prof-setting-label">Account Status</p>
            <p class="prof-setting-value">
                            <span class="prof-status-badge ${user.status.toLowerCase()}">
                                <c:out value="${user.status}"/>
                            </span>
            </p>
          </div>
        </div>
        <div class="prof-setting-item">
          <div>
            <p class="prof-setting-label">Role</p>
            <p class="prof-setting-value"><c:out value="${user.role}"/></p>
          </div>
        </div>
        <div class="prof-setting-item">
          <div>
            <p class="prof-setting-label">Change Password</p>
            <p class="prof-setting-sub">Update your account password</p>
          </div>
          <button class="prof-btn-outline-sm">Change</button>
        </div>
        <div class="prof-setting-item danger">
          <div>
            <p class="prof-setting-label">Delete Account</p>
            <p class="prof-setting-sub">Permanently remove your account</p>
          </div>
          <button class="prof-btn-danger-sm">Delete</button>
        </div>
      </div>
    </div>
  </div>

</div>

<!-- ══ INFO SECTION ══ -->
<section class="prof-info-section">
  <div class="prof-info-footer-grid">
    <div class="prof-info-col">
      <h4 class="prof-info-heading">About Us</h4>
      <a href="#" class="prof-info-link">About SkyLine</a>
      <a href="#" class="prof-info-link">Newsroom</a>
      <a href="#" class="prof-info-link">Corporate Information</a>
      <a href="#" class="prof-info-link">Tenders</a>
      <a href="#" class="prof-info-link">Careers</a>
    </div>
    <div class="prof-info-col">
      <h4 class="prof-info-heading">Book &amp; Manage</h4>
      <a href="#" class="prof-info-link">Search Flights</a>
      <a href="#" class="prof-info-link">Manage Booking</a>
      <a href="#" class="prof-info-link">Flight Schedule</a>
      <a href="#" class="prof-info-link">Cargo</a>
    </div>
    <div class="prof-info-col">
      <h4 class="prof-info-heading">Where We Fly?</h4>
      <a href="#" class="prof-info-link">Route Map</a>
      <a href="#" class="prof-info-link">Nonstop Flights</a>
      <a href="#" class="prof-info-link">Popular Flights</a>
      <a href="#" class="prof-info-link">Partner Airlines</a>
    </div>
    <div class="prof-info-col">
      <h4 class="prof-info-heading">Prepare To Travel</h4>
      <a href="#" class="prof-info-link">Baggage Guidelines</a>
      <a href="#" class="prof-info-link">Airport Information</a>
      <a href="#" class="prof-info-link">First-time Travellers</a>
      <a href="#" class="prof-info-link">Visas &amp; Documents</a>
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
  // Tab switching
  function showTab(tabId, btn) {
    document.querySelectorAll('.prof-tab-panel').forEach(p => p.style.display = 'none');
    document.querySelectorAll('.prof-tab').forEach(t => t.classList.remove('active'));
    document.getElementById('tab-' + tabId).style.display = 'block';
    btn.classList.add('active');
  }

  // Toggle edit mode
  function toggleEdit() {
    const viewMode = document.getElementById('view-mode');
    const editMode = document.getElementById('edit-mode');
    if (editMode.style.display === 'none') {
      viewMode.style.display = 'none';
      editMode.style.display = 'block';
    } else {
      viewMode.style.display = 'grid';
      editMode.style.display = 'none';
    }
  }
</script>

</body>
</html>
