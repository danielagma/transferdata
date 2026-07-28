**QA Execution: PASSED (WITH MINOR DEVIATION) ✅⚠️**

* **Environment:** DEV2
* **ISIN Used:** SPGB 1.300 10/26

**Execution Summary by Scenario:**

### 1. Default State & Saving Custom Quantity (AC1, AC2, AC3)
Verified that the "Man Qty" field is editable and empty by default. The system accepts valid integer inputs and saves the custom quantity successfully when changing context (clicking outside the cell). 
*⚠️ **Deviation Noted:** Exiting edit mode by pressing the 'Enter/Return' key is currently unresponsive (violating AC3). A minor bug has been raised and linked to this story to address the keyboard event.*

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 1 AQUÍ ]

---

### 2. Mutual Exclusivity: Custom Qty Overrides Presets (AC4, AC6)
Verified that entering and saving a custom quantity correctly highlights the "Man Qty" field in orange. Simultaneously, the system accurately removes the orange highlight from all previously selected preset buttons, strictly enforcing the mutual exclusivity rule.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 2 AQUÍ ]

---

### 3. Mutual Exclusivity: Presets Override Custom Qty (AC5)
Verified the reverse flow. When a custom quantity is currently active, selecting any preset button (e.g., 10, 25) successfully highlights the preset button, completely clears the numerical value inside the "Man Qty" input field, and removes its orange highlight.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 3 AQUÍ ]

---

### 4. System Reset: CLR Button (AC8)
Verified that clicking the "CLR" button acts as a full reset. It successfully clears any typed numerical value in the "Man Qty" field and completely removes the active orange highlight from all preset buttons and the manual field.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 4 AQUÍ ]

---

### 5. Order Execution Accuracy (AC7)
Verified the core trading functionality for all 3 quantity paths. Successfully submitted and confirmed orders using:
1. **Custom Manual Quantity:** System executed the exact typed value.
2. **Single Preset:** System executed the exact preset button value.
3. **Aggregated Presets:** System successfully executed the mathematical sum of multiple selected preset buttons.

*(Please see execution video below)*
[ 📎 ARRASTRA Y SUELTA TU VIDEO 5 AQUÍ ]

**Sign-off:** Approved to close. (Enter key defect tracked separately).
