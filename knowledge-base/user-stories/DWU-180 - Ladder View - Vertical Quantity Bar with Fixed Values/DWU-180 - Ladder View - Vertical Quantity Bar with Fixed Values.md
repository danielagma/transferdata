# [DWU-180] Ladder View: Vertical Quantity Bar with Fixed Values

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-180 |
| Ticket name | Ladder View: Vertical Quantity Bar with Fixed Values |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth ladder) |
| Automation status | Not started |
| Suggested automation order | **Tier 5** — Depends on [[DWU-163]] (the ladder widget must exist before a quantity bar can be added to it). Blocks order submission stories ([[DWU-172]], [[DWU-173]]). |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story is a foundational dependency for the ladder's order-submission stories ([[DWU-172]] passive orders, [[DWU-173]] aggressive orders, [[DWU-261]] manual quantity input): before traders can click to submit an order at a given quantity, that quantity bar needs to exist in a usable, vertical layout adjacent to the price ladder. In the prior implementation, the quantity selection bar was horizontal and not aligned with how traders actually work — they rely on fast access to standard trade sizes, and prefer the bar positioned vertically next to the price ladder.

Roles on the ticket: QA Tester — Gabriella Sierra Fossaluza; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Approved; FE — Approved. Functional Area: Order Book Trading.

## User story

As a trader, I want the quantity selection bar in the D2D Market Depth "escalator" widget to be displayed vertically with predefined fixed quantities, so that I can quickly select commonly used sizes during fast market conditions.

## Acceptance criteria

- [ ] The quantity bar is displayed vertically within the D2D Market Depth widget (positioned adjacent to the price ladder for ease of access).
- [ ] The quantity bar contains fixed, configurable values: 10, 25, 50, 75, 100 (values picked by traders / commonly used).
- [ ] Trader can select a quantity with a single click, and the selection is immediately reflected as the active order size.
- [ ] The selected quantity is clearly highlighted (visual distinction required for usability).
- [ ] Configuration allows future updates to preset values (supports desk-level customization if needed).

## Implemented behavior

- The quantity bar was moved from a horizontal row of buttons (previous layout: `Buy | 5 10 25 50 / 100 200 C SET | Sell`) to a vertical column of buttons positioned directly to the right of the price ladder within the Escalator widget: `10 / 25 / 50 / 75 / 100 / CLR`.
- Clicking a preset value selects it as the active order quantity; the selected button is highlighted in orange, and only one preset can be active at a time (selecting a different preset moves the highlight).
- This vertical quantity bar is the same UI component later extended by [[DWU-261]] to also support manual/custom quantity entry, and consumed by [[DWU-172]] and [[DWU-173]] for passive/aggressive order submission.

## QA evidence

No "QA Testing: PASSED" comment banner was captured in the available screenshots for this story — the ticket status is **Closed** ("Cerrada"), and the following evidence was documented:

- **Dev Test Evidence — Frontend** (Gabriel Andrade Correa, Environment: DEV2): shows the Market Depth Escalator widget (`SPGB 2.800 05/26`) rendering the vertical quantity bar (`10/25/50/75/100/CLR`) correctly positioned to the right of the price ladder.
- Additional grid screenshots (further down the ticket's comment thread) show the quantity bar functioning with different presets selected and highlighted (`10` highlighted orange, then `100` highlighted orange), demonstrating single-click selection and highlight behavior working as expected (Acceptance Criteria 3 and 4).

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, Screenshot 1 (old horizontal bar) and Screenshot 2 (new vertical bar), acceptance criteria table.
- `02-dev-test-evidence-frontend-vertical-bar.png` — Dev Test Evidence (Frontend): vertical quantity bar rendered in the Escalator widget.
- `03-evidence-quantity-selection-10-and-100.png` — further evidence: quantity bar with `10` then `100` selected/highlighted.

## Notes for automation

- Candidate validations for a test:
  - The quantity bar renders vertically, adjacent to the price ladder, with buttons `10, 25, 50, 75, 100, CLR`.
  - Clicking a preset value highlights it (visually distinct, e.g. orange background) and sets it as the active order quantity.
  - Selecting a different preset moves the highlight (only one active at a time in this story's scope — see [[DWU-261]] for the added "aggregated presets" and manual-quantity behavior that extends this).
- This story's UI is a prerequisite for the click-to-execute stories ([[DWU-172]], [[DWU-173]]) — the selected quantity here is what those stories consume when submitting an order.
- **Gap:** no explicit "PASSED" QA comment was found in the available evidence; before treating this story as a clean automatable baseline, confirm current behavior against a live environment since it may have since evolved via [[DWU-261]].

## References

- Jira: DWU-180 (https://darwinjira.atlassian.net/browse/DWU-180)
- Epic: DWU-300
- Related stories: [[DWU-172]] (passive order submission), [[DWU-173]] (aggressive order submission), [[DWU-261]] (manual quantity input — extends this quantity bar)
