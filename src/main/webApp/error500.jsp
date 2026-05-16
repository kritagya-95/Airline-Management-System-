<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Technical Turbulence | SkyLine Airlines</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css">
</head>
<body>

<div class="error-container">
    <div class="plane-wrapper">
        <span class="icon">🛠️</span>
    </div>

    <h1 class="error-code">500</h1>
    <h2>Technical Turbulence</h2>

    <p>
        Our ground crew is currently troubleshooting an unexpected system malfunction.<br>
        Please remain seated; we are working to get back on schedule shortly.
    </p>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">
            Return to Terminal
        </a>
    </div>
</div>

</body>
</html>