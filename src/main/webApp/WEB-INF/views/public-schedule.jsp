<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Flight Schedules & Timetables - SkyLine Airlines</title>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@600;700&family=Chivo:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/layout.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/public-schedule.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/fragments/header.jsp" %>

<main class="pub-schedule-container">
    <h1 class="pub-title">Flight Schedule</h1>


    <section>
        <h2 class="section-heading">Current Scheduled Flights</h2>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Airline / Flight</th>
                    <th>Dates / Times</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty scheduledFlights}">
                        <c:forEach var="f" items="${scheduledFlights}">
                            <tr>
                                <td>
                                    <strong><c:out value="${f.origin_city}"/></strong><br/>
                                    <span style="color: #777; font-size: 12px;"><c:out value="${f.origin_code}"/></span>
                                </td>
                                <td>
                                    <strong><c:out value="${f.dest_city}"/></strong><br/>
                                    <span style="color: #777; font-size: 12px;"><c:out value="${f.dest_code}"/></span>
                                </td>
                                <td>
                                    <span style="font-weight: 500;"><c:out value="${f.airline_name}"/></span><br/>
                                    <span style="color: #666; font-size: 12px;">Flight: <c:out value="${f.flight_number}"/></span>
                                </td>
                                <td>
                                    <span style="font-weight: 500;">
                                        Depart: <fmt:formatDate value="${f.departure_time}" pattern="yyyy-MM-dd HH:mm"/>
                                    </span><br/>
                                    <span style="color: #666; font-size: 12px;">Duration: <c:out value="${f.duration}"/></span>
                                </td>
                                <td>
                                    <span class="price-tag">NPR <fmt:formatNumber value="${f.base_economy_fare}" type="number" maxFractionDigits="2"/></span><br/>
                                    <span style="color: #888; font-size: 11px;">Base Fare</span>
                                </td>
                                <td>
                                    <a class="action-link" href="${pageContext.request.contextPath}/book-flight?flightId=${f.flight_id}">Book Now</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 40px; text-align: center; color: #777; font-style: italic; background: #fafafa;">
                                No scheduled commercial airline flights found in the system database registries at this time.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>