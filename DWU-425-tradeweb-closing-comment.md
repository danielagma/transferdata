### **QA Execution: Tradeweb PASSED ✅ · Story stays open**
* **Environment:** UAT2
* **Scope:** Tradeweb allocations. Bloomberg and BondVision are pending.
* **Allocation under test:** leg 20261002.SAN3.EUGV.273 of the Tradeweb switch 20261002.SAN3.EUGV.SWAP.273, 2 October, allocated into two accounts

**Execution Summary:**
Darwin received the allocation event from TransFicc, built the allocation payload, wrote it to log and published it to STP Hub. STP Hub acknowledged it.

---
### Scenario 1. One payload for the allocation event - **PASSED ✅**
StpHubPayloadSent at 14:25:38.541 UTC, PayloadType: StpHubPostTradeAllocationEvent. The call stack starts at TradeAllocationEvent from TransFicc.Gateway.InquiryPostTrade.Service.

### Scenario 2. Payload written to log - **PASSED ✅**
The full payload is in Event.Document, with SourceId: 20261002.SAN3.EUGV.273 and the AllocationId of each entry.

### Scenario 3. Allocation list - **PASSED ✅**

| AllocationId | FundBreakdown | Quantity | QuantityType |
|---|---|---|---|
| 20261002.SAN3.EUGV.273.1 | Test 1 | 500000.0 | NOTIONAL |
| 20261002.SAN3.EUGV.273.2 | Test 2 | 500000.0 | NOTIONAL |

Other fields: Type: ALLOC, EventType: New, Side: Buy, MarketCode: TRADEWEB_EUGV, Operation.Date: 2026-10-02, Operation.Time: 14:25:38.428.

Evidence for scenarios 1 to 3: 1-payload-allocation-StpHubPayloadSent.png

### Scenario 4. End to end, published to STP Hub - **PASSED ✅**
StpHubPayloadAcknowledgedPublished at 14:25:38.692 UTC, same MessageId: 20261002.SAN3.EUGV.273:TradewebEUGV$20261002.SAN3.EUGV.273:New:a2e344e3f54550a3.

Evidence: 2-ack-allocation-StpHubPayloadAcknowledgedPublished.png

---
**Sign-off:** Tradeweb allocations pass in UAT2. The story is not closed: Bloomberg is pending the DWU-629 retest (MarketCode must be BLOOMBERG_MAP_POST_TRADE), and BondVision is pending.
