@workspace Please review `src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts` and perform an explicit audit on the two Switch E2E tests before making any modifications.

**Audit & Conditional Implementation Plan:**

1. **Audit Test 1 ("Should verify Net Delta label, calculation, and accordion default state on Switch RFQ")**:
   - **Check**: Inspect if the test body currently includes a setup step using the `darwinSettings` fixture to establish a Net Delta limit *before* injecting the RMQ message.
   - **Action if missing**: If this setup logic is NOT implemented, inject `darwinSettings` into the test callback arguments and add the missing `test.step` at the very beginning to set a limit of `'10'` (ensuring our expected Net Delta of 5.1 remains unhighlighted):
     ```typescript
     await test.step('I configure a high Net Delta limit in User Settings', async () => {
         await darwinSettings.openNetDeltaLimitSettings()
         await darwinSettings.netDeltaLimitPage.setSwitchNetDeltaLimit('10')
         await darwinSettings.saveChanges()
     })
     ```
   - **Action for Sizes**: Verify the arguments in `generateRmqBreakEvenSwitchData`. If they are placeholders (e.g., `5000`), update them strictly to `2000000` (Buy leg) and `1000000` (Sell leg).

2. **Audit Test 2 ("Should verify Net Delta red highlight when limit exceeded on Switch RFQ")**:
   - **Check & Update Limit**: Inspect the configured limit inside the existing settings step. If it is set to `'5000'`, update it strictly to `'5'` so a Net Delta of 5.1 successfully breaches the threshold.
   - **Action for Sizes**: Verify and update the arguments in `generateRmqBreakEvenSwitchData` to match the exact same sizes: `2000000` (Buy leg) and `1000000` (Sell leg).

Please execute this audit and apply only the missing code and numeric updates directly to the file.
