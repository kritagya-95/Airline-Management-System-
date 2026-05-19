<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>SkyLine — Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/main.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/admin.css"/>
</head>
<body>

<div class="admin-layout">

    <!-- ══ SIDEBAR ══ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/static/images/logo.png"
                 alt="SkyLine" class="sidebar-logo-img"/>
            <span>SkyLine</span>
        </div>

        <nav class="sidebar-nav">
            <a href="#section-stats"   class="nav-item active">Dashboard</a>
            <a href="#section-pending" class="nav-item">
                 Pending Approvals
                <c:if test="${pendingUsers > 0}">
                    <span class="badge">${pendingUsers}</span>
                </c:if>
            </a>
            <a href="#section-users"    class="nav-item">All Users</a>
            <a href="#section-flights"  class="nav-item">Flights</a>
            <a href="#section-bookings" class="nav-item">Recent Bookings</a>
        </nav>

        <div class="sidebar-footer">
            <!-- Clickable Admin Profile -->
            <a href="${pageContext.request.contextPath}/admin/profile" class="admin-user-link">
                <span class="user-icon"></span>
                <span class="admin-name"><c:out value="${admin.fullName}"/></span>
            </a>

            <a href="${pageContext.request.contextPath}/logout"
               class="btn-logout">Log Out</a>
        </div>
    </aside>

    <!-- ══ MAIN CONTENT ══ -->
    <main class="admin-main">

        <!-- Top Bar -->
        <div class="admin-topbar">
            <h1 class="page-title">Admin Dashboard</h1>
            <p class="page-sub">Welcome back, <c:out value="${admin.fullName}"/></p>
        </div>

        <!-- ── STATS CARDS ── -->
        <section id="section-stats" class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon"></div>
                <div class="stat-info">
                    <p class="stat-value">${totalUsers}</p>
                    <p class="stat-label">Total Users</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"></div>
                <div class="stat-info">
                    <p class="stat-value">${totalFlights}</p>
                    <p class="stat-label">Total Flights</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"></div>
                <div class="stat-info">
                    <p class="stat-value">${totalBookings}</p>
                    <p class="stat-label">Total Bookings</p>
                </div>
            </div>
            <div class="stat-card highlight">
                <div class="stat-icon"></div>
                <div class="stat-info">
                    <p class="stat-value">${pendingUsers}</p>
                    <p class="stat-label">Pending Approvals</p>
                </div>
            </div>
        </section>

        <!-- ── PENDING APPROVALS ── -->
        <section id="section-pending" class="admin-section">
            <div class="section-header">
                <h2>Pending User Approvals</h2>
            </div>

            <c:choose>
                <c:when test="${empty pendingUserList}">
                    <div class="empty-state">
                         No pending approvals — all caught up!
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${pendingUserList}"
                                       varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${u.fullName}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><c:out value="${u.phone}"/></td>
                                    <td>
                                            <span class="role-badge ${u.role.toLowerCase()}">
                                                    ${u.role}
                                            </span>
                                    </td>
                                    <td class="action-btns">
                                        <form action="${pageContext.request.contextPath}/admin/users"
                                              method="post" style="display:inline">
                                            <input type="hidden" name="userId" value="${u.userId}"/>
                                            <input type="hidden" name="action" value="approve"/>
                                            <button type="submit" class="btn-approve">
                                                ✓ Approve
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/users"
                                              method="post" style="display:inline">
                                            <input type="hidden" name="userId" value="${u.userId}"/>
                                            <input type="hidden" name="action" value="reject"/>
                                            <button type="submit" class="btn-reject">
                                                ✗ Reject
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── ALL USERS ── -->
        <section id="section-users" class="admin-section">
            <div class="section-header">
                <h2>All Users</h2>
                <span class="section-count">
                    Total: <strong>${totalUsers}</strong> users
                </span>
            </div>

            <c:choose>
                <c:when test="${empty userList}">
                    <div class="empty-state">No users found.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="u" items="${userList}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><c:out value="${u.fullName}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td><c:out value="${u.phone}"/></td>
                                    <td>
                                            <span class="role-badge ${u.role.toLowerCase()}">
                                                    ${u.role}
                                            </span>
                                    </td>
                                    <td>
                                            <span class="status-badge ${u.status.toLowerCase()}">
                                                    ${u.status}
                                            </span>
                                    </td>
                                    <td class="action-btns">
                                        <c:if test="${u.status == 'PENDING'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="approve"/>
                                                <button type="submit" class="btn-approve">
                                                    ✓ Approve
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'APPROVED'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="reject"/>
                                                <button type="submit" class="btn-reject">
                                                    ✗ Reject
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${u.status == 'REJECTED'}">
                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post" style="display:inline">
                                                <input type="hidden" name="userId" value="${u.userId}"/>
                                                <input type="hidden" name="action" value="approve"/>
                                                <button type="submit" class="btn-approve">
                                                    ↺ Re-approve
                                                </button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- ── FLIGHTS ── -->
        <section id="section-flights" class="admin-section">
            <div class="section-header">
                <h2>All Flights</h2>
                <span class="section-count">
                    Total: <strong>${totalFlights}</strong> flights
                </span>
            </div>

            <c:if test="${param.flightSaved == 'true'}">
                <div class="admin-alert success">Flight details saved successfully.</div>
            </c:if>
            <c:if test="${param.flightError == 'true'}">
                <div class="admin-alert error">Unable to save flight details. Please check the form values.</div>
            </c:if>

            <c:choose>
                <c:when test="${empty flightList}">
                    <div class="empty-state">
                        No flights found in the database.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Flight No.</th>
                                <th>Airline</th>
                                <th>Aircraft</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Economy (NPR)</th>
                                <th>Business (NPR)</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="f" items="${flightList}" varStatus="s">
                                <tr>
                                    <td>${s.count}</td>
                                    <td><strong>${f.flight_number}</strong></td>
                                    <td>${f.airline_name}</td>
                                    <td>${f.aircraft_model}</td>
                                    <td>
                                        <strong>${f.origin_code}</strong>
                                        <br/>
                                        <small style="color:#888">
                                                ${f.origin_city}
                                        </small>
                                    </td>
                                    <td>
                                        <strong>${f.dest_code}</strong>
                                        <br/>
                                        <small style="color:#888">
                                                ${f.dest_city}
                                        </small>
                                    </td>
                                    <td>${f.departure_time}</td>
                                    <td>${f.arrival_time}</td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${f.base_economy_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${f.base_business_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                            <span class="status-badge ${f.status.toLowerCase()}">
                                                    ${f.status}
                                            </span>
                                    </td>
                                    <td>
                                        <a class="btn-edit-flight"
                                           href="#editFlightModal"
                                           onclick="openEditFlightModal(this)"
                                           data-flight-id="${f.flight_id}"
                                           data-flight-number="${f.flight_number}"
                                           data-airline-id="${f.airline_id}"
                                           data-aircraft-id="${f.aircraft_id}"
                                           data-origin-code="${f.origin_code}"
                                           data-origin-city="${f.origin_city}"
                                           data-origin-country="${f.origin_country}"
                                           data-dest-code="${f.dest_code}"
                                           data-dest-city="${f.dest_city}"
                                           data-dest-country="${f.dest_country}"
                                           data-departure-time="${f.departure_time}"
                                           data-arrival-time="${f.arrival_time}"
                                           data-status="${f.status}"
                                           data-economy-fare="${f.base_economy_fare}"
                                           data-business-fare="${f.base_business_fare}">Edit</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="flight-add-row">
                <a class="btn-add" href="#addFlightModal" onclick="openFlightModal('addFlightModal')">Add Flight</a>
            </div>

            <div class="flight-modal" id="addFlightModal" aria-hidden="true">
                <form class="flight-editor" action="${pageContext.request.contextPath}/admin/flights" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add"/>
                    <div class="modal-header">
                        <h3>Add Flight</h3>
                        <a class="modal-close" href="#section-flights" onclick="closeFlightModal('addFlightModal')">&times;</a>
                    </div>
                    <div class="flight-form-grid">
                        <label>Flight No.<input type="text" name="flightNumber" maxlength="10" required/></label>
                        <label>Airline
                            <select name="airlineId" required>
                                <c:forEach var="airline" items="${airlineList}">
                                    <option value="${airline.airline_id}">${airline.airline_name} (${airline.iata_code})</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label>Aircraft
                            <select name="aircraftId" required>
                                <c:forEach var="aircraft" items="${aircraftList}">
                                    <option value="${aircraft.aircraft_id}">${aircraft.model} - ${aircraft.registration}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label>Origin Code<input type="text" name="originCode" maxlength="3" required/></label>
                        <label>Origin City<input type="text" name="originCity" required/></label>
                        <label>Origin Country<input type="text" name="originCountry" required/></label>
                        <label>Destination Code<input type="text" name="destCode" maxlength="3" required/></label>
                        <label>Destination City<input type="text" name="destCity" required/></label>
                        <label>Destination Country<input type="text" name="destCountry" required/></label>
                        <label>Departure<input type="datetime-local" name="departureTime" required/></label>
                        <label>Arrival<input type="datetime-local" name="arrivalTime" required/></label>
                        <label>Status
                            <select name="status" required>
                                <option value="SCHEDULED">SCHEDULED</option>
                                <option value="BOARDING">BOARDING</option>
                                <option value="DEPARTED">DEPARTED</option>
                                <option value="ARRIVED">ARRIVED</option>
                                <option value="DELAYED">DELAYED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </label>
                        <label>Economy Fare<input type="number" name="economyFare" step="0.01" min="0" required/></label>
                        <label>Business Fare<input type="number" name="businessFare" step="0.01" min="0" required/></label>
                        <label>Flight Photo<input type="file" name="flightImage" accept="image/jpeg,image/png,image/jpg"/></label>
                    </div>
                    <div class="modal-actions">
                        <a class="btn-reject" href="#section-flights" onclick="closeFlightModal('addFlightModal')">Cancel</a>
                        <button type="submit" class="btn-approve">Add Flight</button>
                    </div>
                </form>
            </div>

            <div class="flight-modal" id="editFlightModal" aria-hidden="true">
                <form class="flight-editor compact" action="${pageContext.request.contextPath}/admin/flights" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="flightId"/>
                    <div class="modal-header">
                        <h3>Edit Flight</h3>
                        <a class="modal-close" href="#section-flights" onclick="closeFlightModal('editFlightModal')">&times;</a>
                    </div>
                    <div class="flight-form-grid">
                        <label>Flight No.<input type="text" name="flightNumber" maxlength="10" required/></label>
                        <label>Airline
                            <select name="airlineId" required>
                                <c:forEach var="airline" items="${airlineList}">
                                    <option value="${airline.airline_id}">${airline.airline_name}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label>Aircraft
                            <select name="aircraftId" required>
                                <c:forEach var="aircraft" items="${aircraftList}">
                                    <option value="${aircraft.aircraft_id}">${aircraft.model} - ${aircraft.registration}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label>Origin Code<input type="text" name="originCode" maxlength="3" required/></label>
                        <label>Origin City<input type="text" name="originCity" required/></label>
                        <label>Origin Country<input type="text" name="originCountry" required/></label>
                        <label>Destination Code<input type="text" name="destCode" maxlength="3" required/></label>
                        <label>Destination City<input type="text" name="destCity" required/></label>
                        <label>Destination Country<input type="text" name="destCountry" required/></label>
                        <label>Departure<input type="datetime-local" name="departureTime" required/></label>
                        <label>Arrival<input type="datetime-local" name="arrivalTime" required/></label>
                        <label>Status
                            <select name="status" required>
                                <option value="SCHEDULED">SCHEDULED</option>
                                <option value="BOARDING">BOARDING</option>
                                <option value="DEPARTED">DEPARTED</option>
                                <option value="ARRIVED">ARRIVED</option>
                                <option value="DELAYED">DELAYED</option>
                                <option value="CANCELLED">CANCELLED</option>
                            </select>
                        </label>
                        <label>Economy Fare<input type="number" name="economyFare" step="0.01" min="0" required/></label>
                        <label>Business Fare<input type="number" name="businessFare" step="0.01" min="0" required/></label>
                        <label>Replace Photo<input type="file" name="flightImage" accept="image/jpeg,image/png,image/jpg"/></label>
                    </div>
                    <div class="modal-actions">
                        <a class="btn-reject" href="#section-flights" onclick="closeFlightModal('editFlightModal')">Cancel</a>
                        <button type="submit" class="btn-approve">Save Changes</button>
                    </div>
                </form>
            </div>
        </section>

        <!-- ── RECENT BOOKINGS ── -->
        <section id="section-bookings" class="admin-section">
            <div class="section-header">
                <h2>Recent Bookings</h2>
                <span class="section-count">
                    Total: <strong>${totalBookings}</strong> bookings
                </span>
            </div>

            <c:choose>
                <c:when test="${empty recentBookings}">
                    <div class="empty-state">No bookings yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table class="admin-table">
                            <thead>
                            <tr>
                                <th>Ref</th>
                                <th>Passenger</th>
                                <th>Email</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Class</th>
                                <th>Total (NPR)</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="b" items="${recentBookings}">
                                <tr>
                                    <td><strong>${b.booking_ref}</strong></td>
                                    <td><c:out value="${b.passenger_name}"/></td>
                                    <td><c:out value="${b.email}"/></td>
                                    <td>${b.flight_number}</td>
                                    <td>${b.from_code} → ${b.to_code}</td>
                                    <td>${b['class']}</td>
                                    <td>
                                        NPR <fmt:formatNumber
                                            value="${b.total_fare}"
                                            pattern="#,##0.00"/>
                                    </td>
                                    <td>
                                            <span class="status-badge ${b.booking_status.toLowerCase()}">
                                                    ${b.booking_status}
                                            </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>
</div>
<script>
    // Highlight active sidebar link on scroll
    const sections = document.querySelectorAll(
        '#section-stats, #section-pending, #section-users, #section-flights, #section-bookings'
    );
    const navItems = document.querySelectorAll('.nav-item');

    window.addEventListener('scroll', () => {
        let current = '';
        sections.forEach(section => {
            if (window.scrollY >= section.offsetTop - 120) {
                current = section.id;
            }
        });
        navItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('href') === '#' + current) {
                item.classList.add('active');
            }
        });
    });

    function openFlightModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.add('show');
            modal.classList.add('open');
            modal.setAttribute('aria-hidden', 'false');
        }
    }

    function closeFlightModal(id) {
        const modal = document.getElementById(id);
        if (modal) {
            modal.classList.remove('show');
            modal.classList.remove('open');
            modal.setAttribute('aria-hidden', 'true');
        }
    }

    function openEditFlightModal(trigger) {
        const modal = document.getElementById('editFlightModal');
        const form = modal ? modal.querySelector('form') : null;
        if (!form) {
            return;
        }

        setFormValue(form, 'flightId', trigger.dataset.flightId);
        setFormValue(form, 'flightNumber', trigger.dataset.flightNumber);
        setFormValue(form, 'airlineId', trigger.dataset.airlineId);
        setFormValue(form, 'aircraftId', trigger.dataset.aircraftId);
        setFormValue(form, 'originCode', trigger.dataset.originCode);
        setFormValue(form, 'originCity', trigger.dataset.originCity);
        setFormValue(form, 'originCountry', trigger.dataset.originCountry);
        setFormValue(form, 'destCode', trigger.dataset.destCode);
        setFormValue(form, 'destCity', trigger.dataset.destCity);
        setFormValue(form, 'destCountry', trigger.dataset.destCountry);
        setFormValue(form, 'departureTime', toDateTimeLocal(trigger.dataset.departureTime));
        setFormValue(form, 'arrivalTime', toDateTimeLocal(trigger.dataset.arrivalTime));
        setFormValue(form, 'status', trigger.dataset.status);
        setFormValue(form, 'economyFare', trigger.dataset.economyFare);
        setFormValue(form, 'businessFare', trigger.dataset.businessFare);
        openFlightModal('editFlightModal');
    }

    function setFormValue(form, name, value) {
        const field = form.elements[name];
        if (field) {
            field.value = value || '';
        }
    }

    function toDateTimeLocal(value) {
        if (!value) {
            return '';
        }
        return value.trim().replace(' ', 'T').substring(0, 16);
    }

    document.querySelectorAll('.flight-modal').forEach(modal => {
        modal.addEventListener('click', event => {
            if (event.target === modal) {
                closeFlightModal(modal.id);
            }
        });
    });
</script>

</body>
</html>
