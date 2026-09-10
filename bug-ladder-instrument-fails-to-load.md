[Bug] Ladder: some instruments fail to load and the widget shows "Unknown error. Please contact support."

* **Environment:** DEV2

**Overview**
On the Order Management screen, loading certain instruments into the Ladder leaves the widget unable to render the book: the price grid never appears and the widget area shows the generic message "Unknown error. Please contact support.". It was reproduced with SPGBS 31/10/26 CAC (ISIN ES00000125K5) on venue MULTI. At the moment the widget gives up, the browser console logs a Critical entry from the Market Depth Widget Store: `[Order Management] [[Market Depth Widget Store]] getInitialData TypeError: Cannot read properties of null (reading 'pricingFormat').

**Steps to reproduce**
1. Navigate to the Order Management screen.
2. In the Ladder, with venue MULTI selected, enter the instrument SPGBS 31/10/26 CAC (ISIN ES00000125K5).

**Actual result:** The price ladder does not render. The widget body shows "Unknown error. Please contact support.". The browser console logs `Critical: [Order Management] [[Market Depth Widget Store]] getInitialData TypeError: Cannot read properties of null (reading 'pricingFormat')`. Every request the widget issues for this instrument returns 200, so nothing fails in the Network tab.

**Expected result:** The Ladder must load and display the book for this instrument, the same way it does for the instruments that work today. If data the widget requires is genuinely unavailable for an instrument, the widget must state which data is missing instead of showing the generic "Unknown error. Please contact support.".

**Evidence:**
