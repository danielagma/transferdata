# [DWU-161] [Futures Maintenance Screen] Implement Dynamic Vertical Re-sizing of 'Contracts' Section

> **Automation recommendation: LOW priority — likely not worth automating.** See "Should this be automated?" at the bottom of this document for the full reasoning. Short version: this is a pure responsive-layout/CSS behavior with no business logic, no data or trading impact, and any test would depend on exact viewport/pixel dimensions — a high-maintenance, low-value combination for an E2E suite. Documented here for completeness of the knowledge base, not because automation is being recommended.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-161 |
| Ticket name | [Futures Maintenance Screen] Implement Dynamic Vertical Re-sizing of 'Contracts' Section |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-297 — UST1 Reference Data |
| Module / area | Trade Reference Data — Futures Maintenance (Edit Futures Details screen) |
| Automation status | Not started (recommended: skip / low priority) |
| Suggested priority | @low |
| Suggested automation order | **Not tiered / out of sequence** — unrelated to both the Order Management and Reference Data dependency chains covered by the other stories; not blocked by, and does not block, anything else in this backlog. |
| Automation spec | (pending — see recommendation) |

## Context

This is a small UX/responsive-layout fix on the Futures Maintenance "Edit Futures Details" screen, unrelated to the Bonds Order Management epic (DWU-300) that most other stories in this knowledge base belong to. Before this fix, the "Contracts" grid inside that screen had a fixed height: if the trader maximized or vertically enlarged the browser window, the grid stayed the same size and unused empty space appeared below it, forcing extra scrolling to see more contract rows than necessary.

Roles on the ticket: Assignee — Daniel Aguilar; QA Tester — Daniel Aguilar; Reporter — Mohammed Rahman; Jira priority — Medium. PR Approval Status: BE — Approved; FE — Approved. Status: **Closed**.

## User story

As a trader, I want to view more records in the Futures Maintenance Edit screen's 'Contracts' section without needing to scroll, so that I have a better user experience.

## Acceptance criteria

- [ ] When a user vertically expands the Futures Maintenance Edit screen, the 'Contracts' section must dynamically re-size vertically to fit the screen (expanding in-line with the screen, filling the otherwise empty space).
- [ ] There must be no impact to the existing behavior for all other attributes/fields in the Futures Maintenance Edit screen (i.e. all fields above the 'Contracts' section must remain as-is).
- [ ] The existing horizontal dynamic re-sizing of the 'Contracts' section (when the screen is expanded horizontally) must remain as-is (unchanged by this story).

## Implemented behavior

- The "Contracts" grid within Futures Maintenance > View/Edit Futures Details now dynamically grows/shrinks its visible height in proportion to the browser window's vertical size, showing more (or fewer) contract rows without needing internal scrolling when there's room.
- All form fields above the grid (Prefix, Description, Market Data Field, Trader Group, Currency, Active, Front Month, Back Month as Active, Market Data Service, Include decade in contract code, Ticker Prefix, Contract Size) keep their original size, alignment, and spacing — they do not stretch or shift during a vertical resize.
- Horizontal resizing behavior is untouched: widening the window still triggers the pre-existing horizontal scrollbar for the Contracts grid's columns, with no new conflicts introduced by the vertical logic.
- At extreme vertical compression (e.g. a ~600px-tall window), the "Contracts" section respects a minimum visible height rather than collapsing to 0px, and a scrollbar appears to allow full vertical navigation — the top form remains fully legible.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Results: the 'Contracts' grid successfully expands proportionally, increasing the number of visible rows without requiring internal scroll. Top form fields maintained their original dimensions, alignment, and spacing without stretching or overlapping during vertical resize.

1. **Baseline vs. expanded view:** compared the screen at standard window height against a vertically stretched window — the Contracts grid visibly shows more rows in the expanded view, with the top form fields unchanged in both.
2. **Horizontal behavior unchanged:** confirmed that resizing the window horizontally still triggers the original horizontal scrollbar for the Contracts grid's columns, without conflicting with the new vertical resize logic.
3. **Extreme vertical compression (e.g. 600px window height):** confirmed the top form remains fully legible, and the Contracts section respects a minimum visible height (does not collapse to 0px) — a scrollbar appears for full vertical navigation.

Tagged for review: Gabriel Andrade Correa, Mohammed Rahman.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-requirements-mockup.png` — full ticket: user story, background, 3-item requirements table, example baseline/expanded mockups.
- `02-qa-testing-passed-baseline-vs-expanded.png` — QA result: baseline (standard window height) vs. expanded (vertically stretched) comparison.
- `03-qa-horizontal-behavior-unchanged-extreme-compression.png` — QA result: horizontal resize behavior unchanged, and extreme vertical compression (600px) handling.

## Notes for automation

If this were automated despite the recommendation below, candidate checks would be:
- At a taller viewport, the Contracts grid renders more visible rows (or a taller bounding box) than at a shorter viewport, without an internal scrollbar appearing when there's room.
- Fields above the grid keep a stable bounding box/position across viewport height changes (no overlap or resizing).
- Horizontal scrolling of the grid still works correctly regardless of vertical window size.

## Should this be automated?

**Recommendation: no — or, at most, a single low-priority smoke check, not a full regression suite entry.**

Reasoning:
- This is a pure responsive-layout/CSS behavior (a grid resizing to fill available vertical space), not business logic. It carries no risk to data integrity, trading operations, or financial calculations — the worst-case failure is a suboptimal layout (needing to scroll a bit more), not a broken transaction.
- Any meaningful assertion here depends on viewport dimensions and rendered pixel/row heights, which are inherently fragile across browsers, OS font rendering, DPI scaling, and even minor unrelated CSS changes — exactly the kind of test that tends to flake or need frequent maintenance for very little payoff (see this repo's guidance on `expect.poll` and avoiding brittle waits/assertions).
- The three acceptance criteria are essentially "the grid resizes" and "nothing else regresses" — the second part (no impact to other fields, horizontal behavior unchanged) is a generic non-regression check that a broader smoke test of the Futures Maintenance screen would likely already catch if something were seriously broken.
- Compare this to the Bonds Order Management stories in this knowledge base ([[DWU-172]], [[DWU-173]], [[DWU-413]], etc.): those guard real trading behavior (order execution, quantity math, price formatting) where a regression has direct financial/operational consequences — a much higher bar to justify the cost of maintaining a test.

If the team later adopts visual regression tooling (screenshot-diffing), that would be a better-suited mechanism for this kind of story than a functional Playwright test asserting on pixel/row counts.

## References

- Jira: DWU-161 (https://darwinjira.atlassian.net/browse/DWU-161)
- Epic: DWU-297
