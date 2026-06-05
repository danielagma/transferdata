**Summary / Title:**
[Bug] Escalator: Visual mismatch on Quantity Bar when changing instruments (Internal state retained but highlight lost)

**Description:**
A UI state synchronization issue was found in the Escalator widget. When a user selects a quantity from the vertical Quantity Bar, it highlights in orange. If the user then changes the instrument via the dropdown, the Quantity Bar loses its visual highlight, suggesting to the user that the selection has been cleared. 

However, the internal state still retains the previously selected value. If the user clicks on the market depth grid, the system submits an order using that "invisible" quantity. This mismatch poses a severe risk of unintended order submissions (fat-finger errors).

*(Note: The ORCA timeout error shown in the evidence is a known environment issue. However, the error banner itself explicitly confirms the bug by showing the system attempted to submit a "BUY 10MM" order despite no quantity being visually selected).*

**Steps to Reproduce:**
1. Open the Escalator widget and select any instrument (e.g., `PGB 3.250 06/36`).
2. Click on a value in the vertical Quantity Bar (e.g., `10`). Observe it highlights in orange.
3. Change the instrument using the top dropdown (e.g., to `PGB 0.900 10/35`).
4. **Observe the UI:** The Quantity Bar loses the orange highlight, appearing as if no quantity is selected.
5. Click on any price cell in the grid to submit an order.
6. **Observe the network payload / banner:** The system attempts to submit the order using the previously selected quantity (`10`), even though it was not visually highlighted.

**Expected Result:**
The UI and the internal state must remain synchronized. The Product Owner should define the exact desired behavior, which must be one of the following:
* **Option A:** Changing the instrument completely clears the selection (both visual highlight and internal state reset).
* **Option B:** Changing the instrument retains the selection (the internal state is kept AND the orange highlight remains visible).

**Actual Result:**
The visual highlight resets, but the internal state does not, allowing the user to submit an order "blindly" with a hidden quantity.

**Environment:**
* DEV2

**Severity / Priority:**
* **Severity:** High (Risk of unintended financial exposure due to misleading UI).
* **Priority:** High

**Attachments:**
* `image_8af71d.png` (Quantity selected)
* `image_8af3a3.png` (Instrument changed, visual highlight lost)
* `escalator.mp4` (Video showing the full flow and the 10MM submission attempt on the network/banner)