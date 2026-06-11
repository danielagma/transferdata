# Bonds USA Automation — Discovery Questions (Responsibility & Dependencies)

> Personal file. Not committed (covered by `/LOCAL_*.md` in .gitignore).
> **SCOPE:** Who is responsible for providing what? Who does what?
> **FOCUS:** Not "does this exist" but "who provides it, who configures it, and who ensures it works"
> **Goal:** Map all dependencies to owners so we know who to ask, when, and what they need to do.

---

## Known Facts So Far

✅ **USA Entry Point (CONFIRMED):**
- OpenFin manifest URL: `fins://eu-bonds-dev2-core.darwin.aws.scib.dev.corp/ui/assets/app.json`
- Note: Has "eu" in hostname but is USA DEV2 (infrastructure shared between desks)
- Question: What does this URL mean for our framework? Is it the "manifest URL" or something else?

✅ **OpenSearch (CONFIRMED):**
- OpenSearch is enabled for USA
- USA events ARE being logged there
- Question: Who configures our framework to connect to USA OpenSearch? What are the connection details?

❌ **Does NOT exist (CONFIRMED):**
- No USA automation user
- No USA credentials
- No USA user permissions set up
- No RabbitMQ for USA

---

## Block 1 — App Access & Infrastructure Responsibility 🔴

**Goal:** Understand the USA entry point and who's responsible for each infrastructure piece.

| # | Question | Who should answer | What does "answer" mean |
|---|----------|-------------------|------------------------|
| 1.1 | **What exactly is `fins://eu-bonds-dev2-core.darwin.aws.scib.dev.corp/ui/assets/app.json`?** Is it the OpenFin manifest URL, the API base URL, or something else entirely? | Makzim + USA Platform Team | Clarify the technical role of this URL in our framework. Can we use it directly in tests or do we need separate URLs for manifest vs API calls? |
| 1.2 | **Is the CDP endpoint for connecting to the OpenFin runtime on localhost:12001 (like EU) or different?** | USA Platform Team / DevOps | Confirm if Playwright can use the same CDP connection code for USA or if it needs to be desk-parameterized. |
| 1.3 | **The hostname `eu-bonds-dev2-core.darwin.aws.scib.dev.corp` is shared between EU and USA?** Or are there separate USA hostnames for different services? | Makzim + Platform | Understand if we need one hostname or multiple (one for app, one for API, one for events, etc.). |

---

## Block 2 — Automation User & Credentials (WHO PROVIDES THEM?) 🔴

**Goal:** Map out who creates the automation user, who provides credentials, who assigns permissions.

| # | Question | Who should answer | Expected outcome |
|---|----------|-------------------|-------------------|
| 2.1 | **Is there an existing USA automation user created by DevOps/Platform?** If not yet, **WHO creates it and WHEN?** | DevOps Lead or Platform Team | Get a committed owner and timeline. If it doesn't exist, you need to request it formally. Example: "Makzim, please ask DevOps to create user `darwin_automation_usa` with specific permissions by [date]" |
| 2.2 | **What credentials will the automation user have?** (username, password/token, how will they be delivered?) | DevOps / Credentials Management | Once user is created, who provides the credentials? Where are they stored (vault, email, secure channel)? |
| 2.3 | **What exact permissions does the automation user need on the Darwin app?** (can read? can trade? can modify settings? any desk restrictions?) | USA QA Lead + Business / Permissions Owner | List explicit permissions needed. Example: "read market data, create test orders, amend/cancel orders, view blotter" |
| 2.4 | **Who assigns those permissions?** (Application administrator? Makzim? Security team?) | Permissions Owner | Get a committed owner who will assign perms once user exists. |
| 2.5 | **What is the timeline?** (user created by when? permissions assigned by when? credentials available by when?) | Project Manager / Makzim | Get dates. This unblocks everything else. |

---

## Block 3 — OpenSearch Connection (WHO SETS IT UP?) 🟡

**Goal:** USA OpenSearch IS enabled. Now figure out how to connect to it from the framework.

| # | Question | Who should answer | Expected outcome |
|---|----------|-------------------|-------------------|
| 3.1 | **What is the OpenSearch endpoint URL for USA DEV2?** (e.g., `https://opensearch-usa.something.com:9200` or similar?) | USA Platform Team / Makzim | You need the exact URL to connect. Even if you haven't needed it before, you'll need it for debugging test failures. |
| 3.2 | **Does OpenSearch require authentication?** (username/password? API key? Is it the same user as the app?) | Platform Team / Security | If auth is required, who provides the credentials? Same answer as Block 2 (user creation process). |
| 3.3 | **What index names do we query?** (e.g., `darwin-events-usa-*`, `darwin-logs-*`, or a specific naming pattern?) | Platform Team / Makzim | This is how you'd search for test execution events/logs after tests run. Helps with debugging. |
| 3.4 | **WHO is responsible for setting up the framework to connect to USA OpenSearch?** (Makzim? You? A platform engineer?) | Makzim + You | If it's you, it's a code change. If it's Makzim, it's a request. Be clear on ownership. |

