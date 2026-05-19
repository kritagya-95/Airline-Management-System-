<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<section class="gift-buy-panel" id="buyGiftCard">
    <div class="gift-card-visual" id="giftCardVisual">
        <img id="giftCardImage"
             src="${pageContext.request.contextPath}/static/images/Classic Travel Gift Card.png"
             alt="Classic Travel Gift Card">
    </div>
    <div class="gift-buy-content">
        <h2>Buy a Gift Card</h2>
        <div class="gift-style-options" role="group" aria-label="Gift card styles">
            <button type="button" class="gift-style selected" data-style="Classic Travel" data-visual="Classic Travel Gift Card" data-image="Classic Travel Gift Card.png">Classic Travel</button>
            <button type="button" class="gift-style" data-style="Premium Escape" data-visual="Premium Escape Gift Card" data-image="Premium Escape Gift Card.png">Premium Escape</button>
            <button type="button" class="gift-style" data-style="Family Trip" data-visual="Family Trip Gift Card" data-image="Family Trip Gift Card.png">Family Trip</button>
            <button type="button" class="gift-style" data-style="Student Fare" data-visual="Student Fare Gift Card" data-image="Student Fare Gift Card.png">Student Fare</button>
        </div>

        <div class="gift-denominations" role="group" aria-label="Gift card denominations">
            <button type="button" class="gift-chip selected" data-value="25">$25</button>
            <button type="button" class="gift-chip" data-value="50">$50</button>
            <button type="button" class="gift-chip" data-value="100">$100</button>
            <button type="button" class="gift-chip" data-value="200">$200</button>
            <button type="button" class="gift-chip" data-value="300">$300</button>
            <button type="button" class="gift-chip" data-value="500">$500</button>
        </div>

        <form class="gift-buy-form" id="giftBuyForm">
            <label>
                Custom Amount
                <input type="number" id="giftCustomAmount" min="1" placeholder="Optional"/>
            </label>
            <label>
                Recipient Name
                <input type="text" id="giftRecipientName" required/>
            </label>
            <label>
                Recipient Email
                <input type="email" id="giftRecipientEmail" required/>
            </label>
            <button type="submit" class="gift-primary-btn" id="giftPurchaseButton">Purchase</button>
        </form>

        <div class="gift-buy-confirmation" id="giftBuyConfirmation" aria-live="polite"></div>
    </div>
</section>

<script>
    (function () {
        const buyForm = document.getElementById("giftBuyForm");
        if (!buyForm) {
            return;
        }

        const chips = Array.from(document.querySelectorAll(".gift-chip"));
        const styles = Array.from(document.querySelectorAll(".gift-style"));
        const customAmount = document.getElementById("giftCustomAmount");
        const confirmation = document.getElementById("giftBuyConfirmation");
        const purchaseButton = document.getElementById("giftPurchaseButton");
        const giftCardImage = document.getElementById("giftCardImage");
        const giftCardImageBase = "${pageContext.request.contextPath}/static/images/";
        let selectedAmount = 25;
        let selectedStyle = "Classic Travel";

        function buildGiftCode() {
            const part = () => Math.random().toString(36).substring(2, 6).toUpperCase();
            return "SKY-" + part() + "-" + part();
        }

        chips.forEach(chip => {
            chip.addEventListener("click", () => {
                chips.forEach(item => item.classList.remove("selected"));
                chip.classList.add("selected");
                selectedAmount = Number(chip.getAttribute("data-value"));
                customAmount.value = "";
            });
        });

        styles.forEach(style => {
            style.addEventListener("click", () => {
                styles.forEach(item => item.classList.remove("selected"));
                style.classList.add("selected");
                selectedStyle = style.getAttribute("data-style");
                giftCardImage.src = giftCardImageBase + style.getAttribute("data-image");
                giftCardImage.alt = style.getAttribute("data-visual");
            });
        });

        customAmount.addEventListener("input", () => {
            chips.forEach(item => item.classList.remove("selected"));
        });

        purchaseButton.addEventListener("click", event => {
            if (typeof window.skylineGiftCardPurchaseAllowed !== "undefined" && !window.skylineGiftCardPurchaseAllowed) {
                event.preventDefault();
                const loginUrl = window.skylineGiftCardLoginUrl || "/login";
                window.location.href = loginUrl + "?returnUrl=" + encodeURIComponent(window.location.pathname + window.location.search);
            }
        });

        buyForm.addEventListener("submit", event => {
            event.preventDefault();
            const amount = Number(customAmount.value) > 0 ? Number(customAmount.value) : selectedAmount;
            const recipientName = document.getElementById("giftRecipientName").value.trim();
            const recipientEmail = document.getElementById("giftRecipientEmail").value.trim();

            if (typeof window.skylineGiftCardPurchaseAllowed !== "undefined" && !window.skylineGiftCardPurchaseAllowed) {
                const loginUrl = window.skylineGiftCardLoginUrl || "/login";
                window.location.href = loginUrl + "?returnUrl=" + encodeURIComponent(window.location.pathname + window.location.search);
                return;
            }

            if (!confirm("Are you sure you want to purchase a $" + amount + " " + selectedStyle + " gift card for " + recipientName + "?")) {
                return;
            }

            const code = buildGiftCode();

            confirmation.textContent = selectedStyle + " gift card for " + recipientName + " purchased: " + code + " ($" + amount + ")";
            confirmation.classList.add("visible");
            if (window.skylineAddChecklistItem) {
                window.skylineAddChecklistItem({
                    id: "gift-card-" + Date.now(),
                    label: "Gift Card: $" + amount + " " + selectedStyle + " for " + recipientName + " (" + recipientEmail + ")"
                });
            }
        });
    })();
</script>
