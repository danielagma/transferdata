# [DWU-261] Add Manual Quantity Input to Quantity Bar

> The QA execution found a real, unresolved-at-the-time defect: pressing **Enter/Return** to exit edit mode on the "Man Qty" field is unresponsive, violating Acceptance Criterion 3. A minor bug was raised and linked to this story. Do not assume Enter/Return works as an exit-edit-mode trigger when automating — confirm current status first (clicking outside the cell is the workaround confirmed to work).

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-261 |
| Ticket name | Add Manual Quantity Input to Quantity Bar |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Escalator (Ladder quantity bar) |
| Automation status | Not started |
| Suggested automation order | **Tier 8** — Depends on [[DWU-180]] (adds manual quantity entry alongside the preset buttons). Order relative to [[DWU-260]] doesn't matter — both extend the same quantity bar independently. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story extends the fixed-preset vertical quantity bar introduced in [[DWU-180]] by adding a manually editable "Man Qty" field, so traders can trade quantities not covered by the preset buttons. It defines a mutual-exclusivity relationship between the manual field and the preset buttons, and clarifies how the ladder's order-submission logic ([[DWU-172]], [[DWU-173]]) should compute the quantity to use, including when multiple presets are aggregated.

Roles on the ticket: QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. PR Approval Status: BE — Not Required; FE — Approved. Functional Area: Order Book Trading. Status: **Released**.

## User story

As a trader, I want to manually enter a quantity directly from the quantity bar so that I can quickly trade using quantities that are not available in the preset quantity buttons.

## Acceptance criteria

- [ ] **AC1:** The first quantity field in the quantity bar ("Man Qty") is editable. Default: clear (null).
- [ ] **AC2:** User must be able to enter a custom quantity value directly into the editable field. Type: integer.
- [ ] **AC3:** Exiting cell edit mode after entering a quantity saves and selects the custom quantity. (Exiting edit mode works the same as in the Bond Pricer: hit Enter/Return, or change context out of the cell.)
- [ ] **AC4:** When a custom quantity is selected: (1) the editable field is highlighted with an orange background, and (2) all preset number buttons have their orange highlight removed.
- [ ] **AC5:** Selecting a preset quantity (1, 5, 10, 25, 50, or 100) must: (1) highlight the selected button in orange, (2) remove the orange highlight from the "Man Qty" cell, and (3) clear the value in the "Man Qty" cell.
- [ ] **AC6:** Selecting a custom quantity removes the orange highlight from all previously selected preset quantity buttons.
- [ ] **AC7:** The sum of the currently selected quantities — whether a single preset, multiple aggregated presets, or "Man Qty" — must be used for the next order submitted from the widget.
- [ ] **AC8:** Clicking `CLR` must clear the selected custom quantity and remove any active quantity-selection highlight from "Man Qty" and all preset buttons; the user must reselect a quantity after `CLR` is pressed.

## Implemented behavior

