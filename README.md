# DARWIN_AGENT.md — Specialized Agent (Darwin / Playwright / CDP)

## Scope
Use this agent for Darwin Bonds automation in:
- `src/pages/darwin/**`
- `src/tests/functional/bonds/**`
- Related fixtures/hooks/utils for Darwin flows.

## Context
Darwin is an OpenFin desktop app automated through CDP and Playwright. UI flows include pricer, RFQ, blotter, static page and user settings.

## Implementation Rules
1. Apply Page Object Pattern strictly.
   - Keep locators and UI operations in `src/pages/darwin/**`.
   - Keep scenario logic in specs.
2. Reuse existing fixtures/page-object injection (`src/fixtures/**`).
3. Selector priority:
   - `getByTestId` > `getByRole` > exact text > scoped CSS fallback.
4. Scope selectors by row/component to avoid ambiguity.
5. Prefer stable, auto-retry assertions (`toHave...`) through project assertion wrappers.
6. Avoid transient assertions on unstable input states after re-render.
7. Add setup cleanup and teardown for deterministic runs.
8. Keep changes surgical; do not modify shared components unless required and justified.

## Anti-Flake Playbook
- Wait for real UI state transitions, not fixed delays.
- Use `scrollIntoViewIfNeeded()` before actions on potentially hidden controls.
- Use forced clicks only as controlled fallback.
- Close blocking overlays/popups when needed.

## Expected Output Style
- New feature helper methods in Darwin POM with clear names (`open...`, `set...`, `check...`, `verify...`).
- Specs organized with `test.step()` and one intent per step.
- Metadata included (`test_key`, optional `bug`).
- Minimal, auditable diff.



# TRADEWEB_AGENT.md — Specialized Agent (TradeWeb / AutoIt / Images)

## Scope
Use this agent for TradeWeb desktop automation in:
- `src/pages/trade-web/autoit/**`
- `src/pages/trade-web/nuts/**`
- `src/pages/trade-web/nuts/resources/**`
- Specs that trigger/validate TradeWeb behaviors.

## Context
TradeWeb is a Windows desktop application automated via AutoIt and image-based interactions. Reliability depends on robust window targeting, control focus, and stable image anchors.

## Implementation Rules
1. Keep desktop action logic in TradeWeb page modules, not in specs.
2. Reuse existing AutoIt abstractions (`tw-base-page.ts`, feature modules).
3. Keep image resources centralized in `nuts/resources` and reference them consistently.
4. Validate window/app readiness before interaction.
5. Use deterministic action sequences (activate window → focus control → input/click → verify state).
6. Add resilience for timing/focus issues with condition-based waits where possible.
7. Keep cross-app boundaries clear:
   - TradeWeb actions in TradeWeb pages.
   - Darwin validations in Darwin pages.
8. Cleanup/rollback state when flow can pollute subsequent runs.

## Reliability Rules (Desktop-specific)
- Avoid brittle coordinates when image/control targeting exists.
- Prefer explicit window activation before every critical action.
- Reuse known-good image assets; avoid duplicates.
- Keep fallback logic bounded and documented in method naming.

## Expected Output Style
- Feature methods with clear intent (`open...`, `send...`, `submit...`, `verify...`).
- No raw AutoIt/image details in test specs.
- Specs remain business-oriented and concise.
- Minimal, reviewable changes aligned to scope.
