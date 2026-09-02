# [DWU-171] Bond Pricer: Display of Price fields in 32nd format

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-171 |
| Ticket name | Bond Pricer: Display of Price fields in 32nd format |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-298 — UST1 Base Price Generation |
| Module / area | Bonds — Bond Pricer (price field rendering) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story is the display-layer consumer of the "Price Format" per-bond configuration introduced in [[DWU-169]] (Reference Data dropdown "Decimal"/"32nd") and depends on the precision increase from [[DWU-170]] (up to 8 decimal places, needed to represent 32nd fractions accurately). Bond Pricer must render its price-related columns differently depending on each row's configured Price Format: unchanged for "Decimal", converted to the market-convention fractional "32nd" notation otherwise.

Roles on the ticket: FE Developer — Gabriel Andrade Correa; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium.

## User story

As a trader, I would like the Bond Pricer prices to be displayed taking into account the selected instrument format per bond, whether it is decimal or 32nd format.

## Acceptance criteria

- [ ] **Requirement 1:** if a Bond Pricer row has an instrument with "Price Format" (Bond Referential) defined as "Decimal", no changes are made — price is displayed as-is (e.g. `98.123`).
- [ ] **Requirement 2:** if a Bond Pricer row has an instrument with "Price Format" defined as "32nd", price fields must be displayed in 32nd format.
- [ ] **Requirement 3:** the scope of price fields that must be displayed in 32nd format (per the "Pricer Data Dictionary" > "Pricer UI" tab) is: Forward Price, PsPrc, PDiff, PrcMid, Ref PrcMid, BrokerBestBid, BrokerBestAsk, PrBid, PrcAsk, T+2MidP, Ask Tier 3, Bid Tier 3, Ask Tier 4, Bid Tier 4, Cls P (Closing Price), Dirty Price Mid, Ref P Bid, Ref P Ask, Bid Tier 1, Ask Tier 1, Bid Tier 2, Ask Tier 2, Bid Tier 5, Ask Tier 5, Ref 2 Price Ask, Ref 2 Price Bid, Ref 2 Price Mid.
- [ ] **Requirement 4:** the decimal-to-32nd conversion logic must follow the documented process (see below) when the bond's Price Format is "32nd".
- [ ] **Requirement 5:** in this iteration, calibration (editing) is NOT supported when Price Format is "32nd" — editing the Price cell must not allow entering a 32nd-format price. The edit function should either not work, or continue to accept a decimal price and display it back in 32nd format. This limitation is explicitly deferred to a future story.

### Decimal-to-32nd conversion logic (Requirement 4)

- The security price's whole-number part (left of the decimal point) is the "Handle".
- The Handle is separated from the fractional part with a `-` in 32nd formatting (e.g. `102-5/8`).
- The "32nd" component is the decimal fraction multiplied by 32, using the whole part to the left.
- The "1/8th of a 32nd" is the remaining decimal multiplied by 8.

Conversion table (decimal → 32nd fraction):

| Decimal | 32nd fraction |
|---|---|
| 0 | 0 |
| 0.125 | 1/8 |
| 0.25 | 1/4 |
| 0.375 | 3/8 |
| 0.50 | 1/2 |
| 0.625 | 5/8 |
| 0.75 | 3/4 |
| 0.875 | 7/8 |

A reference working model (`UST Pricing 32nd Conversions.xlsx`) was attached to the ticket for this logic.

## Implemented behavior

- Bond Pricer inspects each row's instrument "Price Format" (from Bond Referential, see [[DWU-169]]). Rows configured as "Decimal" render unchanged (e.g. `98.123`). Rows configured as "32nd" render the in-scope price columns using the fractional convention (e.g. `100-00 1/2`, `100-00 1/8`).
- The backend `pricingFormat` field carries the enum value `"ThirtySeconds"` (confirmed via network payload) for bonds configured as 32nd, and `"Decimal"` otherwise. Backend dev evidence shows this field was updated to include the trailing "S" (`ThirtySeconds`), tying this story's rendering logic to the same reference-data field introduced in DWU-169.
- The conversion from raw decimal price to the fractional 32nd display is applied automatically by the pricing/formatting engine — confirmed working across the populated in-scope columns (e.g. Price Bid, Price Ask, MidPrice 1DayFwd, Ask/Bid Tier levels, Ref Price Bid/Ask).
- **Column-scope limitation (from QA notes):** at the time of testing, several of the 27 in-scope columns had no data (empty cells) in the test environment, so the 32nd formatting logic could not be fully verified for those specific columns — only for the ones populated with values. Two column-name aliases were also noted: "Source Price Spread Mid" in the UI maps to "P Diff" in the requirement, and "MidPrice 1DayFwd" maps to "T+2 MidP".
- **Editing restriction (Requirement 5) is enforced:** attempting to edit a price cell for a "32nd"-configured bond by typing a non-decimal / 32nd-style value (e.g. `100-00`) is blocked, and the UI shows an error banner: "Calibration value cannot be converted to decimal:". This confirms editing continues to expect decimal input and rejects 32nd-formatted input, per Requirement 5.

