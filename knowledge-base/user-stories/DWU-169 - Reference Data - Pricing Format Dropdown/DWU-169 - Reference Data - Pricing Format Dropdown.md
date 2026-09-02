# [DWU-169] Reference Data: Add "Pricing Format" dropdown to Bond Referential to enable selection of "32nd/decimal" formats

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-169 |
| Ticket name | Reference Data: Add "Pricing Format" dropdown to Bond Referential to enable selection of "32nd/decimal" formats |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-297 — UST1 Reference Data |
| Module / area | Reference Data — Bond Referential (Classifications section) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

US Treasury bonds are conventionally priced in "32nd" format rather than decimal. Today, Bond Referential has no per-instrument way to configure which price format a bond should be displayed/quoted in. This story adds a "Price Format" field to the Bond Referential so price format can be set per bond, aligned with market convention.

**What is 32nd format?** It refers to the tick size (smallest price increment) used in financial markets, particularly for U.S. Treasury bonds. Per the ticket's own example: a price quoted as `99-30` means 99 full points plus 30/32.

Roles on the ticket: FE Developer — unassigned; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium.

## User story

As a trader, I would like to configure for which instruments I want to see price information formatted in 32nd format so that it is aligned with the market convention. I should be able to define price format per bond. Additionally, this dropdown should be created right under the "Quote Group" field.

## Acceptance criteria

- [ ] A new field/parameter named "Price Format" must be added to the Bond Referential data screen, in the "Static" window under "View/Edit".
- [ ] The parameter must be a dropdown, with exactly the following enum options: "Decimal", "32nd".
- [ ] The field must be placed directly under the "Quote Group" field.
- [ ] The parameter must be a mandatory input (*).
- [ ] The default for existing instruments must be "Decimal".
- [ ] For new instruments, it must default to "Decimal".

## Implemented behavior

- A "Price Format" dropdown was added to Bond Referential > View/Edit > **Classifications** section, positioned immediately under "Quote Group".
- The dropdown is a controlled select exposing exactly two options: "Decimal" and "32nds". The UI structurally prevents clearing the field or leaving it blank — the mandatory constraint is enforced via input restriction rather than a separate validation error message.
- The field defaults to "Decimal" both for existing instruments (on load) and for newly created instruments.
- Updating the field triggers a `POST` to `/api/reference-data/bonds`. The request payload's `pricingFormat` property is sent using the backend enum value `"ThirtySeconds"` when the UI value "32nd" is selected (confirmed via network inspection).
- **Known defect (documented in QA notes, non-blocking for this story's sign-off):** updating "Price Format" on at least one specific ISIN (`PTOTE3OE0025`) causes the backend (CAPI) to return an unhandled `500 Internal Server Error`, with a plain-text response body: `Bond Update failed for ISIN PTOTE3OE0025.` The UI surfaces a generic error toast ("An error has occurred while saving the bond. Request failed, please try again or contact Support."). This did not reproduce on other tested ISINs (e.g. `PTOTE4OE0008`, which updated successfully), so the failure appears to be data/ISIN-specific rather than a systemic feature failure.

## QA evidence

**QA Testing: PASSED WITH NOTES** — Environment: DEV2. Tested by Daniel Aguilar.

Results (ISIN used: `PTOTE4OE0008`, bond `PGB 3.375 06/40`):
1. The mandatory "Price Format:*" parameter was successfully integrated into the "Classifications" section of the Bond Referential form.
2. UI spatial mapping is correct — positioned exactly underneath the "Quote Group" dropdown field.
3. Initial state validation confirmed the field automatically defaults to "Decimal" upon loading existing instruments, preventing unpopulated/null fields by design.
4. The dropdown list exclusively exposes "Decimal" and "32nds" as selectable options; the interface structurally bars the user from clearing the field or leaving it blank, fulfilling the mandatory constraint via input restriction.
5. "Price Format" was successfully updated to "32nd" via the UI, with a success toast ("The bond was updated successfully.").
6. The CAPI backend correctly processed the `POST` request (HTTP 200 OK), and the payload updated the `pricingFormat` property to `"ThirtySeconds"`.

**QA Notes — bug found (reason for "WITH NOTES"):**
- Title: Price Format update failure on specific ISIN (Bug/Data Issue).
- ISIN used: `PTOTE3OE0025` (bond `PGB 3.625 06/54`).
- The CAPI backend rejects the `POST` request, returning an unhandled `500 Internal Server Error`. The response body drops a plain-text message: `Bond Update failed for ISIN PTOTE3OE0025.`
- Tagged for follow-up to: Luiz Gustavo Henrique Justo, Artur Moreira Dobler, Shaun Murdoch.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, 32nd format explanation, acceptance criteria table, Screenshot 1 (Bond Referential Data Screen).
- `02-screenshot2-field-placement.png` — Screenshot 2: expected field placement under "Quote Group" in Classifications.
- `03-qa-testing-passed-with-notes-default-decimal.png` — QA result: field added, positioned correctly, defaults to "Decimal" (ISIN `PTOTE4OE0008`).
- `04-qa-testing-dropdown-options-and-update-success.png` — QA result: dropdown restricted to "Decimal"/"32nds", successful update to "32nd" with success toast.
- `05-qa-notes-bug-500-error-isin.png` — QA notes: network payload showing `pricingFormat: "ThirtySeconds"` on success, and the start of the bug report (500 error) on ISIN `PTOTE3OE0025`.
- `06-qa-notes-bug-500-error-network-detail.png` — QA notes: full error toast, network request detail (500 Internal Server Error), and tagged reviewers.

## Notes for automation

- Requires access to Bond Referential (Bonds app) and a bond instrument to open in View/Edit mode.
- **Use a known-good ISIN for the happy path** (e.g. `PTOTE4OE0008` or an equivalent instrument confirmed to work) — do not use `PTOTE3OE0025` for happy-path assertions, since it currently triggers a real backend defect (500 error), not expected behavior. Confirm the bug's current status before writing any test that exercises that ISIN.
- Candidate validations for a test:
  - "Price Format" field is present in the Classifications section, directly under "Quote Group".
  - Field defaults to "Decimal" on load for an existing instrument.
  - Dropdown exposes only "Decimal" and "32nd" (no blank/clear option).
  - Selecting "32nd" and saving succeeds with a success confirmation, and the value persists on reload.
- Known open risk: the 500 error on ISIN `PTOTE3OE0025` (and potentially other instruments sharing its data profile) is an unresolved defect at the time this story was tested. If a regression test is written specifically to track this bug, keep it separate from the main feature's happy-path test.

## References

- Jira: DWU-169 (https://darwinjira.atlassian.net/browse/DWU-169)
- Epic: DWU-297
- PR Approval Status: BE Approved, FE Approved
