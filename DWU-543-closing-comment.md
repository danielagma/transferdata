### **QA Execution: PASSED ✅**
* **Environment:** DEV2

**Execution Summary:**
The scrollbar misalignment reported on this ticket no longer reproduces. On the Order Management screen with multiple Ladder widgets open, the scrollbar thumb now centres together with the prices on every reload, accurately reflecting the current position within the scrollable area.

---
### 1. Scrollbar centres with the prices on reload - **PASSED ✅**
Followed the steps on the ticket: opened the Order Management screen with Ladder widgets, reloaded the screen and checked the price column against the scrollbar on the right of each widget. The prices centre in the view and the scrollbar thumb centres with them, instead of staying pinned to the top. Repeated across several reloads with no misalignment observed.

---
**Sign-off:** Approved to close. The reported behaviour does not reproduce after the fix.

**Evidence:**

@Gabriel Andrade Correa
