# [DWU-344] Apply Existing Pricing Format in Market Depth Widget

> **Approved deviation on AC5/AC6:** the written acceptance criteria state that ALL prices — including the manual order-entry price field — must reflect the configured Pricing Format (32nds when applicable). In practice, the manual `Price:*` entry field in the Market Depth/Ladder widgets does **not** support typed 32nd input: clicking a 32nd price level on the grid populates that field with its **decimal** translation, and manually typing a 32nd-style value is rejected. This was explicitly agreed as an exemption for the manual entry field — do not treat it as a bug when automating.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-344 |
| Ticket name | Apply Existing Pricing Format in Market Depth Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-297 — UST1 Reference Data |
| Module / area | Reference Data / Bonds — Market Depth + Ladder (price rendering) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

The per-bond "Pricing Format" field (Decimal/32nd) was introduced in [[DWU-169]] and already consumed by the Bond Pricer. This story extends that same reused formatting logic to the **Market Depth** and **Ladder** (formerly "Escalator", see [[DWU-334]]) widgets — explicitly reusing the Bond Pricer's existing implementation rather than introducing new formatting logic.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. Tags: `Groom_Next`. PR Approval Status: BE — Not Required; FE — Approved. Status: **Released**.

## User story

As a trader, I want prices displayed in the Market Depth and Ladder widgets to use the Pricing Format configured for each bond, so that prices are displayed consistently throughout Darwin.

## Acceptance criteria

- [ ] Market Depth must use the Pricing Format configured for the selected bond in Referential Data ([[DWU-169]]).
- [ ] Ladder must use the Pricing Format configured for the selected bond in Ref Data ([[DWU-169]]).
- [ ] Market Depth and Ladder must use the same formatting behavior currently implemented in Bond Pricer.
- [ ] If the Pricing Format is Decimal, ALL prices displayed in the widget (price ladder values, order entry prices, working order prices, and any other price values) must be shown in decimal format.
- [ ] If the Pricing Format is 32nds, ALL prices displayed in the widget must be shown in 32nds format (same scope as above).
- [ ] All price fields displayed in Market Depth/Ladder — including price ladder values, order entry prices, working order prices, and any other price values — must use the configured Pricing Format consistently.
- [ ] Market Depth must display prices identically for the same bond and Pricing Format.
- [ ] No new price formatting logic must be introduced — the existing implementation from Bond Pricer must be reused.
- [ ] ~~For the Sweep widget, prices should be displayed in 32nd format only if all Bonds selected have their Pricing Format set to 32nd in static.~~ (struck through in the ticket — out of scope for this story)

## Implemented behavior

- Market Depth and Ladder widgets now read each bond's "Pricing Format" (from [[DWU-169]]) and render all grid price values (ladder/order book prices) accordingly — decimal or 32nd fractional — reusing the same formatting logic already used by the Bond Pricer.
- This applies consistently across both widgets for the same bond and format, matching Bond Pricer's rendering exactly.
- **Exception (approved):** the manual order-entry `Price:*` field does not accept typed 32nd-format input. Clicking a 32nd price level in the grid populates this field with the **decimal equivalent** (e.g. clicking `97-01 1/2` populates `97.05`), and the field otherwise behaves in decimal. This is an accepted deviation from the literal wording of AC5/AC6.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the core logic for inheriting the Referential Data pricing format is working and successfully matching the Bond Pricer in the main grid areas.

**Important Note regarding AC5 & AC6:** the written Acceptance Criteria state that ALL prices (including "order entry prices") must reflect the 32nds format. Currently, the manual `Price:*` order entry field in the Market Depth widget does not support this and reverts to decimal values. However, it was agreed that the manual entry field is exempt from this formatting rule.

1. **Market Depth: Decimal Pricing Format (AC1, AC3, AC4, AC6, AC7, AC8) — PASSED:** verified that when a bond is configured as Decimal, all price values inside the Market Depth grid and the manual order entry price fields display accurately in decimal format, matching the Bond Pricer format.
2. **Market Depth: 32nds Pricing Format (AC1, AC3, AC5, AC6, AC7, AC8) — PASSED:** verified the grid displays 32nds accurately. **Deviation Accepted:** clicking a 32nds price level (e.g. `97-01 1/2`) populates the `Price:*` field with its decimal translation (e.g. `97.05`); manual typing of 32nds is rejected — approved despite conflicting with the original written AC wording.
3. **Ladder: Decimal Pricing Format (AC2, AC3, AC4, AC6, AC8) — PASSED:** verified that when a bond is configured as Decimal, all price values inside the Ladder's price ladder grid render consistently in decimal format, matching the Bond Pricer.
4. **Ladder: 32nds Pricing Format (AC2, AC3, AC5, AC6, AC7, AC8) — PASSED:** verified that when a bond is configured in 32nds, all price values inside the Ladder's price ladder grid successfully render in the 32nds fractional format, completely matching the Bond Pricer formatting.

Tagged for review: Hermela Mekonnen, Artur Moreira Dobler.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria-mockup.png` — full ticket: user story, background (link to DWU-169), acceptance criteria table, mockup (`DBR 0.500 08/27` in 32nd format).
- `02-market-depth-decimal-format-example.png` — Market Depth widget rendering `DBR 0.500 08/27` in decimal format.
- `03-qa-execution-passed-deviation-note-decimal.png` — QA header, AC5/AC6 deviation note, scenario 1 (Market Depth decimal).
- `04-qa-32nds-pricing-format-deviation-accepted.png` — QA scenario 2: Market Depth 32nds format, deviation evidence on the manual Price field.
- `05-qa-escalator-decimal-pricing-format.png` — QA scenario 3: Ladder decimal format.
- `06-qa-escalator-32nds-pricing-format-signoff.png` — QA scenario 4: Ladder 32nds format, sign-off.

## Notes for automation

- Requires at least two bonds: one configured "Decimal" and one "32nd" (per [[DWU-169]]), viewable in both Market Depth and Ladder widgets.
- Candidate validations for a test:
  - A "Decimal" bond renders all grid price values as decimals in both Market Depth and Ladder, matching Bond Pricer's rendering for the same bond.
  - A "32nd" bond renders all grid price values in fractional 32nd notation in both widgets, matching Bond Pricer.
  - **Do not assert that the manual Price entry field accepts or displays 32nd-formatted values** — it is confirmed and accepted to always show/accept decimal, even for a 32nd-configured bond. Clicking a grid price level populates that field with the decimal equivalent.
- This story is a good pairing with [[DWU-171]] (which defined the 32nd conversion logic in Bond Pricer) and [[DWU-169]]/[[DWU-170]] (Price Format field and precision) when building broader 32nd-format regression coverage.

## References

- Jira: DWU-344 (https://darwinjira.atlassian.net/browse/DWU-344)
- Epic: DWU-297
- Related stories: [[DWU-169]] (Price Format field — source of truth), [[DWU-170]] (8 decimal precision), [[DWU-171]] (Bond Pricer 32nd conversion logic — reused here), [[DWU-334]] (Escalator renamed to Ladder)
