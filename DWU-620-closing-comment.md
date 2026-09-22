### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trades under test:** amend of TOMS ticket `21027094`, published under ticket `21027095`, and cancellation of TOMS ticket `21027096`, both booked manually on 22 September

**Execution Summary:**
Both halves of this ticket were booked in TOMS and traced end to end. Amend and cancel events are now processed and published, and STP Hub acknowledged both with Status OK.

---
### 1. Amend events are processed and published - **PASSED ✅**

| Published field | Value out |
|---|---|
| `EventType` | **`Amend`** |
| `PreviousTradeId` | **`21027094`** |
| `TomsTicketId` | `21027095` |
| `TradeNo` | `21027095` |
| `SourceId` | `21027094` |

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:14:44.391` | TOMS XML received |
| `PublishingStpHubEvent` | `13:14:44.514` | `MessageId 6affe3855060401abf34b30ba332ff17` |
| `StpHubAcknowledgementReceived` | `13:14:45.147` | **`Status: OK`** |

---
### 2. Cancel events are processed and published - **PASSED ✅**

| Published field | Value out |
|---|---|
| `EventType` | **`Cancel`** |
| `PreviousTradeId` | **`21027096`** |
| `TomsTicketId` | `21027096` |
| `TradeNo` | `21027096` |
| `SourceId` | `21027096` |

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:18:56.253` | TOMS XML received |
| `PublishingStpHubEvent` | `13:18:56.345` | `MessageId 31b25aba87224f5791f9b6f3f81725e7` |
| `StpHubAcknowledgementReceived` | `13:18:56.818` | **`Status: OK`** |

---
**Sign-off:** Approved to close. Amend and cancel events are both processed and published, and STP Hub acknowledges both.
