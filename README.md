RFQ Net Delta Audit Report
1) Factory Findings
Break-even helper (not generic switch):
generateRmqBreakEvenSwitchData in src/factories/rabbitmq.factory.ts

True 2-leg generic switch helper (correct one for standard switch RFQ):
generateRmqSwitchData in src/factories/rabbitmq.factory.ts

Butterfly helper (3-leg):
generateRmqButterflyData in src/factories/rabbitmq.factory.ts

2) Signature + Payload Audit
A) Break-even switch factory
Symbol: generateRmqBreakEvenSwitchData
Signature:
( direction1='Buy', direction2='Sell', qty1=5000, qty2=5000, settlementDate1=1, settlementDate2=1 ): RabbitMqSwitch
Payload fields returned: rfqIdNumber, instrument1, instrument2, settlementDate1, settlementDate2, direction1, direction2, quantity1, quantity2
Important: It hardcodes only 2 instruments:
instrument1 = testBonds.GB27.isin
instrument2 = testBonds.GB_LINKER_28.isin
Type confirms 2-leg structure via RabbitMqSwitch in src/models/rabbitmq-model.d.ts.
Conclusion: It does not statically inject 3 legs. If UI shows 3 instruments, that is not caused by this factory’s payload shape.

B) Correct pure 2-leg switch factory
Symbol: generateRmqSwitchData
Signature:
( settlementDate1=1, settlementDate2=1, direction1='Buy', direction2='Sell', qty1=5000, qty2=5000, instrument1=testBonds.GB27.isin, instrument2=testBonds.GB28.isin, currency='GBP' ): RabbitMqSwitch
This is the standard configurable 2-leg switch builder.
C) Butterfly factory
Symbol: generateRmqButterflyData
Signature:
( settlementDate1=1, settlementDate2=1, settlementDate3=1, direction1='Buy', direction2='Sell', direction3='Buy', qty1=5000, qty2=5000, qty3=5000, instrument1=testBonds.GB27.isin, instrument2=testBonds.GB28.isin, instrument3=testBonds.GB29.isin, currency='GBP' ): RabbitMqButterfly
This is the explicit 3-leg constructor.
3) User Settings POM Lifecycle Audit
Class: DarwinSettingsPage in src/pages/darwin/user-settings/user-settings-page.ts
buttonRfqLayoutsSection and netDeltaLimitPage are declared with definite assignment (!) and initialized later.
buttonRfqLayoutsSection is assigned inside DarwinSettingsPage.initPage.
DarwinSettingsPage.openNetDeltaLimitSettings calls .click() on buttonRfqLayoutsSection, then initializes NetDeltaLimitPage.
Lifecycle fact: calling openNetDeltaLimitSettings() before successful initPage(...) leaves buttonRfqLayoutsSection undefined.

4) Root Cause of Cannot read properties of undefined (reading 'click')
In src/tests/functional/bonds/rfq-flow/rfq-window/net-delta-accordion-tests.spec.ts, settings setup currently uses direct init flow:
darwinSettings.initPage(DarwinPageUrls.settings)
then darwinSettings.openNetDeltaLimitSettings()
JUnit shows prior failure in getDarwinPageByUrlPart / settings init path (src/utils/darwin/darwin-pages.ts, src/pages/darwin/user-settings/user-settings-page.ts).
When settings page is not opened/initialized through launcher lifecycle first, buttonRfqLayoutsSection may never be assigned; then .click() at openNetDeltaLimitSettings throws undefined-click TypeError.
5) Action Plan (exact adjustments for net-delta-accordion-tests.spec.ts)
Import fix (switch factory):

Replace generateRmqBreakEvenSwitchData with generateRmqSwitchData from src/factories/rabbitmq.factory.ts.
Settings lifecycle fix (all Net Delta config steps):

Replace await darwinSettings.initPage(DarwinPageUrls.settings) with launcher-driven initialization:
await darwinLauncher.openOrInitUserSettings(darwinSettings)
Keep:
await darwinSettings.openNetDeltaLimitSettings()
await darwinSettings.netDeltaLimitPage.setSwitchNetDeltaLimit(...) / setButterflyNetDeltaLimit(...)
await darwinSettings.saveChanges()
Remove now-unused import:

Remove DarwinPageUrls import if no longer used.
Switch RFQ creation fix in both Switch tests:

Replace:
generateRmqBreakEvenSwitchData('Buy','Sell',2000000,1000000)
With:
generateRmqSwitchData(1, 1, 'Buy', 'Sell', 2000000, 1000000)
Planned patch sketch:

If you want, I can provide a second pass with a strict line-by-line diff map (old line → new line) for each of the 4 tests in that spec.
