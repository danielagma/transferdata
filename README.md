# AGENTS.md — Master Agent Context (Darwin Automation Framework)

## Mission
Build and maintain E2E tests for Darwin Bonds + TradeWeb with minimal risk, high stability, and clean reviewable diffs.

## Core Tech Stack
- Language: TypeScript 5.3.3
- Runtime: Node.js (project baseline: 16.19.1)
- Test framework: Playwright / `@playwright/test` 1.58.2
- Desktop automation: AutoIt via `node-autoit-koffi`
- Reporting: Playwright HTML + JUnit + Xray reporter
- Quality: ESLint + Prettier + Husky hooks

## Runtime Model (Critical)
- Dual app orchestration:
  - Darwin Bonds desktop app (OpenFin) via CDP/Playwright.
  - TradeWeb desktop app via AutoIt + image resources.
- Tests run sequentially (`workers: 1`) because apps are shared single-instance on local machine.

## Strict Coding Rules (Repository Policy)
1. Follow Page Object Pattern.
   - Empty constructor + `initPage()` for locator initialization.
2. Use framework fixtures; do not recreate setup manually.
3. Keep concerns separated:
   - Page Objects = UI interactions/helpers.
   - Specs = scenario flow + assertions.
4. Use `softExpect` from project assertions helper (no bare `expect` in specs unless explicitly required by existing pattern).
5. Reuse existing helpers before creating new ones.
6. No duplicated selector logic in tests.
7. No arbitrary sleeps (`waitForTimeout`) unless justified as last resort.
8. No dead code, no temporary comments, no unrelated refactors.
9. Keep diffs small, scoped, and reversible.
10. Before finishing: lint + format + targeted test execution.

## Stability/Anti-Flake Rules
- Prefer state-based waits (`toHave...`, visibility, attach/detach) over time-based waits.
- Scope selectors to stable containers/rows.
- Verify preconditions before interaction.
- Clean pre-existing data/state before creating new records.
- Always perform teardown for event-driven flows.

## File & Folder Placement Map
- `src/tests/functional/**` → functional test specs.
- `src/tests/performance/**` → performance specs.
- `src/pages/darwin/**` → Darwin web/OpenFin Page Objects.
- `src/pages/trade-web/autoit/**` → TradeWeb AutoIt flows.
- `src/pages/trade-web/nuts/**` + `resources/**` → image-based desktop automation.
- `src/fixtures/**` → fixtures and dependency injection.
- `src/hooks/**` → setup/teardown orchestration.
- `src/components/**` → reusable UI components.
- `src/utils/**` → cross-cutting utilities (assertions, data, messaging, state).
- `src/test-data/**` → static data/payloads/screenshots.
- `src/env/**` → environment variables and config contracts.
- `src/reporters/**` → custom reporting integrations.

## Delivery Checklist
- Test is deterministic and passes repeatedly.
- Correct placement of new files in framework structure.
- Reusable logic moved to Page Object/fixtures/utils.
- Lint/format clean.
- No unrelated changes.
- Commit/PR message references ticket and execution evidence.

## Sub-Agent Routing
- If task targets Darwin web/OpenFin UI flows, use `DARWIN_AGENT.md`.
- If task targets TradeWeb desktop automation/AutoIt/images, use `TRADEWEB_AGENT.md`.
- If task spans both apps, split work by domain and integrate only at spec/fixture level.
