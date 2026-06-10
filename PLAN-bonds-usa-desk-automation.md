# Plan: Bonds USA Desk Automation — Feasibility Analysis & Strategy

## TL;DR

The existing Darwin Bonds EU framework **can and should** be extended to support Bonds USA using a **"shared core + desk-specific layers"** architecture. Starting a new framework would waste 70%+ of reusable infrastructure. The key insight: **Page Objects will diverge** (different OpenFin apps, different teams), but the underlying infrastructure (CDP connection, fixture system, reporting, utilities, factory patterns) is fully desk-agnostic.

Estimated effort: **Medium complexity** (3-5 weeks for a senior QA to enable USA support with first test suite running against DEV2).

---

## Current Framework Audit Summary

### Architecture (Desk-Agnostic ✅)

| Layer | Technology | Reusable? |
|-------|-----------|-----------|
| Test Runner | Playwright 1.58.2 | ✅ 100% |
| Language | TypeScript 5.3.3 | ✅ 100% |
| Desktop Connection | OpenFin via CDP (localhost:12001) | ✅ Pattern reusable |
| TradeWeb | AutoIt desktop automation | ⚠️ TBD (same flow?) |
| DI Pattern | Fixture-based injection | ✅ 100% |
| Reporting | Xray + JUnit + TeamCity + HTML | ✅ 100% |
| Quality | ESLint 9 + Prettier + Husky | ✅ 100% |
| Execution | Sequential (workers: 1) | ✅ Same constraint |

### What's EU-Hardcoded (6 Coupling Points) 🔴

1. **URLs/Endpoints**: `eu-bonds-qa-core.darwin.aws.scib.pre.corp` in env, rabbitmq.ts, open-search.ts
2. **OpenFin Launch Path**: `fins://eu-bonds-qa-core.darwin.aws.scib.pre.corp/...`
3. **Window Config**: `window['productRegion'] = 'eu'`, `subDomain: 'EU-Bonds-QA'`
4. **RabbitMQ Venue ID**: `DARWINSCRIPT_YYYYMMDD_SAN3_EUGV_rfqIdNumber` (EUGV = EU Gov)
5. **Test Data**: Only EU/UK ISINs (ES, GB, DE bonds) — no US Treasuries
6. **Holiday Calendar**: GB calendar only for settlement date calculations

### What's Already Desk-Agnostic (Reusable ✅)

- CDP connection and browser context management (`darwin-connection.ts`)
- Page Object base architecture + `initPage()` lazy-init pattern
- Fixture injection system (4 fixture files)
- RFQ model types (Outright, Switch, Butterfly) in `models/`
- Component library (grids, color picker)
- Assertion utilities (`softExpect`, auto-retry)
- Data generator and factory pattern (`rabbitmq.factory.ts`)
- Reporter infrastructure (Xray, JUnit, TeamCity)
- Test tagging and metadata strategy (`@critical`, `@rfq-flow`, `test_key`)
- Git workflow and quality gates
- Performance measurement utilities
- Hooks architecture (setup/teardown)

---

## Critical Context (Confirmed)

| Question | Answer | Impact |
|----------|--------|--------|
| Same OpenFin app? | **NO** — Different app, similar UI, different dev teams | Page Objects WILL diverge |
| QA/UAT for USA? | **NO** — Only DEV2 available | Tests will be less stable |
| Apps evolve together? | **NO** — Independent roadmaps | Cannot share Page Objects long-term |

### Remaining Questions to Resolve

- ¿Bonds USA connects to TradeWeb the same way? (Same AutoIt flow?)
- US settlements T+1 vs EU T+2? (Affects settlement date logic)
- Separate RabbitMQ instance for USA?
- What is the DEV2 USA URL/endpoint?
- ¿Usa el mismo CDP port (12001) o uno diferente?

---

## Option A: Extend Framework — Shared Core Architecture (RECOMMENDED ✅)

### Proposed Directory Structure

