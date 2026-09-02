# [DWU-375] Add Bond Sector to Bond Referential

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-375 |
| Ticket name | Add Bond Sector to Bond Referential |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-297 — UST1 Reference Data |
| Module / area | Reference Data — Bond Referential (Bond Reference Data / Classifications) |
| Automation status | Not started |
| Suggested automation order | **Tier 1** — Reference Data foundation; independent of Price Format ([[DWU-169]]) and of the entire Order Management epic. Good starting point. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

U.S. Treasury requirements introduce additional reference data fields that Darwin does not currently support, documented in an external "Bonds Data Dictionary". This story adds one of those fields, "Bond Sector" — a maturity-category label (e.g. a Treasury grouped as `2Y` belongs to the two-year sector; `10Y` to the ten-year sector). The sector can change as an instrument approaches maturity. TIPS and STRIPS have their own dedicated sector labels rather than a maturity-year bucket. This story is scoped strictly to adding the field and its input controls to Darwin — automatic sourcing/updates from external feeds (ICAP, Bloomberg, Treasury Direct) are explicitly out of scope, handled separately.

Roles on the ticket: QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium. PR Approval Status: BE — Approved; FE — Approved. Functional Area: Bond Reference Data. Status: **Released**.

## User story

As a reference data user, I want Darwin to view and maintain Bond Sector in Bond Referential, so that Treasury instruments such as Notes and Bonds can be grouped in the correct trading sector as it ages.

## Acceptance criteria

- [ ] Add a field named "Bond Sector" under: `Bond Referential > Bond Reference Data > Classifications`, directly below "Internal Sector".
- [ ] Bond Sector must be supported through the existing Bond Referential Bulk Upload function — accepting only the approved enum values or a blank value; invalid values must produce a row-level validation error and must not update the instrument's existing Bond Sector.
- [ ] Bond Sector must use a dropdown containing: `Short, 2Y, 3Y, 5Y, 7Y, 10Y, 20Y, 30Y, TIPS, STRIPS` — users must not be able to enter free text.
- [ ] The Bond Sector field must apply to U.S. Treasury instruments; it must remain blank for instruments that do not require a sector.
- [ ] The field must remain optional and allow a blank value — no conditional mandatory or visibility rules until Darwin has a confirmed way to identify a U.S. Treasury instrument.
- [ ] All existing Bond Referential behavior not explicitly changed by this story must remain unchanged (saving permissions, audit validation, bulk upload behavior remain business-as-usual).

### Simple user flow (from the mockup)

1. User searches for or creates a U.S. Treasury instrument.
2. User opens the Bond Reference Data tab.
3. User selects a value from "Bond Sector" under Classifications, below "Internal Sector".
4. User saves the instrument.
5. Darwin stores and displays the selected value when the instrument is reopened.

## Implemented behavior

- A "Bond Sector" dropdown field was added to Bond Referential > View/Edit > "Bond Reference Data" tab > **Classifications** section, positioned directly below "Internal Sector".
- The dropdown is a strict enum selector — free text is blocked — offering exactly: `Short, 2Y, 3Y, 5Y, 7Y, 10Y, 20Y, 30Y, TIPS, STRIPS`, plus the ability to leave it blank (optional field, no mandatory rule).
- Saving an instrument with a selected Bond Sector persists it — confirmed via network payload showing the `bondSector` key (e.g. `"5Y"`) — and the value is redisplayed correctly when the instrument is reopened.
- The field is supported by the existing Bulk Upload function: a CSV with a valid `bondSector` value (e.g. `TIPS`) or a blank value updates successfully. A CSV with an invalid value (e.g. `QATEST`) is rejected with a row-level validation error, and the instrument's existing Bond Sector is not modified.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the "Bond Sector" field has been successfully implemented within the Bond Referential module. UI placement, strict dropdown enumerations (preventing free text), and data persistence work precisely as requested. The Bulk Upload functionality correctly supports the new field, accepting valid entries and properly triggering row-level validation errors for invalid inputs without disrupting existing behavior.

1. **UI Layout and Dropdown Options (AC1, AC3, AC5) — PASSED:** verified the "Bond Sector" field is correctly located in the Bond Reference Data tab, under Classifications, directly below "Internal Sector". Confirmed it operates as a strict dropdown (free text blocked) containing only the approved enum values, and permits blank values as an optional field.
2. **Manual Assignment and Persistence (AC4, AC6) — PASSED:** verified selecting a valid Bond Sector and saving the instrument correctly updates the database; reloading the instrument shows the selected sector persisting accurately in the UI, with the network payload confirming transmission of the `bondSector` key.
3. **Bulk Upload Validation (AC2) — PASSED:** verified Bulk Upload using a test CSV — successfully updated instruments using valid enum values (e.g. `TIPS`) and blank values. Attempting to upload an invalid value (`QATEST`) successfully triggered the expected row-level validation error, ensuring the system safely rejects bad data without updating the instrument's existing configuration.

Sign-off: "Approved to close. All Acceptance Criteria have been successfully met." Tagged: Shaun Murdoch, Gabriel Andrade Correa, Luiz Gustavo Henrique Justo.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-background.png` — full ticket: user story, background, Bond Sector definition and value list.
- `02-acceptance-criteria-table.png` — acceptance criteria table (6 items).
- `03-mockup-simple-user-flow.png` — mockup: simple user flow and field placement.
- `04-qa-execution-passed-scenario1-ui-layout-dropdown.png` — QA scenario 1: field placement and dropdown enumeration.
- `05-qa-scenario2-manual-assignment-persistence.png` — QA scenario 2: manual assignment, persistence, network payload (`bondSector`).
- `06-qa-scenario3-bulk-upload-valid-values.png` — QA scenario 3: bulk upload with valid enum value.
- `07-qa-scenario3-bulk-upload-invalid-value-error-signoff.png` — QA scenario 3 continued: invalid value rejected with row-level error, sign-off.

## Notes for automation

- Requires access to Bond Referential (Bonds app), a U.S. Treasury instrument to edit, and a way to perform a Bulk Upload (test CSV).
- Candidate validations for a test:
  - "Bond Sector" field is present under Classifications, directly below "Internal Sector".
  - Dropdown offers only the 10 approved enum values, with no free-text entry, and allows blank (no forced default).
  - Selecting a value and saving persists it; reopening the instrument shows the same value.
  - Bulk Upload with a valid enum value (or blank) succeeds; bulk upload with an invalid value fails with a row-level error and does not alter the instrument's existing Bond Sector.
- Independent story — no dependency on the Order Management epic (DWU-300) stories; this is pure Reference Data, alongside [[DWU-169]] and [[DWU-170]].

## References

- Jira: DWU-375 (https://darwinjira.atlassian.net/browse/DWU-375)
- Epic: DWU-297
- Related stories: [[DWU-169]] (Price Format field — same Bond Referential Classifications area), [[DWU-170]] (precision settings — same epic)
