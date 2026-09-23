[Bug] TOMS trades publish InternalTradeId in the previous format instead of DWB + Base62

* **Environment:** UAT2

**Overview**
On TOMS trades, `PostTradeEvent.Trade.InternalTradeId` publishes the previous format instead of the `DWB` + 11-character Base62 format that DWU-549 requires. DWU-549 lists TOMS trades explicitly in its scope. Seen on TOMS ticket `21027189`, booked on 23 September.

**Actual result:** `InternalTradeId` publishes `BloombergToms$21027189`.

**Expected result:** `InternalTradeId` publishes a 14-character value in the form `DWB` followed by 11 Base62 characters.

**Evidence:**
