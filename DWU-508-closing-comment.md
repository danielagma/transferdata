### **QA Execution: PASSED ✅ with AC 6 BLOCKED**
* **Environment:** UAT2
* **Counterparty under test:** TELE, product class GILTS
* **Target Events:** PublishingStpHubEvent, plus the ALLOC message received in STP Hub

**Execution Summary:**
The CalculateSalesCredit field has been verified on the D2C venue leg. Two Tradeweb RFQs were executed on the same instrument two minutes apart while toggling the Darwin Calc'n flag on the Counterparty Relationship screen, and the published payloads were audited in OpenSearch. The field is present, it is Boolean, it resolves from the counterparty relationship static data, and it follows the flag in both directions with no service restart. The allocation event was checked separately and does not carry the field. AC 6 cannot be exercised because the D2D leg does not publish to STP Hub yet.

---
### 1. Field Added to the D2C Trade Payload (AC 1) - **PASSED ✅**
Verified that PostTradeEvent.Trade.Counterparty.CalculateSalesCredit is present in the published payload for D2C trades and that it carries a Boolean value.

---
### 2. Value Sourced from the Darwin Calc'n Flag (AC 2, AC 3, AC 4) - **PASSED ✅**
Verified with a controlled pair on the same instrument, ISIN GB00BNNGP668, counterparty Glcs TELE, Instrument.Class GILTS, Sales Book AMICHEL, Side Buy, quantity 1,000,000.

| ContextId | Time (UTC) | Darwin Calc'n | CalculateSalesCredit |
|---|---|---|---|
| Tradeweb$TRD_20260915_SAN3_EUGV_38 | 15:19:03 | ON | true |
| Tradeweb$TRD_20260915_SAN3_EUGV_39 | 15:21:11 | OFF | false |

Nothing else differed between the two payloads. Confirmed that the value resolves against the TELE plus GILTS row of the Counterparty Relationship screen, that "yes" maps to true and "no" maps to false, and that the change took effect on the next RFQ with no service restart. A second pair executed on 14 September ran the toggle in the opposite direction, which rules out a residual environment state.

---
### 3. Allocation Payloads (AC 5) - **PASSED ✅**
Verified against the allocation event for the Bloomberg deal 3564:20260917:1:5, closed on 17 September and allocated into two accounts. The message as received in STP Hub does not carry CalculateSalesCredit at any level.

```json
{"PostTradeEvent":{"EventType":"New","MessageId":"61d01d2bd6524d409f2cb126eb699148","Type":"ALLOC","Operation":{"Date":"2026-09-17","Time":"13:34:35.000"},"Allocation":{"Side":"Sell","SourceId":"3564:20260917:1:5","MarketCode":"Bloomberg","Allocations":[{"AllocationId":"0","FundBreakdown":"TEST","Quantity":500000.0,"QuantityType":"NOTIONAL"},{"AllocationId":"1","FundBreakdown":"TEST2","Quantity":500000.0,"QuantityType":"NOTIONAL"}]}}}
```

Payload as received in STP Hub, provided by Sergio Gutierrez Gomez on 17 September.

---
### 4. D2D Default Value (AC 6) - **BLOCKED**
CalculateSalesCredit cannot be observed on a D2D payload because the D2D leg does not publish to STP Hub. D2D post trade consumption from ORCA is DWU-562, currently in progress, and the post trade events were groomed on 16 September under DWU-433. This criterion is blocked by that dependency.

---
### 5. JSON Schema and Regression (AC 7, AC 8) - **NOT VERIFIED**
The required marker on the JSON schema is not observable from the published payload. No regression pass has been run against other trade types.

---
**Sign-off:** Not approved to close. AC 1 to AC 5 are met. AC 7 and AC 8 are outstanding, and AC 6 is blocked until DWU-562 delivers the D2D leg.
@Shaun Murdoch
