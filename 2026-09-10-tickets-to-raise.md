# Tickets a levantar · 2026-09-10

Cuatro, del chat `D2C Manual entry trades in Toms`. Proyecto destino **DWU** en los cuatro.

| # | Tipo | Contra | Título |
|---|---|---|---|
| 1 | Bug | DWU-417 | AccruedDays and AccruedInterest are published as 0 |
| 2 | Bug | DWU-417 | Settlement.SettlementLocation and Settlement.InvertFlag are published as null |
| 3 | Bug | DWU-418 | EventType is published as Reversal on a cancellation |
| 4 | Task | DWU-415 | Do not validate the Yield field when the AssetClass is a future |

---

## 1 · Bug · DWU-417

**Título**

```
[Bug] TOMS post-trade: AccruedDays and AccruedInterest are published as 0
```

**Descripción**

```
* **Environment:** UAT

**Overview**
DWU-417 maps `PostTradeEvent.Trade.AccrDays` from the TOMS field `NumberOfDaysAccrued` and `PostTradeEvent.Trade.AccruedInterest` from the TOMS field `SettlementCcyAccrued`. On TOMS ticket 21022133 the published `PostTradeEvent` has `AccruedDays: 0` and `AccruedInterest: 0.0`. The inbound TOMS event for the same trade has `SettlementCcyAccrued: 88890.41`.

**Steps to reproduce**
1. In TOMS, book a bond trade on an instrument that carries accrued interest.
2. Compare `AccruedDays` and `AccruedInterest` on the published `PostTradeEvent` with the accrued values on the inbound TOMS event.

**Evidence:**
```

**Adjuntar:** `source/payloads/2026-09-09-TOMS-inbound-event-21022133-INPUT.md` · `source/payloads/2026-09-09-TOMS-PostTradeEvent-21022133-FIRST-ACK-OK.json`

---

## 2 · Bug · DWU-417

**Título**

```
[Bug] TOMS post-trade: Settlement.SettlementLocation and Settlement.InvertFlag are published as null
```

**Descripción**

```
* **Environment:** UAT

**Overview**
DWU-417 maps `PostTradeEvent.Trade.Settlement.SettlementLocation` from the TOMS field `SettlementLocationAbbreviation` and `PostTradeEvent.Trade.Settlement.InvertFlag` from the TOMS field `InvertFlag`. On TOMS ticket 21022133 both are published as `null`. The TOMS XML for the same trade has `ST` and `N`.

**Steps to reproduce**
1. In TOMS, book a bond trade with a settlement location set.
2. Compare `Settlement.SettlementLocation` and `Settlement.InvertFlag` on the published `PostTradeEvent` with the values on the TOMS XML.

**Evidence:**
```

**Adjuntar:** los mismos dos ficheros del bug 1.

---

## 3 · Bug · DWU-418

**Título**

```
[Bug] TOMS post-trade: EventType is published as Reversal on a cancellation
```

**Descripción**

```
* **Environment:** UAT

**Overview**
DWU-418 maps `PostTradeEvent.EventType` from the Trade Model field `LifecycleAction`. On the cancellation of TOMS ticket 21021472, `TransactionType: "XMT"` and `CancelDueToCorrection: false`, the trade model has `LifecycleAction: "Reversal"`. DWB-1376 sets the TM Lifecycle Action to CANCEL for XTT, XMT, XFT and XRF with `CancelDueToCorrection = N`. DWU-418's mapping row states that the current logic does not take into account the values AE, CAE, PCA, XAE and PXA.

**Steps to reproduce**
1. In TOMS, book a bond trade and cancel it on the same day.
2. Read `TransactionType`, `CancelDueToCorrection` and `LifecycleAction` on the cancellation event in the trade model.
3. Read `EventType` on the published `PostTradeEvent`.

**Evidence:**
```

**Adjuntar:** `source/payloads/2026-09-03-03-cancel-bond-21021472-REVERSAL.json`

---

## 4 · Task · DWU-415

**Título**

```
[Task] STP Hub payload: do not validate the Yield field when the AssetClass is a future
```

**Descripción**

```
**Overview**
Futures do not carry a yield, from the venue or from TOMS. DWU-415 declares `PostTradeEvent.Trade.Price.Yield` as `number` (required, non-null) and its AC 5 names Yield among the fields covered by the mandatory field validation, so a futures trade fails validation in Darwin and is not published to STP Hub.

Seen on TOMS ticket 21022388, a EURO-BUND FUTURE Sep26 (RXU6) booked in UAT2, where `Yield` is null:

`STP Hub payload validation failed for trade 'BloombergToms$21022388': field 'Price.Yield' is invalid (expected type: 'Decimal', gateway source: 'BBG_TOMS')`

**What is needed**
Do not validate the `Yield` field when the AssetClass is a future, so that futures trades are published to STP Hub. Mandatory for go live: these events are not processed otherwise.

The value to publish for `Yield` on a futures trade, and the scope of the change, are for the team to define.

**Evidence:**
```

**Adjuntar:** el screenshot del ticket TOMS `21022388` (Sergio, 9:47).
