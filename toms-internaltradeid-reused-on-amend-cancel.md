[Bug] InternalTradeId is not regenerated on TOMS amendments and cancellations

* **Environment:** UAT2

**Overview**
On TOMS amendments and cancellations, `PostTradeEvent.Trade.InternalTradeId` publishes the same value as the original trade event. Each published event should get its own value. Seen on a TOMS amend and cancellation booked on 23 September.

**Actual result:** the amend and the cancellation publish the same `InternalTradeId` as the original trade.

**Expected result:** each event published to STP Hub gets its own `InternalTradeId`.

**Evidence:**
