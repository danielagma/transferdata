@workspace You are acting as a Senior SDET. We need to perform a definitive structural refactor and debugging session on `src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts` to ensure it successfully passes without execution errors.

### 🧠 1. Deep Context & Business Goal
- **Tickets**: We are automating acceptance criteria for `DWB-2521` (Net Delta label presence, calculation logic, and default collapsed accordion state) and `DWB-4180` (Net Delta turning red/highlighted when exceeding the defined limit in User Settings).
- **Target Features**: The logic applies to both **Switch RFQs** and **Butterfly RFQs** raised directly via RabbitMQ injection.
- **Testing Strategy**: Instead of injecting unrealistic nominal sizes (e.g., billions) to reach an arbitrary default limit of 5000, our strategy is to configure **tight limits** in User Settings (e.g., `10` for non-highlighted, `5` for highlighted) to evaluate the UI's comparison engine using standard manual test sizes.

### 🔍 2. Root Cause of the Current Failure (`TypeError`)
The test execution currently crashes at the very first step with `TypeError: Cannot read properties of undefined (reading 'click')` inside `user-settings-page.ts:145`.
- **Architectural Reason**: In our framework, `DarwinSettingsPage` inherits from a BasePage and **does not** initialize its core UI locators inside the constructor. Properties like `this.buttonRfqLayoutsSection` remain `undefined` until the asynchronous lifecycle method `initPage(...)` is explicitly called.
- **The Bug**: The current test scripts invoke `await darwinSettings.openNetDeltaLimitSettings()` directly without initializing the page object first.

### 🛑 3. The Switch Factory Nuance (3 Instruments)
When injecting `generateRmqBreakEvenSwitchData`, the underlying RMQ factory injects a payload that renders **3 instruments** in the Darwin UI. Because Darwin consolidates the Net Delta across all incoming legs, the calculated Net Delta might differ from a pure 2-leg calculation. You must be aware of this consolidated value when setting thresholds.

### 🛠️ 4. Explicit Refactoring Instructions
Please audit and update `src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts` directly applying these mandatory rules:

1. **Fix Page Object Initialization Globally**:
   In **every** `test.step` where `darwinSettings` is used to set limits (across all 4 tests), inject the mandatory page initialization step immediately before interacting with settings methods:
   ```typescript
   await darwinSettings.initPage('settings') // Use the valid string/enum mapped to User Settings in this repository
   await darwinSettings.openNetDeltaLimitSettings()
Implement Verified Sizes and Tight Limits for Switch Tests:

Test 1 (No Highlight / DWB-2521): Set the limit strictly to '10' using setSwitchNetDeltaLimit('10'). Use sizes 2000000 (Buy) and 1000000 (Sell) inside generateRmqBreakEvenSwitchData.

Test 2 (Highlight / DWB-4180): Set the limit strictly to '5' using setSwitchNetDeltaLimit('5'). Use the exact same sizes (2000000 and 1000000).

Replicate Architectural Readiness for Butterfly Tests:

Ensure darwinSettings is properly injected into the test callback signatures if missing.

For the Butterfly highlight test, apply the exact same initPage(...) fix before calling setButterflyNetDeltaLimit(...).

Replace the /* TODO */ placeholders inside generateRmqButterflyData with stable sizes that reliably trigger or avoid the thresholds.

Preserve Deterministic Teardowns:
Ensure all tests conclude by securely capturing rfqIdNumber and invoking await rejectRmqRfq(request, rfqIdNumber) followed by await darwinRfq.waitForRfqStackToBeEmpty().

Please audit the file and apply the full end-to-end refactor directly to the code editor.
