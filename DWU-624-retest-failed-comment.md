### **QA Execution: FAILED ❌**
* **Environment:** UAT2
* **Trade under test:** Tradeweb outright `Tradeweb$TRD_20260922_SAN3_EUGV_2237`, launched on 22 September

**Execution Summary:**
`User.TraderUuid` no longer publishes the Darwin trader code, but it does not publish the value of the trader on the trade either. It publishes the `Bloomberg` External Code of a different trader.

---
### 1. TraderUuid is not taken from the trader who executed the trade - **FAILED ❌**

| | Value |
|---|---|
| Trader on the trade, `TraderId` | `x531532` |
| `Trader Platform Codes` for `X531532` in UAT2 | *"No External Codes are currently associated with this Trader"* |
| **Published `User.TraderUuid`** | **`31473668`** |
| Owner of `31473668` | the `Bloomberg` External Code of trader **`N317167`** |

**Expected:** `null`. Confirmed by Fation Gjoni on 23 September: *"the trader uuid should be taken for the Trader who closed the trade, in this case you. Since you didn't have one assigned it should have published null, and stp would get an error, but that is expected as missing data. From Darwin point of view traderuuid should be enriched for the trader X531532 who executed the trade"*.

A null here is missing reference data and is not a defect. Publishing another trader's identifier is, because the message is accepted by STP Hub and the trade is attributed to the wrong person.

---
**Sign-off:** Not approved. Returning to development.