```
src/
├── pages/
│   └── darwin/
│       ├── shared/              → Base classes, interfaces, common patterns
│       │   ├── base-page.ts     → Shared BasePage (buttons, common actions)
│       │   └── interfaces/      → Page contracts (what methods each page must have)
│       ├── eu/                  → EU-specific Page Objects (EXISTING, relocated)
│       │   ├── rfq-stack-page.ts
│       │   ├── blotter-page.ts
│       │   ├── bond-pricer-page.ts
│       │   ├── login-page.ts
│       │   └── ...
│       └── usa/                 → USA-specific Page Objects (NEW)
│           ├── rfq-stack-page.ts
│           ├── blotter-page.ts
│           ├── login-page.ts
│           └── ...
├── tests/
│   └── functional/
│       ├── bonds/               → EU tests (EXISTING, rename to bonds-eu/ later)
│       ├── bonds-usa/           → USA tests (NEW)
│       └── d2d/                 → D2D tests (existing, evaluate if applicable to USA)
├── env/
│   ├── desks/
│   │   ├── eu.config.ts         → EU URLs, RMQ endpoints, calendars, credentials
│   │   └── usa.config.ts        → USA DEV2 URLs, RMQ endpoints, calendars
│   ├── variables.ts             → Reads DESK env var, delegates to desk config
│   └── .env-template            → Updated with USA section
├── fixtures/
│   ├── page-object.fixture.ts   → Desk-aware: creates EU or USA pages based on DESK
│   ├── page-object-usa.fixture.ts → USA-specific fixture (if pages differ enough)
│   └── ...
├── test-data/
│   ├── test-bonds.ts            → EU bonds (existing)
│   ├── test-bonds-usa.ts        → US Treasuries, Agency bonds (NEW)
│   ├── all-isins.json           → EU ISINs (existing)
│   ├── all-isins-usa.json       → US ISINs (NEW)
│   └── ...
└── utils/                       → Shared, desk-agnostic utilities (unchanged)
    ├── rabbitmq.ts              → Parameterized with desk URLs
    ├── api-actions.ts           → Desk-aware URL resolution
    ├── open-search.ts           → Desk-aware dashboard URLs
    └── darwin/
        └── darwin-connection.ts → Desk-aware OpenFin launch
```

### Advantages

1. **~70% code reuse** — Infrastructure, utilities, reporting, conventions, quality gates
2. **Proven patterns** — Architecture battle-tested with 54+ EU tests
3. **Independent evolution** — Each desk's Page Objects evolve without affecting the other
4. **Single codebase** — Shared improvements benefit both desks automatically
5. **Team knowledge** — Same conventions, documentation, PR process for both teams
6. **Faster delivery** — No bootstrapping; leverage existing patterns immediately
7. **Single CI/CD infra** — One pipeline config, two project triggers

### Disadvantages

1. **Coordination overhead** — Two teams in same repo (mitigated by CODEOWNERS)
2. **Initial refactor needed** — Current pages need relocating to `eu/` subfolder
3. **Shared dependency risk** — Updating a shared utility could theoretically break both
4. **DEV2 instability** — USA tests inherently less reliable (environment maturity)

---

## Implementation Phases

### Phase 1: Architecture Foundation (Week 1-2)

| # | Task | Depends On |
|---|------|-----------|
| 1 | Create `src/env/desks/eu.config.ts` — extract current EU URLs, RMQ endpoints, holiday calendar | — |
| 2 | Create `src/env/desks/usa.config.ts` — USA DEV2 URLs, RMQ endpoints, US calendar | USA DEV2 URL |
| 3 | Add `DESK` env variable to `.env-template` (`EU` \| `USA`) | — |
| 4 | Refactor `src/env/variables.ts` — resolve endpoints via desk config | 1, 2 |
| 5 | Update `src/utils/rabbitmq.ts` — parameterize hardcoded EU publish URLs | 4 |
| 6 | Update `src/utils/open-search.ts` — parameterize dashboard URLs | 4 |
| 7 | Update `src/utils/api-actions.ts` — desk dimension in URL resolution | 4 |
| 8 | Update `darwin-connection.ts` — desk-aware OpenFin launch path | 4 |

**Validation**: Run full EU test suite → zero regressions after parameterization.

### Phase 2: Page Object Separation (Week 2-3)

| # | Task | Depends On |
|---|------|-----------|
| 9 | Create `src/pages/darwin/shared/base-page.ts` (extract truly shared logic) | — |
| 10 | Move existing EU pages to `src/pages/darwin/eu/` + update imports | 9 |
| 11 | Update `tsconfig.json` path aliases for new structure | 10 |
| 12 | Update fixture files for new import paths | 10, 11 |
| 13 | Create `src/pages/darwin/usa/login-page.ts` (first USA page) | 9 |
| 14 | Create `src/pages/darwin/usa/launch-page.ts` (different OpenFin app) | 9 |
| 15 | Create `src/pages/darwin/usa/rfq-stack-page.ts` (start from EU copy, adapt) | 9, USA app access |

