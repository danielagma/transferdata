# [DWU-172] Ladder View: Quantity Bar Passive Order Submission

> Note: the Jira ticket title itself contains a typo ("Quanitity"). Preserved here as `Quantity` for readability; the ticket ID `DWU-172` is the authoritative reference.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-172 |
| Ticket name | Ladder View: Quanitity Bar Passive Order Submission (as titled in Jira) |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

Traders need to quickly place passive (non-aggressive) orders directly from the ladder (Escalator) interface, without going through manual order ticket entry, to reduce latency in fast-moving markets. This functionality depends on quantity selection introduced in DWU-180 (quantity bar). Passive orders must respect existing system constraints, notably that they must be disabled when VWAP mode is active.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Functional Area: Order Book Trading.

## User story

As a trader, I want to execute passive orders directly from the Market Depth widget using a "click to execute" action, so that I can effectively place a resting order without additional steps.

## Acceptance criteria

- [ ] Trader can click on "Buy" or "Sell" controls to submit a passive order (action available directly within the widget).
- [ ] The order is submitted at the selected price level without crossing the spread.
- [ ] The selected quantity from the quantity bar is applied to the order (must integrate with the DWU-180 quantity-bar functionality).
- [ ] Execution occurs immediately upon click — no additional confirmation is required (designed for speed in trading conditions).
- [ ] Passive execution is disabled when VWAP mode is active.
- [ ] Visual confirmation (a green banner) is displayed after order submission.

## Implemented behavior

- From the Escalator (ladder) widget, clicking a price level's bid (left) or ask (right) column submits a passive order at that price level, using the quantity currently selected in the quantity bar (10/25/50/75/100/CLR buttons).
- Passive orders are inherently submitted as "GTD" (Good For Today) orders.
- Clicking a price cell can also be used to add the chosen quantity to an existing order without executing (per Screenshot 1 annotations), and orders can be cancelled via an "X" control.
- On successful submission, a green confirmation banner is shown (e.g. `SELL 10MM @ 100.365 CONFIRMED`, `EBM BUY 100MM @ 99.96 CONFIRMED`), and the executed quantity appears as an "own order" indicator directly in the Escalator grid at that price level.
- **MTS market mirroring / MULTI view business logic:** when trading in the MULTI view, the Market Depth widget aggregates liquidity mirrored across submarkets (e.g. ESP + EBM). After a passive order is submitted, the resulting displayed quantity at that price level reflects `(selected quantity × 2) + initial quantity` — the ×2 accounts for the mirrored liquidity across the two submarkets, not just the order itself. This was explicitly confirmed as correct/expected behavior with the Business team, not a bug.
- **VWAP kill switch:** when VWAP mode is toggled ON, clicking any column in the Escalator grid does not submit any order — no confirmation banner appears, and the Market Depth grid remains completely unchanged. This is the mechanism that satisfies Acceptance Criterion 5.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Business Logic Note: as confirmed with Business, the Escalator accurately respects the MTS market mirroring behavior when using the MULTI view. The system correctly aggregates liquidity mirrored across submarkets (e.g. ESP + EBM), and the UI dynamically updates to reflect this expected business logic without filtering the backend data.

Results (ISIN used: `ES0000012L29`, bond `SPGB 2.800 05/26`):
1. **Passive Sell order:** validated submission by clicking the right (ask) column at the `100.055` price level (initial Qty: 14) with a selected quantity of 10. The system submitted the order, displayed the green confirmation banner, and rendered the own-order indicator `[10]`. The updated Ask quantity displayed `34`, correctly reflecting the aggregated mirrored liquidity (`(10 × 2) + 14`) across submarkets, as expected in the MULTI view.
2. **Passive Buy order:** validated submission by clicking the left (bid) column at the `99.960` price level (initial Qty: 4) with a selected quantity of 100. The system submitted the order, triggering the green confirmation banner (`EBM BUY 100MM @ 99.96 CONFIRMED`) and displaying the own-order indicator `[100]`. The updated Bid quantity displayed `204`, accurately reflecting the aggregated mirrored liquidity (`(100 × 2) + 4`) across submarkets, as expected in the MULTI view.
3. **Block passive order submission when VWAP is active — PASSED.** Validated that enabling VWAP mode successfully acts as a kill switch for passive execution: clicking any column within the Escalator grid while VWAP is ON does not trigger any order submission, no confirmation banners are displayed, and the Market Depth grid remains completely unchanged.

Tagged for review: Artur Moreira Dobler, Hermela Mekonnen.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria-screenshot1.png` — full ticket: user story, background, acceptance criteria table, Screenshot 1 ("Submitting Passive Orders" annotated walkthrough).
- `02-qa-testing-passed-passive-sell-order.png` — QA result: passive Sell order scenario, business logic note on MTS mirroring.
- `03-qa-testing-passive-buy-order-before-after.png` — QA result: passive Buy order scenario, before/after grid state.
- `04-qa-testing-buy-confirmed-and-vwap-block-passed.png` — QA result: Buy order confirmation banner, and VWAP-active block scenario (PASSED).

## Notes for automation

- Requires an Order Management setup with both an Escalator (ladder) widget and a Market Depth widget open for the same instrument, in MULTI view, with a book (e.g. `DanielTestBook`) selected.
- Candidate validations for a test:
  - Clicking a bid/ask column at a price level submits a passive order using the quantity bar's currently selected quantity, without requiring extra confirmation.
  - A green confirmation banner appears immediately after submission.
  - The own-order indicator appears in the Escalator grid at the price level clicked, with the selected quantity.
  - The Market Depth aggregated quantity at that price level updates to `(selected quantity × 2) + initial quantity` when trading a mirrored MULTI-view instrument — do not treat this ×2 factor as a bug; it is confirmed expected behavior for MTS market mirroring across submarkets (ESP + EBM).
  - With VWAP mode toggled ON, clicking any Escalator column produces no order, no banner, and no grid change.
- Test data: an instrument with MTS mirroring across at least two submarkets (e.g. ESP + EBM) to properly validate the mirrored-liquidity aggregation math, plus a way to toggle VWAP mode for the negative case.
- Depends on [[DWU-180]] (quantity bar selection) being functional, since the selected quantity is a precondition for this story's behavior.

## References

- Jira: DWU-172 (https://darwinjira.atlassian.net/browse/DWU-172)
- Epic: DWU-300
- Related stories: [[DWU-173]] (aggressive order submission — same widget, opposite execution mode), [[DWU-180]] (quantity bar selection — dependency), [[DWU-253]] (own orders columns — same widget)
