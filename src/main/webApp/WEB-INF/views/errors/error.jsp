<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Error - Skyline Airlines</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/error.css">
</head>
<body>

<c:set var="statusCode" value="${requestScope['jakarta.servlet.error.status_code']}" />

<div class="error-code">${statusCode}</div>

<div class="error-message">
    <c:choose>
        <c:when test="${statusCode == 404}">
            Oops! The page you're looking for has flown away.
        </c:when>
        <c:when test="${statusCode == 403}">
            Access Denied. You don't have the clearance to land here.
        </c:when>
        <c:when test="${statusCode == 500}">
            System Turbulence. Our engineers are working on it.
        </c:when>
        <c:otherwise>
            Something went wrong on our end.
        </c:otherwise>
    </c:choose>
</div>

<a href="${pageContext.request.contextPath}/" class="btn">Return to Home</a>

</body>
</html>