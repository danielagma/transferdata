# [DWU-414] Fast Execution/Take Best Buttons in Market Depth Widget

> **QA scenario gap:** the QA execution's numbered scenarios jump from "2. Real-time Data Mapping and Coloring" directly to "4. Order Submission and Parameters" — scenario 3 was not captured. Based on the acceptance criteria not otherwise covered, scenario 3 most likely addressed **AC8** (Take Best buttons disabled/greyed out when no best executable price/quantity is available). Treat AC8 as **unverified** in this document until that evidence is found or the behavior is re-tested.

## Metadata

| Field | Value |
|---|---|
| Jira ticket | DWU-414 |
| Ticket name | Fast Execution/Take Best Buttons in Market Depth Widget |
| Project / Space | Darwin Bonds US |
| Parent epic | DWU-300 — UST1 Order Management: Ladder View & Fast ... |
| Module / area | Bonds — Order Management / Ladder (Take Best execution) |
| Automation status | Not started |
| Suggested automation order | **Tier 10** — Built on the redesigned "Ladder" widget from [[DWU-334]] and reuses the accordion pattern from [[DWU-283]]. |
| Suggested priority | @medium |
| Automation spec | (pending) |

## Context

This story adds two "Take Best" buttons to the Ladder — one-click aggressive execution at the best available Buy or Sell price, without needing to click a specific price level in the grid (as [[DWU-173]]'s aggressive order submission requires). The buttons mirror the current best opposite-side price/quantity in real time and reuse the ladder's Bid/Ask color scheme.

Roles on the ticket: FE Developer — Artur Moreira Dobler; QA Tester — Daniel Aguilar; Reporter — Hermela Mekonnen (deactivated); Jira priority — Medium. Tags: `Groom_20260715`. PR Approval Status: BE — Not Required; FE — Approved. Status: **Approved**.

## User story

As a trader, I want to use Take Best buttons so that I can quickly submit an order at the current best available Buy or Sell price.

## Acceptance criteria

- [ ] **AC1:** the Ladder widget must display a "Take Best" section with one Buy button and one Sell button.
- [ ] **AC2:** the Buy button must display the current best available **Sell** quantity and price.
- [ ] **AC3:** the Sell button must display the current best available **Buy** quantity and price.
- [ ] **AC4:** the displayed quantity and price must update whenever the best available market price changes.
- [ ] **AC5:** clicking the Buy button must submit a Buy order using the displayed quantity and price.
- [ ] **AC6:** clicking the Sell button must submit a Sell order using the displayed quantity and price.
- [ ] **AC7:** the Take Best Buy/Sell buttons must support user customization through existing application color settings (Ask color → Sell button, Bid color → Buy button, consistent with the ladder's price colors).
- [ ] **AC8:** the Take Best Buy/Sell buttons must be disabled and greyed out when no best executable price or quantity is available for that side of the market.
- [ ] **AC9:** the buttons must remain fully functional when VWAP mode is enabled (they look identical in VWAP mode).
- [ ] **AC10:** the Take Best section must have its own accordion (`+`/`-` icons), hidden by default, shown only when expanded.
- [ ] **AC11:** the Take Best Buy/Sell buttons must submit orders using the existing default Order Type and Time in Force values (`LMT` and `FAK`).
- [ ] **AC12:** update the collapse/expand controls per the mockups (`+`/`-`).

## Implemented behavior

- A "Take Best" section sits below the ladder grid, collapsed by default behind its own `+`/`-` accordion (separate from the main widget accordion in [[DWU-283]]).
- When expanded, it shows two buttons: a Buy button labeled with the current best **Sell** side's quantity and price (e.g. `Buy 16 @ 97-09 1/2`), and a Sell button labeled with the current best **Buy** side's quantity and price (e.g. `Sell 16 @ 97-05 3/4`) — i.e. each button reflects the opposite side of the book it would execute against.
- The Buy button uses the "Bid" color, and the Sell button uses the "Ask" color, both driven by the same customizable color settings used elsewhere in the ladder (`Settings → ... → Buy/Sell Colours`).
- Both buttons update immediately as market conditions/prices change.
- Clicking either button submits an order immediately at the exact displayed price and quantity, using the default `LMT` order type and `FAK` (Fill and Kill) time in force — confirmed via the backend request payload (`orderType: "Limit"`, `timeInForce: "FillAndKill"`).
- Buttons remain fully functional and visually unchanged when VWAP mode is toggled on.
- **Not confirmed in available evidence:** whether the buttons actually disable/grey out when no best executable price/quantity exists on a side (AC8) — see banner above.

## QA evidence

**QA Execution: PASSED** — Environment: DEV2. Tested by Daniel Aguilar.

Execution Summary: the Fast Execution (Take Best) functionality has been successfully validated. The UI correctly hides the section by default under an accordion, accurately crosses the spread (mapping best Sell data to the Buy button and vice versa), and submits orders using the strict `LMT` and `FAK` default parameters. Real-time updates and edge cases (VWAP mode, empty market states) function as defined in the Acceptance Criteria.

1. **UI Layout and Accordion default state (AC1, AC10, AC12) — PASSED:** verified the Take Best section uses its own accordion with `+`/`-` icons and remains hidden by default; expanding it displays the dedicated Buy and Sell execution buttons per the mockups.
2. **Real-time Data Mapping and Coloring (AC2, AC3, AC4, AC7) — PASSED:** verified the Buy button correctly displays the best available Sell quantity/price and inherits the "Bid" color, while the Sell button displays the best Buy quantity/price and inherits the "Ask" color. Confirmed buttons update immediately in real time as market conditions change.
3. *(Scenario 3 not captured in available evidence — likely AC8, see banner above.)*
4. **Order Submission and Parameters (AC5, AC6, AC11) — PASSED:** verified clicking either Take Best button immediately submits an order matching the exact price and quantity displayed. Validated via backend payload that the system strictly applies the default `LMT` Order Type and `FAK` Time in Force for these executions.
5. **VWAP Mode Compatibility (AC9) — PASSED:** verified toggling VWAP mode on does not disrupt the Take Best section — buttons remain visually identical and fully functional for submitting orders while VWAP is active.

Sign-off: "Approved to close. All Acceptance Criteria have been successfully met." Tagged: Artur Moreira Dobler, Hermela Mekonnen.

Original ticket screenshots available in `evidence/`:
- `01-ticket-user-story-acceptance-criteria.png` — full ticket: user story, background, 12-item acceptance criteria table.
- `02-mockup-take-best-expanded.png` — mockup: Take Best section expanded with Buy/Sell buttons.
- `03-mockup-take-best-collapsed.png` — mockup: Take Best and Type/TIF/Book sections collapsed.
- `04-qa-execution-passed-scenario1-accordion-default-state.png` — QA scenario 1: accordion default collapsed state, expansion reveals buttons.
- `05-qa-scenario2-realtime-data-mapping-coloring.png` — QA scenario 2: real-time price/quantity mapping and Bid/Ask coloring, including the Buy/Sell Colours settings screen.
- `06-qa-scenario4-order-submission-parameters-payload.png` — QA scenario 4: order submission with backend payload showing `LMT`/`FAK` parameters.
- `07-qa-scenario5-vwap-mode-compatibility-signoff.png` — QA scenario 5: VWAP mode compatibility, sign-off.

## Notes for automation

- Requires a Ladder widget with an instrument that has active bid/ask liquidity, ideally with the ability to simulate a one-sided (empty) market to test AC8.
- Candidate validations for a test:
  - Take Best section is collapsed by default; expanding shows Buy (best Sell price/qty) and Sell (best Buy price/qty) buttons.
  - Buttons update live as the best price/quantity on either side changes.
  - Clicking Buy/Sell submits an order at the exact displayed price/quantity, with Order Type `LMT` and TIF `FAK`.
  - Buttons use the Bid/Ask color scheme, consistent with `Settings → Order Management → Buy/Sell Colours`.
  - Buttons remain functional and visually unchanged with VWAP mode active.
  - **Before treating AC8 as covered, verify live** whether the buttons actually disable when one side of the market has no executable price/quantity — this was not confirmed in the available QA evidence.
- Distinguish from [[DWU-173]] (aggressive order submission by clicking a specific ladder price level): this story's buttons always execute at the *current best* price without needing to select a level.

## References

- Jira: DWU-414 (https://darwinjira.atlassian.net/browse/DWU-414)
- Epic: DWU-300
- Related stories: [[DWU-173]] (aggressive order submission — related execution mechanism), [[DWU-283]] (widget accordion — this story adds a second, independent accordion for Take Best)
