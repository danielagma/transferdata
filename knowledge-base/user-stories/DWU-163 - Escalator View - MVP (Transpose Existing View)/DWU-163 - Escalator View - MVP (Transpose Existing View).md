# [DWU-163] Escalator View - MVP (Transpose Existing View)

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-163 |
| Ticket name | Escalator View - MVP (Transpose Existing View) |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Bond Pricer (D2D market depth widget) |
| Automation status | Not started |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

In Darwin EU, the D2D market depth widget (order book) is displayed horizontally. US traders migrating from the legacy ION system are used to a vertical "ladder"-style (price ladder) view, which is the format they normally use to scan price levels and order flow in real time. This story introduces that vertical ("Escalator") view as a transposition of the existing horizontal view, without redesigning the widget's underlying logic.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Shaun Murdoch; Jira priority — Medium.

## User story

As a trader, I want the D2D market depth widget displayed vertically in Darwin Bonds, so that I can interpret order book depth more quickly and execute trades with greater accuracy during fast moving markets.

## Acceptance criteria

- [ ] Bid and ask prices are stacked vertically, with the ask displayed above the bid. Ask quantities are aligned with ask prices, and the same applies to bid.
- [ ] The "MKT" (market) columns present in the current horizontal widget are omitted in the new vertical view.
- [ ] A "View Escalator" option must exist in the Bond Pricer's context menu (right-click), positioned immediately below "View Order Book...".
- [ ] Regression 1: "Own order" functionality is maintained — where "JC" is displayed in the grid, clicking a price/quantity auto-populates the order panel.
- [ ] Regression 2 (non-blocking): price/quantity auto-population in the order parameters from the new Escalator does not need to work yet, because that user experience will be replaced later.

## Implemented behavior

- **Current view (horizontal, pre-existing):** table with columns `MKT | Q | BID | ASK | Q | MKT`, where each row is a price level with its originating market on both sides.
- **New view (Escalator, vertical):** a vertical ladder where asks are stacked in the upper half (pink/magenta background) with quantities right-aligned, and bids are stacked in the lower half (blue background) with quantities left-aligned. Market ("MKT") columns are not shown in this view.
- **Access to the view:** from the Bond Pricer, right-clicking an instrument opens a context menu with the options `Create Sweep...`, `View Order Book...`, `View Escalator...` (new), `Pricing Defaults...`, plus standard grid options (Cut, Copy, Copy with Headers, Copy with Group Headers, Paste, Export). "View Escalator..." appears immediately below "View Order Book...".
- **Escalator widget:** opens as a panel inside "Order Management", showing the name of the selected bond (e.g. `BGB 1.000 06/26`, `SPGB 6.000 01/29`, `PGB 3.625 06/54`), a VWAP toggle, and quick-size buttons (10/25/50/75/100/CLR) to the right of the ladder for defining quantity.
- **Own Orders:** the user's active own orders are mapped and visually aligned within the vertical ladder (behavior inherited from the horizontal view, marked as "JC" in the screenshots).
- **Event isolation:** interacting with a price/quantity level in the Escalator grid does not trigger auto-population in the legacy "Order Management" panel (Market Depth) — click events are intentionally isolated, since that integration will be replaced later (see Regression 2).

## QA evidence

**QA Testing: PASSED** — Environment: DEV2.

Observed results:
1. The market depth widget successfully renders in vertical "Escalator" format: asks (pink) in the upper half with quantities right-aligned, bids (blue) in the lower half with quantities left-aligned. The "MKT" columns were correctly omitted. See `evidence/03-qa-testing-resultado-escalator-y-menu.png`.
2. The "View Escalator..." option is correctly displayed in the instrument's context menu within the Bond Pricer, positioned immediately below "View Order Book...". See `evidence/03-qa-testing-resultado-escalator-y-menu.png`.
3. Active "Own Orders" are successfully mapped and visually aligned in the vertical ladder. See `evidence/04-qa-testing-own-orders-y-aislamiento-clicks.png`.
4. Interacting with any price/quantity step on the Escalator grid does not trigger auto-population events in the legacy order panel (Market Depth); click events are successfully isolated. See `evidence/04-qa-testing-own-orders-y-aislamiento-clicks.png`.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-y-contexto.png` — full ticket, user story, business context, current view vs. desired view.
- `02-requirements-y-context-menu.png` — context menu screenshot (requirement 3) and requirements table (1–4).
- `03-qa-testing-resultado-escalator-y-menu.png` — QA result: rendered Escalator and "View Escalator" menu option.
- `04-qa-testing-own-orders-y-aislamiento-clicks.png` — QA result: mapped Own Orders and click event isolation.

## Notes for automation

- Requires an environment with active order book data for at least one bond (e.g. `BGB 1.000 06/26`, `SPGB 6.000 01/29`, `PGB 3.625 06/54`) and, for the "Own Orders" case, an active own order visible in the grid (marked "JC").
- The entry point to the feature is the context menu (right-click) on a Bond Pricer row → "View Escalator..." option. Verify its exact relative position with respect to "View Order Book...".
- Candidate validations for a test:
  - The vertical view stacks asks on top / bids on bottom, with correct quantity alignment on each side.
  - Absence of "MKT" columns in the Escalator view.
  - Presence and position of "View Escalator..." in the context menu.
  - Active "Own Orders" are reflected in the Escalator.
  - Clicking a price/quantity in the Escalator must NOT modify/auto-populate the legacy Order Management panel (Regression 2 — the expected behavior is that there is NO effect).
- Risk: Regression 2 explicitly documents that auto-population "does not need to work" because the UX will be replaced later — do not treat the absence of auto-population as a bug if automated before that replacement; confirm against the app's actual state at automation time.

## References

- Jira: DWU-163 (https://darwinjira.atlassian.net/browse/DWU-163)
- Epic: DWU-300
- PR Approval Status: BE Approved, FE Approved