**Validation**: EU tests still pass with relocated pages. USA pages compile.

### Phase 3: Test Data & Factories (Week 2-3, parallel with Phase 2)

| # | Task | Depends On |
|---|------|-----------|
| 16 | Create `src/test-data/test-bonds-usa.ts` (US Treasuries, Agency bonds) | USA instrument list |
| 17 | Create `src/test-data/all-isins-usa.json` | USA ISIN data |
| 18 | Extend `rabbitmq.factory.ts` — USD currency, US settlement conventions | 16 |
| 19 | Add US holiday calendar for settlement dates (T+1 if applicable) | — |
| 20 | Create USA-specific RabbitMQ payloads if message format differs | USA RMQ analysis |

**Validation**: Factory generates valid US instrument payloads.

### Phase 4: Playwright Config & First Tests (Week 3-4)

| # | Task | Depends On |
|---|------|-----------|
| 21 | Add `darwin-functional-tests-usa` project in `playwright.config.ts` | Phase 1 |
| 22 | Add USA npm scripts (`test:functional:usa`, `test:usa:smoke`) | 21 |
| 23 | Create USA setup/teardown hooks (`src/hooks/functional/usa/`) | Phase 2 |
| 24 | Write smoke test: login → navigate → verify US instruments load | 13-15, 16 |
| 25 | Write first RFQ test: inject US bond via RMQ → verify in RFQ window | 18, 15 |
| 26 | Tag USA tests with `@usa` for filtering | 24, 25 |

**Validation**: USA smoke passes against DEV2. RFQ flow E2E successful.

### Phase 5: CI/CD & Reporting (Week 4-5)

| # | Task | Depends On |
|---|------|-----------|
| 27 | Create separate Xray test plan for USA desk | Phase 4 |
| 28 | Update reporter to detect desk from project name | 27 |
| 29 | Configure CI: `DESK=USA` pipeline trigger | All phases |
| 30 | Add CODEOWNERS: `/src/pages/darwin/usa/` → USA team | — |
| 31 | Document environment switching in README | All phases |

**Validation**: Xray correctly separates EU vs USA. CI runs independently.

---

## Key Files to Modify

| File | Change | Risk |
|------|--------|------|
| `src/env/variables.ts` | Desk-aware endpoint resolution | Medium — impacts all tests |
| `src/env/.env-template` | Add USA credentials/URLs section | None |
| `src/utils/rabbitmq.ts` | Parameterize hardcoded EU publish URLs | Medium |
| `src/utils/api-actions.ts` | Add desk dimension (lines ~87, ~831) | Medium |
| `src/utils/open-search.ts` | Parameterize dashboard URLs | Low |
| `src/utils/darwin/darwin-connection.ts` | Desk-aware OpenFin launch | Medium |
| `src/test-data/environment-config-no-virtualization.js` | USA productRegion | Low |
| `tsconfig.json` | New path aliases for desk-specific pages | Low |
| `playwright.config.ts` | New USA project definition | Low |
| `package.json` | USA npm scripts | None |

---

## Option B: New Separate Framework ❌

### Advantages

1. **Zero risk to EU** — Completely isolated codebase
2. **Freedom to diverge** — No coordination needed
3. **Independent releases** — No deployment coupling

### Disadvantages

1. **Massive duplication** (~70%): CDP connection, POM base, fixtures, reporting, assertions, factories, hooks
2. **Double maintenance**: Bug fixes need porting (assertion helpers, reporter updates, CDP fixes)
3. **Slower delivery**: 6-8 weeks minimum to reach infrastructure parity
4. **Knowledge fragmentation**: Two documentation sets, two convention sets
5. **Divergence risk**: Repos drift apart, team knowledge becomes siloed
6. **No shared improvements**: New Xray features, new assertion patterns — implemented twice
7. **Hiring/onboarding**: New team members must learn two codebases

---

## Complexity Comparison

| Aspect | Extend (Shared Core) | New Framework |
|--------|---------------------|---------------|
| **Initial effort** | 3-5 weeks | 6-8 weeks |
| **First test running** | ~1.5-2 weeks | ~3-4 weeks |
| **Long-term maintenance** | Lower (shared infra) | Higher (duplicated) |
| **Risk to EU tests** | Low (separate dirs) | Zero |
| **Team scalability** | Better (shared patterns) | Worse (knowledge silos) |
| **Code reuse** | ~70% | 0% |
| **Dependency on EU stability** | Minimal (isolated pages) | None |
| **Reporting unification** | Trivial (same reporters) | Requires integration work |

