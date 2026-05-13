Running 3 tests using 1 worker

##teamcity[testRetrySupport enabled='true']
     1 [setup] › src\hooks\functional\setup.spec.ts:17:1 › Test Setup
##teamcity[testStarted name='setup: src\hooks\functional\setup.spec.ts: Test Setup' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
🚀  Darwin application launched successfully
##teamcity[testStdOut name='setup: src\hooks\functional\setup.spec.ts: Test Setup' out='🚀  Darwin application launched successfully|n' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
⏳  Waiting for Darwin to be ready (timeout: 90000ms)...
##teamcity[testStdOut name='setup: src\hooks\functional\setup.spec.ts: Test Setup' out='⏳  Waiting for Darwin to be ready (timeout: 90000ms)...|n' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
  ✓  1 [setup] › src\hooks\functional\setup.spec.ts:17:1 › Test Setup (56.4s)
##teamcity[testStdOut name='setup: src\hooks\functional\setup.spec.ts: Test Setup' out='🔗  CDP connected successfully|n' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
🚀  TradeWeb application launched successfully
##teamcity[testStdOut name='setup: src\hooks\functional\setup.spec.ts: Test Setup' out='🚀  TradeWeb application launched successfully|n' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
##teamcity[testFinished name='setup: src\hooks\functional\setup.spec.ts: Test Setup' duration='56446' flowId='8af87926-cbd2-48ec-8179-03f7bdc5824d']
     2 …q-flow\rfq-window\net-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow
