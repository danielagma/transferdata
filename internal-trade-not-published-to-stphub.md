[Bug] TOMS internal trades are never published to STP Hub

* **Environment:** UAT2

**Overview**
An internal trade booked in TOMS arrives as two halves and neither reaches STP Hub. Both are enriched, `InternalTradeEnrichmentSuccess` and `TradingBookEnrichmentSuccess` are logged on each, and then both fail Darwin's payload validation, defer publication, retry 31 times and time out. Seen on TOMS tickets 21027102 and 21027103, the two halves of the same trade, where each half carries the other half's trading book as its `CustomerAccountCounterparty`, `GBPASECM` and `FO_BONOS`.

**Steps to reproduce**
1. In TOMS, book a bond trade against another desk of the same bank, in portfolio `FO_BONOS`.
2. Read the life of each half: `"<ticket>"`.
3. Check for a published payload: `Event.Type: "PublishingStpHubEvent" and "<ticket>"`.

**Actual result:** no payload is published for either half. The sequence is identical on both.

```
07:36:55.611            TradeEvent                          G39Y1319100021027102
07:36:55.664  Debug     InternalTradeEnrichmentSuccess
07:36:55.673  Warning   StpHubPayloadValidationFailed
07:36:55.679            StpHubEventPublishingDeferred
07:36:57 to 07:37:27    StpHubTomsOverridesApplied, 31 times, one per second
07:37:27.314  Warning   StpHubPublicationTimedOut

07:36:56.051            TradeEvent                          H39Y1319120021027103
07:36:56.093  Debug     InternalTradeEnrichmentSuccess
07:36:56.102  Warning   StpHubPayloadValidationFailed
07:36:56.108            StpHubEventPublishingDeferred
07:37:27.174  Warning   StpHubPublicationTimedOut
```

`Event.Type: "PublishingStpHubEvent"` returns No Results for both tickets.

The first half fails validation at 07:36:55.673, 378 ms before the second half is received, so the failure is not caused by the other half being absent.

**Expected result:** the internal trade is published to STP Hub.

**Evidence:**

---

⚠ **Pendiente antes de subirlo:** falta el campo concreto que rechaza el validador. Está en el evento
`StpHubPayloadValidationFailed`, que no se pudo abrir el 2026-09-22 porque cerró el acceso a OpenSearch.
Un comando, rango `Last 2 days`:

```
Event.Type: "StpHubPayloadValidationFailed" and "21027102"
```

El bug se puede levantar sin ese dato y añadirlo después como comentario.
