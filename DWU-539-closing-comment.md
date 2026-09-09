### **QA Execution: PASSED ✅**
* **Environment:** DEV2

**Execution Summary:**
The dynamic expansion resize refactor of the Ladder widget has been successfully verified. As this ticket introduces no new acceptance criteria of its own, execution was run as a regression pass against the behaviour already signed off in DWU-283 (accordion), DWU-414 (Take Best section), DWU-413 (Show Qty / Iceberg mode) and DWU-423 (default height), covering both the docked widget in Order Management and the floating widget launched from the Bond Pricer. In every state tested the widget height is driven by its content, with no clipping, no dead space and no vertical scrolling.

---
### 1. Default State and Height on Load (DWU-283 AC 1, AC 4 · DWU-423) - **PASSED ✅**
Verified that a newly opened Ladder in Order Management defaults to both accordions collapsed, and that the widget height matches its content exactly: the full ladder, the quantity row and both accordion headers are visible, with no vertical scrollbar and no empty space below the last control. The DWU-423 condition does not reproduce, since the bottom controls are reachable without scrolling or manually resizing the widget.

---
### 2. Accordion Expansion: Take Best and Type / TiF (DWU-283 AC 2, AC 5 · DWU-414 AC 10, AC 12) - **PASSED ✅**
Verified that expanding "Take Best" grows the widget by exactly the height of the section, displaying the Buy and Sell buttons with their live quantity and price. Expanding "Type / TiF" afterwards grows it again to reveal Type, TiF and the DELAY toggle. The ladder keeps the same number of price levels through both expansions, and both dropdowns open in full without being clipped by the widget's bottom edge.

---
### 3. Collapse and Height Restoration (DWU-283 AC 3, AC 4) - **PASSED ✅**
Verified that collapsing each section reduces the widget by the height that section occupied, and that collapsing both returns the widget to the exact state and height it had on load, with no residual empty space and the ladder fully visible.

---
### 4. Data Retention Across Accordion Toggles (DWU-283 AC 6, AC 7, AC 8 · DWU-413 AC 8, AC 9) - **PASSED ✅**
Verified on venue ESP that Total Qty, Show Qty and the Order Type / Time in Force selections survive repeated expand and collapse cycles of both accordions. Confirmed that the section renders and measures identically while Type and TiF are disabled by an active Show Qty value (DWU-413 AC 8) and after clearing it, once both fields become editable again (DWU-413 AC 9). No widget refresh is triggered and market data keeps streaming throughout.

---
### 5. Accordion State Persistence to Workspace (DWU-283 AC 9) - **PASSED ✅**
Verified that saving the layout with "Take Best" expanded and "Type / TiF" collapsed restores exactly that combination, and the widget height corresponding to it, after a layout reload and after a full re-login. The layout loads in a clean state, with no pending Save / Revert.

---
### 6. Widget Resizing in Order Management - **PASSED ✅**
Verified across the full width range, with both accordions expanded, that no control is clipped, overlapped or pushed outside the widget at either extreme, and that the widget height continues to follow its content independently of the width applied. Evidence attached as a screen recording.

---
### 7. Floating Ladder Launched from the Bond Pricer (DWU-334 AC 8) - **PASSED ✅**
Verified that the Ladder launched from the Bond Pricer context menu ("View Ladder") behaves identically in its own window: expanding each accordion grows the window to fit the content, and collapsing them returns it to its original size, with nothing cut off and no scrolling required.

---
**Not covered in this cycle:** the disabled state of the Take Best buttons ("No Bids" / "No Asks"), as no instrument with an empty side of the book was available in DEV2 during execution.

---
**Sign-off:** Approved to close. The refactor preserves the behaviour previously signed off for the Ladder widget, in both the docked and the floating contexts.
@Artur Moreira Dobler