---

## DEV2 Environment Considerations

Since USA only has DEV2 (no QA/UAT), specific accommodations are needed:

| Concern | Strategy |
|---------|----------|
| **Higher flakiness** | `retries: 2` for USA project specifically |
| **Slower responses** | Increase action/navigation timeouts (+50%) |
| **Environment downtime** | Pre-test health check hook (verify DEV2 responsive) |
| **Limited test scope** | Start smoke/critical path only; don't aim for full regression |
| **Non-blocking CI** | USA failures don't block EU deployments |
| **Debugging difficulty** | Mandatory screenshot-on-failure + trace capture |
| **Data instability** | More aggressive test data cleanup pre/post |
| **No prod-like perf** | Skip performance tests for USA until QA exists |

---

## Coexistence Model: EU (QA) + USA (DEV2)

```
┌──────────────────────────────────────────────────────────┐
│                    SHARED CORE (70%)                       │
│                                                           │
│  CDP Connection │ Fixture System │ Reporting │ Utilities  │
│  Assertions │ Factories │ Components │ Hooks Base         │
│  ESLint + Prettier + Husky │ Git Workflow                 │
└──────────────────────┬───────────────────────────────────┘
                       │
         ┌─────────────┴──────────────┐
         │                            │
┌────────┴─────────┐         ┌───────┴──────────┐
│    BONDS EU      │         │    BONDS USA     │
│                  │         │                  │
│ Pages: darwin/eu/│         │ Pages: darwin/usa│
│ Tests: bonds/    │         │ Tests: bonds-usa/│
│ Env: QA + PROD   │         │ Env: DEV2        │
│ Xray: DWB-6878  │         │ Xray: TBD        │
│ Stable (mature)  │         │ Unstable (new)   │
│ retries: 1       │         │ retries: 2       │
│ EU holidays (GB) │         │ US holidays (NY) │
│ EUR/GBP bonds    │         │ USD bonds        │
│ ~54 tests        │         │ Start: 5-10      │
└──────────────────┘         └──────────────────┘
```

### Execution Commands

```bash
# Run EU tests only (current behavior, unchanged)
DESK=EU npx playwright test --project=darwin-functional-tests

# Run USA tests only
DESK=USA npx playwright test --project=darwin-functional-tests-usa

# Run USA smoke only
DESK=USA npx playwright test --project=darwin-functional-tests-usa --grep @smoke

# Run both desks (CI full regression)
npx playwright test
```

---

## Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| EU tests break during refactor | Medium | High | Phase 2 validation gate: full EU suite must pass |
| USA Page Objects diverge heavily | High | Low | By design — separate directories, independent evolution |
| DEV2 too unstable for automation | Medium | Medium | Start with smoke only; add retry logic; health checks |
| Team coordination conflicts | Low | Medium | CODEOWNERS file; separate test directories; PR reviews |
| Shared utility update breaks desk | Low | High | Each desk has own test project; both run in CI |

---

## Success Criteria

- [ ] EU test suite passes unchanged after infrastructure refactoring
- [ ] USA smoke test (login + navigate) passes against DEV2
- [ ] USA first RFQ test passes end-to-end
- [ ] Both desks can execute independently via `DESK=EU|USA`
- [ ] Xray reports separated by desk
- [ ] CI pipeline configured for both desks (non-blocking)
- [ ] Documentation updated with multi-desk usage

---

## Final Recommendation

**Extend the current framework with "shared core + desk-specific layers" architecture.**

The confirmed fact that USA is a different OpenFin app with different dev teams means Page Objects **will** diverge — but this is handled cleanly by having separate `pages/darwin/eu/` and `pages/darwin/usa/` directories. The 70%+ of infrastructure that IS shared (CDP connection pattern, fixture system, reporting, assertions, factories, hooks, quality gates) makes starting a new framework from scratch a wasteful proposition.

The DEV2-only constraint is manageable with proper timeout/retry configuration and realistic stability expectations. Start with smoke tests, prove the infrastructure works, then expand coverage as the USA environment matures toward QA.

**Risk assessment**: LOW. EU tests remain untouched in their own directory. USA development happens in parallel without cross-contamination. Shared utilities benefit both desks equally. The monorepo approach is industry-standard for multi-product test automation within the same platform family.

---

*Generated: 2025-06-10 | Author: QA Automation Analysis | Status: DRAFT — Pending team review*
