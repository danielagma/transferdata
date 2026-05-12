@workspace Read #AGENTS.md, #DARWIN_AGENT.md, and the definitive Playwright guide. I need to automate Jira tickets DWB-2521 / DWB-4180 for the Darwin Bonds application strictly following the framework's architecture, surgical implementation rules, and delivery checklist.

User Story & Business Context (DWB-2521 / DWB-4180):
"As a Trader, I want to see the Net Delta value in Butterfly and Switch Inquiries to determine how to reply to the inquiry and have the Price/Yield spinner area collapsed by default. This feature involves adding a 'Net Delta' label, computing the value based on the direction logic, highlighting the Net Delta label in red if it exceeds a user-defined limit (e.g. 5k, both positive and negative values)."

Acceptance Criteria to Validate:
- AC1: Verify the presence of the "Net Delta" label and correct delta calculation. The UI must display a clearly labeled "Net Delta" value computed based on the direction of each Leg: -Delta for Buy Leg, +Delta for Sell Leg.
- AC2: Verify user-configurable limit applies in the RFQ Window. Users must be able to configure the limit (e.g. 5.000) under User Settings -> RFQ Layouts tab ("NET DELTA LIMIT" option). If the absolute Net Delta exceeds this limit, it gets highlighted in Red.
- AC3: Verify accordion default state is collapsed. The pricing section accordion must be collapsed by default when the page loads.
- AC4: Verify user-initiated accordion expansion. Users must have the ability to manually expand the accordion to input prices per Leg.

Strict Implementation Rules (from Framework MDs):
1. RMQ Injection Mold: Strictly replicate the granular injection pattern from `src/tests/functional/bonds/rfq-flow/rfq-window/break-even-switches-tests.spec.ts`. Use RMQ helpers like `generateRmqBreakEvenSwitchData` and `raiseSwitchRfqFromRabbitMq`. Find and utilize their 3-leg/Butterfly equivalents in the framework factories/utils. Do NOT use TradeWeb/AutoIt flows.
2. Sizes Placeholders: Pass cleanly marked placeholders (`/* TODO: Insert calculated test sizes here */`) into the payload generator functions for the Buy/Sell legs. I will manually test in Darwin later to inject the exact large sizes needed to ensure the absolute Net Delta exceeds `5.000`.
3. Deterministic Teardown (CRITICAL): Always perform teardown for event-driven flows. Use the captured RMQ `rfqIdNumber` to cleanly reject the RFQ inside a dedicated `test.step` at the end of the flow or via `test.afterEach` to guarantee the shared single-instance environment remains pristine.
4. Coding Style & Naming: 
   - POM classes MUST have empty constructors. Initialize locators strictly inside `initPage()`.
   - Use high-level POM method names strictly prefixed with `set*`, `expand*`, or `verify*`.
   - Specs must be organized using explicit `test.step('intention', async () => { ... })` blocks (one intent per step).
   - Assertions must use `softExpect` wrapping auto-retrying matchers (e.g., `toHaveText`, `toHaveClass`, `toHaveAttribute`).
   - Include metadata traceability (`test_key: 'DWB-2521'`) per repository conventions.

Exact Verified DOM Mapping (Inject these into POM updates):
- User Settings POM Updates:
  - Switch Limit Input: `locator('#bondMultiLegSwitch')`
  - Butterfly Limit Input: `locator('#bondMultiLegButterfly')`
  - Methods to generate: `setSwitchNetDeltaLimit(...)`, `setButterflyNetDeltaLimit(...)`.
- RFQ Window POM Updates:
  - Net Delta Value Container: `locator('#rfqNetDeltaValue')` (Verify text inside matches AC1 math logic).
  - Red Highlight (AC2): Assert `#rfqNetDeltaValue span` using `.toHaveClass(/text-color-error/)`.
  - Pricing Section Accordion Header: `getByRole('button', { name: /pricing section/i })`.
  - Accordion State (AC3/AC4): Assert attribute `aria-expanded` using `.toHaveAttribute('aria-expanded', 'false')` (collapsed) or `'true'` (expanded).
  - Methods to generate: `verifyNetDeltaCalculation(...)`, `verifyNetDeltaHighlight(...)`, `verifyPricingSectionCollapsed(...)`, `expandPricingSection(...)`.

Expected Deliverables:
1. Surgical POM Updates: Provide ONLY the new class properties, `initPage()` additions, and highly readable action/verification methods to be added to the existing User Settings POM and RFQ Window POM files. Output this code first.
2. Granular Test Spec: Generate the complete `.spec.ts` file inside `src/tests/functional/bonds/rfq-flow/rfq-window/` executing the Switch and Butterfly flows deterministically using the POM updates, RMQ injection, and standard framework fixtures.
