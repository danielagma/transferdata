# STP Hub testing: from a trade ID to a bug

For Gabriella. Environment: UAT2. Logs: OpenSearch, index `fidw-eu-bonds-uat2*`.

---

## 1. Where bugs come from

1. Someone sends a trade: Sergio or Fation from TOMS or Bloomberg, or you from Tradeweb.
2. They post the trade ID in the Teams chat `Darwin - STP Hub Validation`.
3. They, or you, check the logs of that trade.
4. A field in the payload does not match the story that defines it.
5. Someone asks for a bug to be raised, usually Murat.
6. We raise it in Jira. The developer fixes it, the ticket moves to `READY FOR QA`, and we retest it.

The trade can come from your own testing or from Sergio, Fation or Murat. The steps are the same.

---

## 2. When the report has no details

If someone only says "I found this", ask them for the trade ID and the field.

To find the story for that field, search the field name in Jira. Each field sent to STP Hub is defined in the mapping table of a story:

| Trade source | Stories |
|---|---|
| Venue (Tradeweb, Bloomberg, BondVision) | DWU-415, DWU-419, DWU-420 |
| TOMS (manual entry) | DWU-416, DWU-417, DWU-418 |
| `CalculateSalesCredit` | DWU-508 |

Check the logs and the story yourself first. If it is still not clear, ask the person who reported it.

---

## 3. The 3 records of a trade

For each trade, check three records in this order: the input to Darwin, the payload Darwin sends to STP Hub, and the STP Hub acknowledgement (ACK).

Example: TOMS ticket `21027094`, booked by Sergio on 22 September, a bond bought from TELEFONICA. In OpenSearch, open each result with the arrow and use the JSON tab.

### Step 1. Input: the TOMS XML

```
Event.Type: "TradeEvent" and "21027094"
```

It returns 3 results. The ticket number also appears in the events of its amend (`21027095`), which was booked later. Open the row whose `ContextId` ends in `21027094` and has the earliest time: `07:12:00.804`, `ContextId G39Y1319100021027094`, `LifecycleAction "New"`.

The XML is in `Event.TradeFeedXml`. Values used below:

```xml
<SecurityIdentifierFlag>8</SecurityIdentifierFlag>
<SecurityIdentifier>ES00000124C5</SecurityIdentifier>
<BuySellCoverShortFlag>B</BuySellCoverShortFlag>
<CustomerAccountCounterparty>TELE</CustomerAccountCounterparty>
<AccruedInterestRepoInterest>92558.9</AccruedInterestRepoInterest>
<NumberOfDaysAccrued>328</NumberOfDaysAccrued>
<SettlementLocationAbbreviation>ST</SettlementLocationAbbreviation>
<InvertFlag>N</InvertFlag>
<TransactionType>TT</TransactionType>
```

### Step 2. Payload sent to STP Hub

```
Event.Type: "PublishingStpHubEvent" and "21027094"
```

It returns 2 results. Open the one with `ContextId G39Y1319100021027094` (07:12:00.992). The other is the amend.

The payload is in `Event.Payload`. Values used below:

```json
"EventType":"New"
"MessageId":"20d23472ced94447b643cced7164120c"
"Side":"Buy"
"Counterparty":{"Glcs":"TELE","Type":"Bank"}
"Instrument":{"Id":"ES00000124C5","IdType":"ISIN"}
"Settlement":{"InvertFlag":"N","SettlementLocation":"ST"}
"AccruedDays":328
"AccruedInterest":92558.9
```

Copy the `MessageId`. The ACK does not contain the trade ID, so you search it by `MessageId`.

### Step 3. ACK from STP Hub

```
"20d23472ced94447b643cced7164120c"
```

It returns 2 results: the payload from step 2 and the ACK. Open the ACK (`07:12:01.609`):

```
Event.Type:        StpHubAcknowledgementReceived
Status:            "OK"
AcknowledgedMsgId: 20d23472ced94447b643cced7164120c
ContextId:         null
```

`Status: "OK"` means STP Hub accepted the message.

### Step 4. Compare input, payload and story

