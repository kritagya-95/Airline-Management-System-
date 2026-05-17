<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkyLine - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/auth.css" />
</head>

<body>
<div class="auth-page">

    <div class="auth-form">
        <form action="${pageContext.request.contextPath}/login" method="post">

            <%-- 🔑 Captures the filter query parameters from the URL and hands them to LoginServlet --%>
            <input type="hidden" name="redirect" value="<c:out value='${param.redirect}'/>" />
            <input type="hidden" name="flightId" value="<c:out value='${param.flightId}'/>" />

            <h1>Log In To Your SkyLine Account</h1>

            <c:if test="${not empty error}">
                <p class="error"><c:out value="${error}" /></p>
            </c:if>

            <c:if test="${not empty success}">
                <p class="success"><c:out value="${success}" /></p>
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
                    <span class="toggle-password"
                          onclick="togglePassword()">👁</span>
                </div>
            </div>

            <button type="submit" class="btn-login">Log In</button>

            <p class="link">
                Not a member yet?
                <a href="${pageContext.request.contextPath}/register">Register Now</a>
            </p>
        </form>
    </div>

    <div class="auth-left">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine Logo" class="logo-image" />
            <h1>SKYLINE</h1>
        </div>
        <h2>WELCOME TO SKYLINE</h2>
        <p class="tagline">YOUR JOURNEY STARTS HERE</p>
        <p class="description">
            Join millions of travelers and unlock your exclusive benefits with us
        </p>
    </div>

</div>

<script>
    function togglePassword() {
        const pwd = document.getElementById("passwordField");
        pwd.type = pwd.type === "password" ? "text" : "password";
    }
</script>
</body>
</html>