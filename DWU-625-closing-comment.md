### **QA Execution: PASSED ✅**
* **Environment:** UAT2

**Execution Summary:**
The renamed BSGB allocation gateway was verified against the real Bloomberg / TransFicc venue, which is the item this ticket listed as still needing human verification. A deal was closed in Bloomberg and allocated into two accounts; Darwin received the allocation event, assembled the `PostTradeEvent.Allocations` payload and published it to STP Hub. This is the first Bloomberg allocation processed by this environment.

---
### 1. Runtime behaviour of the renamed fleet - **PASSED ✅**
Trade `3564:20260917:1:5` was closed in Bloomberg and allocated into two accounts. The allocation reached Darwin, was handled and was published, which exercises the renamed fleet end to end: the gateway is deployed, its UAT2 credentials are populated and it connects to TransFicc. Without all three, no allocation event would have arrived.

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeAllocationReceivedEventHandled` | `2026-09-17T13:34:36.704Z` | ContextId `Bloomberg$3564:20260917:1:5`, `AllocationCount: 2` |
| `PublishingStpHubEvent` | `2026-09-17T13:34:36.093Z` | same ContextId |

Index `fidw-eu-bonds-uat2-trade-2026.09.17`.

---
### 2. Payload received on the STP Hub side - **PASSED ✅**
STP Hub confirmed reception of the same message, `MessageId 61d01d2bd6524d409f2cb126eb699148`. The payload Darwin logged and the payload STP Hub received match field by field, including both allocation breakdowns.

```json
{"PostTradeEvent":{"EventType":"New","MessageId":"61d01d2bd6524d409f2cb126eb699148","Type":"ALLOC","Operation":{"Date":"2026-09-17","Time":"13:34:35.000"},"Allocation":{"Side":"Sell","SourceId":"3564:20260917:1:5","MarketCode":"Bloomberg","Allocations":[{"AllocationId":"0","FundBreakdown":"TEST","Quantity":500000.0,"QuantityType":"NOTIONAL"},{"AllocationId":"1","FundBreakdown":"TEST2","Quantity":500000.0,"QuantityType":"NOTIONAL"}]}}}
```

---
**Not covered in this cycle:**
* Creation of the `TransFicc/BBG/Alloc/BSGB` secrets, which is a DevOps action.
* Dependants of the old `BBG-PostTrade-BSGB` fleet name (dashboards, alerts, runbooks).

---
**Sign-off:** Approved to close. The renamed gateway processes Bloomberg allocations in UAT2.
