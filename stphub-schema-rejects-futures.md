[Bug] STP Hub rejects futures trades on eight fields that do not apply to a future

* **Environment:** UAT2

**Overview**
Darwin publishes a futures trade with the Yield and seven bond reference attributes null, because a future does not carry them. STP Hub rejects the message on its own schema. Seen on TOMS ticket 21027097, a `G U6` Long Gilt Future.

**Steps to reproduce**
1. In TOMS, book a futures trade, for example `G U6` Long Gilt Future.
2. Read the published payload: `Event.Type: "PublishingStpHubEvent" and "<ticket>"`.
3. Read the acknowledgement: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`.

**Actual result:** `Status: ERROR`.

```
Validation failed: [/PostTradeEvent/Trade/Instrument/Class: null found, string expected, /PostTradeEvent/Trade/Instrument/CountryCode: null found, string expected, /PostTradeEvent/Trade/Instrument/CouponType: null found, string expected, /PostTradeEvent/Trade/Instrument/IndustrySector: null found, string expected, /PostTradeEvent/Trade/Instrument/IsInflationLinked: null found, boolean expected, /PostTradeEvent/Trade/Instrument/Ticker: null found, string expected, /PostTradeEvent/Trade/Instrument/VenueCode: null found, string expected, /PostTradeEvent/Trade/Price/Yield: null found, number expected]
```

**Expected result:** the futures trade is accepted by STP Hub.

**Evidence:**
