### Issue Details
*   **Espacio:** Darwin Bonds US (DWU)
*   **Tipo de actividad:** Error (Bug)
*   **Estado:** For Triage
*   **Sprint:** [Current Active Sprint]
*   **Resumen:** [Bug] Escalator: "Type" and "TiF" dropdowns are hidden on initial load due to insufficient default height
*   **Principal (Epic):** [Leave Blank unless required by team]
*   **Componentes:** Order Management / Escalator
*   **Assignee:** Artur Moreira Dobler
*   **Linked Issues:** relates to DWU-188, relates to DWU-189
*   **Priority:** High

---

### Descripción

**Overview:**
Following the implementation of DWU-188 (TiF Field) and DWU-189 (Order Type Parameter), a UI rendering issue occurs when opening the Escalator widget. The default height of the component is too short, causing the "Manual Quantity" section to overlap or push down the newly added "Type" and "TiF" dropdowns out of the initial view. 

*(Note: The dropdowns are present in the component, but the user is forced to either use the vertical scrollbar or manually drag to increase the height of the widget to access them. This disrupts the fast-paced trading UX required for this widget).*

**Steps to Reproduce:**
1. Navigate to the **Order Management** screen.
2. Launch the **Escalator** widget for any instrument.
3. Observe the bottom control section of the widget (below the price ladder).

**Actual Result:**
Only the "Man Qty" field is visible within the default viewport. The "Type" and "TiF" dropdowns are pushed down, forcing the trader to scroll or manually resize the widget to see and interact with them.

**Expected Result:**
The default layout height of the Escalator widget must be adjusted to ensure all bottom controls ("Man Qty", "Type", and "TiF") are fully visible and accessible immediately upon launch, without requiring the trader to scroll or resize the window.
