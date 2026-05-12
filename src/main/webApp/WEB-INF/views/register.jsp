<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkyLine - Create Account</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Chivo:wght@300;400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/auth.css" />
    <style>

        /* ── LEFT PANEL OVERRIDES ───────────────────────── */
        .auth-left {
            flex: 0 0 38%;
            min-width: unset;
            max-width: 38%;
            padding: 60px 50px;
            justify-content: center;
            gap: 0;
        }

        .auth-left .logo {
            margin-bottom: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .auth-left .logo-image {
            max-width: 260px;
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

        /* ── RIGHT PANEL OVERRIDES ──────────────────────── */
        .auth-form {
            flex: 1;
            min-width: unset;
            max-width: 62%;
            padding: 50px 70px;
        }

        /* ── POPUP OVERLAY ──────────────────────────────── */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            z-index: 999;
            justify-content: center;
            align-items: center;
        }

        .modal-overlay.active {
            display: flex;
        }

        /* ── POPUP BOX ──────────────────────────────────── */
        .modal-box {
            background: white;
            border-radius: 16px;
            padding: 44px 40px;
            width: 100%;
            max-width: 430px;
            box-shadow: 0 24px 70px rgba(0,0,0,0.35);
            text-align: center;
            animation: popIn 0.25s ease;
        }

        @keyframes popIn {
            from { transform: scale(0.85); opacity: 0; }
            to   { transform: scale(1);   opacity: 1; }
        }

        .modal-icon {
            font-size: 44px;
            margin-bottom: 16px;
        }

        .modal-box h3 {
            font-family: 'Cinzel', serif;
            font-size: 20px;
            font-weight: 700;
            color: #8B0000;
            margin-bottom: 10px;
        }

        .modal-box p {
            font-family: 'Chivo', sans-serif;
            font-size: 14px;
            color: #666;
            margin-bottom: 24px;
            line-height: 1.7;
        }

        .modal-box input[type="password"] {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 15px;
            margin-bottom: 10px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: 'Chivo', sans-serif;
        }

        .modal-box input[type="password"]:focus {
            border-color: #8B0000;
            box-shadow: 0 0 0 3px rgba(139,0,0,0.08);
        }

        .modal-error {
            color: #c62828;
            font-size: 13px;
            margin-bottom: 14px;
            display: none;
            font-family: 'Chivo', sans-serif;
        }

        .modal-error.show {
            display: block;
        }

        .btn-verify {
            width: 100%;
            padding: 14px;
            background: #8B0000;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-bottom: 14px;
            transition: background 0.2s;
            font-family: 'Chivo', sans-serif;
        }

        .btn-verify:hover { background: #660000; }

        .btn-cancel {
            background: none;
            border: none;
            color: #888;
            font-size: 13px;
            cursor: pointer;
            text-decoration: underline;
            font-family: 'Chivo', sans-serif;
        }

        .btn-cancel:hover { color: #333; }

        /* ── RESPONSIVE ─────────────────────────────────── */
        @media (max-width: 900px) {
            .auth-left {
                flex: unset;
                max-width: 100%;
                padding: 50px 30px;
            }
            .auth-left .logo h1 { font-size: 60px; }
            .auth-left h2       { font-size: 20px; }
            .auth-left .tagline { font-size: 16px; }
            .auth-form {
                max-width: 100%;
                padding: 40px 30px;
            }
        }
    </style>
</head>

<body>
<div class="auth-page">

    <!-- ── LEFT PANEL — Branding ── -->
    <div class="auth-left">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine Logo" class="logo-image" />
            <h1>SKYLINE</h1>
        </div>
        <h2>START YOUR ADVENTURE</h2>
        <p class="tagline">Join SkyLine and start exploring</p>
        <p class="description">
            Join millions of travelers and unlock your exclusive benefits with us
        </p>
    </div>

    <!-- ── RIGHT PANEL — Form ── -->
    <div class="auth-form">
        <form id="registerForm"
              action="${pageContext.request.contextPath}/register"
              method="post">

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
                    <input type="text" name="firstName"
                           placeholder="First Name" required />
                </div>
                <div class="form-group half">
                    <label>Last Name</label>
                    <input type="text" name="lastName"
                           placeholder="Last Name" required />
                </div>
            </div>

            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" id="emailField"
                       placeholder="Your Email Address" required />
            </div>

            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone"
                       placeholder="+977-98XXXXXXXX" required />
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="passwordField"
                           placeholder="Create a strong password" required />
                    <span class="toggle-password"
                          onclick="togglePassword()">👁</span>
                </div>
            </div>

            <div class="form-group">
                <label>Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" name="confirmPassword"
                           id="confirmPasswordField"
                           placeholder="Re-enter your password" required />
                    <span class="toggle-password"
                          onclick="toggleConfirmPassword()">👁</span>
                </div>
            </div>

            <div class="terms">
                <input type="checkbox" name="terms" id="terms" required />
                <label for="terms">
                    I agree to the <a href="#">Terms and Conditions</a>
                </label>
            </div>

            <!-- Hidden admin key — filled by popup -->
            <input type="hidden" name="adminKey"
                   id="adminKeyHidden" value=""/>

            <button type="button" class="btn-login"
                    onclick="handleSubmit()">
                Create Account
            </button>

            <p class="link">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Log In</a>
            </p>
        </form>
    </div>

</div>

<!-- ── ADMIN KEY POPUP ── -->
<div class="modal-overlay" id="adminModal">
    <div class="modal-box">
        <div class="modal-icon">🔐</div>
        <h3>Admin Verification Required</h3>
        <p>
            You are registering with an admin email.<br/>
            Please enter your Admin Registration Key to continue.
        </p>
        <input type="password" id="adminKeyInput"
               placeholder="Enter Admin Registration Key"/>
        <p class="modal-error" id="modalError">
            Incorrect key. Please try again.
        </p>
        <button class="btn-verify" onclick="verifyAdminKey()">
            Verify &amp; Register
        </button>
        <br/>
        <button class="btn-cancel" onclick="closeModal()">
            Cancel — Register as Passenger instead
        </button>
    </div>
</div>

<script>
    function togglePassword() {
        const pwd = document.getElementById("passwordField");
        pwd.type = pwd.type === "password" ? "text" : "password";
    }

    function toggleConfirmPassword() {
        const pwd = document.getElementById("confirmPasswordField");
        pwd.type = pwd.type === "password" ? "text" : "password";
    }

    function handleSubmit() {
        const form  = document.getElementById("registerForm");
        const email = document.getElementById("emailField").value.toLowerCase().trim();

        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        if (email.endsWith("@skyline.admin.com")) {
            document.getElementById("adminModal").classList.add("active");
            document.getElementById("adminKeyInput").focus();
        } else {
            form.submit();
        }
    }

    function verifyAdminKey() {
        const key      = document.getElementById("adminKeyInput").value.trim();
        const errorMsg = document.getElementById("modalError");
        const ADMIN_KEY = "JavaHut-SkyLine";

        if (key === ADMIN_KEY) {
            document.getElementById("adminKeyHidden").value = key;
            document.getElementById("adminModal").classList.remove("active");
            document.getElementById("registerForm").submit();
        } else {
            errorMsg.classList.add("show");
            document.getElementById("adminKeyInput").focus();
        }
    }

    function closeModal() {
        document.getElementById("adminModal").classList.remove("active");
        document.getElementById("adminKeyInput").value = "";
        document.getElementById("modalError").classList.remove("show");
        document.getElementById("adminKeyHidden").value = "";
        document.getElementById("registerForm").submit();
    }

    document.addEventListener("keydown", function(e) {
        const modal = document.getElementById("adminModal");
        if (e.key === "Enter" && modal.classList.contains("active")) {
            verifyAdminKey();
        }
    });
</script>
</body>
</html>