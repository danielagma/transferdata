@workspace Act as a Senior SDET Code Auditor. I need you to perform a deep semantic search and structural analysis across the entire repository to investigate our RabbitMQ factories, Page Object Models, and the E2E spec implementations for the RFQ Net Delta flows. 

Do NOT modify any files yet. Perform the deep search and give me a comprehensive, structured REPORT answering the exact points below.

### 🔍 Phase 1: Search & Audit RabbitMQ Factories (`src/factories/` or related)
1. **Analyze `generateRmqBreakEvenSwitchData`**: Find its exact declaration and implementation. Analyze the returned payload structure. Does it statically inject **3 legs/instruments** by default? (Explain why raising an RFQ with this factory renders 3 instruments in the UI despite passing only 4 arguments).
2. **Identify the True 2-Leg Switch Factory**: Search the workspace for the standard factory method designed to raise a pure **2-leg Switch RFQ** (e.g., look for functions named `generateRmqSwitchData`, `generateRmqSwitchRfqData`, or similar standard Switch helpers). Provide its exact file path, function name, and required parameter signature.
3. **Analyze `generateRmqButterflyData`**: Find its implementation, file path, and exact parameter signature to confirm how it constructs a 3-leg Butterfly RFQ.

### 🔍 Phase 2: Search & Audit User Settings POM (`src/pages/`)
1. **Locate `DarwinSettingsPage`** (specifically `user-settings-page.ts` around line 145).
2. **Analyze Locator Lifecycle**: Examine how properties like `this.buttonRfqLayoutsSection` or `this.netDeltaLimitPage` are instantiated. Confirm if they are undefined in the constructor and require an explicit lifecycle method call (like `initPage(...)`) before actions like `.click()` can be performed. 

### 📋 Phase 3: Deliver the Audit Report
Output your findings in a clear markdown report containing:
- **Factory Findings**: The exact name and import path of the correct 2-leg Switch factory vs. the BreakEven factory.
- **Signatures**: The exact arguments we need to pass to the correct Switch factory and the Butterfly factory.
- **Root Cause of TypeError**: The precise technical explanation of why `user-settings-page.ts:145` threw `Cannot read properties of undefined (reading 'click')`.
- **Action Plan**: The exact line-by-line code adjustments we will need to make to `net-delta-accordion-tests.spec.ts` to fix the POM initialization and inject the correct factories.
