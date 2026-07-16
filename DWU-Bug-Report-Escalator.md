**Summary:**
[Intermittent] [Bug] Escalator: Saved submarket venue loses internal state after layout reload, defaulting to "MULTI" payload

**Environment:**
* DEV2

**Description:**

**⚠️ QA Note - Intermittent Behavior:**
> This bug was successfully reproduced and evidence was collected based on Gabriel's report. However, after repeated testing cycles, the issue's reproducibility became inconsistent. This suggests a potential race condition or state/cache desynchronization during the workspace reload sequence.

**Overview:**
There is a state mismatch between the UI and the backend payload in the Escalator widget. When a user saves a specific submarket venue (e.g., `ESP`) to their layout and reloads the screen, the widget visually displays `ESP` as selected. However, if the user executes an order immediately after the reload, the system ignores the visually selected venue and sends a `MULTI` order instead, causing incorrect routing and inaccurate Toast/Blotter information.

**Steps to Reproduce:**
1. Navigate to the **Order Management** screen and observe the default **Escalator** widget.
2. Select a specific submarket from the dropdown (e.g., `ESP`).
3. Click the **Save** button to save the Escalator layout.
4. Right-click the application window and select **Reload**.
5. Once the screen reloads, observe that the Escalator widget correctly displays `ESP` in the venue dropdown.
6. Execute an order (e.g., click to submit a passive Buy order).
7. Inspect the confirmation Toast, the DevTools Network payload, and the Blotter.

**Actual Result:**
The internal state is lost despite the UI showing `ESP`:
* **Toast:** Displays an incorrect venue confirmation (e.g., shows `SENAF BUY...`).
* **Network Payload:** The Request Payload incorrectly sends `subMarket: "Multi"` instead of `ESP`.
* **Blotter:** The trade registers under an incorrect venue (e.g., `SENAF`) instead of the expected `ESP`.

**Expected Result:**
The internal state must match the rendered UI upon layout reload. If the widget loads with `ESP` visually selected, the subsequent order payload must strictly send `subMarket: "ESP"`. The Toast and Blotter must also reflect the correct `ESP` venue.

**Workaround (State Sync):**
If the user manually interacts with the dropdown after the reload (e.g., changes it to `SENAF` and then back to `ESP`), the internal state successfully re-syncs. Subsequent orders correctly send `subMarket: "ESP"`, triggering the correct `ESP` toast and Blotter entry.

**Attachments:**
* `Gabriel_Report.png` (Slack context)
* `Bug_Payload_Mismatch.jpg` (Showing UI with ESP, Payload with Multi, and Toast/Blotter with SENAF)
* `Successful_Workaround.jpg` (Showing correct behavior after manual toggle)
