<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>505 - Fleet Incompatibility | SkyLine Airlines</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/error.css">
</head>
<body>

<div class="error-container">
    <div class="plane-wrapper">
        <span class="icon">🛩️</span>
    </div>

    <h1 class="error-code">505</h1>
    <h2>Fleet Incompatibility</h2>

    <p>
        Your browser is attempting to communicate using an unapproved protocol configuration.<br>
        Please upgrade your connection profile to board this digital flight path.
    </p>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">
            Check In Again
        </a>
    </div>
</div>

</body>
</html>