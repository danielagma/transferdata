# [DWU-188] Market Depth Widget: TIF (Time in Force Field)

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-188 |
| Ticket name | Market Depth Widget: TIF (Time in Force Field) |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Market Depth widget |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

Time in Force (TIF) defines how long an order stays valid in the market before it is executed or cancelled. Traders need this control embedded directly in the Market Depth widget so they can manage order behavior quickly during fast-moving market conditions, without leaving the ladder interface. The ticket explicitly notes that partial development for this feature already existed under a previously linked ticket — this story extends and finalizes that existing functionality rather than building it from scratch.

Roles on the ticket: Assignee — Artur Moreira Dobler; QA Tester — Gabriella Sierra Fossaluza; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Functional Area: Order Book Trading.

## User story

As a trader, I want to select the appropriate Time in Force (TIF) instruction directly from the D2D Market Depth widget, so that I can control how long an order remains active and how it should behave once submitted to the market.

## Acceptance criteria

- [ ] A Time in Force dropdown field is available within the D2D Market Depth widget (positioned as shown in Screenshot 1).
- [ ] The dropdown includes exactly three selectable values: **FAK**, **FOK**, **GTD**.
- [ ] **GTD** is pre-selected by default when the widget loads (must remain consistent with current Darwin behavior).
- [ ] Traders can manually change the TIF selection before submitting an order.
- [ ] The selected TIF remains visible until changed by the trader.
- [ ] The selected TIF value must carry through correctly when the order is submitted, so the order is processed in the market exactly as intended.
- [ ] Existing linked dev work is reused and extended where applicable.

### TIF option definitions (from the ticket)

- **FAK (Fill and Kill):** execute as much of the order as possible immediately, then automatically cancel any unfilled balance.
- **FOK (Fill or Kill):** execute the entire order immediately in full, or cancel it entirely if full execution is not possible.
- **GTD (Good till Day):** keep the order active in the market until the end of the trading day, unless filled or manually cancelled. This is the default, matching Darwin's existing standard workflow.

## Implemented behavior

- A "TiF" dropdown field was added to the Market Depth / Escalator + Market Depth order entry area, next to the "Type" (order type) field. It defaults to `GTD` on widget load.
- Traders can open the dropdown and select `FAK`, `FOK`, or `GTD`; the selected value stays visibly set in the field until changed again.
- The selected TIF value is carried through to order submission — confirmed via a successful order execution using `FOK` (see QA evidence below).
- This story shares the same order-entry area as [[DWU-189]] (Order Type parameter), tested by the same QA engineer on the same day.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Gabriella Sierra Fossaluza.

Results: The TIF functionality within the Market Depth widget was successfully validated against all acceptance criteria. The TIF dropdown was displayed correctly within the widget and contained the expected selectable values: FAK, FOK, and GTD. GTD was selected by default when the widget loaded, maintaining consistency with the existing Darwin workflow. Manual selection of alternative TIF values was verified, and the selected value remained visible and persisted as expected until changed by the user. Order submissions were validated to ensure the selected TIF instruction was correctly carried through and applied to the submitted order. No functional discrepancies, usability concerns, or regression issues were identified.

Evidence sequence (instrument `PGB 3.000 06/35`, then `SPGB 5.900 07/26`):
1. TIF dropdown defaults to `GTD` on load.
2. TIF manually changed to `FAK`.
3. TIF manually changed to `FOK` (tested on a second instrument, `SPGB 5.900 07/26`).
4. An order was submitted with `FOK` selected: `ESP BUY 10MM @ 100.72 CONFIRMED` — confirming the selected TIF carried through to a real order submission.

Tagged for review: Artur Moreira Dobler, Hermela Mekonnen.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, TIF definitions, acceptance criteria table, Screenshot 1.
- `02-screenshot1-tif-dropdown-zoom.png` — zoomed Screenshot 1: TIF dropdown location in the Market Depth widget (set to FAK).
- `03-qa-testing-passed-gtd-default.png` — QA result: TIF defaults to GTD on load.
- `04-qa-testing-fak-selection.png` — QA result: TIF changed to FAK.
- `05-qa-testing-fok-selection.png` — QA result: TIF changed to FOK on a second instrument.
- `06-qa-testing-order-submitted-fok-confirmed.png` — QA result: order submitted and confirmed with FOK, tagged reviewers.

## Notes for automation

- Requires an Order Management setup with Escalator + Market Depth widgets open for an instrument with liquidity.
- Candidate validations for a test:
  - TIF dropdown defaults to `GTD` when the widget loads.
  - TIF dropdown offers exactly `FAK`, `FOK`, `GTD` and no other values.
  - Selecting a different TIF value updates and persists the field's displayed value.
  - Submitting an order with a non-default TIF (e.g. `FOK`) results in a confirmed order, and the TIF used should be verifiable (e.g. via order confirmation or order details, if exposed in the UI).
- Related/parallel story: [[DWU-189]] (Order Type parameter) — same order-entry area, same QA tester, tested the same day. Consider whether a single test scenario can reasonably cover both dropdowns' presence/interaction if testing the same widget area, while keeping assertions scoped to each story's own acceptance criteria.

## References

- Jira: DWU-188 (https://darwinjira.atlassian.net/browse/DWU-188)
- Epic: DWU-300
- Related story: [[DWU-189]] (Order Type parameter — same widget area)
