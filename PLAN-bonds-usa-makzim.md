# Bonds USA Automation Plan - Final Version for Makzim

## 1. Decision Needed Now

Approve or reject this implementation approach:

- Approach: Extend the existing EU framework (single repo, shared core, desk-specific layers)
- Not recommended: Build a separate USA framework from scratch

Reason: the current framework already provides most of the required infrastructure (Playwright setup, fixtures, reporters, utilities, CI patterns), while UI/test logic can diverge safely by desk.

---

## 2. Executive Recommendation

Proceed with a shared-core architecture and USA-specific test/page layers, delivered in a **D2D-first** sequence.

Expected result:
- Faster first business delivery for current USA priorities (D2D operations)
- Lower long-term maintenance
- No forced coupling between EU and USA UI logic

Estimated timeline:
- 3-5 weeks to first reliable USA functional coverage on DEV2

---

## 3. Framework Audit — What Can Be Reused

### Architecture (Desk-Agnostic ✅)

| Layer | Technology | Reusable? |
|-------|-----------|----------|
| Test Runner | Playwright 1.58.2 | ✅ 100% |
| Language | TypeScript 5.3.3 | ✅ 100% |
| Desktop Connection | OpenFin via CDP (localhost:12001) | ✅ Pattern reusable |
| TradeWeb | AutoIt desktop automation | ⚠️ TBD (same flow?) |
| DI Pattern | Fixture-based injection | ✅ 100% |
| Reporting | Xray + JUnit + TeamCity + HTML | ✅ 100% |
| Quality | ESLint 9 + Prettier + Husky | ✅ 100% |
| Execution | Sequential (workers: 1) | ✅ Same constraint |

### What's EU-Hardcoded (6 Coupling Points) 🔴

These are the only things that need to change to support USA:

1. **URLs/Endpoints**: `eu-bonds-qa-core.darwin.aws.scib.pre.corp` in env, `rabbitmq.ts`, `open-search.ts`
2. **OpenFin Launch Path**: `fins://eu-bonds-qa-core.darwin.aws.scib.pre.corp/...`
3. **Window Config**: `window['productRegion'] = 'eu'`, `subDomain: 'EU-Bonds-QA'`
4. **RabbitMQ Venue ID**: `DARWINSCRIPT_YYYYMMDD_SAN3_EUGV_rfqIdNumber` (`EUGV` = EU Gov)
5. **Test Data**: Only EU/UK ISINs (ES, GB, DE bonds), no US Treasuries
6. **Holiday Calendar**: GB calendar only for settlement date calculations

### What's Already Reusable ✅

- CDP connection and browser context management
- Page Object base architecture + lazy-init pattern
- Fixture injection system
- RFQ model types (Outright, Switch, Butterfly)
- Component library (grids, color picker)
- Assertion utilities and auto-retry
- Data generator and factory pattern
- Reporter infrastructure (Xray, JUnit, TeamCity)
- Test tagging strategy (`@critical`, `@rfq-flow`, `test_key`)
- Git workflow and quality gates
- Performance measurement utilities
- Hooks architecture (setup/teardown)

---

## 4. Non-Negotiable Prerequisites (Go/No-Go)

Before implementation starts, these must be confirmed for USA DEV2:

1. OpenFin runtime details (official USA DEV2 manifest endpoint and CDP port)
2. USA D2D venue model and permissions (which venues are enabled, user rights for create/amend/cancel)
3. USA D2D test instruments with stable market depth in DEV2
4. RabbitMQ/AMQUI availability for event publishing (required for RFQ/performance stream)
5. OpenSearch/Sentinel access and URL for performance correlation

If items 1-3 are available, D2D implementation starts immediately.
If items 4-5 are delayed, RFQ/performance scope is deferred without blocking D2D delivery.

---

## 5. Scope and Rollout Order

Target parity with EU, delivered by risk sequence:

1. USA D2D functional (first, aligned with desk priority)
2. USA user-settings functional
3. USA Bonds RFQ functional (when RabbitMQ/event dependencies are ready)
4. USA performance baseline (only when messaging/log dependencies are confirmed)

---

## 6. Minimal Architecture to Implement

Keep one repository, split by desk where divergence is expected.

Core principles:
- Shared infrastructure: fixtures, reporting, common utilities, base models
- Desk-specific UI/tests: `darwin/eu` vs `darwin/usa`, `bonds` vs `bonds-usa`
- Central desk config: one desk-definition entrypoint for URLs, paths, endpoints, calendars

