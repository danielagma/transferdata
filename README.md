**QA Execution: FAILED ❌**

* **Environment:** DEV2
* **Instrument Configured:** PGB 3.000 06/35 (32nds config) / Decimal configured bonds

**Execution Summary:**
The core logic for inheriting the Referential Data pricing format is working and successfully matching the Bond Pricer in almost all areas. However, the story fails AC5 and AC6 specifically within the Market Depth widget. The manual `Price:*` order entry field does not support or render the 32nds format, reverting to decimal values instead.

---

### 1. Market Depth: Decimal Pricing Format (AC1, AC3, AC4, AC6, AC7, AC8)
**Status: PASSED ✅**
Verified that when a bond is configured as Decimal, all price values inside the Market Depth grid and the manual order entry price fields display accurately in decimal format, perfectly matching the Bond Pricer widget.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 1 AQUÍ ]

---

### 2. Market Depth: 32nds Pricing Format (AC1, AC3, AC5, AC6, AC7, AC8)
**Status: FAILED ❌**
Verified the grid displays 32nds correctly, but the manual `Price:*` entry field fails to inherit the format (Violating AC5 and AC6). 
* **Defect detail:** When clicking a 32nds price level on the grid (e.g., `97-01 1/2`), the system populates the `Price:*` input field with its decimal translation (e.g., `97.05`) instead of the fractional format. Manual typing of 32nds formatting is also rejected by the input field.

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

**Sign-off:** Blocked. Returning to Development to fix the Market Depth Order Entry Price field parsing for 32nds.
