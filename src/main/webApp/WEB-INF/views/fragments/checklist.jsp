<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="header-checklist">
  <button type="button" class="header-cart-toggle" id="headerChecklistToggle" aria-label="Open trip cart">
    <span class="header-cart-icon" aria-hidden="true"></span>
    <span class="header-cart-count" id="headerChecklistCount">0</span>
  </button>
  <div class="header-checklist-menu" id="headerChecklistMenu">
    <h3>Trip Cart</h3>
    <ul id="headerChecklistItems"></ul>
    <p id="headerChecklistEmpty">No hotels or gift cards added yet.</p>
  </div>
</div>

<script>
  (function () {
    const checklistUserId = "<c:out value='${not empty user ? user.userId : ""}'/>";
    const toggle = document.getElementById("headerChecklistToggle");
    const menu = document.getElementById("headerChecklistMenu");
    const list = document.getElementById("headerChecklistItems");
    const empty = document.getElementById("headerChecklistEmpty");
    const count = document.getElementById("headerChecklistCount");

    function getChecklistItems() {
      if (!checklistUserId) {
        return [];
      }

      try {
        return JSON.parse(localStorage.getItem("skylineTripChecklist_" + checklistUserId) || "[]");
      } catch (error) {
        return [];
      }
    }

    function saveChecklistItems(items) {
      if (checklistUserId) {
        localStorage.setItem("skylineTripChecklist_" + checklistUserId, JSON.stringify(items));
      }
    }

    function renderChecklist() {
      const items = getChecklistItems();
      list.innerHTML = "";
      count.textContent = items.length;
      empty.style.display = items.length === 0 ? "block" : "none";

      items.forEach(item => {
        const row = document.createElement("li");
        const label = document.createElement("span");
        const remove = document.createElement("button");

        label.textContent = item.label;
        remove.type = "button";
        remove.textContent = "Remove";
        remove.addEventListener("click", () => {
          saveChecklistItems(getChecklistItems().filter(savedItem => savedItem.id !== item.id));
          renderChecklist();
        });

        row.appendChild(label);
        row.appendChild(remove);
        list.appendChild(row);
      });
    }

    window.skylineAddChecklistItem = function (item) {
      if (!checklistUserId) {
        return;
      }

      const items = getChecklistItems();
      items.push({
        id: item.id || String(Date.now()),
        label: item.label || "SkyLine add-on"
      });
      saveChecklistItems(items);
      renderChecklist();
    };

    if (toggle && menu) {
      toggle.addEventListener("click", event => {
        event.stopPropagation();
        menu.classList.toggle("open");
      });

      menu.addEventListener("click", event => event.stopPropagation());
      document.addEventListener("click", () => menu.classList.remove("open"));
    }

    document.addEventListener("skylineChecklistChanged", renderChecklist);
    renderChecklist();
  })();
</script>