- The vertical quantity bar (from [[DWU-180]]) now includes a "Man Qty" input field alongside the preset buttons (`5, 10, 25, 50, 100, 200, CLR` in this iteration — an expanded preset set vs. DWU-180's original `10/25/50/75/100`).
- Clicking preset buttons individually toggles their selection (highlight/unhighlight); pressing `C`/`CLR` clears all highlights/selections at once. Multiple presets can be selected simultaneously and are summed (aggregated presets).
- Editing "Man Qty" removes highlighting from all preset buttons and highlights the "Man Qty" field instead — the two input modes (presets vs. manual) are mutually exclusive.
- Selecting any preset while a custom quantity is active clears the "Man Qty" value and its highlight, reverting to preset-only selection.
- `CLR` resets both the manual field and all preset highlights back to the default (no selection).
- The quantity used for order submission is the sum of whichever input mode is currently active: the manual quantity, a single preset, or the sum of multiple selected presets.
- **Known defect:** exiting "Man Qty" edit mode via the Enter/Return key does not work (unresponsive) — only clicking outside the cell (changing context) successfully saves and selects the custom quantity. This is a confirmed minor bug, tracked and linked to this story.

## QA evidence

**QA Execution: PASSED (WITH MINOR DEVIATION)** — Environment: DEV2. Tested by Daniel Aguilar.

1. **Default State & Saving Custom Quantity (AC1, AC2, AC3):** verified the "Man Qty" field is editable and empty by default. The system accepts valid integer inputs and saves the custom quantity successfully when changing context (clicking outside the cell). **Deviation noted:** exiting edit mode via Enter/Return is currently unresponsive (violates AC3) — a minor bug was raised and linked to this story.
2. **Mutual Exclusivity: Custom Qty Overrides Presets (AC4, AC6):** verified that entering and saving a custom quantity correctly highlights "Man Qty" in orange, while the system simultaneously removes the orange highlight from all previously selected preset buttons — strictly enforcing mutual exclusivity.
3. **Mutual Exclusivity: Presets Override Custom Qty (AC5):** verified the reverse flow — when a custom quantity is active, selecting any preset button (e.g. 10, 25) highlights the preset, completely clears the "Man Qty" value, and removes its highlight.
4. **System Reset: CLR Button (AC8):** verified that clicking `CLR` fully resets the widget — clears any typed "Man Qty" value and removes the active highlight from all preset buttons and the manual field.
5. **Order Execution Accuracy (AC7):** verified core trading functionality across all 3 quantity paths, with orders successfully submitted and confirmed using: (1) a custom manual quantity — system executed the exact typed value; (2) a single preset — system executed the exact preset button value; (3) aggregated presets — system correctly executed the mathematical sum of the multiple selected preset buttons.

Final sign-off: "Approved to close." Tagged: Hermela Mekonnen, Artur Moreira Dobler.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 8-item acceptance criteria table.
- `02-mockup-preset-buttons-behavior.png` — mockup: individual preset button click-to-highlight/unhighlight, `C` to clear all.
- `03-mockup-man-qty-field-behavior.png` — mockup: editing "Man Qty" removes preset highlights, highlights the manual field.
- `04-qa-execution-scenario1-default-state-deviation-noted.png` — QA scenario 1: default state, saving custom quantity, **deviation noted** (Enter/Return unresponsive).
- `05-qa-execution-scenario1-continued.png` — QA scenario 1 continued: additional evidence of custom quantity saved and highlighted.
- `06-qa-execution-scenario2-custom-overrides-presets.png` — QA scenario 2: custom quantity overrides preset highlights.
- `07-qa-execution-scenario3-presets-override-custom.png` — QA scenario 3: preset selection overrides/clears custom quantity.
- `08-qa-execution-scenario4-clr-reset.png` — QA scenario 4: `CLR` resets all selections.
- `09-qa-execution-scenario5-order-execution-accuracy.png` — QA scenario 5: order execution using custom, single-preset, and aggregated-preset quantities.
- `10-qa-execution-approved-to-close.png` — final scenario 5 evidence and "Approved to close." sign-off.

## Notes for automation

- Requires an Order Management setup with the Escalator widget open for an instrument with bid/ask liquidity.
- Candidate validations for a test, mapped to acceptance criteria:
  - AC1/AC2: "Man Qty" is editable, empty by default, accepts integer input.
  - AC3: saving via clicking outside the cell works. **Do not assert Enter/Return as a working exit method** — it was a confirmed bug at QA time; verify current status in the target environment before writing that assertion either way.
  - AC4/AC6: entering "Man Qty" clears preset highlights and highlights the manual field; selecting a preset while "Man Qty" is active clears and unhighlights it (AC5).
  - AC8: `CLR` resets both "Man Qty" and all preset highlights.
  - AC7: submitting an order uses the correct quantity for each of the 3 input modes (manual, single preset, aggregated presets — verify the sum math on multi-preset selection).
- This story builds directly on [[DWU-180]]'s quantity bar and is a precondition for correct quantity behavior in [[DWU-172]] (passive orders) and [[DWU-173]] (aggressive orders) — when automating those, confirm which quantity-selection mode (preset vs. manual vs. aggregated) the test is exercising.

## References

- Jira: DWU-261 (https://darwinjira.atlassian.net/browse/DWU-261)
- Epic: DWU-300
- Related stories: [[DWU-180]] (base vertical quantity bar — extended by this story), [[DWU-172]] (passive orders), [[DWU-173]] (aggressive orders) — both consume the quantity selected here
