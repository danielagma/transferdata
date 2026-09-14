```
[Bug] Venue post-trade: TraderUuid is published with the Darwin trader code instead of the Bloomberg external code

* **Environment:** UAT2

**Overview**
DWU-419 maps `PostTradeEvent.Trade.User.TraderUuid` from `Trader.TraderPlatforms.Codes.ExternalCode` where `ExternalPlatformName = "Bloomberg"`. On the Tradeweb trade `TradewebEUGV$20260914.SAN3.EUGV.83` the payload publishes `"TraderUuid":"x531532"`, which is the Darwin trader code and the same value as `"TraderId":"x531532"` on that same payload. The external platform mapping is not being read.

**Actual result:** `TraderUuid` carries the Darwin trader code, identical to `TraderId`.

**Expected result:** `TraderUuid` carries the `External Code` of the trader's `Bloomberg` row in `Trader Platform Codes`.

**Evidence:**
```
