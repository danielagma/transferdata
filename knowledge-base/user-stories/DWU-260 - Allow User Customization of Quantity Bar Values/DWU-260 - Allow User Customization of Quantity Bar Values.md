# [DWU-260] Allow User Customization of Quantity Bar Values

> **Known, approved deviation on AC14:** the system does NOT validate configured quantity values against the instrument's maximum order size. A user can save an astronomically large number (e.g. `100000000000000000`), which causes text overflow and visually breaks the quantity bar UI. This was explicitly accepted as a known deviation for this release, pending business definition of maximum-size rules — it is not a regression to flag, but also not a passing case for AC14 if tested literally.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-260 |
| Ticket name | Allow User Customization of Quantity Bar Values |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Settings (Order Management > Fast Size Buttons) / Escalator quantity bar |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story turns the Escalator's quantity bar presets (originally fixed in [[DWU-180]], later extended with manual entry in [[DWU-261]]) into a user-configurable setting, following the same design pattern as Darwin's existing "Fast Spread Buttons" settings screen. Each user can define their own set of 1–6 preset quantities, stored per user profile and persisted across sessions.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Functional Area: Order Book Trading. Status: **Released**.

## User story

As a trader, I want to configure the quantity bar values shown in the Escalator Market Depth quantity bar, so that the preset quantities match my preference.

## Acceptance criteria

- [ ] **AC1:** system must provide a "Fast Size Buttons" settings page under `SETTINGS → ORDER MANAGEMENT → FAST SIZE BUTTONS`.
- [ ] **AC2:** the "Fast Size Buttons" settings page must allow users to configure the quantity values displayed in the Escalator quantity bar.
- [ ] **AC3:** after settings are saved, the configured quantity values must replace the default preset values in the Escalator widget.
- [ ] **AC4:** a newly created quantity bar configuration will contain the default values: `1, 5, 10, 25, 50, 100` (in millions).
- [ ] **AC5:** quantity bar configurations must be stored independently for each user.
- [ ] **AC6:** user-defined quantity values must persist after closing/reopening the widget and after logging out and back into Darwin.
- [ ] **AC7:** selecting a quantity button must apply that quantity to the next order submitted from the Escalator widget.
- [ ] **AC8:** users must be able to configure between 1 and 6 quantity values.
- [ ] **AC9:** duplicate quantity values are not permitted within the same configuration; save must be prevented until duplicates are removed.
- [ ] **AC10:** quantity values must always be displayed and saved in ascending numerical order, left to right (Darwin auto-sorts).
- [ ] **AC11:** the quantity bar must always occupy the same width — unused button positions (fewer than 6 configured) must remain blank, not resize the bar.
- [ ] **AC12:** updating the quantity bar settings must immediately update the buttons displayed in the Escalator widget after save, with no restart or widget recreation required.
- [ ] **AC13:** quantity values must be positive whole numbers greater than 0 (no zero, decimals, letters, or blanks).
- [ ] **AC14:** quantity values must not exceed, or be savable beyond, the maximum order size configured for the selected instrument. **(Known deviation — not enforced; see banner above.)**

## Implemented behavior

- A new settings page, "Fast Size Buttons", exists under `Settings → Order Management`, following the same UI pattern as the pre-existing "Autospread Buttons" / "Fast Spread Buttons" screens (reused component).
- Each user can add/remove quantity values (as an "integer" input with an "Add" button), building a personal list of 1 to 6 values.
- On save, values are auto-sorted ascending and immediately reflected in the Escalator's quantity bar for that user — no widget restart needed.
- Validation in place: rejects decimals, zero, negative numbers, letters/blank input, and duplicate values (save is blocked with an inline error until resolved).
- If fewer than 6 values are configured, the quantity bar keeps its full original width, with unused button slots rendered blank (present in the DOM, visually empty).
- Configuration is stored per user profile and persists across widget close/reopen and full logout/login cycles.
- Clicking any configured quantity button applies that exact quantity to the next order submitted from the Escalator.
- **Not implemented (accepted deviation):** no validation against the instrument's maximum order size (AC14) — a user can type/save an arbitrarily large number, which breaks the quantity bar's visual layout (text overflow) rather than being rejected.

## QA evidence

**QA Execution: PASSED (With Approved Deviation)** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the feature works perfectly for sorting, persistence, standard validations, and execution.

**Important Note regarding AC14:** the system currently does not validate the configured maximum order size. Users can save astronomically large numbers that subsequently break the quick quantity bar display due to text overflow. It was agreed that the implementation of AC14 will be deferred until the business rules are clearly defined. The story is approved to move forward with this known deviation.

