[Bug] TOMS post-trade: PreviousTradeId is published as null on a cancellation

* **Environment:** UAT2

**Overview**
DWU-417 maps `PostTradeEvent.Trade.PreviousTradeId` from the trade entity field `PreviousTransactionId`. When a trade is cancelled from TOMS, the payload is published with `"PreviousTradeId":null`, and that is the field that identifies the original trade being cancelled. Seen on `BloombergToms$21023146`, `EventType: "Cancel"`.

**Actual result:** `PreviousTradeId` is published as `null` on the cancellation.

**Expected result:** `PreviousTradeId` carries the id of the original trade being cancelled.

**Evidence:**
