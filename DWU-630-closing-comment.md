### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trade under test:** Tradeweb butterfly `20260922.SAN3.EUGV.BFLY.2240`, launched on 22 September, repeating the instrument package of the report

**Execution Summary:**
A three-leg butterfly was launched from Darwin against Tradeweb. The three published payloads were read. `Instrument.IsCallable` is `false` on every leg, including the one that reported `null`.

---
### 1. IsCallable is published on all three legs - **PASSED ✅**

| Leg | ISIN | Instrument | `Instrument.IsCallable` |
|---|---|---|---|
| `20260922.SAN3.EUGV.2241` | `GB00BNNGP668` | UKT 0.375 10/26 | **`false`** |
| `20260922.SAN3.EUGV.2242` | `GB00BL6C7720` | UKT 4.125 01/27 | **`false`** |
| `20260922.SAN3.EUGV.2243` | **`GB00BPSNB460`** | UKT 3.750 03/27 | **`false`** |

`GB00BPSNB460` is the instrument named in the report, the leg that published `null` on both `BFLY.28` and `BFLY.60`. It now publishes `false`, matching `Callable` set to off in Bond Referential.

The three legs carry `ComplexTradeId: 20260922.SAN3.EUGV.BFLY.2240` and `NumberOfLegs: 3`, so they are the same butterfly.

The reported behaviour does not reproduce.

---
**Sign-off:** Approved to close. `Instrument.IsCallable` is published as `false` on all three legs of a butterfly, including the instrument the defect was reported on.