| Input XML (step 1) | Payload (step 2) | Story |
|---|---|---|
| `NumberOfDaysAccrued 328` | `AccruedDays 328` | DWU-417 |
| `AccruedInterestRepoInterest 92558.9` | `AccruedInterest 92558.9` | DWU-417 |
| `SettlementLocationAbbreviation ST` | `Settlement.SettlementLocation "ST"` | DWU-417 |
| `InvertFlag N` | `Settlement.InvertFlag "N"` | DWU-417 |
| `BuySellCoverShortFlag B` | `Side "Buy"` | DWU-418 |
| `SecurityIdentifierFlag 8` | `Instrument.IdType "ISIN"` | DWU-418 |
| `CustomerAccountCounterparty TELE` | `Counterparty.Glcs "TELE"` | DWU-418 |

All values match the stories and the ACK is `OK`, so there is no bug. Before 22 September, `AccruedDays` and `AccruedInterest` were published as 0 (bug DWU-616) and the two settlement fields as null (DWU-617). This trade was the retest of both.

### Tradeweb trades

Use the same commands with the Tradeweb ID, without `Tradeweb$`. Example, the outright of 22 September:

```
Event.Type: "PublishingStpHubEvent" and "20260922.SAN3.EUGV.2237"
```

For a switch or a butterfly, search each leg ID separately, for example `20260922.SAN3.EUGV.2238` and then `20260922.SAN3.EUGV.2239`.

### When a record is missing

No payload in step 2 means Darwin rejected it before sending. Example, TOMS ticket `21027091`:

```
Event.Type: "StpHubPayloadValidationFailed" and "21027091"
```

Result: "STP Hub payload validation failed for trade 'BloombergToms$21027091': field 'Mifid.Transparency' is invalid".

If step 3 returns only the payload, STP Hub may have rejected it (NACK). A NACK cannot be found by `MessageId`. Example, TOMS ticket `21027097`, a future:

```
Event.Type: "StpHubAcknowledgementReceived" and Level: Warning
```

Result: `Status: "ERROR"` and the reason, for example `/PostTradeEvent/Trade/Price/Yield: null found, number expected`.

For other warnings on a trade:

```
"21027097" and Level: Warning
```

---

## 4. Example: DWU-644

1. Report. Fation, 18 September, in the chat: "bug is the BrokerComission.Amount appears as null and the transactioncost in the toms message is informed".

2. Trade: TOMS ticket `21023156`.

3. Input XML:
```xml
<ClearingBroker>6ATE</ClearingBroker>
<TransactionCosts>
  <TransactionCost><Type>1</Type><Currency>EUR</Currency><Cost>1200.0</Cost></TransactionCost>
</TransactionCosts>
```

4. Payload:
```json
"Broker":{"BrokerCode":"6ATE","BrokerCommission":{"Amount":null}}
```

5. Story DWU-417, mapping table:

| StpHub field | Rule |
|---|---|
| `PostTradeEvent.Trade.Broker.BrokerCommission.Amount` | If TOMS fields ClearingBroker and `<TransactionCost><Type>2</Type>` are populated map `<Cost>` |

The trade has a broker and a cost of 1200, and the payload publishes the commission as `null`. That is the bug.

The XML has cost Type 1 and the rule says Type 2. In a case like this, raise the bug and ask Fation about the rule separately in the chat. The question does not go in the bug.

6. The bug as it was raised:
```
[Bug] TOMS post-trade: BrokerCommission.Amount is published as null when the TOMS transaction cost is informed

* Environment: UAT2

Overview
DWU-417 maps PostTradeEvent.Trade.Broker.BrokerCommission.Amount from the TOMS transaction cost when ClearingBroker and that cost are populated. On BloombergToms$21023156 the payload publishes "BrokerCommission":{"Amount":null}, while the TOMS message carries a transaction cost of 1200.0 EUR and "BrokerCode":"6ATE" on the same payload, which is mapped from ClearingBroker.

Actual result: BrokerCommission.Amount is published as null.

Expected result: BrokerCommission.Amount carries the <Cost> value from the TOMS transaction cost, 1200.0.

Evidence:
(screenshot of the payload in OpenSearch)
```

