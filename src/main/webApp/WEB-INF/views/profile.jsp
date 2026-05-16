<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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

<c:if test="${showSuccess || not empty successMsg}">
  <div class="prof-popup-overlay" id="successPopup">
    <div class="prof-popup-box">
      <div class="prof-popup-icon">✅</div>
      <h3 class="prof-popup-title">Success</h3>
      <p class="prof-popup-msg"><c:out value="${successMsg != null ? successMsg : 'Profile Updated!'}"/></p>
      <button class="prof-popup-close" onclick="closePopup()">Close</button>
    </div>
  </div>
</c:if>

<header class="prof-header">
  <div class="prof-header-logo">
    <a href="${pageContext.request.contextPath}/home" class="prof-logo-link">
      <img src="${pageContext.request.contextPath}/static/images/logo.png" class="prof-logo-img" alt="SkyLine"/>
      <span class="prof-logo-text">SkyLine</span>
    </a>
  </div>
  <nav class="prof-nav">
    <a href="${pageContext.request.contextPath}/home" class="prof-nav-link">Book Flights</a>
    <a href="${pageContext.request.contextPath}/home" class="prof-nav-link">Flights</a>
    <a href="${pageContext.request.contextPath}/profile" class="prof-nav-link active">My Profile</a>
  </nav>
  <a href="${pageContext.request.contextPath}/logout" class="prof-btn-logout">⎋ Logout</a>
</header>

<div class="prof-banner">
  <div class="prof-banner-inner">
    <div class="prof-avatar">
      <c:choose>
        <c:when test="${not empty user.profileImage and user.profileImage != 'default-avatar.png'}">
          <img src="${pageContext.request.contextPath}/uploads/${user.profileImage}"
               alt="Profile" style="width:100%;height:100%;object-fit:cover;border-radius:50%;">
        </c:when>
        <c:otherwise>
          <c:set var="nameParts" value="${fn:split(user.fullName, ' ')}"/>
          ${fn:length(nameParts) >= 2 ?
            fn:substring(nameParts[0], 0, 1).concat(fn:substring(nameParts[1], 0, 1)) :
            fn:substring(user.fullName, 0, 2)}
        </c:otherwise>
      </c:choose>
    </div>
    <h1 class="prof-banner-name"><c:out value="${user.fullName}"/></h1>
  </div>
</div>

<div class="prof-tabs-wrap">
  <div class="prof-tabs">
    <button class="prof-tab active" onclick="showTab('overview', this)">Overview</button>
    <button class="prof-tab" onclick="showTab('myflights', this)">My Flights</button>
    <button class="prof-tab" onclick="showTab('settings', this)">Settings</button>
  </div>
</div>

<div class="prof-content">

  <div id="tab-overview" class="prof-tab-panel active">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">Personal Information</h2>
        <button class="prof-btn-edit" onclick="toggleEdit()">✏️ Edit</button>
      </div>

      <div id="view-mode" class="prof-info-grid">
        <div class="prof-info-item">
          <span class="prof-info-label">First Name</span>
          <span class="prof-info-value"><c:out value="${fn:split(user.fullName, ' ')[0]}"/></span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">Last Name</span>
          <span class="prof-info-value">
            <c:choose>
              <c:when test="${fn:length(fn:split(user.fullName, ' ')) >= 2}">
                <c:out value="${fn:split(user.fullName, ' ')[1]}"/>
              </c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">Email</span>
          <span class="prof-info-value"><c:out value="${user.email}"/></span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">Phone</span>
          <span class="prof-info-value"><c:out value="${user.phone}" default="—"/></span>
        </div>
      </div>

      <form id="edit-mode" class="prof-edit-form"
            action="${pageContext.request.contextPath}/profile/update"
            method="post" enctype="multipart/form-data" style="display:none;">

        <div class="prof-edit-grid">
          <div class="prof-edit-field">
            <label>First Name</label>
            <input type="text" name="firstName" value="<c:out value='${fn:split(user.fullName, " ")[0]}'/>" required/>
          </div>
          <div class="prof-edit-field">
            <label>Last Name</label>
            <input type="text" name="lastName" value="<c:out value='${fn:length(fn:split(user.fullName, " ")) >= 2 ? fn:split(user.fullName, " ")[1] : ""}'/>"/>
          </div>
          <div class="prof-edit-field">
            <label>Email</label>
            <input type="email" name="email" value="<c:out value='${user.email}'/>" required/>
          </div>
          <div class="prof-edit-field">
            <label>Phone</label>
            <input type="tel" name="phone" value="<c:out value='${user.phone}'/>"/>
          </div>
          <div class="prof-edit-field">
            <label>Profile Picture</label>
            <input type="file" name="profileImage" accept="image/*"/>
          </div>
        </div>

        <div class="prof-edit-actions">
          <button type="submit" class="prof-btn-save">Save Changes</button>
          <button type="button" class="prof-btn-cancel" onclick="toggleEdit()">Cancel</button>
        </div>
      </form>
    </div>
  </div>

</div>

<footer class="prof-footer">
  <div class="prof-footer-inner">
    <div class="prof-footer-logo">
      <img src="${pageContext.request.contextPath}/static/images/logo.png" class="prof-footer-logo-img" alt="SkyLine"/>
      <span class="prof-footer-logo-text">SkyLine</span>
    </div>
    <p class="prof-footer-copy">&copy; 2026 SkyLine Airlines. All rights reserved.</p>
    <div class="prof-footer-social">
      <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/facebook.png" alt="Facebook" width="20"/></a>
      <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/twitter.png" alt="Twitter" width="20"/></a>
      <a href="#" class="prof-social-link" target="_blank"><img src="${pageContext.request.contextPath}/static/images/instagram.png" alt="Instagram" width="20"/></a>
    </div>
  </div>
</footer>

<script>
  function closePopup() {
    const popup = document.getElementById('successPopup');
    if (popup) popup.style.display = 'none';
  }

  function showTab(tabId, btn) {
    document.querySelectorAll('.prof-tab-panel').forEach(p => p.style.display = 'none');
    document.querySelectorAll('.prof-tab').forEach(t => t.classList.remove('active'));
    document.getElementById('tab-' + tabId).style.display = 'block';
    btn.classList.add('active');
  }

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

  window.addEventListener('load', function () {
    const popup = document.getElementById('successPopup');
    if (popup) popup.style.display = 'flex';
  });
</script>

</body>
</html>