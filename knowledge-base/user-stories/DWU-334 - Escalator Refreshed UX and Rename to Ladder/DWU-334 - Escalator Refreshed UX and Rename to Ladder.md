# [DWU-334] Escalator: Refreshed User Experience and Rename to "Ladder"

> **Naming change affecting every prior "Escalator" story:** this story renames the widget previously called "Escalator" to **"Ladder"** everywhere in the application — the Order Management title, the "Widgets" dropdown, and the Bond Pricer's right-click context menu option (`View Escalator...` → `View Ladder...`). Every earlier user story in this knowledge base that references "Escalator" (e.g. [[DWU-163]], [[DWU-171]], [[DWU-172]], [[DWU-173]], [[DWU-180]], [[DWU-253]], [[DWU-257]], [[DWU-259]], [[DWU-261]], [[DWU-283]], [[DWU-284]], [[DWU-318]]) describes the **same widget** — only its name changed. When automating any of those stories against a current environment, use "Ladder" in selectors/labels, not "Escalator".

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-334 |
| Ticket name | Escalator: Refreshed User Experience and Rename to "Ladder" |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management (widget rebrand) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

By this point in the epic, the "Escalator" widget had accumulated many features across many stories. This story is a UI refresh and rebrand pass: rename it to "Ladder" throughout the app, align its layout with an approved mockup, and remove any controls not shown in that mockup — while explicitly preserving all existing functionality delivered by prior stories unless another story says otherwise.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium. Tags: `Groom_20260715`. PR Approval Status: BE — Not Required; FE — Approved. Status: **Released**.

## User story

As a trader, I want the Escalator widget to be refreshed and renamed to Ladder.

## Acceptance criteria

- [ ] Rename the Escalator widget to "Ladder" wherever it is displayed.
- [ ] Update the Ladder widget to match the attached mockup.
- [ ] Existing controls must be displayed in the positions shown in the mockup.
- [ ] Controls not shown in the approved mockup must be removed.
- [ ] Existing functionality must remain unchanged unless covered by another story.
- [ ] Buy and Sell colors must remain consistent with the current application (customizable).
- [ ] The refreshed Ladder widget must replace the existing Escalator widget throughout the application.
- [ ] The Ladder widget must support the same right-click context menu available in the Bond Pricer (reuse existing functionality).

## Implemented behavior

- Every visible reference to "Escalator" was replaced with "Ladder": the Order Management panel title, the top navigation "Widgets" dropdown (`Market Depth`, `Ladder`, `Market Trades`, `Sweep`), and the Bond Pricer's right-click context menu, where `View Escalator...` became `View Ladder...`.
- The widget's layout was refreshed to match the approved mockup, keeping controls (including the quantity bar) repositioned per that mockup, and removing anything not shown in it.
- Buy/Sell color coding (pink asks, blue bids) remains consistent with the rest of the application.
- All prior functionality (order submission, cancellation, TIF/Order Type fields, quantity bar, My Bids/My Asks columns, accordion, scrollbar/recenter, etc. — from the stories listed in the banner above) continues to work under the new name; this story did not change any of that behavior itself.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the UI refresh and rebranding of the "Escalator" to "Ladder" has been successfully validated. All legacy naming has been eradicated globally. The new UI layout matches the updated mockups (safely retaining the Quantity Bar), Buy/Sell colors remain consistent, and the right-click context menu integration from the Bond Pricer works seamlessly without breaking existing functionality.

1. **Global renaming and replacement (AC1, AC7):** verified the term "Escalator" has been completely replaced by "Ladder" throughout the application — confirmed in the Order Management title, the top navigation Widgets dropdown menu, and all general UI labels.
2. **UI layout update and control cleanup (AC2, AC3, AC4, AC6):** verified the refreshed Ladder UI matches the approved mockups, with controls correctly repositioned and obsolete elements removed. Confirmed the critical retention of the Quantity Bar at the bottom of the widget, and validated that Buy and Sell color indicators remain strictly consistent with the global application theme.
3. **Context menu integration and regression (AC5, AC8):** verified that right-clicking an instrument in the Bond Pricer correctly displays the renamed "View Ladder" option. Clicking it successfully launches the newly refreshed widget for the selected bond, confirming underlying widget behavior and existing functionality remain intact.

Sign-off: "Approved to close. All Acceptance Criteria have been successfully met." Tagged: Artur Moreira Dobler, Shaun Murdoch.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria-mockup.png` — full ticket: user story, background, 8-item acceptance criteria table, Ladder mockup.
- `02-qa-execution-passed-global-rename-layout.png` — QA result: global rename confirmed, Widgets dropdown showing "Ladder", layout/color validation.
- `03-qa-context-menu-view-ladder-signoff.png` — QA result: Bond Pricer context menu showing "View Ladder" option, sign-off.

## Notes for automation

- **Update selectors/labels for all prior "Escalator" stories** when automating against a live environment: widget title, Widgets dropdown entry, and Bond Pricer context menu item are now "Ladder" / "View Ladder...", not "Escalator" / "View Escalator...".
- This story itself is mostly a rebrand/layout pass; a dedicated test could simply confirm: the widget opens under the "Ladder" name from the Widgets dropdown, and from the Bond Pricer's "View Ladder..." context menu option, with the quantity bar and other core controls present per the approved mockup.
- No functional behavior changed here — testing this story mostly means testing that the *name* changed everywhere, not new logic.

## References

- Jira: DWU-334 (https://darwinjira.atlassian.net/browse/DWU-334)
- Epic: DWU-300
- Affects naming in: [[DWU-163]], [[DWU-171]], [[DWU-172]], [[DWU-173]], [[DWU-180]], [[DWU-253]], [[DWU-257]], [[DWU-259]], [[DWU-261]], [[DWU-283]], [[DWU-284]], [[DWU-318]] (all describe the same widget, pre-rename)
