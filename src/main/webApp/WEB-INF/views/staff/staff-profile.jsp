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
    <style>
        /* Inline override to bypass any caching issues */
        .prof-banner {
            background: linear-gradient(135deg, #8B0000, #5C0000);
            color: white;
            padding: 20px 40px !important;
            text-align: left !important;
        }
        .prof-banner-inner {
            display: flex !important;
            align-items: center !important;
            gap: 20px !important;
            max-width: 900px;
            margin: 0 auto;
        }
        .prof-banner-text h1 {
            font-size: 22px;
            font-weight: 700;
            color: white;
            margin-bottom: 6px;
        }
        .avatar-circle {
            width: 60px !important;
            height: 60px !important;
            min-width: 60px !important;
            min-height: 60px !important;
            max-width: 60px !important;
            max-height: 60px !important;
            border-radius: 50% !important;
            overflow: hidden !important;
            flex-shrink: 0 !important;
            background: rgba(255,255,255,0.25);
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            font-size: 18px;
            font-weight: bold;
            color: white;
            border: 3px solid rgba(255,255,255,0.4);
        }
        .avatar-circle img {
            width: 60px !important;
            height: 60px !important;
            object-fit: cover !important;
            border-radius: 50% !important;
            display: block !important;
        }
    </style>
</head>
<body>

<!-- HEADER -->
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

<!-- SUCCESS FLASH -->
<c:if test="${showSuccess}">
    <div style="background:#E3F9E5;color:#1a6e2e;border:1px solid #1a6e2e;border-radius:8px;
                padding:12px 20px;margin:16px 40px;font-size:14px;font-weight:500;">
        ✅ Profile updated successfully.
    </div>
</c:if>
<c:if test="${not empty errorMsg}">
    <div style="background:#FDE8E8;color:#8B0000;border:1px solid #8B0000;border-radius:8px;
                padding:12px 20px;margin:16px 40px;font-size:14px;font-weight:500;">
        ❌ <c:out value="${errorMsg}"/>
    </div>
</c:if>

<!-- BANNER -->
<div class="prof-banner">
    <div class="prof-banner-inner">
        <div class="avatar-circle">
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
        <div class="prof-banner-text">
            <h1><c:out value="${user.fullName}"/></h1>
            <p class="role-badge staff">STAFF MEMBER</p>
        </div>
    </div>
</div>

<!-- MAIN CONTENT -->
<div class="prof-main-content">
    <div class="prof-card">
        <div class="prof-card-header">
            <h2>Personal &amp; Employment Information</h2>
            <button class="prof-btn-edit" onclick="toggleEdit()">✏️ Edit Profile</button>
        </div>

        <!-- VIEW MODE -->
        <div id="view-mode" class="prof-info-grid">
            <div class="prof-info-item">
                <span class="label">Full Name</span>
                <span><c:out value="${user.fullName}"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Email</span>
                <span><c:out value="${user.email}"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Phone</span>
                <span><c:out value="${user.phone}" default="Not Provided"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Employee Code</span>
                <span><c:out value="${staff != null ? staff.employeeCode : 'N/A'}"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Designation</span>
                <span><c:out value="${staff != null ? staff.designation : 'N/A'}"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Department</span>
                <span><c:out value="${staff != null ? staff.department : 'N/A'}"/></span>
            </div>
            <div class="prof-info-item">
                <span class="label">Hire Date</span>
                <span><c:out value="${staff != null ? staff.hireDate : 'N/A'}"/></span>
            </div>
        </div>

        <!-- EDIT FORM -->
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
