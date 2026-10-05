# Hoja de ruta · lunes 5-oct

UAT2, índice `fidw-eu-bonds-uat2*`. Hora de pantalla de México. OpenSearch hasta las 12:00.
Página con casillas: https://claude.ai/artifact/AsMjh24VgLy9zV9zEUPA6x

## 0 · Al empezar (5 min)

1. Manda el mensaje a Sergio (abajo, sección 6). Así trabaja en paralelo.
2. Pide a Murat que apunte Tradeweb a UAT2.
3. Abre OpenSearch. **Pon el rango de fechas del día del trade** (2-oct, o 22-sep para `21027091`). Con `Today` no sale nada de días anteriores.

## 1 · El ciclo de búsqueda (igual para cada ticket)

Siempre en este orden. Una captura por paso.

| Paso | Qué | Comando |
|---|---|---|
| 1 | Todo el ticket | `"<ID>"` |
| 2 | Payload | `Event.Type: "StpHubPayloadSent" and "<ID>"` · abre `Event.Document`, copia el `MessageId` |
| 3 | XML (sólo TOMS) | `Event.Type: "TradeEvent" and "<ID>"` · abre `Event.TradeFeedXml` |
| 4 | ACK | `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "<ID>"` |

**Si algo sale vacío:**

- **Paso 1 vacío:** el rango de fechas está mal. Corrígelo antes de seguir.
- **Paso 2 vacío:** busca, en este orden:
  1. `"<ID>" and Level: Error`
  2. `Event.Type: "StpHubPayloadValidationFailed" and "<ID>"` (el campo que falló está en `Event.Exception.Message`)
  3. `"<ID>" and Level: Warning`
- **Paso 3 vacío:** en el resultado del paso 1, abre la fila `TradeEvent` del log group `...BBG-TomsInbound-TOMS`. No uses `OnTradeEventReceived`: trae el XML en Base64.
- **Paso 4 vacío:**
  1. `"<MessageId>"`, pegado del payload, no tecleado.
  2. `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`: así sale un rechazo (NACK).
  3. Mira en el paso 1 si hay filas `StpHubAcknowledgementReceived` con `AcknowledgedMsgId` igual al `MessageId`.

**Reglas de los ids:**

- TOMS: un amend o cancel publica con el `SourceId` del ticket **original**. Para `21028749` busca `21028743`. Separa con `and Event.EventType: "Amend"` (o `"New"`, `"Cancel"`).
- Bloomberg: `3564:20261002:1:5`, sin `BSGB`.
- Tradeweb: sin `Tradeweb$`, por ejemplo `20261002.SAN3.EUGV.276`.

## 2 · OpenSearch, en orden (hasta las 12:00)

| # | Ticket | Rango | Pasos | Qué mirar | Cierra |
|---|---|---|---|---|---|
| 1 | `21028743` y su amend `21028749` | 2-oct | 1, 3 (de los dos), 4 | Cada campo del payload contra el XML. En el XML del 749, `TransactionNumber` | 416 #1-2 · 417 #1-2 · 418 #1-2 · Excel 30 y 31 |
| 2 | `21028770` | 2-oct | 1, 2, 3, 4 | `BrokerCode`, `BrokerCommission.Amount` contra `ClearingBroker` y `TransactionCost` Type 2 | 416 #3 · 417 #3 |
| 3 | `21028777` | 2-oct | 1, 2, 3, 4 | `IsInternalTrade` | 416 #4 · si es interno, retest DWU-649 |
| 4 | `21028773` | 2-oct | 1, 3 | `Ticker` y `SecurityIdentifierFlag` (`30` = `BLOOMBERG ID`, el payload dice `VENUE`). Sin ACK (DWU-648) | 416 #5 · 417 #4 · 418 #3 |
| 5 | `21028863` | 2-oct | 1, 2, 3, 4 | `SourceOriginalName STW`, `ExecutedPlatformName VOICE` | 418 fila STW |
| 6 | `3564:20261002:1:5` | 2-oct | 4 | ACK. Payload ya en captura | 415, 419, 420 (Bloomberg) · Excel 10 |
| 7 | `20261002.SAN3.EUGV.276` | 2-oct | `Event.Type: "StpHubPayloadValidationFailed" and "20261002.SAN3.EUGV.276"` | Trade, campo, tipo, valor, gateway | 419 #7 · AC de log de error de 415, 419, 420 |
| 8 | `21027091` | 22-sep | `Event.Type: "StpHubPayloadValidationFailed" and "21027091"` | Lo mismo. Si sale vacío, el AC de error de 416, 417 y 418 sale del alcance | 416 AC 8 · 417 AC 12 · 418 AC 8 |
| 9 | `20261002.SAN3.EUGV.272` (opcional) | 2-oct | `Event.Type: "MessageSentToSentinel" and "20261002.SAN3.EUGV.272"` | Evento no verificado en UAT2 | DWU-441 Req 4 |

