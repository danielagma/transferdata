# [DWU-253] Add Own Orders Column in Escalator Market Depth

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-253 |
| Ticket name | Add Own Orders Column in Escalator Market Depth |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested automation order | **Tier 7** — Depends on [[DWU-172]] / [[DWU-173]] (must be able to place an order before its own-order indicator can appear in these columns). |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

Today, a trader's own active orders are shown only as small markers within the shared price ladder (e.g. the "JC"/"GAC"/"AD" tags seen in other stories' evidence, such as [[DWU-172]] and [[DWU-261]]). This makes them hard to distinguish from general market liquidity at a glance. This story adds two dedicated columns — "My Bids" and "My Asks" — flanking the price ladder, showing only the logged-in trader's own active order quantities at each price level, while the existing shared market-depth display continues to show everyone else's liquidity as it does today.

Roles on the ticket: QA Tester — Gabriella Sierra Fossaluza; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**.

## User story

As a trader, I want to see my own active orders directly in the Escalator Market Depth widget in separate columns next to the price ladder, so that I can manage orders without leaving the widget.

## Acceptance criteria

- [ ] System must add a "My Bids" column to the left of the buy side of the ladder (highlighted yellow box in Screenshot 1).
- [ ] System must add a "My Asks" column to the right of the sell side of the ladder.
- [ ] The new columns must only display active bid/ask order quantities that belong to the logged-in trader — other users' orders must not appear in these columns.
- [ ] The displayed quantities must appear on the same price level as the trader's active order.
- [ ] Existing market depth quantities and orders that do not belong to the logged-in trader must continue to display as they do today.
- [ ] Existing functionality for submitting, viewing, and updating orders must continue to work after the new columns are added.
- [ ] System must implement the click-to-execute feature (i.e. the new columns don't break/bypass existing click-to-execute behavior from [[DWU-172]]/[[DWU-173]]).
- [ ] If a trader has multiple orders at the same price level, the system must sum them in the "My Bid"/"My Ask" columns.

## Implemented behavior

- Two new columns, "My Bids" and "My Asks", were added flanking the price ladder in the Escalator widget — "My Bids" to the left of the buy (blue) side, "My Asks" to the right of the sell (pink/magenta) side.
- These columns show only the logged-in trader's own active order quantities, at the price level matching that order. Orders belonging to other users continue to render only via the pre-existing in-ladder markers, not in these new columns.
- The rest of the market depth display (shared bid/ask liquidity across all traders) is unchanged and continues to render as before.
- Click-to-execute behavior (from [[DWU-172]] and [[DWU-173]]) continues to function with the new columns present.
- When a trader has multiple own orders resting at the same price level, the "My Bids"/"My Asks" column aggregates (sums) them into a single displayed quantity at that level — confirmed in QA evidence where a second order added to an existing position at the same price updated the aggregated column value (e.g. `100` → `108` after adding another own order at the same level).

## QA evidence

**Status: Tested & Approved** — Tested by Gabriella Sierra Fossaluza.

Results: verified the implementation of the new "My Bids" and "My Asks" columns in the Escalator Market Depth widget. The new columns are displayed in the expected positions, show only the logged-in trader's orders at the correct price levels, preserve the existing market depth information, and maintain current order management functionality, including click-to-execute behavior. Multiple orders at the same price level are correctly aggregated and displayed. All acceptance criteria were successfully validated. **Approved to proceed.**

Evidence (instrument `ESP SPGB 1.300 10/26` and `PGB 3.000 06/35`):
1. "My Bids" and "My Asks" columns confirmed positioned correctly on either side of the price ladder.
2. A passive Sell order submission: `ESP SELL 100MM @ 99.625 CONFIRMED`, reflected in the "My Asks" column at that price level.
3. A passive Buy order submission: `ESP BUY 100MM @ 99.345 CONFIRMED`, with a second own order added at the same level, aggregating to `108` in the "My Bids" column — confirming the sum-at-same-price-level behavior (Acceptance Criterion 8).

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 8-item acceptance criteria table.
- `02-screenshot1-my-bids-my-asks-columns.png` — Screenshot 1: "My Bids" and "My Asks" columns highlighted (yellow boxes) in the Market Depth widget mockup.
- `03-qa-tested-approved.png` — QA result: "Status: Tested & Approved" summary and Escalator grid with columns annotated.
- `04-qa-sell-buy-confirmed-aggregation.png` — QA result: Sell and Buy order confirmations, including the aggregation of multiple own orders at the same price level.

## Notes for automation

- Requires an Order Management setup with the Escalator widget open, and the ability to place at least two own orders (one to establish a position, one more at the same price level to test aggregation).
- Candidate validations for a test:
  - "My Bids" column appears to the left of the buy side; "My Asks" to the right of the sell side.
  - After submitting an own order, its quantity appears in the correct "My Bids"/"My Asks" column, at the matching price level.
  - Other traders' orders/liquidity do not appear in these columns (only in the existing shared bid/ask display).
  - Submitting a second own order at the same price level as an existing one updates the column to show the summed quantity.
  - Click-to-execute (from [[DWU-172]]/[[DWU-173]]) still functions correctly with these columns present.
- Depends on [[DWU-172]] and [[DWU-173]] (order submission mechanics) being functional, since placing an order is the precondition for observing this story's columns populate.

## References

- Jira: DWU-253 (https://darwinjira.atlassian.net/browse/DWU-253)
- Epic: DWU-300
- Related stories: [[DWU-172]] (passive order submission), [[DWU-173]] (aggressive order submission) — both are preconditions for testing this story; [[DWU-284]] (per-row cancel icon added to these columns); [[DWU-257]] (ladder layout these columns sit within)
