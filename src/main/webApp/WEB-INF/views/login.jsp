<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkyLine - Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/auth.css" />
</head>

<body>
<div class="auth-page">

    <!-- Left Panel - Branding -->
    <div class="auth-left">
        <div class="logo">
            <!--logo.png -->
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine Logo"
                 class="logo-image" />
        </div>

        <h2>WELCOME TO SKYLINE</h2>
        <p class="tagline">YOUR JOURNEY STARTS HERE</p>
        <p class="description">
            Join millions of travelers and unlock your exclusive benefits with us
        </p>
    </div>

    <!-- Right Panel - Login Form -->
    <div class="auth-form">
        <form action="${pageContext.request.contextPath}/login" method="post">
            <h2>Log In</h2>

            <c:if test="${not empty error}">
                <p class="error"><c:out value="${error}" /></p>
            </c:if>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email"
                       name="email"
                       placeholder="Your Email Address"
                       value="<c:out value='${param.email}' default='' />"
                       required />
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="password-wrapper">
                    <input type="password"
                           name="password"
                           id="passwordField"
                           placeholder="Password"
                           required />
                    <span class="toggle-password" onclick="togglePassword()">👁</span>
                </div>
            </div>

            <button type="submit" class="btn-login">Log In</button>

            <p class="link">
                Not a member yet?
                <a href="${pageContext.request.contextPath}/register">Register Now</a>
            </p>
        </form>
    </div>

</div>

<script>
    function togglePassword() {
        const pwd = document.getElementById("passwordField");
        if (pwd.type === "password") {
            pwd.type = "text";
        } else {
            pwd.type = "password";
        }
    }
</script>
</body>
</html>