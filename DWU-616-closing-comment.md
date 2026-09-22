### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027094`, booked manually on 22 September
* **Target Events:** `TradeEvent`, `PublishingStpHubEvent`, `StpHubAcknowledgementReceived`

**Execution Summary:**
A new bond trade carrying accrued interest was booked manually in TOMS and traced end to end in OpenSearch. The TOMS XML that entered the gateway and the payload Darwin published to STP Hub were read on the same ContextId and compared field by field. AccruedDays and AccruedInterest are no longer published as 0: they carry the values the source XML supplies, digit for digit. STP Hub acknowledged the message with Status OK.

---
### 1. The two fields carry the source values - **PASSED ✅**
Instrument SPGB 5.15% 31 Oct 2028, ISIN ES00000124C5, portfolio FO_BONOS, counterparty TELE, Buy of 2,000,000 at 195.0. ContextId `G39Y1319100021027094`, index `fidw-eu-bonds-uat2*`.

| TOMS XML field | Value in | Published field | Value out |
|---|---|---|---|
| `NumberOfDaysAccrued` | `328` | `AccruedDays` | `328` |
| `AccruedInterestRepoInterest` | `92558.9` | `AccruedInterest` | `92558.9` |

Both values are non zero and both match the source exactly. The reported behaviour, two zeros regardless of what the ticket carried, does not reproduce.

---
### 2. The trade reaches STP Hub and is accepted - **PASSED ✅**
The payload was published and acknowledged, so the values above are the ones STP Hub actually received.

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:12:00.804` | TOMS XML received on the Bloomberg TOMS inbound gateway |
| `PublishingStpHubEvent` | `13:12:00.992` | `MessageId 20d23472ced94447b643cced7164120c` |
| `StpHubAcknowledgementReceived` | `13:12:01.609` | **`Status: OK`** |

---
**Sign-off:** Approved to close. AccruedDays and AccruedInterest are published with the values the TOMS XML carries.
