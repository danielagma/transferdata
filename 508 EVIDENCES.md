**QA Execution: PASSED** ✅

**Environment:** DEV1
**Trigger Source:** Tradeweb (Manual RFQs via UI) & Darwin UI (Static Data)
**ContextId (False Scenario):** `Tradeweb$20260828.SANT.EUGV.7`
**ContextId (True Scenario):** `Tradeweb$TRD_20260828_SANT_EUGV_8`
**ContextId (Allocation Scenario):** `Bloomberg$3564:20260825:4:5`
**Target Event:** `PublishingStpHubEvent`

The dynamic injection of the `CalculateSalesCredit` boolean field for D2C trades (DWU-508) has been fully verified in DEV1. Manual RFQs were executed via Tradeweb while toggling the underlying Counterparty static data in the Darwin UI, leveraging the exact test execution steps provided by Development. The OpenSearch payloads were audited to ensure accurate static data lookups and boolean transformations.

*(Insert Darwin UI and OpenSearch screenshots here)*

**Validation Against Test Scenarios**
* **AC 1, 2, 3 & 4: D2C Trades dynamically map static data**
  * **Result: PASSED.** The lookup using GLCS code and Product Class successfully retrieved the static data. 
    * When the "Darwin Calc'n" flag was set to "no" (disabled), the payload accurately generated `"CalculateSalesCredit":false`.
    * When the "Darwin Calc'n" flag was updated to "yes" (enabled), a subsequent trade payload accurately generated `"CalculateSalesCredit":true`.
* **AC 5: Allocation Events exclusion**
  * **Result: PASSED.** Payload inspection of allocation outputs confirms the `CalculateSalesCredit` field is completely omitted from the `PostTradeEvent.Allocations` payload structure (as explicitly noted by Development).
* **AC 6: D2D Trades default behavior**
  * **Result: PASSED.** Executed D2D trades successfully populated the required field and defaulted to `false`.

**Sign-off:** Approved to close. All Test Scenarios have been successfully met.
@Murat Guney @Fation Gjoni

Event.Type is PublishingStpHubEvent
