<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>My Profile — SkyLine</title>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/profile.css"/>
</head>
<body>

<c:if test="${showSuccess || not empty successMsg}">
  <div class="prof-popup-overlay" id="successPopup">
    <div class="prof-popup-box">
      <div class="prof-popup-icon">✅</div>
      <h3 class="prof-popup-title">Success</h3>
      <p class="prof-popup-msg">
        <c:choose>
          <c:when test="${not empty successMsg}"><c:out value="${successMsg}"/></c:when>
          <c:otherwise>Your profile has been updated successfully.</c:otherwise>
        </c:choose>
      </p>
      <button class="prof-popup-close" onclick="closePopup()">Close</button>
    </div>
  </div>
</c:if>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<div class="prof-banner">
  <div class="prof-banner-inner">
    <div class="prof-avatar">
      <c:choose>
        <c:when test="${not empty user.profileImage and user.profileImage != 'default-avatar.png'}">
          <img src="${pageContext.request.contextPath}/uploads/${user.profileImage}"
               alt="Profile Picture"
               style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
        </c:when>
        <c:otherwise>
          <c:set var="nameParts" value="${fn:split(user.fullName, ' ')}"/>
          <c:choose>
            <c:when test="${fn:length(nameParts) >= 2}">
              ${fn:substring(nameParts[0], 0, 1)}${fn:substring(nameParts[1], 0, 1)}
            </c:when>
            <c:otherwise>
              ${fn:substring(user.fullName, 0, 2)}
            </c:otherwise>
          </c:choose>
        </c:otherwise>
      </c:choose>
    </div>
    <h1 class="prof-banner-name"><c:out value="${user.fullName}"/></h1>
  </div>
</div>

<div class="prof-tabs-wrap">
  <div class="prof-tabs">
    <button class="prof-tab active" onclick="showTab('overview', this)">Overview</button>
    <button class="prof-tab"        onclick="showTab('myflights', this)">My Flights</button>
    <button class="prof-tab"        onclick="showTab('settings', this)">Settings</button>
  </div>
</div>

<div class="prof-content">

  <div id="tab-overview" class="prof-tab-panel">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">Personal Information</h2>
        <button class="prof-btn-edit" onclick="toggleEdit()">✏️ Edit</button>
      </div>

      <div id="view-mode" class="prof-info-grid">
        <div class="prof-info-item">
          <span class="prof-info-label">👤 First Name</span>
          <span class="prof-info-value">
            <c:out value="${fn:split(user.fullName, ' ')[0]}"/>
          </span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">👤 Last Name</span>
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
          <span class="prof-info-label">✉️ Email</span>
          <span class="prof-info-value"><c:out value="${user.email}"/></span>
        </div>
        <div class="prof-info-item">
          <span class="prof-info-label">📞 Phone</span>
          <span class="prof-info-value">
            <c:choose>
              <c:when test="${not empty user.phone}"><c:out value="${user.phone}"/></c:when>
              <c:otherwise>—</c:otherwise>
            </c:choose>
          </span>
        </div>
      </div>

      <form id="edit-mode" class="prof-edit-form"
            action="${pageContext.request.contextPath}/profile/update"
            method="post" enctype="multipart/form-data" style="display:none;">

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
          <div class="prof-edit-field">
            <label>Profile Picture</label>
            <input type="file" name="profileImage" accept="image/jpeg,image/png,image/jpg"/>
          </div>
        </div>
        <div class="prof-edit-actions">
          <button type="submit" class="prof-btn-save">Save Changes</button>
          <button type="button" class="prof-btn-cancel" onclick="toggleEdit()">Cancel</button>
        </div>
      </form>
    </div>
  </div>

  <div id="tab-myflights" class="prof-tab-panel" style="display:none;">
    <div class="prof-card">
      <div class="prof-card-header">
        <h2 class="prof-card-title">My Flights</h2>
      </div>
      <div class="prof-empty-state">
        <div class="prof-empty-icon">✈️</div>
        <p>No flights booked yet.</p>
        <a href="${pageContext.request.contextPath}/home" class="prof-btn-book">Book a Flight</a>
      </div>
    </div>
  </div>

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
            <p class="prof-setting-value">PASSENGER</p>
          </div>
        </div>

        <c:if test="${not empty passwordError}">
          <div class="prof-flash-error">❌ <c:out value="${passwordError}"/></div>
        </c:if>
        <c:if test="${not empty deleteError}">
          <div class="prof-flash-error">❌ <c:out value="${deleteError}"/></div>
        </c:if>

        <div class="prof-setting-item">
          <div>
            <p class="prof-setting-label">Change Password</p>
            <p class="prof-setting-sub">Update your account password</p>
          </div>
          <button type="button" class="prof-btn-outline-sm" onclick="openPasswordPopup()">Change</button>
        </div>

        <div class="prof-setting-item danger">
          <div>
            <p class="prof-setting-label">Delete Account</p>
            <p class="prof-setting-sub">Permanently remove your account</p>
          </div>
          <form action="${pageContext.request.contextPath}/profile/delete"
                method="post"
                onsubmit="return confirm('Delete your account permanently? This cannot be undone.');">
            <button type="submit" class="prof-btn-danger-sm">Delete</button>
          </form>
        </div>

      </div>
    </div>
  </div>

</div><div class="prof-popup-overlay" id="passwordPopup">
  <div class="prof-popup-box">
    <h3 class="prof-popup-title">Change Password</h3>
    <form action="${pageContext.request.contextPath}/profile/password"
          method="post" class="prof-password-form">
      <label for="newPassword">New Password</label>
      <input type="password" id="newPassword" name="newPassword" required/>
      <label for="confirmPassword">Re-enter New Password</label>
      <input type="password" id="confirmPassword" name="confirmPassword" required/>
      <div class="prof-popup-actions">
        <button type="submit" class="prof-popup-close">Save</button>
        <button type="button" class="prof-btn-cancel" onclick="closePasswordPopup()">Cancel</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

<script>
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

  function closePopup() {
    const popup = document.getElementById('successPopup');
    if (popup) popup.style.display = 'none';
  }

  function openPasswordPopup() {
    document.getElementById('passwordPopup').style.display = 'flex';
  }

  function closePasswordPopup() {
    document.getElementById('passwordPopup').style.display = 'none';
  }

  window.addEventListener('load', function () {
    const successPopup = document.getElementById('successPopup');
    if (successPopup) successPopup.style.display = 'flex';

    document.getElementById('tab-overview').style.display = 'block';

    const hasPasswordError = ${not empty passwordError};
    const hasDeleteError   = ${not empty deleteError};
    if (hasPasswordError || hasDeleteError) {
      const settingsBtn = document.querySelectorAll('.prof-tab')[2];
      showTab('settings', settingsBtn);
      if (hasPasswordError) openPasswordPopup();
    }
  });
</script>

</body>
</html>