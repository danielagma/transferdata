### Bug Ticket: Scrollbar Visual Mismatch on Ladder Widget

**Title:** Scrollbar position does not center with prices upon reloading Order Management screen
**Reporter:** Andrade Correa Gabriel
**Component:** UI / Order Management / Ladder Widget
**Severity:** Minor / Cosmetic

---

### Description
There is a visual synchronization issue on the Order Management screen. When the screen is reloaded, the prices within the Ladder widgets are centering correctly in the view, but the scrollbar fails to update its position accordingly. The developer noted this is more of a visual mismatch than a functional bug.

### Steps to Reproduce
1. Navigate to the Order Management screen containing the Ladder widgets.
2. Reload the screen.
3. Observe the position of the prices and the corresponding scrollbar on the right side of the Ladder widget.

### Actual Result
* The prices (bids and asks) center correctly in the view.
* The scrollbar remains in an incorrect position (e.g., pinned to the top) and does not visually reflect the centered state of the data grid.

### Expected Result
* The scrollbar thumb should center simultaneously with the prices upon reload, accurately reflecting the current view within the scrollable area.

### Attachments
* Order Management Overview: Screenshot showing multiple ladders with offset scrollbars.
* Ladder Close-up: Image highlighting the correctly centered prices alongside the incorrectly positioned scrollbar.