7. Retest after the fix: ticket `21027098`, the example in section 3. The amount is published as `1200.0` and the ACK is `OK`. The bug was closed with a PASSED comment.

### Second example: DWU-651

- Sergio reported that tickets `21027084` and `21027091` did not arrive in STP Hub.
- There was no payload. `StpHubPayloadValidationFailed` showed "field 'Mifid.Transparency' is invalid". The payload had `"Transparency":["LRGS","RPRI"]`, and `RPRI` is not in the value list of DWU-415.
- Murat asked for a Jira. It was raised as DWU-651.

---

## 5. Raising the bug in Jira

| Jira field | Value |
|---|---|
| Issue type | Bug |
| Parent | DWU-434, Post Trade & Allocations Feeds to STPHub |
| Title | `[Bug] <TOMS post-trade or Venue post-trade>: <field> is published as <wrong value>` |
| Body | Environment, Overview, Actual result, Expected result, Evidence, as in section 4 |
| Evidence | Screenshot of the payload, and of the XML if you compared against it |

- Include the story and the trade ID in the Overview.
- Do not add steps to reproduce, explanations or open questions. Questions go in the chat.
- Post the Jira link in the chat.

To get a trade:
- Tradeweb: send it yourself. First switch TWB to UAT2 in TeamCity and tell the Bonds EU team in the `Darwin | Bonds | UAT` chat.
- TOMS or Bloomberg: ask Sergio, and tell him exactly what you need (bond or future; new, amend or cancel; fields that must be populated).

---

## 6. Priorities next week

The priority is STP Hub. Start with `IN QA`, then `READY FOR QA`.

`IN QA`:

| Ticket | What it is | What is missing |
|---|---|---|
| DWU-416 / 417 / 418 | TOMS field mapping | Mostly verified with the 22 September trades. DWU-417 needs ticket `21027291` (notes populated) booked again and published |
| DWU-508 | `CalculateSalesCredit` | Test cases written. Missing: switch and butterfly with the flag OFF |
| DWU-538 | Filter for TOMS trades coming back from Darwin | Positive case not available in UAT2 |
| DWU-550 | Amundi/UBS allocation flow | Needs `Allocation Reporting` ON and a `CBOA` client account in Tradeweb |
| DWU-624 | `TraderUuid` | Tradeweb outright with a trader that has one Bloomberg code |

`READY FOR QA`:

| Ticket | What it is |
|---|---|
| DWU-649 | TOMS internal trade publication. Retest with Sergio; `Counterparty.Type` must be `Bank` |
| DWU-629 | Allocation `MarketCode`. Tradeweb outright with `Pre-Alloc` and 3 accounts |
| DWU-584 | TOMS internal trade workflow, together with DWU-649 |
| DWU-611 | Venue internal trades |
| DWU-551 | Calypso allocation flow |
| DWU-564 | Report to Sentinel, Amundi/UBS |
| DWU-559 | PT filter for SSA |
| DWU-631 | Retry for enrichment |
| DWU-432 | Replay from the Darwin UI. Last one |

Before testing in UAT2:
- Static data. On 23 September DevOps copied the static data from UAT to UAT2, and on 24 September every Quote Group had an empty Trader Group, so RFQs did not arrive. 19 Quote Groups were fixed; the 13 that use `Eugv` are still empty. If RFQs do not arrive, check Quote Group first.
- `InternalTradeId`. Do not check it until DWU-549 is deployed to UAT2 (Murat said Monday).
- Market hours. Tradeweb stops taking RFQs around noon, Mexico time.

---

## 7. Who to ask

Check the three records and the story first.

| Topic | Person |
|---|---|
| Something someone reported that you do not understand | The person who reported it |
| Environment, deployments, whether it is a code issue | Murat |
| What a story or field should do | Fation |
| TOMS or Bloomberg trades, STP Hub side | Sergio |
| Testing on the STP Hub engine side | José María |

Ask in the `Darwin - STP Hub Validation` chat.
