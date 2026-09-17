[Bug] IsCallable is published as null on one leg of a Butterfly trade

* **Environment:** UAT2

**Overview**
DWU-419 maps `PostTradeEvent.Trade.Instrument.IsCallable` from `BondRecord.Callable` in the Reference Stack. On Butterfly trades Darwin publishes three trade events, one per leg, and one of them carries `IsCallable` as `null` while the other two carry `false`. On package `20260915.SAN3.EUGV.BFLY.28` it is leg `20260915.SAN3.EUGV.31`, and on package `20260915.SAN3.EUGV.BFLY.60` it is leg `20260915.SAN3.EUGV.63`. The instrument on that leg, `GB00BPSNB460`, has `Callable` set to off in Bond Referential.

**Actual result:** `IsCallable` is published as `null` on one of the three legs.

**Expected result:** `IsCallable` is published as `false`, matching the static data.

**Evidence:**
