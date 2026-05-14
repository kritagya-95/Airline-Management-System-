<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>My Profile - SkyLine Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700&family=Chivo:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin-profile.css"/>
</head>
<body>

<div class="admin-profile-container">

    <!-- Top Navigation -->
    <header class="admin-top-nav">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="SkyLine"/>
            <span>SKYLINE</span>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/profile" class="active">My Profile</a>
        </nav>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </header>

    <!-- Red Banner -->
    <div class="profile-banner">
        <div class="avatar-circle">
            ${fn:substring(user.fullName, 0, 2)}
        </div>
        <h1><c:out value="${user.fullName}"/></h1>
    </div>

    <!-- Main Content -->
    <div class="profile-content">
        <div class="tabs">
            <button class="tab active">Overview</button>
           <!-- <button class="tab">Settings</button>-->
        </div>

        <div class="info-card">
            <div class="card-header">
                <h2>Personal Information</h2>
                <button class="edit-btn" onclick="toggleEdit()">
                    <span>✏️</span> Edit
                </button>
            </div>

            <!-- View Mode -->
            <div id="view-mode" class="info-grid">
                <div class="info-row">
                    <span class="info-label">First Name</span>
                    <span class="info-value"><c:out value="${fn:split(user.fullName, ' ')[0]}"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Last Name</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${fn:length(fn:split(user.fullName, ' ')) > 1}">
                                <c:out value="${fn:split(user.fullName, ' ')[1]}"/>
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email</span>
                    <span class="info-value"><c:out value="${user.email}"/></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phone</span>
                    <span class="info-value"><c:out value="${user.phone}" default="Not Provided"/></span>
                </div>
            </div>

            <!-- Edit Mode -->
            <form id="edit-mode" class="edit-form" action="${pageContext.request.contextPath}/admin/profile/update" method="post" style="display: none;">
                <div class="info-grid">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" value="<c:out value='${user.fullName}'/>" required/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" value="<c:out value='${user.email}'/>" required/>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="tel" name="phone" value="<c:out value='${user.phone}'/>"/>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="save-btn">Save Changes</button>
                    <button type="button" class="cancel-btn" onclick="toggleEdit()">Cancel</button>
                </div>
            </form>
        </div>
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
            view.style.display = 'block';
            edit.style.display = 'none';
        }
    }
</script>
</body>
</html>