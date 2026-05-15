<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Flight Diverted | SkyLine Airlines</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/error.css">
</head>
<body>

<div class="error-container">
    <div class="plane-wrapper">
        <span class="icon">✈️</span>
    </div>

    <h1 class="error-code">404</h1>
    <h2>Flight Diverted</h2>

    <p>
        The destination you are looking for is not on our flight path.<br>
        Please return to the main terminal to continue your journey.
    </p>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">
            Return to Base
        </a>
    </div>
</div>

</body>
</html>