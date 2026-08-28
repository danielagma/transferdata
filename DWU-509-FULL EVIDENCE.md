**QA Execution: PASSED** ✅

**Environment:** DEV2-EU
**Trigger Source:** reference-data-service (Startup Routine)
**Operation / Context:** `StartupValidation`
**Target Event:** `TreasuryDirect`

The integration with the U.S. Treasury Fiscal Data API (DWU-509) has been fully verified in DEV2. The `reference-data-service` was restarted, triggering the `TreasuryDirectStartupValidation` routine. The resulting logs were extracted and audited, confirming Darwin successfully connects to the external API and retrieves the Treasury Securities Auctions Data.

*(Insert OpenSearch screenshots here)*

**Validation Against Test Scenarios**
* **AC 1 & 2: Connect and retrieve valid data**
  * **Result: PASSED.** The startup routine successfully called the Treasury Fiscal Data API. The log confirmed a valid response, returning a `RecordCount` of 11093 and successfully parsing a sample JSON of the marketable securities.
* **AC 3 & 4: Gracefully handle responses and log technically**
  * **Result: PASSED.** The API interaction was correctly written to Kibana. The `TreasuryDirect` event was logged under the `StartupValidation` operation, demonstrating proper technical traceability for the success path without halting the service.

**Sign-off:** Approved to close. All Test Scenarios have been successfully met.
@Rodrigo Pereira Da Silva Campos



Event.Type is TreasuryDirect

Operation is StartupValidation

service.name is Darwin-EU-Bonds-DEV2-BondsReferenceDataService
