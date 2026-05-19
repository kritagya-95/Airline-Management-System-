<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<article class="hotel-card" data-city="<c:out value='${hotel.city}'/>">
    <div class="hotel-card-image"><c:out value="${hotel.image}"/></div>
    <div class="hotel-card-body">
        <div class="hotel-card-topline">
            <h3><c:out value="${hotel.name}"/></h3>
            <span><c:out value="${hotel.stars}"/> Stars</span>
        </div>
        <p class="hotel-card-city"><c:out value="${hotel.city}"/></p>
        <p class="hotel-card-copy"><c:out value="${hotel.description}"/></p>
        <div class="hotel-card-footer">
            <strong>$<fmt:formatNumber value="${hotel.pricePerNight}" pattern="#,##0"/> / night</strong>
            <button type="button" class="hotel-book-btn"
                    data-hotel-name="<c:out value='${hotel.name}'/>"
                    data-hotel-city="<c:out value='${hotel.city}'/>"
                    data-hotel-price="<c:out value='${hotel.pricePerNight}'/>">Book Now</button>
        </div>
        <p class="hotel-selected-message" aria-live="polite">Hotel added to your trip shortlist.</p>
    </div>
</article>