This gives isolation without duplication.

### Proposed Directory Structure

```
src/
├── pages/darwin/
│   ├── shared/          → Shared BasePage and optional contracts
│   ├── eu/              → EU Page Objects (EXISTING, relocated)
│   └── usa/             → USA Page Objects (NEW)
├── tests/functional/
│   ├── bonds/           → EU bonds (EXISTING)
│   ├── bonds-usa/       → USA bonds (NEW)
│   ├── d2d/             → EU D2D (EXISTING)
│   └── d2d-usa/         → USA D2D (NEW, if supported)
├── tests/performance/
│   ├── (EU specs)       → EXISTING
│   └── usa/             → USA baseline (NEW)
├── env/
│   ├── variables.ts     → Preserved
│   └── desk-definitions.ts → NEW: EU/USA URLs, RMQ, OpenSearch, calendar
├── test-data/
│   ├── test-bonds.ts    → EU data (EXISTING)
│   └── test-bonds-usa.ts → US Treasuries, Agency bonds (NEW)
└── utils/               → Shared, desk-agnostic helpers
```

---

## 7. Delivery Plan (High Value Milestones)

### Milestone 1 - Foundation (Week 1-2)

- Add desk-aware configuration resolution
- Parameterize hardcoded EU dependencies (OpenFin/API/OpenSearch, then RabbitMQ)
- Validate USA D2D venues, permissions, and instrument availability in DEV2
- Keep EU suite green

Exit criteria:
- EU regression passes
- USA runtime + D2D prerequisites validated or formally blocked with fallback

### Milestone 2 - USA Base Runtime (Week 2-3)

- Split EU/USA page-object structure
- Implement USA login/launch + order-management base pages
- Enable USA project in Playwright config

Exit criteria:
- USA app launches and D2D pages navigate in DEV2 through automation

### Milestone 3 - First Business Value (Week 3-4, D2D First)

- Add USA test data model (instruments, settlement/calendar assumptions)
- Implement first USA smoke and first USA D2D E2E path (create/amend/cancel)

Exit criteria:
- One stable USA smoke path
- One stable USA D2D E2E path

### Milestone 4 - Expansion and Stabilization (Week 4-5)

- Add RFQ stream + performance baseline (if RabbitMQ/OpenSearch dependencies are ready)
- Add USA reporting separation (Xray plan, CI non-blocking)

Exit criteria:
- USA suite runs independently
- Reporting separated by desk

---

## 8. Key Risks and Mitigations (Only What Matters)

1. USA D2D venue/market-data mismatch vs EU assumptions
- Impact: first-value D2D tests are unstable or non-representative
- Mitigation: validate venue list + instrument set in week 1; start with smallest stable D2D subset

2. DEV2 instability (no QA/UAT)
- Impact: flaky execution and slower confidence
- Mitigation: retries only for USA, stronger timeouts, health checks, non-blocking CI

3. RabbitMQ/AMQUI or event contract mismatch
- Impact: blocks RFQ and performance parity, but not D2D-first delivery
- Mitigation: run RFQ/performance as dependency-gated stream; isolate payload adapters by desk

4. OpenFin connection mismatch (endpoint/CDP)
- Impact: app cannot be controlled by Playwright
- Mitigation: validate runtime details in week 1 before deeper implementation

---

## 9. What We Need from Makzim to Start

Please confirm these points to authorize implementation:

1. Approve architecture: shared core + desk-specific layers
2. Approve rollout order and 3-5 week target
3. Confirm owner path for USA DEV2 dependencies:
   - Official OpenFin endpoint (manifest URL) and CDP owner
   - D2D venue scope + permissions owner
   - USA D2D instrument set owner
   - RabbitMQ/AMQUI endpoint and provisioning owner (RFQ/performance stream)
   - Credentials/secrets storage
   - Event contracts (same as EU or different?)
   - OpenSearch URL and access
4. Confirm CI policy while USA is DEV2-only: non-blocking

If approved, implementation starts immediately with Milestone 1.

---

## 10. Definition of Success

Success is not "immediate full parity with EU".
Success is:
- EU remains stable throughout
- USA becomes runnable independently
- First USA functional value is delivered quickly
- Blockers are surfaced early with a named owner and fallback

---

Author: QA Automation
Date: 2026-06-11
Status: Ready for Makzim review