## QA evidence

**QA Testing: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Results:
1. Validated that when a bond is configured as "Decimal" in Bond Referential (ISIN `PTOTEAOE0005`, bond `PGB 3.000 06/35`), the Bond Pricer grid respects this configuration and displays prices unchanged.
2. Validated the rendering of a bond configured as "32nd" (ISIN `PTOTEAOE0005` and others in the `PORTUGAL` book). The backend formatting engine successfully converts decimal raw prices into the correct fractional convention across the populated in-scope columns.
3. QA Notes (Column Scope): while the formatting logic is correct, several in-scope columns had no data at test time, so 32nd formatting could not be fully verified for those specific columns until populated. Column aliasing noted: "Source Price Spread Mid" = "P Diff"; "MidPrice 1DayFwd" = "T+2 MidP".
4. Validated editing restrictions on the price cell: entering a non-decimal format (e.g. `100-00`) is correctly blocked, with an error banner shown. **PASSED** for Requirement 5.
5. Backend dev test evidence (Luiz Gustavo Henrique Justo, environment DEV2, ISIN `PTOTE4OE0008`): confirms the `pricingFormat` field was updated to send `"ThirtySeconds"` (adding the trailing "S"), and the network response payload reflects this value for the corresponding instrument.

Tagged for review: Luiz Gustavo Henrique Justo, Gabriel Andrade Correa, Shaun Murdoch.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-requirements-1-3.png` — ticket description, user story, Requirements 1–3 (behavior for Decimal/32nd, column scope list).
- `02-requirements-4-5-conversion-logic.png` — Requirement 4 (conversion logic and table) and Requirement 5 (editing not supported), with "Like this" comparison screenshots (32nd vs Decimal pricer UI).
- `03-qa-testing-passed-decimal-config-respected.png` — QA result: Decimal-configured bond rendered unchanged in Bond Pricer.
- `04-qa-testing-32nd-config-bond-pricer-grid.png` — QA result: Bond Pricer grid for the PORTUGAL book with the 32nd-configured row highlighted.
- `05-qa-notes-column-scope-and-edit-restriction-passed.png` — QA notes on column-scope limitation, plus the passed validation of the edit-restriction error banner with fractional values visible in-grid.
- `06-dev-test-evidence-backend-pricing-format.png` — Backend dev test evidence: Bond Referential + DevTools, ISIN `PTOTE4OE0008`.
- `07-dev-test-evidence-network-payload-thirtyseconds.png` — Backend dev test evidence: network response payload showing `"pricingFormat": "ThirtySeconds"`.

## Notes for automation

- Depends on [[DWU-169]] (Price Format field must be set per bond in Bond Referential) and [[DWU-170]] (8 decimal place precision) being in place before this story's behavior can be exercised end-to-end.
- Candidate validations for a test:
  - A bond configured as "Decimal" shows unchanged decimal prices in Bond Pricer.
  - A bond configured as "32nd" shows fractional-format prices (e.g. `100-00 1/2`) in the in-scope columns that have data.
  - Editing a price cell on a "32nd"-configured bond with a non-decimal value is blocked and shows the "Calibration value cannot be converted to decimal:" error.
- **Known gap:** not all 27 in-scope columns (Requirement 3) were verified at QA time due to empty data in some columns. Before writing assertions against a specific column beyond the ones confirmed in the evidence (Price Bid, Price Ask, MidPrice 1DayFwd, Ask/Bid Tier 1-5 where populated, Ref Price Bid/Ask, Closing Price, Dirty Price Mid), confirm that column actually has data in the target test environment.
- Test data needs at least two bonds: one with Price Format = "Decimal" and one with Price Format = "32nd", both with populated pricing data in Bond Pricer.

## References

- Jira: DWU-171 (https://darwinjira.atlassian.net/browse/DWU-171)
- Epic: DWU-298
- Attachment: "UST Pricing 32nd Conversions.xlsx" (conversion reference model)
- Related stories: [[DWU-169]] (Price Format dropdown), [[DWU-170]] (8 decimal places precision)
