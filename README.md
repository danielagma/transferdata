**QA Execution: PASSED ✅ (With Approved Deviation)**

* **Environment:** DEV2
* **Instrument Configured:** PGB 3.000 06/35 (32nds config) / Decimal configured bonds

**Execution Summary:**
The core logic for inheriting the Referential Data pricing format is working and successfully matching the Bond Pricer in the main grid areas. 

**⚠️ Important Note regarding AC5 & AC6:** 
The written Acceptance Criteria state that *ALL* prices (including "order entry prices") must reflect the 32nds format. Currently, the manual `Price:*` order entry field in the Market Depth widget does not support this and reverts to decimal values. However, following an offline discussion between the Product Owners and the Development team, it was agreed that the manual entry field is exempt from this formatting rule. Although the written ACs in this ticket were not updated by the BAs to reflect this scope change, I am marking this execution as **PASSED** based on that explicit PO approval.

---

### 1. Market Depth: Decimal Pricing Format (AC1, AC3, AC4, AC6, AC7, AC8)
**Status: PASSED ✅**
Verified that when a bond is configured as Decimal, all price values inside the Market Depth grid and the manual order entry price fields display accurately in decimal format, perfectly matching the Bond Pricer widget.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 1 AQUÍ ]

---

### 2. Market Depth: 32nds Pricing Format (AC1, AC3, AC5, AC6, AC7, AC8)
**Status: PASSED ✅ (With PO Exemption)**
Verified the grid displays 32nds accurately. 
* **Deviation Accepted:** When clicking a 32nds price level on the grid (e.g., `97-01 1/2`), the system populates the `Price:*` input field with its decimal translation (e.g., `97.05`). Manual typing of 32nds is rejected. As noted in the summary, this specific behavior for the entry field has been approved by the PO despite conflicting with the original written AC comments.

*(Please see execution video/image below)*
[ 📎 ARRASTRA Y SUELTA TU CAPTURA/VIDEO 2 AQUÍ ]

---

### 3. Escalator: Decimal Pricing Format (AC2, AC3, AC4, AC6, AC7, AC8)
**Status: PASSED ✅**
Verified that when a bond is configured as Decimal, all price values inside the Escalator price ladder grid render consistently in decimal format, matching the Bond Pricer.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 3 AQUÍ ]

---

### 4. Escalator: 32nds Pricing Format (AC2, AC3, AC5, AC6, AC7, AC8)
**Status: PASSED ✅**
Verified that when a bond is configured in 32nds, all price values inside the Escalator price ladder grid successfully render in the 32nds fractional format (e.g., `97-01 1/2`), completely matching the Bond Pricer formatting.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 4 AQUÍ ]

**Sign-off:** Approved to close. (Market Depth order entry format deviation approved offline by PO).
