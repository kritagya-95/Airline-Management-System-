<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<section class="gift-redeem-panel" id="redeemGiftCard">
    <h2>Redeem a Gift Card</h2>
    <form class="gift-redeem-form" id="giftRedeemForm">
        <label>
            Gift Card Code
            <input type="text" id="giftRedeemCode" placeholder="SKY-2026-GOLD" autocomplete="off"/>
        </label>
        <button type="submit" class="gift-secondary-btn">Apply</button>
    </form>
    <p class="gift-redeem-message" id="giftRedeemMessage" aria-live="polite"></p>
</section>

<script>
    (function () {
        const redeemForm = document.getElementById("giftRedeemForm");
        if (!redeemForm) {
            return;
        }

        const validGiftCards = [
            { code: "SKY-2026-GOLD", balance: 100 },
            { code: "SKY-TRIP-0050", balance: 50 },
            { code: "SKY-GIFT-0200", balance: 200 }
        ];

        redeemForm.addEventListener("submit", event => {
            event.preventDefault();
            const codeInput = document.getElementById("giftRedeemCode");
            const message = document.getElementById("giftRedeemMessage");
            const submittedCode = codeInput.value.trim().toUpperCase();
            const matchedCard = validGiftCards.find(card => card.code === submittedCode);

            if (matchedCard) {
                const deductedAmount = Math.min(matchedCard.balance, 75);
                const remainingBalance = matchedCard.balance - deductedAmount;
                message.textContent = "Gift card applied. Mock remaining balance: $" + remainingBalance + ".";
                message.className = "gift-redeem-message success";
                document.dispatchEvent(new CustomEvent("skylineGiftCardApplied", {
                    detail: {
                        code: matchedCard.code,
                        deductedAmount: deductedAmount,
                        remainingBalance: remainingBalance
                    }
                }));
            } else {
                message.textContent = "That code is not valid yet. Try SKY-2026-GOLD for the mock flow.";
                message.className = "gift-redeem-message error";
                document.dispatchEvent(new CustomEvent("skylineGiftCardRemoved"));
            }
        });
    })();
</script>
