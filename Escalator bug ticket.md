Overview:
Following the implementation of DWU-188 (TiF Field) and DWU-189 (Order Type Parameter), a UI rendering issue occurs when opening the Escalator widget. The default height of the component is too short, causing the "Manual Quantity" section to overlap or push down the newly added "Type" and "TiF" dropdowns, making them invisible to the user upon launch.

(Note: As discussed in Slack, the dropdowns are still there and become visible only if the user manually drags and increases the vertical height of the widget).

Steps to Reproduce:

Navigate to the Order Management screen.

Launch the Escalator widget for any instrument.

Observe the bottom control section of the widget (below the price ladder).

Actual Result:
Only the "Man Qty" field is visible. The "Type" and "TiF" dropdowns are completely hidden/cut off from the viewport on the widget's initial load.

Expected Result:
The default layout height of the Escalator widget must be adjusted to ensure all bottom controls ("Man Qty", "Type", and "TiF") are fully visible and accessible immediately upon launch, without requiring the trader to manually resize the window.
