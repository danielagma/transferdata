# [DWU-189] Market Depth Widget: Order Type Parameter

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-189 |
| Ticket name | Market Depth Widget: Order Type Parameter |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Market Depth widget |
| Automation status | Not started |
| Suggested automation order | **Tier 4** — Market Depth order-entry field; no dependency on the Ladder quantity bar. Can be automated in parallel with [[DWU-163]] / [[DWU-188]] (same order-entry area, tested together). |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

Order type determines how an order is executed in relation to its price (e.g. limit vs. other order types). This parameter already existed in the legacy Market Depth widget (linked ticket "[DWD-13] Insert MTS Cash Order Parameters"); this story's scope is to replicate that existing "Type" parameter into the new Market Depth widget, not to design new order-type behavior.

Roles on the ticket: Assignee — Artur Moreira Dobler; QA Tester — Gabriella Sierra Fossaluza; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium.

## User story

As a trader, I want to select the order type and time in force for a given order, so that the order is executed as per my requirements.

## Acceptance criteria

- [ ] The "type" parameter from the existing (legacy) Market Depth widget must be implemented in the new Market Depth widget.

Screenshot 1 (Current) shows the legacy Market Depth widget with a `Type: LMT` field alongside `TiF: GTD`, a Book selector, and Buy/Sell controls. Screenshot 2 (Request) shows the desired placement in the new widget: `Order Type` and `Time in Force` fields displayed below the vertical quantity bar.

## Implemented behavior

- A "Type" dropdown field (order type, e.g. `LMT`) was added to the new Market Depth / Escalator order-entry area, alongside the "TiF" field from [[DWU-188]].
- Selecting a value from the "Type" dropdown updates and persists the displayed value, consistent with the legacy widget's existing behavior.
- This story only covers replicating the "type" parameter — it shares the same order-entry area and was tested the same day as [[DWU-188]] (TIF field) by the same QA engineer.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Gabriella Sierra Fossaluza.

Results: The Order Type parameter was successfully validated within the new Market Depth widget and compared against the existing implementation. The "Type" field was displayed correctly in the expected location and provided the same functionality available in the current Market Depth widget. Available order type options were accessible, selectable, and correctly reflected within the UI after selection. The implementation demonstrated consistent behavior with the existing workflow, allowing traders to configure order types as expected prior to order submission. No functional discrepancies, usability concerns, or regression issues were identified.

Evidence (instrument `SPGB 5.900 07/26`): the "Type" dropdown was opened and `LMT` selected/confirmed with a checkmark, alongside the "TiF" field set to `FOK` (from the parallel DWU-188 testing on the same instrument/session).

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-screenshot1-current.png` — full ticket: user story, background, acceptance criteria, Screenshot 1 (current/legacy widget with Type field).
- `02-screenshot2-request-mockup.png` — Screenshot 2 (request): desired placement of Order Type and Time in Force fields in the new widget.
- `03-qa-testing-passed-type-field.png` — QA result: "Type" field validated, PASSED summary.
- `04-qa-testing-lmt-dropdown-selection.png` — QA result: "Type" dropdown opened, `LMT` selected.

## Notes for automation

- Candidate validations for a test:
  - The "Type" (order type) field is present in the Market Depth / Escalator order-entry area.
  - The dropdown is selectable, and the selected value is reflected in the UI.
  - Behavior matches the legacy Market Depth widget's order-type functionality (no new order-type values were introduced by this story — it is a straight replication).
- Consider whether this story's test can be combined with [[DWU-189]]'s sibling [[DWU-188]] (TIF field) into a single scenario covering the shared order-entry area, since both fields sit side by side and were validated together in the same QA pass — while still keeping assertions scoped to each ticket's own acceptance criteria.

## References

- Jira: DWU-189 (https://darwinjira.atlassian.net/browse/DWU-189)
- Epic: DWU-300
- Linked legacy ticket: DWD-13 ("Insert MTS Cash Order Parameters")
- Related story: [[DWU-188]] (TIF field — same widget area, tested together)
