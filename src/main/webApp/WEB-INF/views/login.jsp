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
    <style>

        /* ── LAYOUT — side by side ──────────────────────── */
        .auth-page {
            display: flex;
            flex-direction: row;
            min-height: 100vh;
        }

        /* ── LEFT SIDE — Login Form ─────────────────────── */
        .auth-form {
            flex: 0 0 45%;
            max-width: 45%;
            min-width: unset;
            background: white;
            padding: 0 70px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .auth-form h1 {
            font-size: 32px;
            font-weight: 700;
            color: #8B0000;
            margin-bottom: 32px;
            text-align: center;
        }

        .auth-form .form-group {
            margin-bottom: 20px;
        }

        .auth-form .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
            display: block;
        }

        .auth-form .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .auth-form .form-group input:focus {
            outline: none;
            border-color: #8B0000;
            box-shadow: 0 0 0 3px rgba(139,0,0,0.08);
        }

        .btn-login {
            width: 100%;
            padding: 13px;
            background: #8B0000;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
            transition: background 0.2s;
        }

        .btn-login:hover { background: #660000; }

        .link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .link a {
            color: #8B0000;
            font-weight: 600;
        }

        /* ── RIGHT SIDE — Branding ──────────────────────── */
        .auth-left {
            flex: 0 0 55%;
            max-width: 55%;
            min-width: unset;
            background: linear-gradient(135deg, #8B0000, #5C0000);
            color: white;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .auth-left .logo {
            margin-bottom: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .auth-left .logo-image {
            max-width: 200px;
            height: auto;
            filter: brightness(1.3);
            margin-bottom: 10px;
        }

        .auth-left .logo h1 {
            font-family: 'Cinzel', serif;
            font-size: 98px;
            font-weight: 900;
            color: white;
            letter-spacing: 0.08em;
            line-height: 1;
            margin: 0;
            text-align: center;
        }

        .auth-left h2 {
            font-family: 'Cinzel', serif;
            font-size: 28px;
            font-weight: 700;
            color: white;
            text-align: center;
            margin: 28px 0 16px;
            letter-spacing: 0.05em;
        }

        .auth-left .tagline {
            font-family: 'Cinzel', serif;
            font-size: 22px;
            font-weight: 600;
            color: rgba(255,255,255,0.95);
            text-align: center;
            margin-bottom: 14px;
            line-height: 1.4;
        }

        .auth-left .description {
            font-family: 'Chivo', sans-serif;
            font-size: 16px;
            font-weight: 300;
            color: rgba(255,255,255,0.85);
            text-align: center;
            line-height: 1.7;
        }

        /* ── RESPONSIVE ─────────────────────────────────── */
        @media (max-width: 900px) {
            .auth-page { flex-direction: column; }
            .auth-form,
            .auth-left {
                flex: unset;
                max-width: 100%;
                padding: 50px 30px;
            }
            .auth-left .logo h1 { font-size: 60px; }
            .auth-left h2       { font-size: 22px; }
            .auth-left .tagline { font-size: 17px; }
        }
    </style>
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