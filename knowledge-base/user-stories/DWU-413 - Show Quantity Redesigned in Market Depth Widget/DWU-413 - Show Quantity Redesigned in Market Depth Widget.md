# [DWU-413] Show Quantity Redesigned in Market Depth Widget

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-413 |
| Ticket name | Show Quantity Redesigned in Market Depth Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Ladder (Iceberg orders) |
| Automation status | Not started |
| Suggested automation order | **Tier 10** — Built on the redesigned "Ladder" widget from [[DWU-334]]; automate after the rename/consolidation pass is covered. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

The refreshed Ladder ([[DWU-334]]) separates "Total Qty" (the full order quantity) from a new "Show Qty" field (the portion of the order actually displayed to the market). Entering a Show Qty puts the order into **Iceberg mode** — the rest of the quantity stays hidden from the visible market depth. This story defines the full validation and interaction rules around that field, including its interplay with routing venue (MULTI disables Iceberg), quantity-button presets, and Order Type/TIF locking.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. Tags: `Groom_20260715`. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**.

## User story

As a trader, I want to enter a Show Qty in the Ladder widget so that only part of my total order quantity is displayed to the market.

## Acceptance criteria

- [ ] **AC1:** display an editable "Show Qty" field next to the "Total Qty" field in the Ladder.
- [ ] **AC2:** "Show Qty" must default to blank when a new Ladder widget is opened (blank means Iceberg mode is not active).
- [ ] **AC3:** entering a "Show Qty" must place the order into Iceberg mode.
- [ ] **AC4:** "Show Qty" must be entered/displayed in millions and accept the instrument's minimum quantity and increment rules from existing Instrument Reference Data (e.g. `5` = 5 million).
- [ ] **AC5:** "Show Qty" must accept only values that are valid multiples of the selected instrument's minimum quantity increment (e.g. increment `5` million → valid values are `5, 10, 15`..., not `12`).
- [ ] **AC6:** "Show Qty" is optional; if entered, it must be greater than 0, at least the instrument's minimum quantity, and less than or equal to "Total Qty".
- [ ] **AC7:** orders with an invalid "Show Qty" must not be submitted.
- [ ] **AC8:** when "Show Qty" contains a value, Order Type must default to `LMT` and Time in Force to `GTD`; both fields must be disabled (greyed out) until "Show Qty" is cleared.
- [ ] **AC9:** if "Show Qty" is cleared, Order Type and TIF fields must remain `LMT`/`GTD` but become editable again.
- [ ] **AC10:** Iceberg mode must NOT be available when the routing venue is `MULTI`.
- [ ] **AC11:** if the venue is changed to `MULTI` after "Show Qty" has been entered, "Show Qty" must be cleared and Iceberg mode must end.
- [ ] **AC12:** selecting a quantity preset button must continue to populate "Total Qty" using existing behavior; "Total Qty" must remain editable.
- [ ] **AC13:** when a valid Iceberg order is submitted, both "Total Qty" and "Show Qty" must be sent to ORCA.
- [ ] **AC14:** on successful submission, "Show Qty" must be sent to ORCA and reset to blank after the order is acknowledged; if submission fails, the value must remain.
- [ ] **AC15:** if "Total Qty" is changed to a value below "Show Qty", "Show Qty" must be marked invalid and the order must not be submitted until corrected.

### "Show Qty" validation rules (from the ticket)

| # | Scenario | Outcome |
|---|---|---|
| 1 | `Show Qty` = `null` | Pass |
| 2 | `Show Qty` < 0 | Fail |
| 3 | `Show Qty` > `Quantity` (Total Qty) | Fail |
| 4 | `Show Qty` < minimum quantity for the instrument | Fail |
| 5 | `Show Qty` > 0 AND `Show Qty` <= `Quantity` AND `Show Qty` >= minimum quantity | Pass |

## Implemented behavior

- The Ladder shows "Show Qty" and "Total Qty" as two separate, adjacent editable fields. "Show Qty" defaults to blank on widget open (no Iceberg mode active).
- Clicking a quantity preset button (e.g. `10`, `25`) only ever populates "Total Qty" — "Show Qty" stays blank/untouched, and "Total Qty" remains manually editable afterward.
- Entering any value in "Show Qty" activates Iceberg mode: Order Type snaps to `LMT` and TIF to `GTD`, and both fields become disabled (greyed out) while "Show Qty" holds a value. Clearing "Show Qty" re-enables both fields, retaining their `LMT`/`GTD` values.
- "Show Qty" enforces: minimum 1 (below that → `"Show Qty must be at least 1"`), cannot exceed "Total Qty" (→ `"Show Qty cannot exceed Total Qty"`), and negative input is auto-reset to `0`. Submission is blocked while any of these invalid states hold.
- Reducing "Total Qty" below an already-set "Show Qty" immediately invalidates the form and blocks submission until corrected (AC15).
- Selecting routing venue `MULTI` automatically clears "Show Qty" and exits Iceberg mode — Iceberg is unavailable while `MULTI` is selected, whether it was active before switching or not.
- On successful Iceberg order submission, both quantities are sent to ORCA and "Show Qty" resets to blank for the next order. On a **failed/rejected** submission, both quantities are still sent to ORCA in the request, but "Show Qty" is deliberately **retained** in the UI so the trader can retry without re-entering it.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

