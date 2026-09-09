[Bug] Ladder: expanding or collapsing an accordion in one Ladder resets a second Ladder's scroll to the top of the book

* **Environment:** DEV2

**Overview**
When two Ladder widgets are open in the same Order Management layout, changing the expanded state of an accordion ("Take Best" or "Type / TiF") in one of them resets the price ladder of the *other* widget to the top of the book. The trader loses the view of the spread, and any active order being watched is pushed out of the visible rows. The recentre control does not recover it: pressing it while the ladder sits at the top has no effect, and it only works after the trader scrolls the grid manually first. The behaviour occurs in both directions, since either widget can be the one that jumps, and it happens on both accordions.

**Steps to reproduce**
1. Open Order Management, with a Ladder widget loaded on an instrument (SPGB 1.300 10/26, venue MULTI).
2. From "Widgets", open a second Ladder and set the same instrument.
3. In both widgets, expand "Take Best" and "Type / TiF", leaving both ladders centred on the spread.
4. Expand or collapse either accordion in one of the two widgets.
5. Observe the price ladder of the other widget.
6. Press the recentre control on the affected widget.
7. Scroll that ladder manually, then press recentre again.

**Actual result:** At step 5 the other widget's ladder jumps to the top of the book, showing the highest ask levels instead of the spread. At step 6 the recentre control has no effect and the ladder stays at the top. At step 7, once the grid has been scrolled by hand, the same recentre control works and returns the ladder to the spread.

**Expected result:** Changing the expanded state of an accordion in one Ladder must not alter the scroll position of any other Ladder in the layout; each widget keeps its own view of the book. The recentre control must return the ladder to the spread from any scroll position, including the top of the book, without requiring the trader to scroll manually first.

**Evidence:**

**Note:** it has not been established whether this behaviour predates DWU-539 (Ladder dynamic expansion resize), which is why it is raised as a standalone defect rather than as a regression of that ticket.
