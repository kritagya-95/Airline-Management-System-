<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkyLine - Create Account</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/auth.css" />
</head>

<body>
<div class="auth-page">

    <!-- Left Panel - Branding -->
    <div class="auth-left">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine Logo"
                 class="logo-image" />
            <h1>SKYLINE</h1>
        </div>
        <h2>START YOUR ADVENTURE</h2>
        <p class="tagline">Join SkyLine and start exploring</p>
        <p class="description">
            Join millions of travelers and unlock your exclusive benefits with us
        </p>
    </div>

    <!-- Right Panel - Registration Form -->
    <div class="auth-form">
        <form action="${pageContext.request.contextPath}/register" method="post">
            <h2>Create Account</h2>

            <c:if test="${not empty error}">
                <p class="error"><c:out value="${error}" /></p>
            </c:if>

            <c:if test="${not empty success}">
                <p class="success"><c:out value="${success}" /></p>
            </c:if>

            <div class="form-row">
                <div class="form-group half">
                    <label>First Name</label>
                    <input type="text" name="firstName" placeholder="First Name" required />
                </div>
                <div class="form-group half">
                    <label>Last Name</label>
                    <input type="text" name="lastName" placeholder="Last Name" required />
                </div>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Your Email Address" required />
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" placeholder="+977-98XXXXXXXX" required />
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="passwordField"
                           placeholder="Create a strong password" required />
                    <span class="toggle-password" onclick="togglePassword()">👁</span>
                </div>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" name="confirmPassword" id="confirmPasswordField"
                           placeholder="Re-enter your password" required />
                    <span class="toggle-password" onclick="toggleConfirmPassword()">👁</span>
                </div>
            </div>

            <div class="terms">
                <input type="checkbox" name="terms" id="terms" required />
                <label for="terms">I agree to the <a href="#">Terms and Conditions</a></label>
            </div>

            <button type="submit" class="btn-login">Create Account</button>

            <p class="link">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Log In</a>
            </p>
        </form>
    </div>

</div>

<script>
    function togglePassword() {
        const pwd = document.getElementById("passwordField");
        if (pwd.type === "password") pwd.type = "text";
        else pwd.type = "password";
    }

    function toggleConfirmPassword() {
        const pwd = document.getElementById("confirmPasswordField");
        if (pwd.type === "password") pwd.type = "text";
        else pwd.type = "password";
    }
</script>
</body>
</html>