Capturas a `Screenshots\Trades\2026-10-02\<ticket>\`. Fila nueva en `deliverables/evidencia/DWU-xxx.md` por cada captura.

## 3 · Tradeweb, cuando Murat lo apunte a UAT2

Recetas: `playbooks/recetas-trades-tradeweb.md` y `playbooks/receta-allocation-tradeweb.md`. Revisión: ciclo de la sección 1 con rango `Today`.

1. **Outright con allocation a 2 cuentas, flag Calypso en No** (receta de allocation). Cierra el retest de DWU-679: el trade se publica antes que la `ALLOC`, y cada uno tiene su ACK.
2. **Outright sobre un bono con axe** (receta 3). `IsAxed true`, `Axe.Side` = `Verb`. Cierra 420 #3 y Excel 16.
3. **Switch con `Darwin Calc'n` en No** (receta 4). `CalculateSalesCredit false` en las 2 patas. Excel 15. Vuelve a Yes al terminar.
4. **DWU-551**, escenarios 1 a 3 de la guía (https://claude.ai/artifact/UYeckrwqzAkUFXcj5bA7X6). Primero mira si `Counterparty Relationship` muestra `Calypso Flow`. Si no, para y pregunta a Murat.
5. **Outright para DWU-701**, sólo si el bug está arreglado.

## 4 · BondVision

Receta: `playbooks/receta-allocation-bondvision.md`.

1. Comprueba que conecta a UAT2 (el 2-oct dio `INVALID_CREDENTIALS`).
2. Outright con allocation a `Test1` y `Test2`. Precio a mano = `BV BID/ASK`. Cierra el gateway BV de 415, 419, 420; DWU-425 #4; retest DWU-629; Excel 12 y 26.
3. Switch. Excel 13.

## 5 · Lo que mande Sergio

**Si manda trades:** revísalos con el ciclo de la sección 1, rango `Today`, en este orden:

1. Allocation de Bloomberg: paso 2 con `and Event.PayloadType: "StpHubPostTradeAllocationEvent"`. Mira `MarketCode`. Cierra DWU-424, 425 (Bloomberg), 629, 679.
2. Outright y switch de Bloomberg: Excel 10 y 11.
3. Trades A y D (mismo día): `EventType`, `PreviousTradeId`. Excel 30, 31, 33, 34.
4. Punto 3 (notas): DWU-417 #6 y 418 `InternalTradeId`.
5. Punto 4: DWU-416 #7 y retest DWU-651.
6. Punto 5: DWU-418 y retest DWU-649.
7. Trades B y C: el martes 6-oct (amend y cancel al día siguiente). Excel 32 y 35.

**Si no manda nada:** DWU-416, 417 y 418 no se cierran. Sigue con Tradeweb y BondVision. Recuérdaselo en el chat después de comer.

**Si manda una parte:** revisa lo que llegue en el orden de arriba. Lo que falte queda en esta lista para el martes.

## 6 · Mensaje a Sergio (chat STP Hub Validation)

```
Hi Sergio! Picking up the trades I asked for on Thursday, with a few changes. Please send me the ticket or deal id of each one.

1. Bloomberg
- One Outright
- One Switch
- One trade allocated into two accounts

2. TOMS, four new trades
- Trade A: book it, amend it, then cancel the amended trade.
- Trade B: book it and leave it. Amend it tomorrow.
- Trade C: book it and leave it. Cancel it tomorrow.
- Trade D: book it and cancel it the same day.

3. TOMS, one bond (not a future) with these fields populated:
- Long Note 2, Long Note 3, Long Note 4, Long Note 7
- Short Note 3
- MiFID II "Decision maker within firm" and "Execution within firm"
Please leave Long Note 1 (Sentinel ID) empty.

4. TOMS, one bond with Mifid Transparency and Mifid Waiver populated. For Transparency, use a value outside the standard list, for example RPRI. Long Note 1 empty.

5. TOMS
- One trade with TransactionType PXM or PXT
- One trade on a bond with an axe
- One internal trade (against another desk of the bank)
- One trade with the MiFID execution decision and investment decision flagged as algo
- One ticket each with these values: AE, CAE, PCA, XAE and PXA

Thanks!
```

## 7 · Qué cubre cada trade de Sergio

- Outright Bloomberg: Excel 10 · DWU-415, 419, 420 (gateway Bloomberg).
- Switch Bloomberg: Excel 11 · DWU-415, 419, 420 (multi-leg Bloomberg).
- Allocation 2 cuentas: Excel 26 · DWU-425, 424, retest 629 y 679.
- Trade A: Excel 30, 31, 34 · DWU-418 `EventType`, DWU-417 `PreviousTradeId`.
- Trade B: Excel 32 · DWU-418 `EventType` Amend.
- Trade C: Excel 35 · DWU-418 `EventType` Cancel.
- Trade D: Excel 33 · DWU-418 `EventType` Cancel.
- Bono con notas: DWU-417 (7 filas) · DWU-418 `InternalTradeId`.
- Transparency y Waiver: DWU-416 · retest 651.
- PXM o PXT: DWU-418 `Side`.
- Bono con axe: DWU-418 `IsAxed`.
- Trade interno: retest DWU-649.
- Algo: DWU-418 `MktIdType`.
- AE, CAE, PCA, XAE, PXA: DWU-418 `EventType`.

## 8 · Pendiente de decidir

- Los 5 valores de `EventType`: pedirlos o borrar esa línea del mensaje.
- P7 a Fation (casos de venue que no salen de Tradeweb): mandarlo o no. Texto en `plan-de-trades.md`.
- AC 3 de DWU-551: preguntar a Murat o dejarlo fuera.
- Excel filas 5, 6, 17, 18: pasar a Pass con `.272` y `.274`.

## 9 · Al terminar el día

- Filas nuevas en `deliverables/evidencia/`.
- Actualizar `plan-de-trades.md` con lo cerrado.
- Proponer los cambios del Excel antes de tocarlo.