1. **Navigation & Default Values (AC1, AC4, AC5) — PASSED:** verified the Fast Size Buttons settings page is accessible via the correct path. New configurations correctly display the default values (`1, 5, 10, 25, 50, 100`) and are saved independently per user profile.
2. **Validation: Data Types, Zero, Negatives & Duplicates (AC9, AC13) — PASSED:** verified the system correctly rejects decimals, zero, negative numbers, and letters, displaying proper error messages. Duplicate values are also successfully blocked from being saved.
3. **Validation: Button Limits & Max Order Size (AC8, AC14) — PASSED (With Exemption for AC14):** verified the 1-to-6 button quantity limit is completely respected (AC8). **Deviation Accepted (AC14):** the system does not validate against the instrument's maximum order size, allowing massive values (e.g. `100000000000000000`) that cause text overflow and break the quantity bar UI — explicitly accepted pending BA definition of maximum limits.
4. **Auto-Sorting & Real-Time UI Updates (AC2, AC3, AC10, AC12) — PASSED:** verified entering values in random order auto-sorts them ascending upon saving, and the active Escalator widget instantly updates its quantity bar with the new values without requiring a refresh.
5. **Quantity Bar Width & Blank Slots (AC11) — PASSED:** verified that configuring fewer than 6 buttons (e.g. 2) keeps the quantity bar's original width, with unused slots present in the DOM but rendering completely blank.
6. **Session Persistence (AC6) — PASSED:** verified customized quantity values persist after closing/reopening the widget and after a full logout/login cycle into Darwin.
7. **Order Execution Accuracy (AC7) — PASSED:** verified clicking a custom preset button (e.g. `1`) successfully applies that exact quantity to the next order submitted directly from the Escalator widget.

Tagged for review: Hermela Mekonnen, Artur Moreira Dobler.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 14-item acceptance criteria table.
- `02-screenshot1-settings-location.png` — Screenshot 1: settings page location (Order Management → Trading Books, path context).
- `03-example-existing-control-fast-spread-buttons.png` — reused UI pattern example: existing "Autospread Buttons" settings screen.
- `04-qa-execution-passed-deviation-summary-scenario1.png` — QA header, AC14 deviation note, scenario 1 (navigation & defaults).
- `05-qa-execution-scenario2-validation-data-types.png` — QA scenario 2: data type/zero/negative/duplicate validation.
- `06-qa-execution-scenario3-button-limits-max-order-deviation.png` — QA scenario 3: 1–6 button limit, AC14 deviation evidence (huge number saved, UI overflow).
- `07-qa-execution-scenario3-continued-scenario4-autosort.png` — QA scenario 3 continued, scenario 4: auto-sort and real-time update.
- `08-qa-execution-scenario5-quantity-bar-width-blank-slots.png` — QA scenario 5: bar width and blank slots with fewer than 6 values.
- `09-qa-execution-scenario6-session-persistence-scenario7-order-execution.png` — QA scenario 6: session persistence; scenario 7: order execution using a custom quantity.

## Notes for automation

- Requires access to `Settings → Order Management → Fast Size Buttons` and an Escalator widget open to observe the live quantity bar.
- Candidate validations for a test:
  - Default configuration for a new user is `1, 5, 10, 25, 50, 100`.
  - Adding/removing values enforces the 1–6 range, rejects invalid input (0, negative, decimal, letters, blank), and blocks duplicates.
  - Saving auto-sorts ascending and updates the Escalator's quantity bar immediately, without a refresh.
  - Configuration persists across widget reopen and full logout/login.
  - Configuring fewer than 6 values keeps the quantity bar's width constant, with blank unused slots.
  - Clicking a custom quantity button applies that exact value to the next submitted order.
- **Do not write a passing test for AC14 as literally worded** (rejecting values above the instrument's max order size) — that validation does not exist yet by design; if a regression test is desired, it should assert the *current* (accepted) behavior, or be explicitly deferred until AC14 is implemented.
- This story sits on top of [[DWU-180]] (original fixed presets) and [[DWU-261]] (manual quantity entry) — confirm how user-configured presets interact with DWU-261's aggregation/manual-quantity mutual-exclusivity rules when automating both together.

## References

- Jira: DWU-260 (https://darwinjira.atlassian.net/browse/DWU-260)
- Epic: DWU-300
- Related stories: [[DWU-180]] (original fixed quantity bar), [[DWU-261]] (manual quantity input — coexists with these configurable presets)
