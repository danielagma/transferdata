# [DWU-257] Align Price Ladder and Trader Order Indicators In Market Depth Widget

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-257 |
| Ticket name | Align Price Ladder and Trader Order Indicators In Market Depth Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested automation order | **Tier 5** — Structural layout of the widget created in [[DWU-163]]; no hard functional blocker, but a natural pairing with [[DWU-180]] since both are ladder-layout stories. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This is a structural/visual-consistency story for the Escalator ladder itself: it defines the canonical layout (sell above buy, single centered price column) and where the trader's own-order indicator (initials, e.g. "JC"/"GAC"/"AD" seen across other stories' evidence) must sit relative to the price cell, so the ladder reads consistently regardless of which story added a given piece of functionality on top of it.

Roles on the ticket: QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**.

## User story

As a trader, I want the Escalator Market Depth widget to display price levels and trader order indicators consistently, so that the ladder is easier to read and active orders are clearly associated with the correct side of the market.

## Acceptance criteria

- [ ] Sell price levels must be displayed above buy price levels within a single centered price ladder.
- [ ] Sell and buy price columns must be horizontally aligned within the ladder.
- [ ] Trader order indicators for sell orders must be displayed on the right side of the sell price level.
- [ ] Trader order indicators for buy orders must be displayed on the left side of the buy price level.
- [ ] Trader order indicators must appear at the same price level as the associated active order.
- [ ] The ladder layout must match the approved Escalator Market Depth design.

## Implemented behavior

- The Escalator ladder renders sell prices (pink/magenta) in the upper half and buy prices (blue) in the lower half, both sharing a single centered price column (not two separate side-by-side price columns).
- Sell and buy price cells are horizontally aligned within that single ladder structure.
- A trader's own-order indicator (their initials, e.g. "GAC") appears directly next to the price cell of their active order, at the exact same row/price level as that order:
  - For a **sell** order, the indicator sits on the **right side** of the pink sell price cell.
  - For a **buy** order, the indicator sits on the **left side** of the blue buy price cell.
- This layout is the structural baseline that other stories build on (e.g. [[DWU-253]]'s My Bids/My Asks columns, [[DWU-172]]/[[DWU-173]]'s order submission, [[DWU-284]]'s per-row cancel icon).

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Results: the structural alignment and order indicator positioning for the Escalator Market Depth widget have been successfully validated against the approved design. All Acceptance Criteria have been fully met.

1. **Single centered price ladder layout structural alignment:** validated that the Escalator Market Depth widget correctly renders market data with sell price levels (pink) displayed completely above the buy price levels (blue). Both sell and buy price values are perfectly horizontally aligned within a single, centralized price column, structurally matching the approved design mockup.
2. **Display and positioning of trader order indicators for active Sell orders:** successfully submitted a passive Sell order and validated the UI update — the trader order indicator appears exactly at the same price-level row as the associated active sell order, explicitly positioned on the **right side** of the pink sell price cell (e.g. `ESP SELL 10MM @ 100.815 CONFIRMED`).
3. **Display and positioning of trader order indicators for active Buy orders:** successfully submitted a passive Buy order and validated the UI update — the trader order indicator appears exactly at the same price-level row as the associated active buy order, explicitly positioned on the **left side** of the blue buy price cell.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, acceptance criteria table, Screenshot 1 (approved layout mockup).
- `02-qa-testing-passed-centered-ladder-alignment.png` — QA result: single centered ladder with sell above buy, horizontally aligned.
- `03-qa-testing-sell-buy-indicator-positioning.png` — QA result: own-order indicator positioned right (sell) and left (buy) of the respective price cells.

## Notes for automation

- Candidate validations for a test:
  - The ladder renders as a single centered price column, with sell (pink) rows above buy (blue) rows.
  - After submitting a passive Sell order, the trader's own-order indicator appears on the right side of that price level's sell cell.
  - After submitting a passive Buy order, the trader's own-order indicator appears on the left side of that price level's buy cell.
  - The indicator's row matches the exact price level of the order (no off-by-one-row mismatches).
- This story is a good candidate for a lightweight visual/structural check bundled alongside order-submission tests ([[DWU-172]]/[[DWU-173]]), since exercising those already produces the own-order indicator this story defines the position of — rather than writing a fully separate scenario just to check layout.

## References

- Jira: DWU-257 (https://darwinjira.atlassian.net/browse/DWU-257)
- Epic: DWU-300
- Related stories: [[DWU-172]] (passive order submission — produces the own-order indicator), [[DWU-173]] (aggressive order submission), [[DWU-253]] (My Bids/My Asks columns — related order visibility)
