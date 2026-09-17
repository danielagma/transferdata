### **QA Execution: PASSED ✅**
* **Environment:** DEV2

**Execution Summary:**
The instrument reported on this ticket now loads in the Ladder. The widget renders the book instead of showing "Unknown error. Please contact support.", and the `getInitialData` TypeError no longer appears in the console.

---
### 1. The reported instrument loads and renders the book - **PASSED ✅**
Followed the steps on the ticket: opened the Order Management screen and entered `SPGBS 31/10/26 CAC` (`ES00000125K5`) in the Ladder with venue `MULTI` selected. The price grid renders with bids and asks, and the widget area no longer shows the generic error message.

---
### 2. No Critical entry in the console - **PASSED ✅**
Checked the browser console while loading the instrument. The entry reported on the ticket, `Critical: [Order Management] [[Market Depth Widget Store]] getInitialData TypeError: Cannot read properties of null (reading 'pricingFormat')`, is not logged.

---
### 3. The widget survives a reference data response with no bond data - **PASSED ✅**
Checked the `reference-data/bonds/ES00000125K5` call, which returns `{bond: null, lookups: null}`. The widget keeps working with that response, which is the condition that produced the original crash.

---
**Sign-off:** Approved to close. The reported behaviour does not reproduce after the fix.

**Evidence:**

@Artur Moreira Dobler
