# [DWU-259] Add Persistent Cancel Actions to Escalator Market Depth

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-259 |
| Ticket name | Add Persistent Cancel Actions to Escalator Market Depth |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested automation order | **Tier 7** — Depends on [[DWU-172]] / [[DWU-173]] (must be able to place orders before there is anything to cancel). |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story adds **bulk** cancel actions to the Escalator widget: three persistent top-level buttons that let a trader cancel all of their own bid orders, all their ask orders, or everything at once, for the currently selected instrument — without having to cancel orders one by one. This is distinct from [[DWU-284]], which adds a **per-row** trash icon to cancel one order (or the most recent one at a price level) individually; the two mechanisms coexist on the same widget.

Roles on the ticket: FE Developer — Gabriel Andrade Correa; QA Tester — Gabriella Sierra Fossaluza; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Approved; FE — Approved. Functional Area: Order Book Trading.

## User story

As a trader, I want cancel actions to always be visible at the top of the Escalator Market Depth widget, so that I can quickly cancel my active bid, ask, or all orders.

## Acceptance criteria

- [ ] System must display `Cancel Bids`, `Cancel All`, and `Cancel Asks` at the top of the Escalator Market Depth widget.
- [ ] `Cancel Bids` must cancel all active bid orders belonging to the logged-in trader for the selected instrument.
- [ ] `Cancel Asks` must cancel all active ask orders belonging to the logged-in trader for the selected instrument.
- [ ] `Cancel All` must cancel all active bid and ask orders belonging to the logged-in trader for the selected instrument.
- [ ] Cancel actions must be disabled/greyed out when there are no matching active orders to cancel.
- [ ] Cancel actions must not cancel orders belonging to other traders.

## Implemented behavior

- Three buttons — `Cancel Bids`, `Cancel All`, `Cancel Asks` — are permanently displayed at the top of the Escalator widget, above the price ladder, regardless of scroll position or instrument selected.
- `Cancel Bids` cancels every active bid order the logged-in trader has on the currently selected instrument, across all price levels — not just one. Symmetric behavior applies to `Cancel Asks` for ask orders, and `Cancel All` for both sides.
- When a side has no active orders for the logged-in trader (e.g. no bids), the corresponding button is disabled/greyed out (shown as a circle-slash icon in the disabled state).
- Cancelling only affects the logged-in trader's own orders; other traders' liquidity and orders on the same price levels remain untouched.

## QA evidence

**Status: Tested & Approved** — Tested by Gabriella Sierra Fossaluza.

Results: verified the implementation of the persistent cancel actions in the Escalator Market Depth widget. The cancel actions are displayed in the expected position, correctly perform the cancellation of the logged-in trader's bid, ask, or all orders, remain disabled when there are no matching orders to cancel, and do not affect orders belonging to other traders. All acceptance criteria were successfully validated. **Approved to proceed.**

Evidence sequence (instrument `PGB 3.000 06/35`, later `PTE`/`EBM` book instruments):
1. `Cancel Bids`, `Cancel All`, `Cancel Asks` confirmed visible and correctly positioned at the top of the widget.
2. Multiple passive orders submitted at various price levels (Sell and Buy) to populate active orders to cancel — e.g. `PTE SELL 100MM @ 97.36 CONFIRMED`, `PTE BUY 100MM @ 97.11 CONFIRMED`.
3. `Cancel Bids` clicked: the trader's active bid order was cancelled (`Order cancelled: FAS_20260722_400003400`), and the grid updated to reflect the removal.
4. `Cancel Asks` clicked: the trader's active ask order was cancelled (`Order cancelled: FAS_20260722_400003401`).
5. Additional own order submitted (`EBM BUY 100MM @ 97.06 CONFIRMED`), then `Cancel All` clicked, cancelling all remaining own orders across both sides.
6. Further validation with multiple orders spread across several price levels on both sides, confirming `Cancel Bids`/`Cancel Asks` cancel **all** matching own orders, not just one (`Order cancelled: FAS_20260722_400003404` among others).

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, acceptance criteria table, Screenshot 1 (buttons with red arrows).
- `02-qa-tested-approved-cancel-buttons-position.png` — QA result: "Tested & Approved" summary, buttons highlighted at top of widget.
- `03-qa-quantity-selected-for-test-orders.png` — QA setup: quantity bar used to prepare test orders.
- `04-qa-sell-buy-orders-submitted-confirmed.png` — QA setup: Sell and Buy orders submitted and confirmed, to populate active orders for the cancel tests.
- `05-qa-cancel-bids-order-cancelled.png` — QA result: `Cancel Bids` cancels the trader's bid order.
- `06-qa-cancel-asks-order-cancelled.png` — QA result: `Cancel Asks` cancels the trader's ask order.
- `07-qa-cancel-all-clicked.png` — QA result: `Cancel All` clicked after a new own order was placed.
- `08-qa-cancel-all-multiple-orders-cancelled.png` — QA result: bulk cancellation validated across multiple price levels/orders.

## Notes for automation

- Requires an Order Management setup with the Escalator widget, and the ability to submit multiple own orders across price levels on both bid and ask sides before testing cancellation.
- Candidate validations for a test:
  - With no active own orders, all three cancel buttons are disabled.
  - After placing an own bid order, `Cancel Bids` and `Cancel All` become enabled (and `Cancel Asks` stays disabled if no own ask orders exist).
  - `Cancel Bids` removes all own bid orders (place at least two at different price levels to confirm it isn't a single-order cancel).
  - `Cancel Asks` removes all own ask orders, similarly verified with multiple orders.
  - `Cancel All` removes all own orders on both sides.
  - Other traders' market depth quantities remain unaffected by any of the three actions.
- Distinguish from [[DWU-284]] when writing tests: that story's per-row trash icon cancels one order (LIFO) at a specific price level; this story's buttons cancel in bulk across the whole instrument.

## References

- Jira: DWU-259 (https://darwinjira.atlassian.net/browse/DWU-259)
- Epic: DWU-300
- Related stories: [[DWU-284]] (per-row/per-price-level cancel — complementary bulk vs. individual cancellation), [[DWU-253]] (My Bids/My Asks columns — related order visibility)
