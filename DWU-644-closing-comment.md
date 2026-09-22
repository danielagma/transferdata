### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027098`, booked manually on 22 September with a clearing broker and a transaction cost informed

**Execution Summary:**
A bond trade was booked manually in TOMS with a clearing broker and a transaction cost. The TOMS XML and the published payload were compared. BrokerCommission.Amount carries the informed cost.

---
### 1. BrokerCommission.Amount carries the informed cost - **PASSED ✅**

| TOMS XML | Value in | Published field | Value out |
|---|---|---|---|
| `TransactionCost` `Type 2` `Cost` | `1200.0` | `Broker.BrokerCommission.Amount` | **`1200.0`** |
| `ClearingBroker` | `GATE` | `Broker.BrokerCode` | **`"GATE"`** |

The reported behaviour does not reproduce. On TOMS ticket `21027094`, booked in the same session without a clearing broker, both fields are published as null, which is the correct value there.

---
### 2. The trade reaches STP Hub and is accepted - **PASSED ✅**

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:35:12.761` | TOMS XML received |
| `PublishingStpHubEvent` | `13:36:56.669` | `MessageId 86e3738becfd48a2b6aeb86e91050c76` |
| `StpHubAcknowledgementReceived` | `13:36:57.128` | **`Status: OK`** |

---
**Sign-off:** Approved to close. BrokerCommission.Amount and BrokerCode are populated when a clearing broker and a transaction cost are informed.
