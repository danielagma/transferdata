# Hoja de ruta · lunes 5-oct

UAT2, índice `fidw-eu-bonds-uat2*`. Hora de pantalla de México. OpenSearch hasta las 12:00.
Página con casillas: https://claude.ai/artifact/AsMjh24VgLy9zV9zEUPA6x

## 0 · Al empezar (5 min)

1. Manda el mensaje a Sergio (abajo, sección 6). Así trabaja en paralelo.
2. Pide a Murat que apunte Tradeweb a UAT2.
3. Abre OpenSearch. **Pon el rango de fechas que indica cada trade.** Con `Today` no sale nada de días anteriores.

Estado a las 7:44 del 5-oct: Tradeweb volvió a QA a las 2:34 (hay que pedirlo otra vez para UAT2). BondVision (MTS) lo tiene el equipo EU. Sólo queda OpenSearch.

## 1 · OpenSearch, trade por trade (hasta las 12:00)

Pon el rango de fechas indicado en cada trade antes de buscar. Una captura por búsqueda. Capturas a `Screenshots\Trades\<fecha>\<ticket>\` y fila en `deliverables/evidencia/DWU-xxx.md`.

### 1 · 21028743 (New) y 21028749 (Amend) · TOMS · rango 2-oct

- Todo: `"21028743"`
- XML New: `Event.Type: "TradeEvent" and "21028743"`
- XML Amend: `Event.Type: "TradeEvent" and "21028749"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "21028743"`

Si algo sale vacío:

- Si el XML sale vacío: `"21028749"`
- Si el ACK sale vacío: `"21028743:DWBZnbyV67cLlA:New:7412ec0336fdaf00"`
- Si el ACK sale vacío: `"21028743:DWBZnbykfhIsds:Amend:b3ef4f63962f9ddc"`
- Rechazo de STP Hub: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`

Qué mirar: Payload ya en captura. Cada campo del payload contra el XML. En el XML del 749: TransactionNumber (el payload saca SourceId 21028743). El ACK debe dar 2 filas, New y Amend.

Cierra: 416 #1-2 · 417 #1-2 · 418 #1-2 · Excel 30 y 31

### 2 · 21028770 · TOMS clearing broker · rango 2-oct

- Todo: `"21028770"`
- Payload: `Event.Type: "StpHubPayloadSent" and Event.SourceId: "21028770"`
- XML: `Event.Type: "TradeEvent" and "21028770"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "21028770"`

Si algo sale vacío:

- Si el payload sale vacío: `"21028770" and Level: Error`
- Si el payload sale vacío: `Event.Type: "StpHubPayloadValidationFailed" and "21028770"`
- Si el payload sale vacío: `"21028770" and Level: Warning`
- Si el ACK sale vacío: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`

Qué mirar: BrokerCode contra ClearingBroker. BrokerCommission.Amount contra TransactionCost Type 2. Si el ACK sale vacío, busca entre comillas el MessageId que trae el payload.

Cierra: 416 #3 · 417 #3

### 3 · 21028777 · TOMS libro interno · rango 2-oct

- Todo: `"21028777"`
- Payload: `Event.Type: "StpHubPayloadSent" and Event.SourceId: "21028777"`
- XML: `Event.Type: "TradeEvent" and "21028777"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "21028777"`

Si algo sale vacío:

- Si el payload sale vacío: `"21028777" and Level: Error`
- Si el payload sale vacío: `Event.Type: "StpHubPayloadValidationFailed" and "21028777"`
- Si el payload sale vacío: `"21028777" and Level: Warning`
- Si el ACK sale vacío: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`

Qué mirar: IsInternalTrade. Si es interno y publica, también sirve de retest de DWU-649. Si el ACK sale vacío, busca entre comillas el MessageId que trae el payload.

Cierra: 416 #4 · DWU-649 si es interno

### 4 · 21028773 · TOMS futuro Bobl · rango 2-oct

- Todo: `"21028773"`
- XML: `Event.Type: "TradeEvent" and "21028773"`
- Rechazo: `"21028773:DWBZnc1AZVtjMW:New:b9f21abddc17f35f"`

Si algo sale vacío:

