**Summary:**
[Bug] Escalator: Pressing 'Enter/Return' does not exit edit mode in "Man Qty" field

**Environment:**
* DEV2

**Linked to Story:** DWU-261

**Severity:** Minor / Low

**Description:**

**Overview:**
As per the Acceptance Criteria (AC3) for the Manual Quantity feature in the Escalator widget, users should be able to exit the cell edit mode by either hitting the 'Enter/Return' key or changing the context (clicking outside). Currently, the keyboard event for 'Enter/Return' is unresponsive, forcing the user to use the mouse to click outside the cell to save the custom quantity.

**Steps to Reproduce:**
1. Navigate to the **Order Management** screen.
2. Open an **Escalator Market Depth** widget for any valid instrument.
3. Click on the **"Man Qty"** input field to activate edit mode.
4. Type a valid custom integer (e.g., `15`).
5. Press the **Enter** (or Return) key on the keyboard.

**Expected Result:**
The system must exit edit mode, highlight the "Man Qty" field with an orange background, and successfully set the custom quantity for the next order (Matching the behavior of the Bond Pricer).

**Actual Result:**
The 'Enter/Return' keystroke is ignored. The cursor remains active inside the "Man Qty" input field, and edit mode is not exited.

**Workaround:**
The user can successfully exit edit mode and save the custom quantity by clicking anywhere outside the "Man Qty" cell (changing context).
