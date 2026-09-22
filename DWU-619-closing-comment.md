### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** TOMS ticket `21027097`, gilt future `G U6` booked manually on 22 September

**Execution Summary:**
A gilt future was booked manually in TOMS. Darwin publishes it with `Price.Yield: null`. The validator no longer blocks it and the reported behaviour does not reproduce.

---
### 1. A future with null Yield is published - **PASSED ✅**

The TOMS XML for a future carries no `Yield` element, so Darwin builds the payload with `Price.Yield: null` and publishes it.

| Event | Timestamp (UTC) | Detail |
|---|---|---|
| `TradeEvent` | `13:34:06.367` | `AssetClass: Future`, no `Yield` in the source XML |
| `PublishingStpHubEvent` | `13:34:06.515` | `MessageId 92b4302f3aff44bdad8e98a1472dbcfd`, `Price.Yield: null` |

No validation error is logged on this trade.

---
### 2. STP Hub rejects the published message - **separate ticket**

STP Hub answers 508 ms later with `Status: ERROR`:

```
Validation failed: [
  /PostTradeEvent/Trade/Instrument/Class: null found, string expected,
  /PostTradeEvent/Trade/Instrument/CountryCode: null found, string expected,
  /PostTradeEvent/Trade/Instrument/CouponType: null found, string expected,
  /PostTradeEvent/Trade/Instrument/IndustrySector: null found, string expected,
  /PostTradeEvent/Trade/Instrument/IsInflationLinked: null found, boolean expected,
  /PostTradeEvent/Trade/Instrument/Ticker: null found, string expected,
  /PostTradeEvent/Trade/Instrument/VenueCode: null found, string expected,
  /PostTradeEvent/Trade/Price/Yield: null found, number expected
]
```

Eight fields, seven of which this ticket does not cover. This is the STP Hub schema, not Darwin's validator, and is raised as its own ticket.

---
### 3. Not covered in this cycle
Continued rejection of a non-future with null Yield. All four bonds booked in this session carry a Yield.

---
**Sign-off:** Approved to close. A future with null Yield is published, which it was not before.