1. **Default UI state and Quick Quantity buttons behavior (AC1, AC2, AC12):** verified "Show Qty" displays next to "Total Qty" and defaults blank on load. Clicking quick quantity buttons populates only "Total Qty", leaving "Show Qty" blank and "Total Qty" fully editable.
2. **Iceberg mode restrictions when changing venue to MULTI (AC10, AC11):** verified switching the routing venue to `MULTI` automatically clears any existing "Show Qty" value, deactivating Iceberg mode; it remains disabled while `MULTI` is selected.
3. **Automatic locking/unlocking of Order Type and TIF fields (AC3, AC8, AC9):** verified entering a "Show Qty" value defaults Order Type to `LMT` and TIF to `GTD`, instantly greying out both. Clearing "Show Qty" restores editability while retaining the `LMT`/`GTD` values.
4. **"Show Qty" strict mathematical and instrument validation rules (AC4, AC5, AC6, AC7):** verified boundary validations — value `< 0` resets to `0`; value `< 1` triggers `"Show Qty must be at least 1"`; value `>` Total Qty triggers `"Show Qty cannot exceed Total Qty"`. Submission is blocked in all these invalid states.
5. **Total Qty dependency validation check (AC15):** verified reducing an already-populated "Total Qty" below the current "Show Qty" immediately flags the fields invalid and blocks submission until manually corrected.
6. **Successful Iceberg order submission payload and UI reset (AC13, AC14):** verified a successfully acknowledged Iceberg order sends both Total Qty and Show Qty to ORCA, and "Show Qty" resets to blank immediately after.
7. **Failed Iceberg order submission UI retention (AC13, AC14):** verified a rejected Iceberg order still sends both values to ORCA, but "Show Qty" purposefully remains populated in the UI so the trader can retry/modify without re-entering the Iceberg values.

Sign-off: "Approved to close. All Acceptance Criteria have been successfully met." Tagged: Hermela Mekonnen, Artur Moreira Dobler.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background (Total Qty vs. Show Qty), 15-item acceptance criteria table.
- `02-validation-check-rules-table-mockup.png` — "Show Qty" validation rules table and Ladder mockup with Show Qty/Total Qty fields.
- `03-qa-execution-passed-scenario1-default-ui-state.png` — QA scenario 1: default blank state, quantity presets only affect Total Qty.
- `04-qa-scenario2-iceberg-restrictions-multi-venue.png` — QA scenario 2: MULTI venue clears Show Qty / disables Iceberg.
- `05-qa-scenario3-auto-lock-unlock-ordertype-tif.png` — QA scenario 3: Order Type/TIF auto-lock and unlock.
- `06-qa-scenario4-strict-math-validation-rules.png` — QA scenario 4: min/max/negative validation and error messages.
- `07-qa-scenario5-total-qty-dependency-validation.png` — QA scenario 5: Total Qty reduced below Show Qty blocks submission.
- `08-qa-scenario6-successful-scenario7-failed-iceberg-signoff.png` — QA scenarios 6 and 7: successful submission reset vs. failed submission retention, sign-off.

## Notes for automation

- Requires a Ladder widget with an instrument that has known minimum quantity/increment rules (Instrument Reference Data), and the ability to simulate both a successful and a rejected order submission.
- Candidate validations for a test:
  - "Show Qty" defaults blank; quantity presets only affect "Total Qty".
  - Entering a valid "Show Qty" locks Order Type to `LMT` and TIF to `GTD` (disabled); clearing it re-enables them, values retained.
  - Boundary validation: below minimum, above Total Qty, and negative input all produce the correct block/error and prevent submission.
  - Reducing Total Qty below an existing Show Qty blocks submission until corrected.
  - Switching venue to `MULTI` clears Show Qty and disables Iceberg mode entirely.
  - Successful submission sends both quantities and resets Show Qty to blank; a failed submission sends both quantities but keeps Show Qty populated for retry.
- This story composes with [[DWU-172]]/[[DWU-173]] (order submission mechanics) and [[DWU-334]] (renamed Ladder widget) — confirm whether Iceberg orders interact with passive vs. aggressive submission paths when scoping a test.

## References

- Jira: DWU-413 (https://darwinjira.atlassian.net/browse/DWU-413)
- Epic: DWU-300
- Related stories: [[DWU-334]] (Ladder rebrand — this field lives in that redesigned widget), [[DWU-172]] / [[DWU-173]] (order submission mechanics)