- Si el XML sale vacío: `"21028773" and Level: Warning`
- Rechazo de STP Hub: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`

Qué mirar: Payload ya en captura. En el XML: Ticker (el payload trae null y MaturityCode Z6) y SecurityIdentifierFlag (30 = BLOOMBERG ID en la tabla de DWU-418; el payload dice VENUE). Sin ACK esperado (DWU-648).

Cierra: 416 #5 · 417 #4 · 418 #3

### 5 · 21028863 · TOMS VOICE · rango 2-oct

- Todo: `"21028863"`
- Payload: `Event.Type: "StpHubPayloadSent" and Event.SourceId: "21028863"`
- XML: `Event.Type: "TradeEvent" and "21028863"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "21028863"`

Si algo sale vacío:

- Si el ACK sale vacío: `"21028863:DWBZnctGA9GO1I:New:0928f0ee2ebec1aa"`

Qué mirar: SourceOriginalName STW en el payload. ExecutedPlatformName VOICE en el XML.

Cierra: 418 fila SourceOriginalName

### 6 · 3564:20261002:1:5 · Bloomberg outright · rango 2-oct

- Todo: `"3564:20261002:1:5"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "3564:20261002:1:5"`

Si algo sale vacío:

- Si el ACK sale vacío: `"3564:20261002:1:5:DWBZnboueUhjma:New:c65753e3f0c38954"`
- Rechazo de STP Hub: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`

Qué mirar: Payload ya en captura. Sólo falta el ACK.

Cierra: 415, 419, 420 (gateway Bloomberg) · Excel 10

### 7 · 20261002.SAN3.EUGV.276 · Tradeweb, log de error · rango 2-oct

- Error: `Event.Type: "StpHubPayloadValidationFailed" and "20261002.SAN3.EUGV.276"`

Si algo sale vacío:

- Si sale vacío: `"20261002.SAN3.EUGV.276"`
- Si sale vacío: `"20261002.SAN3.EUGV.276" and Level: Warning`
- Causa: `Event.Type: "TraderBloombergUuidMissing" and "20261002.SAN3.EUGV.276"`

Qué mirar: El log trae trade, campo (User.TraderUuid), tipo esperado, valor y gateway (TRADEWEB_EUGV).

Cierra: 419 #7 · AC de log de error de 415, 419, 420

### 8 · 21027091 · TOMS, log de error · rango 22-sep

- Error: `Event.Type: "StpHubPayloadValidationFailed" and "21027091"`

Si algo sale vacío:

- Si sale vacío: `"21027091"`
- Si sale vacío: `"21027091" and Level: Warning`

Qué mirar: Trade, campo (Mifid.Transparency), tipo esperado, valor y gateway. Si no aparece nada, el AC de error de 416, 417 y 418 sale del alcance.

Cierra: 416 AC 8 · 417 AC 12 · 418 AC 8

### 9 · 21028714 cancel (y 21028716) · TOMS, chat de hoy · rango 2-oct a 5-oct

- Todo: `"21028714"`
- Todo: `"21028716"`
- Descarte: `Event.Type: "TradeEventSkipped" and "21028716"`
- Payloads: `Event.Type: "StpHubPayloadSent" and Event.SourceId: "21028714"`

Si algo sale vacío:

- XML del cancel: `Event.Type: "TradeEvent" and "21028714"`
- XML del 716: `Event.Type: "TradeEvent" and "21028716"`

Qué mirar: Por qué se descartó el cancel: abre el TradeEventSkipped. Payloads: sólo debería salir el New del viernes. Lo revisa Murat.

Cierra: Excel 35 cuando Murat lo arregle

### 10 · 21028699 y su amend 21028705 · TOMS, chat de hoy · rango 2-oct a 5-oct

- Todo: `"21028699"`
- Payloads: `Event.Type: "StpHubPayloadSent" and Event.SourceId: "21028699"`
- XML Amend: `Event.Type: "TradeEvent" and "21028705"`
- ACK: `Event.Type: "StpHubPayloadAcknowledgedPublished" and Event.SourceId: "21028699"`

Si algo sale vacío:

- Rechazo de STP Hub: `Event.Type: "StpHubAcknowledgementReceived" and Level: Warning`
- Todo del amend: `"21028705"`

Qué mirar: En el payload del Amend: SourceId y TradeNo. En el XML del amend: TransactionNumber. Es el mismo caso que 21028749. Lo revisa Murat.

Cierra: 417 SourceId · Excel 32 cuando Murat lo arregle

### 11 · 20261002.SAN3.EUGV.272 · Sentinel (opcional) · rango 2-oct

- Buscar: `Event.Type: "MessageSentToSentinel" and "20261002.SAN3.EUGV.272"`

Qué mirar: El nombre del evento sale del ticket (DEV1). No está verificado en UAT2.

Cierra: DWU-441 Req 4


## 3 · Tradeweb, cuando Murat lo apunte a UAT2

Recetas: `playbooks/recetas-trades-tradeweb.md` y `playbooks/receta-allocation-tradeweb.md`. Revisión: los mismos comandos de la sección 1 con el id nuevo y rango `Today`.

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

**Si manda trades:** revísalos con los comandos de la sección 1 (los de un trade de su tipo), con el id nuevo y rango `Today`, en este orden:

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