---

## Block 4 — Code Changes Needed (WHAT DO WE MODIFY?) 🟡

**Goal:** Once you have answers from Blocks 1-3, what files need to change?

| # | Question | Why it matters | What to do with answer |
|---|----------|-----------------|--------|
| 4.1 | **Does USA use the same Darwin app UI as EU?** (same page selectors, same buttons, same layouts?) | If same: reuse all page objects in `src/pages/darwin/`. If different: fork to `src/pages/darwin-usa/`. | Determine scope: code reuse vs fork. |
| 4.2 | **Does USA use the same API response schemas as EU?** (same endpoint patterns, same JSON structure?) | If same: reuse `src/utils/api-actions.ts`. If different: fork or parameterize. | Determine scope: fixture reuse vs fork. |
| 4.3 | **Once USA credentials are ready, how do we load them in `.env`?** (separate vars like `USA_DARWIN_USERNAME` or parametrize existing ones?) | Affects environment variable naming and loading logic in `src/env/variables.ts`. | Create naming convention for USA-specific secrets. |
| 4.4 | **Do we need to parametrize `darwin-connection.ts` to support desk-specific CDP endpoints?** (or is localhost:12001 universal?) | If CDP endpoint differs by desk, connection logic needs to accept desk parameter. | If yes: update `connectToCDP()` to use desk-aware port resolution. |
| 4.5 | **Do we need to add USA entries to `desk-definitions.ts`?** (and what should they contain?) | Centralized config for all desk-specific values (URLs, credentials names, calendars, etc.). | Create a USA section in `desk-definitions.ts` with all parametrized values. |

---

## Block 5 — Test Data & Business Rules (WHAT DATA DO WE NEED?) 🟡

**Goal:** What instruments, calendars, and business rules are specific to USA?

| # | Question | Who should answer | Expected outcome |
|---|----------|-------------------|-------------------|
| 5.1 | **What instruments are available in USA DEV2 for testing?** (ISINs, bond names, types - at least 2-3 for smoke tests) | Makzim + USA QA Lead | Create `src/test-data/all-isins-usa.json` or add USA section to existing file. Need actual instrument codes that work in the app. |
| 5.2 | **What is the USA settlement cycle?** (T+1 or T+2?) | USA Business / QA Lead | Affects test assertions about settlement dates. Add to `desk-definitions.ts`. |
| 5.3 | **What holiday calendar applies to USA?** (US federal holidays? Trading holidays? Which calendar library?) | USA Business / QA Lead | Configure in `desk-definitions.ts` for date calculations. Likely uses US federal holidays, different from GB in EU. |
| 5.4 | **Are bond classifications the same in USA as EU?** (gilt, linker, sovereign naming?) | USA QA Lead | If different, bond filtering/selection logic might need to be desk-aware. |
| 5.5 | **What is at least ONE instrument that has stable market data right now in USA DEV2?** (so we can write a smoke test on day 1?) | Makzim | Pick one instrument to start with. Needs to have market depth, prices, etc. for basic smoke test. |

---

## Block 6 — RabbitMQ/Event Infrastructure (WHO PROVIDES IT? WHEN?) 🟠

**Goal:** RabbitMQ does NOT exist for USA today. Map out who provides it and when.

| # | Question | Who should answer | Expected outcome |
|---|----------|-------------------|-------------------|
| 6.1 | **Is RabbitMQ/AMQUI required for USA automation at all?** Or can we do everything with just the app UI (D2D, smoke tests, etc.)? | Makzim + Business | If not required for MVP, you don't wait for it. If required, you escalate for provisioning. |
| 6.2 | **If RabbitMQ is required: WHO will provision it for USA DEV2?** (Platform Team? DevOps? When will it be ready?) | Makzim | Get a committed owner and timeline. Example: "Platform Team will set up RabbitMQ USA by [date]" |
| 6.3 | **Once RabbitMQ exists: WHO will create an automation user for it?** | DevOps / RabbitMQ Admin | Get a committed owner. Same process as Block 2. |
| 6.4 | **What are the RabbitMQ connection details?** (host, port, vhost, exchange names, routing key patterns?) | Platform Team | Once RabbitMQ is set up, these define how you configure `src/services/rabbitmq-actions.ts`. |
| 6.5 | **What is the timeline for RabbitMQ availability?** (do you block on it or work around it?) | Project Manager / Makzim | This is a critical dependency decision. If timeline is vague, escalate. |

