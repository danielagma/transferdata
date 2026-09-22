### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027096`, booked and then cancelled manually on 22 September

**Execution Summary:**
A bond trade was booked manually in TOMS and cancelled. The published payload was read to confirm that PreviousTradeId is populated on the cancellation.

---
### 1. PreviousTradeId on a cancellation - **PASSED ✅**

| Published field | Value out |
|---|---|
| `PreviousTradeId` | **`"21027096"`** |
| `EventType` | `Cancel` |

The reported behaviour does not reproduce. On the New event of the same ticket `PreviousTradeId` is null, which is the correct value there, so the field discriminates between the two lifecycle actions.

---
### 2. The cancellation reaches STP Hub and is accepted - **PASSED ✅**

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:18:56.253` | TOMS XML received |
| `PublishingStpHubEvent` | `13:18:56.345` | `MessageId 31b25aba87224f5791f9b6f3f81725e7` |
| `StpHubAcknowledgementReceived` | `13:18:56.818` | **`Status: OK`** |

---
**Sign-off:** Approved to close. PreviousTradeId is populated on a cancellation.
