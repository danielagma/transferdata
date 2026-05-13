@workspace Excellent audit report. Please proceed immediately with the second pass to apply the planned patch sketch directly to `src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts`.

Apply the strict line-by-line updates for all 4 tests following your exact Action Plan:

1. **Imports**: Replace `generateRmqBreakEvenSwitchData` with `generateRmqSwitchData`. Remove unused `DarwinPageUrls` if applicable.
2. **Settings Lifecycle (All 4 Tests)**: Ensure `darwinLauncher` is destructured in the test callbacks where needed. Replace direct `initPage` calls with:
   ```typescript
   await darwinLauncher.openOrInitUserSettings(darwinSettings)
Switch Tests (Tests 1 & 2): Update the RFQ creation strictly to use the generic helper signature with our verified liquid sizes:

TypeScript
const rfqData = generateRmqSwitchData(1, 1, 'Buy', 'Sell', 2000000, 1000000)
Ensure Test 1 sets the limit to '10'.

Ensure Test 2 sets the limit to '5'.

Butterfly Tests (Tests 3 & 4):

Inject the exact same await darwinLauncher.openOrInitUserSettings(darwinSettings) fix before opening settings.

Update generateRmqButterflyData size arguments strictly to valid liquid nominals: 1000000, 1000000, 1000000 (removing the 5000 placeholders so the Pricer calculates successfully).

Ensure Test 3 sets a high limit (e.g., '10') to verify NO highlight.

Ensure Test 4 sets a low limit strictly to '5' to verify the red highlight.

Please overwrite the file directly with these complete, structurally sound implementations.
