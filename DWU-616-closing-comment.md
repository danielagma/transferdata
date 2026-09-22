### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027094`, booked manually on 22 September

**Execution Summary:**
A bond trade carrying accrued interest was booked manually in TOMS. The TOMS XML and the published payload were compared field by field. AccruedDays and AccruedInterest are no longer published as 0.

---
### 1. The two fields carry the source values - **PASSED ✅**

| TOMS XML field | Value in | Published field | Value out |
|---|---|---|---|
| `NumberOfDaysAccrued` | `328` | `AccruedDays` | `328` |
| `AccruedInterestRepoInterest` | `92558.9` | `AccruedInterest` | `92558.9` |

The reported behaviour does not reproduce.

---
### 2. The trade reaches STP Hub and is accepted - **PASSED ✅**

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:12:00.804` | TOMS XML received |
| `PublishingStpHubEvent` | `13:12:00.992` | `MessageId 20d23472ced94447b643cced7164120c` |
| `StpHubAcknowledgementReceived` | `13:12:01.609` | **`Status: OK`** |

---
**Sign-off:** Approved to close. AccruedDays and AccruedInterest are published with the values the TOMS XML carries.
