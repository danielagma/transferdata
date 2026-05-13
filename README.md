@workspace Act as an expert Principal SDET. I am completely handing over the responsibility of fixing `src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts` to you. The test execution is continuously failing with a critical timeout.

### 🚨 The Hard Reality of the Failures
1. **The Settings Modal is NEVER Opening**: The test dies at `user-settings-page.ts:145` with `TimeoutError: locator.click: Timeout 15000ms exceeded` waiting for `getByTestId('rfqLayoutsChildLink')`. The UI trace proves the Settings modal is physically not open. Whatever helper we used fails to trigger the initial navigation/click from the main Darwin dashboard to reveal the User Settings DOM.
2. **The Execution Aborts Early**: Because Step 1 fails, the actual RFQ raising logic is never reached. Any 3-leg 5K RFQs seen on screen are leftover garbage.

### 🔍 Your Autonomous Investigation Task
Do NOT guess the lifecycle methods. Search the workspace to find the absolute truth:
1. **Find a Working Settings Example**: Search existing functional specs (e.g., look inside `src/tests/functional/` for user settings, layouts, or formatting tests) to find a **proven, working E2E test** that successfully opens the User Settings modal from a running Darwin session. Discover exactly what locator, POM method, or header action triggers the initial opening.
2. **Verify Factory Imports**: Ensure `generateRmqSwitchData` (pure 2-leg builder) is correctly imported from `src/factories/rabbitmq.factory.ts`.

### 🛠️ Total Implementation Mandate
Rewrite the entire `net-delta-accordion-tests.spec.ts` file autonomously applying these exact structural rules:

- **Global Setup Fix**: Prepend the proven, working trigger logic discovered in your search to successfully open the Settings modal before invoking `openNetDeltaLimitSettings()` across all 4 tests.
- **Test 1 (Switch No Highlight)**: Set limit to `'10'`. Raise RFQ strictly using `generateRmqSwitchData(1, 1, 'Buy', 'Sell', 2000000, 1000000)`.
- **Test 2 (Switch Highlight)**: Set limit strictly to `'5'`. Raise RFQ using the exact same 2-leg signature (`2000000` vs `1000000`).
- **Test 3 (Butterfly No Highlight)**: Open settings securely. Set Butterfly limit to `'10'`. Raise RFQ using `generateRmqButterflyData` replacing the placeholders strictly with liquid sizes: `1000000`, `1000000`, `1000000`.
- **Test 4 (Butterfly Highlight)**: Open settings securely. Set Butterfly limit strictly to `'5'`. Raise RFQ using the exact same liquid sizes (`1MM` across all 3 legs).
- **Rock-Solid Teardowns**: Ensure every single test cleans up its queue deterministically via `await rejectRmqRfq(request, rfqIdNumber)` and waits for an empty stack.

Analyze the repo context deeply and overwrite the file directly with a 100% working implementation.
