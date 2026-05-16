<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Staff Profile — SkyLine</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/staff-profile.css"/>
</head>
<body>

<header class="prof-header">
    <div class="prof-header-logo">
        <a href="${pageContext.request.contextPath}/staff/dashboard">
            <img src="${pageContext.request.contextPath}/static/images/logo.png" class="prof-logo-img" alt="SkyLine"/>
            <span class="prof-logo-text">SkyLine</span>
        </a>
    </div>
    <nav class="prof-nav">
        <a href="${pageContext.request.contextPath}/staff/dashboard" class="prof-nav-link">Dashboard</a>
        <a href="${pageContext.request.contextPath}/staff/profile" class="prof-nav-link active">My Profile</a>
    </nav>
    <a href="${pageContext.request.contextPath}/logout" class="prof-btn-logout">Logout</a>
</header>

<div class="prof-banner staff-banner">
    <div class="prof-avatar">
        <c:choose>
            <c:when test="${not empty user.profileImage and user.profileImage != 'default-avatar.png'}">
                <img src="${pageContext.request.contextPath}/uploads/${user.profileImage}"
                     alt="Profile" style="width:100%;height:100%;object-fit:cover;border-radius:50%;">
            </c:when>
            <c:otherwise>
                ${fn:substring(user.fullName, 0, 2)}
            </c:otherwise>
        </c:choose>
    </div>
    <h1><c:out value="${user.fullName}"/></h1>
    <p class="role-badge staff">STAFF MEMBER</p>
</div>

<div class="prof-main-content">
    <div class="prof-card">
        <div class="prof-card-header">
            <h2>Personal & Employment Information</h2>
            <button class="prof-btn-edit" onclick="toggleEdit()">✏️ Edit Profile</button>
        </div>

        <div id="view-mode" class="prof-info-grid">
            <div class="prof-info-item"><span class="label">Full Name</span><span><c:out value="${user.fullName}"/></span></div>
            <div class="prof-info-item"><span class="label">Email</span><span><c:out value="${user.email}"/></span></div>
            <div class="prof-info-item"><span class="label">Phone</span><span><c:out value="${user.phone}" default="Not Provided"/></span></div>
            <!-- Add other fields as needed -->
        </div>

        <form id="edit-mode" class="prof-edit-form"
              action="${pageContext.request.contextPath}/staff/profile/update"
              method="post" enctype="multipart/form-data" style="display:none;">

            <div class="prof-edit-grid">
                <div class="prof-edit-field">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="<c:out value='${user.fullName}'/>" required/>
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

<script>
    function toggleEdit() {
        const view = document.getElementById('view-mode');
        const edit = document.getElementById('edit-mode');
        if (edit.style.display === 'none') {
            view.style.display = 'none';
            edit.style.display = 'block';
        } else {
            view.style.display = 'grid';
            edit.style.display = 'none';
        }
    }
</script>
</body>
</html>