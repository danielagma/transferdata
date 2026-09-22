### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027094`, booked manually on 22 September

**Execution Summary:**
A bond trade was booked manually in TOMS. The TOMS XML and the published payload were compared field by field. Settlement.SettlementLocation and Settlement.InvertFlag are no longer published as null.

---
### 1. The two settlement fields carry the source values - **PASSED ✅**

| TOMS XML field | Value in | Published field | Value out |
|---|---|---|---|
| `SettlementLocationAbbreviation` | `ST` | `Settlement.SettlementLocation` | `"ST"` |
| `InvertFlag` | `N` | `Settlement.InvertFlag` | `"N"` |

The reported behaviour does not reproduce. The rest of the settlement block is populated on the same payload: `Settlement.Currency: "EUR"`, `Settlement.Date: "2026-09-24"`, `Settlement.CurrencyRate: 1.0`.

---
### 2. The trade reaches STP Hub and is accepted - **PASSED ✅**

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:12:00.804` | TOMS XML received |
| `PublishingStpHubEvent` | `13:12:00.992` | `MessageId 20d23472ced94447b643cced7164120c` |
| `StpHubAcknowledgementReceived` | `13:12:01.609` | **`Status: OK`** |

---
**Sign-off:** Approved to close. Settlement.SettlementLocation and Settlement.InvertFlag are published with the values the TOMS XML carries.