---

## 🔴 CRITICAL QUESTIONS (Must Answer to Start Any Development)

**Without answers to these, you cannot even start modifying the code:**

| Category | Questions | Owner | What are we really asking |
|----------|-----------|-------|-------------------------|
| **App Access** | 1.1, 1.2, 1.3 | Makzim + Platform | What exactly is the USA entry point and is it the same as EU? |
| **Automation User** | 2.1, 2.2, 2.3, 2.4, 2.5 | DevOps + Makzim | WHO creates the USA automation user? WHEN? With what permissions? |
| **OpenSearch** | 3.1, 3.2, 3.3, 3.4 | Platform Team + Makzim | USA OpenSearch exists. But how do we connect to it from our framework? |
| **Code Changes** | 4.1, 4.2, 4.3, 4.4, 4.5 | You (based on answers above) | Given all the above, WHAT FILES do I modify and HOW? |
| **Test Data** | 5.1, 5.2, 5.3, 5.4, 5.5 | Makzim + QA | What test instruments and business rules do I need? |
| **RabbitMQ** | 6.1, 6.2, 6.3, 6.4, 6.5 | Makzim + Platform (if needed) | IF we need RabbitMQ: WHO provides it and WHEN? |

---

## 📋 IMPLEMENTATION WORKFLOW

Once you have answers to Blocks 1-5, here's what happens:

### Phase 1: Get Answers (Week 1)
1. Schedule meeting with Makzim + USA Platform + DevOps
2. Go through Blocks 1-5 questions
3. Identify what exists (USA entry point, OpenSearch) and what doesn't (automation user, RabbitMQ)
4. Get committed owners and timelines for everything that doesn't exist yet

### Phase 2: Request Missing Infrastructure (Weeks 1-2)
1. DevOps creates USA automation user (Block 2) → get credentials
2. Assign permissions to that user (Block 2) → validate what operations work
3. If RabbitMQ is needed, Platform provisions it (Block 6) → get connection details
4. Optionally: confirm USA OpenSearch connection details (Block 3)

### Phase 3: Code Setup (Week 2-3, in parallel with Phase 2)
1. Create `src/env/desk-definitions-usa.ts` with all USA-specific configs
2. Update `src/env/variables.ts` to load USA credentials (once Block 2 is done)
3. Update `src/utils/darwin-connection.ts` if CDP endpoint differs (Block 1)
4. Test if EU page objects work on USA (Block 4.1) → reuse or fork
5. Test if EU fixtures work with USA credentials (Block 4.2) → reuse or fork
6. Create `src/test-data/all-isins-usa.json` with instruments (Block 5)

### Phase 4: First Smoke Test (Week 3-4)
1. Write simplest test: connect to USA, login, navigate, take screenshot
2. Validate everything works before writing actual test specs

---

## ❌ WHAT THIS IS NOT

- This is **NOT** about "what workflows will we automate" (D2D, RFQ, etc. — that comes later)
- This is **NOT** about "which venues will we test" (venue selection is a scope decision AFTER setup)
- This is **NOT** about test flows or detailed specs

**This IS about:** Knowing who provides what, when it's available, and what code changes are needed to support USA as a new desk.

---

## ✅ SUCCESS CRITERIA

You're ready to code when you can answer:

- ✅ "Block 1: USA entry point is `fins://eu-bonds-dev2-core.darwin.aws.scib.dev.corp/ui/assets/app.json`. CDP is [same/different]. App UI is [same/different]."
- ✅ "Block 2: DevOps will create automation user by [DATE]. Permissions will be assigned by [DATE]. Credentials will be stored [WHERE]."
- ✅ "Block 3: OpenSearch is available. To connect, we need to [DO THIS]. Owner: [WHO]."
- ✅ "Block 4: To support USA, I need to modify these files: [LIST]. Here's why: [REASONS]."
- ✅ "Block 5: Test instruments are [LIST]. Settlement is [T+1/T+2]. Calendar is [COUNTRY]."
- ✅ "Block 6: RabbitMQ is [needed/not needed]. If needed, Platform will set it up by [DATE] or [NOT NEEDED FOR MVP]."

---

## 🎯 KEY PRINCIPLE

**Every question is about WHO is responsible, WHEN it will be ready, and WHAT you do with the answer.**

Not "does it exist" but "who makes it exist and when".

---



*Last updated: 2026-06-11*
*Version: 3.0 (General desk extension, not D2D-specific)*
*This is the foundation. Future iterations will add D2D/RFQ/other workflows.*
