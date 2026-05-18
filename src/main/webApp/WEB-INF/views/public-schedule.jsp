<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.jsp.jstl/fmt" %>
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

    <section class="filter-card">
        <h3>Find the Best Routes that Match Your Travel Needs</h3>
        <form action="${pageContext.request.contextPath}/book-flight-schedule" method="GET">
            <div class="radio-group">
                <label><input type="radio" name="tripType" value="ROUND" checked> Round Trip</label>
                <label><input type="radio" name="tripType" value="ONEWAY" ${param.tripType == 'ONEWAY' ? 'checked' : ''}> One Way</label>
            </div>

            <div class="form-row">
                <div class="input-box">
                    <label>From *</label>
                    <input type="text" name="originCity" placeholder="e.g. Kathmandu" value="${param.originCity}" required>
                </div>
                <div class="input-box">
                    <label>To *</label>
                    <input type="text" name="destCity" placeholder="e.g. New Delhi" value="${param.destCity}" required>
                </div>
                <div class="input-box">
                    <label>Onward Date</label>
                    <input type="date" name="onwardDate" value="${param.onwardDate}">
                </div>
                <div class="input-box">
                    <label>Return Date</label>
                    <input type="date" name="returnDate" value="${param.returnDate}">
                </div>

                <div class="button-group">
                    <button type="button" class="btn-reset" onclick="window.location.href='${pageContext.request.contextPath}/book-flight-schedule'">Reset</button>
                    <button type="submit" class="btn-submit">Submit</button>
                </div>
            </div>
        </form>
    </section>

    <section>
        <h2 class="section-heading">Popular Flights</h2>
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Fare Type</th>
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
                                    <span style="font-weight: 500;">Depart: <c:out value="${f.departure_time}"/></span><br/>
                                    <span style="color: #666; font-size: 12px;">Duration: <c:out value="${f.duration}"/></span>
                                </td>
                                <td>
                                    <span class="price-tag">NPR <fmt:formatNumber value="${f.base_economy_fare}" type="number" maxFractionDigits="2"/></span><br/>
                                    <span style="color: #888; font-size: 11px;">Base Fare</span>
                                </td>
                                <td>
                                    <a class="action-link" href="${pageContext.request.contextPath}/book-flight">Book Now</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6" style="padding: 40px; text-align: center; color: #777; font-style: italic; background: #fafafa;">
                                No scheduled commercial airline flights matched your requested search choices at this time.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </section>

    <section style="margin-top: 60px; margin-bottom: 20px;">
        <h2 class="section-heading">How to Book Flights Tickets Online on SkyLine</h2>
        <p style="font-size: 14px; color:#555; margin-bottom: 20px;">Follow these five simple steps to book your online tickets effortlessly:</p>

        <div class="steps-container">
            <div class="step-block">
                <h4>Step 1</h4>
                <p>Select your departure station, arrival destination, and preferred dates.</p>
            </div>
            <div class="step-block">
                <h4>Step 2</h4>
                <p>Choose your preferred luxury cabin travel tier class (Economy or Business).</p>
            </div>
            <div class="step-block">
                <h4>Step 3</h4>
                <p>Provide valid traveler profile contact coordinates and official documentation info.</p>
            </div>
            <div class="step-block">
                <h4>Step 4</h4>
                <p>Complete authentication via real-time integrated digital wallets like eSewa or Khalti.</p>
            </div>
            <div class="step-block">
                <h4>Step 5</h4>
                <p>Instantly download your secure print-ready ticket directly onto your device.</p>
            </div>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/fragments/footer.jsp" %>

</body>
</html>