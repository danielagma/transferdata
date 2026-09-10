[Bug] Ladder: expanding or collapsing an accordion in one Ladder resets a second Ladder's scroll to the top of the book, and the recentre control responds only after a delay

**Overview**
When two Ladder widgets are open in the same Order Management layout, changing the expanded state of an accordion ("Take Best" or "Type / TiF") in one of them resets the price ladder of the *other* widget to the top of the book. The trader loses the view of the spread, and any active order being watched is pushed out of the visible rows. The recentre control does not recover it immediately: it responds only after a delay of several seconds, or after being clicked repeatedly. The behaviour occurs in both directions, since either widget can be the one that jumps, and it happens on both accordions.

Reproduced with **Bank ON and Trader ON**, on a live book that is actively ticking, on instrument PGB 3.000 06/35 (venue MULTI).

**Steps to reproduce**
1. On Order Management, set Bank to ON and Trader to ON, and confirm the book is ticking.
2. With a Ladder loaded on an instrument (PGB 3.000 06/35, venue MULTI), open a second Ladder from "Widgets" and set the same instrument.
3. In both widgets, expand "Take Best" and "Type / TiF", leaving both ladders centred on the spread.
4. Expand or collapse either accordion in one of the two widgets.
5. Observe the price ladder of the other widget.
6. Click the recentre control on the affected widget once, and keep observing without clicking again.

**Actual result:** At step 5 the other widget's ladder jumps to the top of the book, showing the highest ask levels instead of the spread. At step 6 the ladder does not recentre on the click. It returns to the spread on its own, but only after a delay of several seconds, or after the control is clicked repeatedly. No manual scrolling of the grid is needed for it to recover.

**Expected result:** Changing the expanded state of an accordion in one Ladder must not alter the scroll position of any other Ladder in the layout; each widget keeps its own view of the book. The recentre control must return the ladder to the spread immediately on a single click, from any scroll position, including the top of the book.

**Evidence:**
