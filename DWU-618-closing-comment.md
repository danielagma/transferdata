### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027096`, booked and then cancelled manually on 22 September

**Execution Summary:**
A bond trade was booked manually in TOMS and cancelled. The TOMS XML and the published payload were compared. EventType is published as Cancel, not Reversal.

---
### 1. EventType on a cancellation - **PASSED ✅**

| TOMS XML field | Value in | Published field | Value out |
|---|---|---|---|
| `LifecycleAction` | `Reversal` | `EventType` | **`Cancel`** |

The reported behaviour does not reproduce. On the New event of the same ticket the source carries `LifecycleAction: New` and EventType is published as `New`.

---
### 2. The cancellation reaches STP Hub and is accepted - **PASSED ✅**

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:18:56.253` | TOMS XML received |
| `PublishingStpHubEvent` | `13:18:56.345` | `MessageId 31b25aba87224f5791f9b6f3f81725e7` |
| `StpHubAcknowledgementReceived` | `13:18:56.818` | **`Status: OK`** |

---
**Sign-off:** Approved to close. EventType is published as Cancel on a cancellation.