##teamcity[testStarted name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
🔗  CDP connected successfully
  ✘  2 …rfq-window\net-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow (1.2m)lation, and accordion default state on Switch RFQ @critical @rfq-flow' out='🔗  CDP connected successfully|n' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testFailed name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' message='TimeoutError: locator.click: Timeout 15000ms exceeded.|nCall log:|n  - waiting for getByTestId(|'rfqLayoutsChildLink|').first()|n' details='TimeoutError: locator.click: Timeout 15000ms exceeded.|nCall log:|n  - waiting for getByTestId(|'rfqLayoutsChildLink|').first()|n|n    at DarwinSettingsPage.openNetDeltaLimitSettings (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\pages\darwin\user-settings\user-settings-page.ts:145:44)|n    at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:18:30|n    at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:16:5' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testMetadata type='artifact' testName='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' name='trace' value='test-results/bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests/trace.zip' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testFinished name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' duration='72640' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
     3 …window\net-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow (retry #1)
##teamcity[testStarted name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
🔗  CDP connected successfully
  ✘  3 …et-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow (retry #1) (19.9s)lation, and accordion default state on Switch RFQ @critical @rfq-flow' out='🔗  CDP connected successfully|n' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testFailed name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' message='TimeoutError: locator.click: Timeout 15000ms exceeded.|nCall log:|n  - waiting for getByTestId(|'rfqLayoutsChildLink|').first()|n' details='TimeoutError: locator.click: Timeout 15000ms exceeded.|nCall log:|n  - waiting for getByTestId(|'rfqLayoutsChildLink|').first()|n|n    at DarwinSettingsPage.openNetDeltaLimitSettings (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\pages\darwin\user-settings\user-settings-page.ts:145:44)|n    at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:18:30|n    at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:16:5' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testMetadata type='artifact' testName='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' name='trace' value='test-results/bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests-retry1/trace.zip' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
##teamcity[testFinished name='darwin-functional-tests: src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts: Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow' duration='19855' flowId='bae3ac00-01c9-420a-9ea2-1fe81ba1c3ab']
     4 [teardown] › src\hooks\functional\teardown.spec.ts:8:1 › Test Teardown
##teamcity[testStarted name='teardown: src\hooks\functional\teardown.spec.ts: Test Teardown' flowId='d5e17590-5f33-4a6d-8223-292c58b4f37a']
🔄  Closing TradeWeb main window...
##teamcity[testStdOut name='teardown: src\hooks\functional\teardown.spec.ts: Test Teardown' out='🔄  Closing TradeWeb main window...|n' flowId='d5e17590-5f33-4a6d-8223-292c58b4f37a']
🔴  TradeWeb main window closed successfully
##teamcity[testStdOut name='teardown: src\hooks\functional\teardown.spec.ts: Test Teardown' out='🔴  TradeWeb main window closed successfully|n' flowId='d5e17590-5f33-4a6d-8223-292c58b4f37a']
🔗  CDP connected successfully
  ✓  4 [teardown] › src\hooks\functional\teardown.spec.ts:8:1 › Test Teardown (22.1s)                                                                                      f37a']
🔴  Darwin application closed successfully
##teamcity[testStdOut name='teardown: src\hooks\functional\teardown.spec.ts: Test Teardown' out='🔴  Darwin application closed successfully|n' flowId='d5e17590-5f33-4a6d-8223-292c58b4f37a']
##teamcity[testFinished name='teardown: src\hooks\functional\teardown.spec.ts: Test Teardown' duration='22129' flowId='d5e17590-5f33-4a6d-8223-292c58b4f37a']
📤  [Xray] Sending test report...
(node:1184) Warning: Setting the NODE_TLS_REJECT_UNAUTHORIZED environment variable to '0' makes TLS connections and HTTPS requests insecure by disabling certificate verification.
(Use `node --trace-warnings ...` to show where the warning was created)
❌  [Xray] Failed to send report: Error: Xray API responded with 400: {"error":"Test with key DWB-2521 doesn't exist."}
    at XrayReporter.uploadReport (file:///C:/Users/x531532/OneDrive%20-%20Santander%20Office%20365/Documentos/darwin_automation_framework/darwin-acceptance-tests-bonds-build-verification/src/reporters/xray-reporter.ts:89:19)
    at processTicksAndRejections (node:internal/process/task_queues:105:5)
    at XrayReporter.onEnd (file:///C:/Users/x531532/OneDrive%20-%20Santander%20Office%20365/Documentos/darwin_automation_framework/darwin-acceptance-tests-bonds-build-verification/src/reporters/xray-reporter.ts:43:13)
    at ReporterV2Wrapper.onEnd (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\reporters\reporterV2.js:77:12)
    at wrapAsync (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\reporters\multiplexer.js:89:12)
    at Multiplexer.onEnd (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\reporters\multiplexer.js:57:25)
    at InternalReporter.onEnd (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\reporters\internalReporter.js:77:12)
    at finishTaskRun (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\runner\tasks.js:94:26)
    at runTasks (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\runner\tasks.js:81:10)
    at runAllTestsWithConfig (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\runner\testRunner.js:379:18)
    at runTests (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\program.js:242:18)
    at r.<anonymous> (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\node_modules\playwright\lib\program.js:70:7)


  1) [darwin-functional-tests] › src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow › I configure a high Net Delta limit in User Settings

    TimeoutError: locator.click: Timeout 15000ms exceeded.
    Call log:
      - waiting for getByTestId('rfqLayoutsChildLink').first()


       at src\pages\darwin\user-settings\user-settings-page.ts:145

      143 |
      144 |     async openNetDeltaLimitSettings(): Promise<void> {
    > 145 |         await this.buttonRfqLayoutsSection.click()
          |                                            ^
      146 |         this.netDeltaLimitPage = new NetDeltaLimitPage(this.page)
      147 |         this.netDeltaLimitPage.initPage()
      148 |     }
        at DarwinSettingsPage.openNetDeltaLimitSettings (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\pages\darwin\user-settings\user-settings-page.ts:145:44)
        at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:18:30
        at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:16:5

    attachment #1: trace (application/zip) ─────────────────────────────────────────────────────────
    test-results\bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests\trace.zip
    Usage:

        npx playwright show-trace test-results\bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests\trace.zip

    ────────────────────────────────────────────────────────────────────────────────────────────────

    Retry #1 ───────────────────────────────────────────────────────────────────────────────────────

    TimeoutError: locator.click: Timeout 15000ms exceeded.
    Call log:
      - waiting for getByTestId('rfqLayoutsChildLink').first()


       at src\pages\darwin\user-settings\user-settings-page.ts:145

      143 |
      144 |     async openNetDeltaLimitSettings(): Promise<void> {
    > 145 |         await this.buttonRfqLayoutsSection.click()
          |                                            ^
      146 |         this.netDeltaLimitPage = new NetDeltaLimitPage(this.page)
      147 |         this.netDeltaLimitPage.initPage()
      148 |     }
        at DarwinSettingsPage.openNetDeltaLimitSettings (C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\pages\darwin\user-settings\user-settings-page.ts:145:44)
        at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:18:30
        at C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification\src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:16:5

    attachment #1: trace (application/zip) ─────────────────────────────────────────────────────────
    test-results\bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests-retry1\trace.zip
    Usage:

        npx playwright show-trace test-results\bonds-rfq-flow-rfq-window--226dd-witch-RFQ-critical-rfq-flow-darwin-functional-tests-retry1\trace.zip

    ────────────────────────────────────────────────────────────────────────────────────────────────

  1 failed
    [darwin-functional-tests] › src\tests\functional\bonds\rfq-flow\rfq-window\net-delta-accordion-tests.spec.ts:7:1 › Should verify Net Delta label, calculation, and accordion default state on Switch RFQ @critical @rfq-flow
  2 passed (3.6m)
Finished the run: failed

To open last HTML report run:

  npx playwright show-report

PS C:\Users\x531532\OneDrive - Santander Office 365\Documentos\darwin_automation_framework\darwin-acceptance-tests-bonds-build-verification> npx playwright show-report

  Serving HTML report at http://localhost:9323. Press Ctrl+C to quit.
