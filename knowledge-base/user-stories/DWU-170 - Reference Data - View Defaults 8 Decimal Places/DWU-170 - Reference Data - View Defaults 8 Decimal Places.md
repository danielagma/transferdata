# [DWU-170] Reference Data: View Defaults: Increase selectable precision to 8 decimal places

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-170 |
| Ticket name | Reference Data: View Defaults: Increase selectable precision to 8 decimal places |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-297 — UST1 Reference Data |
| Module / area | Reference Data — Bond Referential (View Defaults) / Bond Pricer |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

Darwin needs to support the "1/32" price format (see [[DWU-169]]), which requires up to 8 decimal places of precision. Today, the precision limit configurable in Bond Referential > "Static" > "View Defaults" tops out at 5 decimal places. This story raises that ceiling to 8, and ensures the Bond Pricer respects the new configured precision when displaying values.

Roles on the ticket: FE Developer — unassigned; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium.

## User story

As a trader, I would like the existing precision limit set in "Static" > "Bond Referential" > "View Defaults" to be increased from 5 to 8 decimal places, in order to support 1/32 price format which requires 8 decimal places.

## Acceptance criteria

- [ ] **Precision enhancement:** given the user is editing the Bond Referential > View Defaults screen, when entering a value in any of the fields, then the system allows values from 0 up to 8 decimal places.
- [ ] Bond Pricer uses this change: for example, if "Price" precision is set to 8, then it is possible to see Price in Bond Pricer with 8 decimal places. QA must check all 5 options work.

The 5 fields governed by this precision setting (per "View Defaults" > Column Format) are: **Driver**, **Bid Offer Spread**, **Price**, **Yield**, and **Relative Value Measures**.

## Implemented behavior

- In Bond Referential > View/Edit > "View Defaults" tab > "Column Format" section, each of the 5 precision fields (Driver, Bid Offer Spread, Price, Yield, Relative Value Measures) now accepts values up to 8 decimal places (previously capped at 5).
- Each field has increment/decrement (+/-) controls next to a numeric input showing "precision decimal places".
- Saving a valid configuration shows a success toast ("The bond was updated successfully.") and persists via a backend sync — confirmed through the network payload (`viewDefaults` object with `driverViewPrecision`, `bidOfferSpreadViewPrecision`, `priceViewPrecision`, `yieldViewPrecision`, `relativeValueMeasuresViewPrecision`, all correctly set to `8`).
- Negative values are blocked at the input level: entering a negative number (e.g. `-5`) shows an inline validation error ("Must be greater than 0") and disables the Save button.
- A warning message is shown when reducing precision on a field that already has user-entered data: "Reducing precision of a user-entry field will round the stored value."
- Bond Pricer is expected to reflect the configured precision (e.g. Price shown with 8 decimal places) — this is Acceptance Criterion 2, not directly captured in the 4 available screenshots (see note at top of this document).

## QA evidence

**QA Testing: PASSED (BUG FOUND)** — Environment: DEV2. Tested by Daniel Aguilar.

Results captured in available screenshots (ISIN used: `ES0000011868`, bond `SPGB 6.000 01/29`):
1. All 5 precision fields (Driver, Bid Offer Spread, Price, Yield, and Relative Value Measures) can be successfully adjusted to the new maximum limit of 8 decimal places.
2. The system successfully processes the maximum configuration, showing the green "The bond was updated successfully." toast notification upon saving.
3. Developer Tools network inspection confirms a successful backend synchronization (HTTP 200 OK), with the JSON response payload correctly storing the value of 8 for all 5 precision fields.
4. Negative inputs are blocked: attempting to enter a negative value (tested on the "Driver" field) triggers a validation error ("Must be greater than 0") alongside a rounding warning.

**Bug found:** the ticket status is explicitly "PASSED (BUG FOUND)". The specific bug's screenshot was not captured in this document, but the bug has since been **closed/resolved** — confirmed by the user. No open defect blocks automation of this story.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, acceptance criteria table, Screenshot 1 (Bond Referential View Defaults screen, ISIN `GB00BMFRL083`).
- `02-qa-testing-passed-bug-found-8-decimal-places.png` — QA result header ("PASSED (BUG FOUND)"), all 5 fields set to 8, and success toast.
- `03-qa-testing-network-payload-confirmation.png` — QA result: network response payload confirming all 5 `*ViewPrecision` fields set to 8.
- `04-qa-testing-negative-input-blocked.png` — QA result: negative-value validation on the "Driver" field.

## Notes for automation

- Requires access to Bond Referential (Bonds app) and a bond instrument's View/Edit > "View Defaults" tab.
- Candidate validations for a test:
  - Each of the 5 precision fields (Driver, Bid Offer Spread, Price, Yield, Relative Value Measures) accepts a value up to 8 decimal places and saves successfully.
  - Entering a negative value on any of these fields is blocked with a validation error and disables Save.
  - After setting "Price" precision to 8 and saving, Bond Pricer displays that instrument's price with 8 decimal places (Acceptance Criterion 2 — not yet verified against a screenshot in this document).
- The bug referenced by "PASSED (BUG FOUND)" has been closed — no open defect to account for when automating this story.

## References

- Jira: DWU-170 (https://darwinjira.atlassian.net/browse/DWU-170)
- Epic: DWU-297
- Related story: [[DWU-169]] (Pricing Format dropdown — motivates the need for 8 decimal places)
