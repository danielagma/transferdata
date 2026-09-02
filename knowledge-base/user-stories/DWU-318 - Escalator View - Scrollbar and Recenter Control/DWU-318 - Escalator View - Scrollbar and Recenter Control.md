# [DWU-318] Escalator View: Add scrollbar & Recenter Control to Ladder Widget

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-318 |
| Ticket name | Escalator View: Add scrollbar & Recenter Control to Ladder Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Ladder navigation) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

The Ladder can contain more price levels than fit on screen at once. This story adds a vertical scrollbar so traders can browse the full depth of the book, plus a "Recenter" button to instantly snap back to the default, market-centered view (best bid/ask visible) after scrolling away — without affecting any live data or active orders in the process.

Roles on the ticket: Assignee — Gabriel Andrade Correa; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium. Tags: `Groom_20260715`. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**.

## User story

As a trader, I want to scroll through the Ladder and quickly return to the current market, so that I can review different price levels and instantly navigate back to the active trading area.

## Acceptance criteria

- [ ] A vertical scroll bar must be available on the Ladder widget.
- [ ] The scroll bar must allow the trader to navigate all available price levels.
- [ ] Scrolling must update the visible price levels without changing any market data or active orders (UI navigation only).
- [ ] A Recenter button must be displayed on the Ladder widget as shown in the mockup.
- [ ] Clicking the Recenter button must return the Ladder to its default market-centered position.
- [ ] The default market-centered position must display the current best bid and best ask, with the best available price levels visible (matches the default ladder view).
- [ ] Clicking the Recenter button must not modify or cancel any active orders (UI navigation only).
- [ ] The Recenter button must work regardless of how far the trader has scrolled.

## Implemented behavior

- The Ladder widget has a vertical scrollbar on its right edge, allowing the trader to scroll up/down through all available price levels beyond what fits in the visible viewport.
- A "Recenter" icon/button (a target-like icon next to the Cancel Bids/All/Asks row) instantly snaps the ladder view back to its default, market-centered position — showing the current best bid and best ask centered in the viewport — regardless of how far the trader had scrolled.
- Both scrolling and recentering are purely visual/UI navigation actions: neither affects live market data streaming, nor modifies or cancels any active orders.
- Prices in this story's evidence also render in fractional "32nd" format (e.g. `97-16 7/8`), consistent with [[DWU-171]].

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the scrollbar and Recenter button functionalities have been successfully validated. The UI safely allows scrolling through all price levels and instantly snaps back to the market center upon clicking the Recenter control, confirming that these actions are strictly visual (UI navigation) and do not disrupt active orders or live market data.

1. **Default load and UI elements presence (AC1, AC4, AC6) — PASSED:** verified the vertical scrollbar and the Recenter button are properly displayed upon opening the widget. The initial view defaults perfectly to the market-centered position, displaying the current best bid and best ask values.
2. **Vertical scrolling and data safety (AC2, AC3) — PASSED:** verified the user can smoothly scroll up and down to navigate all available price levels. Confirmed scrolling is strictly a UI navigation event: it successfully updates the visible price levels without freezing live market data updates or modifying/cancelling any active orders in the grid.
3. **Recenter control functionality and safety (AC5, AC7, AC8) — PASSED:** verified clicking the Recenter button instantly returns the grid to the default market-centered view (best values at center), regardless of how far up or down the trader has scrolled. Confirmed that clicking this button does not modify or cancel any active orders.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 8-item acceptance criteria table.
- `02-ladder-mockup-scrollbar-recenter.png` — Ladder mockup showing the scrollbar and Recenter icon.
- `03-qa-execution-passed-scenario1-default-load.png` — QA scenario 1: default load, scrollbar/Recenter presence, market-centered default view.
- `04-qa-execution-scenario2-scrolling-scenario3-recenter.png` — QA scenario 2 (scrolling) and scenario 3 (Recenter functionality).

## Notes for automation

- Requires an instrument with enough price levels/liquidity that the ladder overflows its viewport, to meaningfully exercise scrolling.
- Candidate validations for a test:
  - The Ladder shows a vertical scrollbar and a Recenter control on load.
  - Scrolling up/down changes the visible price levels without altering market data or any active order.
  - After scrolling away from the default view, clicking Recenter returns the ladder to the market-centered position (best bid/ask visible).
  - Recenter does not modify or cancel any active order present in the ladder.
- Purely a UI-navigation story — no order submission is required to test it, though testing alongside an active own order (from [[DWU-172]]/[[DWU-173]]) is a good way to confirm scrolling/recentering don't disturb it.

## References

- Jira: DWU-318 (https://darwinjira.atlassian.net/browse/DWU-318)
- Epic: DWU-300
- Related stories: [[DWU-171]] (32nd price format — visible in this story's evidence), [[DWU-172]] / [[DWU-173]] (order submission — useful to combine when testing non-disruption)
