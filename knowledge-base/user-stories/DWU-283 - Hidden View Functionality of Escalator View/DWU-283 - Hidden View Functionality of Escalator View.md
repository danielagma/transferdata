# [DWU-283] Hidden View Functionality of Escalator View in Market Widget

> **Incomplete QA coverage on AC5:** the acceptance criterion requires 5 controls behind the accordion — Book, Order Type, Time in Force, VWAP, and Pause. The QA execution's scenario 2 text explicitly confirms only **Order Type, Time in Force, and VWAP**, and is itself labeled **"(PENDING TO VERIFY BOOK CONTROL)"**. "Pause" is not mentioned anywhere in the QA evidence. Before treating AC5 as fully covered, confirm Book and Pause are actually present when the accordion expands.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-283 |
| Ticket name | Hidden View Functionality of Escalator View in Market Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Market Depth widget layout) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

As the Escalator widget accumulated controls across many stories (TIF, Order Type, VWAP, quantity bar, cancel actions, My Bids/My Asks columns), screen space became a concern. This story introduces an accordion (collapsible section) to hide the less frequently used order-entry controls, keeping the core ladder, My Bids/My Asks, quantity bar, and cancellation controls always visible regardless of the accordion's state.

Roles on the ticket: Assignee — Gabriel Andrade Correa; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**. Reference: React Accordion component (Material UI).

## User story

As a trader, I want to expand or collapse the additional order entry controls within the Market Depth widget, so that I can reduce screen space usage when those controls are not needed.

## Acceptance criteria

- [ ] An accordion control shall be displayed at the bottom right of the Market Depth widget.
- [ ] Clicking the accordion control will expand the additional controls section.
- [ ] Clicking the accordion control again shall collapse the additional controls section.
- [ ] When the accordion is collapsed, the ladder section remains fully visible.
- [ ] When the accordion is expanded, the following controls shall be displayed beneath the ladder: **Book, Order Type, Time in Force, VWAP, and Pause**.
- [ ] Expanding or collapsing the accordion will not refresh the widget.
- [ ] Expanding or collapsing the accordion will not impact market data, active orders, or user-entered values.
- [ ] Any selected quantity, Book, Order Type, Time in Force, or manually entered values will remain unchanged when the accordion state changes.
- [ ] The accordion will support both expanded and collapsed states throughout the user session — the system should remember the state the user left it in; if a new Market Depth widget is opened, the default should be closed (compact).

## Implemented behavior

- An accordion toggle control sits at the bottom-right of the Escalator/Market Depth widget. The ladder, My Bids/My Asks columns, quantity bar, and cancellation buttons (Cancel Bids/All/Asks) always remain visible, independent of the accordion's state.
- Collapsed (default for a newly opened widget) hides the additional order-entry controls beneath the ladder.
- Expanded reveals additional controls beneath the ladder — confirmed in evidence: Order Type, Time in Force, VWAP (Book and Pause were part of the ticket's requirement but not explicitly confirmed present in the captured QA evidence — see banner above).
- Toggling the accordion is a purely visual/DOM interaction: it does not trigger a widget refresh, does not affect live market data streaming, and does not clear or alter any user-entered values, selected quantity, Book, Order Type, or TIF configuration.
- The accordion's expanded/collapsed state persists for the user across the session, including after a full reload or fresh login — but a brand-new Market Depth widget instance still defaults to collapsed (compact).

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the Hidden View (Accordion) functionality has been successfully validated. The UI correctly expands and collapses the additional order entry controls without refreshing the widget, causing any data loss, or affecting live market data. State persistence and default behaviors function exactly as defined in the Acceptance Criteria.

1. **Default compact state of a newly opened Escalator widget (AC1, AC4, AC9):** verified that when a brand-new Market Depth widget is opened, the accordion control is present at the bottom right and defaults to a closed (compact) state. The core components (ladder, quantity bar, and cancellation controls) remain fully visible while the extra order controls are hidden.
2. **Expanding the accordion to reveal additional order entry controls (AC2, AC5) — "(PENDING TO VERIFY BOOK CONTROL)":** verified that clicking the accordion icon successfully expands the bottom section. The system accurately displays the hidden controls — **Order Type, Time in Force, VWAP** — without obstructing the ladder. **Book was flagged as still pending verification; Pause was not addressed.**
3. **Collapsing the accordion hides additional controls (AC3, AC4):** verified that clicking the accordion icon while expanded successfully collapses the section, instantly hiding the extra order controls while ensuring the main ladder, bids/asks, and quantity bar remain fully visible and usable.
4. **Accordion state changes do not refresh widget or clear user data (AC6, AC7, AC8):** verified that expanding/collapsing is a purely visual DOM interaction. Toggling does not trigger a widget refresh; all manually entered values, selected quantities, Order Type/TIF configurations, and real-time market data streaming remain 100% intact during state transitions.
5. **Accordion state persists across user sessions (AC9):** verified that after expanding the accordion and saving the layout, reloading the platform or performing a fresh login successfully restores the widget in its exact previous state (expanded), proving the configuration persists at the user profile level.

Note: prices in this evidence render in fractional "32nd" format (e.g. `97-14 5/8`), consistent with [[DWU-171]]'s display logic — confirming that format is now standard in newer ladder screenshots.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 9-item acceptance criteria table, Material UI Accordion reference link.
- `02-screenshot1-collapsed-screenshot2-expanded.png` — Screenshot 1 (collapsed) and Screenshot 2 (expanded) mockups.
- `03-qa-execution-passed-scenario1-default-compact-state.png` — QA scenario 1: default compact state on new widget open.
- `04-qa-execution-scenario2-expand-scenario3-collapse.png` — QA scenario 2 (expand, Book pending) and scenario 3 (collapse).
- `05-qa-execution-scenario4-no-refresh-scenario5-persistence.png` — QA scenario 4 (no refresh/data loss) and scenario 5 (session persistence).

## Notes for automation

- Requires an Order Management setup with the Escalator/Market Depth widget, ideally with an active order and a manually entered value already set, to verify nothing is lost across accordion toggles.
- Candidate validations for a test:
  - A newly opened widget shows the accordion collapsed by default; ladder, My Bids/My Asks, quantity bar, and cancel buttons remain visible.
  - Expanding the accordion reveals the additional controls — **explicitly verify Book and Pause are present**, not just Order Type/TIF/VWAP, since QA evidence left Book unconfirmed and didn't mention Pause at all.
  - Toggling the accordion does not clear a manually entered quantity, selected Order Type/TIF, or affect an active order/live market data.
  - The accordion's state (expanded/collapsed) persists across a page reload / re-login for the same user, but a fresh widget instance still opens collapsed.
- **Before automating AC5 as "fully passed", verify live in the target environment whether Book and Pause controls actually appear** — the QA evidence for this story does not confirm it.

## References

- Jira: DWU-283 (https://darwinjira.atlassian.net/browse/DWU-283)
- Epic: DWU-300
- Related story: [[DWU-171]] (32nd price format — visible in this story's evidence screenshots)
