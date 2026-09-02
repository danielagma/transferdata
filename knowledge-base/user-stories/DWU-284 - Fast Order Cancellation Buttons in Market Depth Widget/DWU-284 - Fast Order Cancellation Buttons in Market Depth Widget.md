# [DWU-284] Fast Order Cancellation Buttons in Market Depth Widget

> **Possible incomplete acceptance-criteria capture:** the visible requirement IDs in the ticket's table jump `0, 1, 2, 3, 4, 7, 8, 9, 10` — IDs 5 and 6 were not visible in the captured screenshot (likely cut off below the fold, not necessarily missing from the ticket). If exact wording for AC5/AC6 is needed, re-check the live Jira ticket before treating this document's criteria list as complete.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-284 |
| Ticket name | Fast Order Cancellation Buttons in Market Depth Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (My Bids/My Asks columns) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story adds a **per-row, per-order** cancellation trash icon to the "My Bids"/"My Asks" columns introduced in [[DWU-253]], letting a trader cancel their own orders directly from the ladder without opening another screen (e.g. the Order Blotter). It explicitly **replaces** the "cancel row" button feature from a prior, now-closed ticket (DWU-256: "Add Individual Order Cancel Columns in Escalator Market Depth"). It complements — and is distinct from — [[DWU-259]]'s bulk `Cancel Bids`/`Cancel All`/`Cancel Asks` buttons: this story cancels one order at a time (LIFO — Last In, First Out — when multiple orders share a price level), while DWU-259 cancels everything on a side in bulk.

Roles on the ticket: QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Approved; FE — Approved. Status: **Approved**.

## User story

As a trader, I want to cancel my active orders directly from the Market Depth Ladder, so that I can manage my orders without opening another screen.

## Acceptance criteria

- [ ] **AC0:** this functionality totally replaces the "cancel row" button feature from DWU-256 (closed).
- [ ] **AC1:** the system must display a trash icon only for price levels where the logged-in trader has one or more active orders.
- [ ] **AC2:** single-clicking the trash icon must immediately cancel the most recently placed active order at that price level (LIFO — Last In, First Out, determined by the latest order creation timestamp).
- [ ] **AC3:** if only one active order exists at the selected price level, the single-click action must cancel that order (and the trash icon then disappears, per AC4).
- [ ] **AC4:** if active orders remain after a single-click cancellation, the trash icon must remain visible.
- [ ] **AC7:** after each successful cancellation, the "My Bids"/"My Asks" columns must immediately refresh to display the remaining active orders.
- [ ] **AC8:** the Order Blotter must update after each successful cancellation to reflect the updated order status.
- [ ] **AC9:** when no active trader orders remain at a price level, the trash icon must no longer be displayed.
- [ ] **AC10:** cancelling an order must not affect market depth quantities or orders belonging to other traders.

## Implemented behavior

- Each row in the "My Bids"/"My Asks" columns ([[DWU-253]]) that has at least one active own order shows a red trash icon.
- Clicking the trash icon cancels the most recently placed order at that price level (LIFO), not necessarily the entire aggregated quantity — if multiple own orders exist at the same price, one click removes only the latest, and the icon stays visible with the reduced remaining quantity; a second click removes the next, and so on until none remain, at which point the icon disappears.
- On successful cancellation: a green confirmation banner is shown, the "My Bids"/"My Asks" column value updates immediately, and the Order Blotter widget reflects the cancellation (status "Cancel").
- This entirely replaces the older "cancel row" button behavior from the now-closed DWU-256.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: successfully verified the implementation of the Fast Order Cancellation buttons within the Escalator widget. All Acceptance Criteria have been met.

1. **Single Order Cancellation & UI Rendering:** submitted individual passive Buy and Sell orders. Verified that the red trash icon correctly renders exclusively on the price levels containing the trader's own active orders. Single-clicking the icon successfully processed the cancellation immediately, removed the trash icon, displayed the green confirmation banner, and accurately updated the Order Blotter status to "Cancel".
2. **Multiple Orders Aggregation & Sequential Cancellation:** submitted two consecutive passive Buy orders (25MM each) at the exact same price level (`99.480`). 
   - **First click:** verified the system successfully aggregated the quantity (50) and that a single click on the trash icon cancelled only the most recently placed order, updating the remaining active quantity to 25 while keeping the trash icon visible.
   - **Second click:** verified the subsequent click successfully cancelled the remaining order and completely removed the trash icon from the grid.

Final sign-off: "Approved to close." Tagged: Hermela Mekonnen.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, acceptance criteria table (note the visible ID gap at AC5/AC6).
- `02-screenshot1-trash-icon-mockup.png` — Screenshot 1: Ladder mockup with per-row trash icons, quantity bar, Total Qty aggregation.
- `03-qa-execution-passed-single-order-cancellation.png` — QA result: single order cancellation, trash icon rendering, Order Blotter update.
- `04-qa-execution-multiple-orders-aggregation-sequential-cancel.png` — QA result: LIFO sequential cancellation of two orders aggregated at the same price level.

## Notes for automation

- Requires an Order Management setup with Escalator + Order Blotter widgets open, with the "My Bids"/"My Asks" columns from [[DWU-253]] present.
- Candidate validations for a test:
  - Placing an own order shows a trash icon at that price level; no trash icon appears where the trader has no own order.
  - Clicking the trash icon with a single own order at that level cancels it, and the icon disappears (AC3/AC9).
  - Placing two own orders at the same price level, then clicking the trash icon twice: the first click cancels only the most recent order (icon stays, quantity reduces), the second click cancels the remaining one (icon disappears) — LIFO behavior (AC2).
  - After each cancellation, the "My Bids"/"My Asks" column and the Order Blotter both update to reflect the change (AC7/AC8).
  - Cancelling a trader's own order does not affect other traders' displayed liquidity (AC10).
- Distinguish from [[DWU-259]] when writing tests: this story is per-row/per-order (LIFO) cancellation; DWU-259 is bulk cancellation of all bids/asks/everything via top-level buttons. Both can coexist in the same widget and may need to be tested for non-interference with each other.
- Depends on [[DWU-253]] (My Bids/My Asks columns) being in place, since the trash icon is rendered within those columns.

## References

- Jira: DWU-284 (https://darwinjira.atlassian.net/browse/DWU-284)
- Epic: DWU-300
- Superseded ticket: DWU-256 ("Add Individual Order Cancel Columns in Escalator Market Depth" — Closed, replaced by this story)
- Related stories: [[DWU-253]] (My Bids/My Asks columns — dependency), [[DWU-259]] (bulk cancel actions — complementary mechanism)
