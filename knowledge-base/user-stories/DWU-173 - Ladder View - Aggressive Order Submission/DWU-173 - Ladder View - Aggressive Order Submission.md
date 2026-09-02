# [DWU-173] Ladder View: Aggressive Order Submission

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-173 |
| Ticket name | Ladder View: Aggressive Order Submission |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested automation order | **Tier 6** — Same dependencies as [[DWU-172]] (widget from [[DWU-163]] + quantity bar from [[DWU-180]]); this is the aggressive-execution counterpart. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story is the aggressive-execution counterpart to [[DWU-172]] (passive order submission) on the same ladder (Escalator) interface. Aggressive execution — crossing the spread to immediately take available liquidity — is critical in fast-moving markets, letting traders act instantly without leaving the ladder. Like passive execution, it must be disabled while VWAP mode is active.

Roles on the ticket: FE Developer — unassigned; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Functional Area: Order Book Trading.

## User story

As a trader, I want to execute aggressive orders directly from the Market Depth widget using a click-to-execute action, so that I can immediately take liquidity at a selected price level.

## Acceptance criteria

- [ ] Trader can click on a price level to execute an aggressive Buy or Sell order (occurs directly on the ladder).
- [ ] The order executes immediately against available liquidity at the selected level.
- [ ] The selected quantity from the quantity bar is applied to the order (dependent on DWU-180).
- [ ] The system provides immediate execution confirmation.
- [ ] Aggressive execution is disabled when VWAP mode is active.
- [ ] The UI updates dynamically post-execution (ladder shift).

## Implemented behavior

- On the Escalator (ladder), each price level has a "negative space" (the empty area next to the price/quantity columns) that acts as the execution button — clicking it sends an aggressive order at that price level, crossing the spread against available liquidity, using the quantity currently selected in the quantity bar.
- This differs from [[DWU-172]] (passive orders), where clicking the bid/ask quantity column itself places a resting (non-crossing) order. Here, clicking the price level's negative space triggers immediate aggressive execution.
- On successful execution, a green confirmation banner is shown immediately (e.g. `SELL 25MM @ 100.360 CONFIRMED`), and the ladder shifts to reflect the liquidity that was just consumed at that level.
- **VWAP kill switch (shared with DWU-172):** when VWAP mode is toggled ON, interacting with the Ask/Bid zones does not trigger any order submission — no confirmation banner appears, and the ladder structure remains unchanged.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Results (instrument: `PGB 3.375 06/40`, MULTI view):
1. **Aggressive Buy Order Execution:** clicking the Buy column at a price level within the Ask zone successfully executes an aggressive Buy order against available liquidity. The system correctly applies the quantity selected from the quantity bar, displays the green immediate-execution confirmation banner, and the UI dynamically shifts the ladder to reflect the consumed liquidity.
2. **Aggressive Sell Order Execution:** clicking the Sell column at a price level within the Bid zone successfully executes an aggressive Sell order. Similar to the Buy action, the selected quantity is respected, the green confirmation banner is triggered, and the market depth grid updates instantly.
3. **VWAP Mode Execution Block:** as per the business rules, aggressive execution is completely disabled when the VWAP mode toggle is active. Interacting with Ask/Bid zones does not trigger any order submission, no confirmation banner is displayed, and the ladder structure remains unchanged.

Tagged for review: Artur Moreira Dobler, Hermela Mekonnen.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria-screenshot.png` — full ticket: user story, background, acceptance criteria table, "Submitting Aggressive Orders" annotated walkthrough (execution button, screen shift after execution).
- `02-qa-testing-passed-buy-sell-vwap-block.png` — QA result: Buy/Sell aggressive execution results and VWAP-block scenario, with Escalator grid evidence.

## Notes for automation

- Requires an Order Management setup with an Escalator (ladder) widget open for an instrument with both bid and ask liquidity, in MULTI view.
- Candidate validations for a test:
  - Clicking a price level's execution area (negative space) on the Ask side executes an aggressive Buy at that level, using the quantity bar's selected quantity.
  - Clicking a price level's execution area on the Bid side executes an aggressive Sell at that level.
  - A green confirmation banner (`<SIDE> <QTY>MM @ <PRICE> CONFIRMED`) appears immediately after execution.
  - The ladder shifts/updates to reflect consumed liquidity after execution.
  - With VWAP mode toggled ON, clicking the execution area produces no order, no banner, and no ladder change.
- Distinguish clearly from [[DWU-172]] when writing tests: the click target differs (price level's execution space vs. the bid/ask quantity column itself) and the trading behavior differs (crosses the spread vs. rests at the level).
- Depends on [[DWU-180]] (quantity bar selection) being functional, since the selected quantity is a precondition for this story's behavior.

## References

- Jira: DWU-173 (https://darwinjira.atlassian.net/browse/DWU-173)
- Epic: DWU-300
- Related stories: [[DWU-172]] (passive order submission — same widget, opposite execution mode), [[DWU-180]] (quantity bar selection — dependency), [[DWU-253]] (own orders columns — same widget)
