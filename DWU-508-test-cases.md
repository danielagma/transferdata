# DWU-508 · Test cases y plantilla de cierre

Fuente: [`stories/DWU-508.md`](../../stories/DWU-508.md), captura del ticket del 2026-09-07 (8 AC), más las
respuestas escritas de Fation antes del grooming (addendum 2026-09-11), la llamada de grooming del
2026-08-26 (addendum 2026-09-13) y su aclaración de multi-leg en el chat `Darwin - STP Hub Validation`
del 2026-09-24 2:47.

**Cada escenario lleva `# Covers AC n` o `# Source:` con su origen.** Las líneas marcadas `# INFERENCIA`
son lectura de QA, no texto del ticket.

## Antes de ejecutar

- **El ticket se contradice entre AC 1 y AC 5.** AC 1: *"Add a new Field in all trade payloads for D2C,
  D2D **and Allocation** events"*. AC 5: *"For Allocation trade payloads… **do not add the field**"*.
  Lo resuelve el comentario de Fation del 27-ago en el propio ticket: *"Do not add…
  CalculateSalesCredit at the Allocations events, is not needed"*. Los casos siguen a AC 5.
- **AC 7 no es observable desde Darwin.** El schema es de STP Hub. Lo único que se ve es que el campo va
  siempre presente y booleano, y que STP Hub responde `OK`. Ver el escenario marcado.
- **AC 6 (D2D) no se puede ejecutar hoy.** La integración D2D está parada del lado de ORCA (Fation,
  daily del 2026-09-22). El escenario queda escrito y bloqueado.
- **El toggle es compartido.** Antes de tocar `Darwin Calc'n`, capturar su estado y devolverlo al final.

## Test cases

```gherkin
Feature: CalculateSalesCredit field in the PostTradeEvent payload for D2C trades (DWU-508)
  As the STP Hub
  I need Darwin to send PostTradeEvent.Trade.Counterparty.CalculateSalesCredit on every D2C trade
  So that STP Hub knows whether to calculate the sales credit for that counterparty and product class

  Background:
    Given the environment is UAT2
    And the Darwin Trade Service is publishing trade payloads to STP Hub
    And the static screen is BONDS > TRADE REFERENCE DATA > Counterparty Relationship Maintenance
    # INFERENCIA: the observable is the PublishingStpHubEvent log, as in every sign-off of DWU-419/420

  # Covers AC 1, AC 2, AC 3, AC 4
  Scenario Outline: D2C venue trade takes the flag from the Darwin Calc'n static
    Given the Counterparty Relationship row for counterparty "<glcs>" and product class "<class>" has "Darwin Calc'n" set to "<static>"
    When a Tradeweb D2C RFQ is executed against counterparty "<glcs>" on a "<class>" instrument
    Then the PublishingStpHubEvent payload contains "Counterparty.Glcs" equal to "<glcs>"
    And the payload contains "Instrument.Class" equal to "<class>"
    And the payload contains "Counterparty.CalculateSalesCredit" equal to <payload>
    And the value is a boolean, not the string "yes" or "no"

    Examples:
      | glcs | class | static | payload |
      | TELE | GILTS | Yes    | true    |
      | TELE | GILTS | No     | false   |

  # Covers AC 3
  Scenario: The lookup key is the combination of GLCS code and product class
    Given a counterparty has two Counterparty Relationship rows with different product classes
    And "Darwin Calc'n" is "Yes" on one product class and "No" on the other
    When a D2C trade is executed against that counterparty on an instrument of each product class
    Then each payload carries the CalculateSalesCredit value of the row matching its own product class
    # INFERENCIA: needs a counterparty with rows of opposite value. In DEV1 BSTE had EUROBONDS = Yes and
    # GILTS = No; that row set has not been checked in UAT2

  # Covers AC 2
  Scenario: A static change takes effect on the next RFQ without restarting any service
    Given a D2C trade was executed with "Darwin Calc'n" set to "No" and published CalculateSalesCredit false
    When "Darwin Calc'n" is changed to "Yes" and saved
    And a new RFQ is executed against the same counterparty and product class, with no service restart
    Then the new payload contains "Counterparty.CalculateSalesCredit" equal to true
    # Source: grooming 2026-08-26, Fation "it takes effect on next [RFQ]", Murat "no need for service restart"

  # Covers AC 2
  Scenario: TOMS D2C trade takes the flag from the Darwin Calc'n static
    Given the Counterparty Relationship row for the TOMS trade's counterparty and product class has "Darwin Calc'n" set to "No"
    When a TOMS manual entry trade is booked and published to STP Hub
    Then the payload contains "Counterparty.CalculateSalesCredit" equal to false
    # AC 2 names "transficc and toms events" explicitly

  # Covers AC 2
  # Source: Fation, chat Darwin - STP Hub Validation, 2026-09-24 2:47
  Scenario Outline: Every leg of a multi-leg trade carries the same flag
    Given "Darwin Calc'n" is "<static>" for the counterparty and product class of the trade
    When a Tradeweb "<structure>" is executed
    Then every leg's PublishingStpHubEvent payload contains "Counterparty.CalculateSalesCredit" equal to <payload>
    # Fation: "Darwin reports the flag on all the legs, STP hub will do the bit of work to identify only
    # one leg with true… set it the same in all legs for a multileg"

    Examples:
      | structure | static | payload |
      | Switch    | Yes    | true    |
      | Switch    | No     | false   |
      | Butterfly | Yes    | true    |
      | Butterfly | No     | false   |

  # Covers AC 3
  # Source: written answers before grooming, addendum 2026-09-11
  Scenario: A GLCS and product class combination with no static row publishes false
    Given there is no Counterparty Relationship row for the trade's counterparty and product class
    When the D2C trade is published
    Then the payload contains "Counterparty.CalculateSalesCredit" equal to false
    And a warning is logged
    And the trade is still published
    # INFERENCIA: the warning's Event.Type is not named anywhere; search the trade id with Level: Warning

  # Covers AC 5
  Scenario: Allocation payloads do not carry the field
    Given a D2C trade is executed with allocations to more than one account
    When the allocation event is published to STP Hub
    Then the PostTradeEvent.Allocations payload does not contain a "CalculateSalesCredit" field

  # Covers AC 6
  # BLOCKED: D2D integration on hold on the ORCA side (Fation, daily 2026-09-22)
  Scenario: D2D trade payloads default the flag to false
    Given a D2D trade is received
    When its PostTradeEvent.Trade payload is published to STP Hub
    Then the payload contains "Counterparty.CalculateSalesCredit" equal to false
    And the value does not depend on the Darwin Calc'n static
    # Source: grooming 2026-08-26, "In D2D, there is no sales people"

  # Covers AC 1, AC 7
  Scenario: The field is always present and STP Hub accepts it
    Given any D2C or D2D trade payload published to STP Hub
    Then "Counterparty.CalculateSalesCredit" is present and is true or false, never null or missing
    And STP Hub acknowledges the message with Status OK
    # INFERENCIA: AC 7 is about the STP Hub JSON schema, which Darwin does not own. An ACK OK on a payload
    # carrying the field is the only evidence observable from our side

  # Covers AC 8
  Scenario Outline: No regression on the other trade types
    When a "<trade>" is executed and published
    Then STP Hub acknowledges it with Status OK
    And the rest of the payload is unchanged by the new field

    Examples:
      | trade                    |
      | Tradeweb Outright        |
      | Tradeweb Switch          |
      | Tradeweb Butterfly       |
      | TOMS manual entry trade  |
      | TOMS amend               |
      | TOMS cancel              |
```

## Plantilla de cierre

**Es una plantilla, no una afirmación.** Cada `PASSED ✅` es algo que vas a afirmar en el ticket cuando
hayas corrido los casos. Las secciones que no se hayan ejecutado se quitan o se pasan a `Not covered`.

```
### **QA Execution: PASSED ✅**
* **Environment:** UAT2
* **Trades under test:** [ids]

**Execution Summary:**
CalculateSalesCredit is published on D2C trade payloads with the value of the Darwin Calc'n flag of the Counterparty Relationship static, looked up by GLCS code and product class. It is omitted from allocation payloads and does not affect the other trade types.

---
### 1. Value taken from the Darwin Calc'n static (AC 1, AC 2, AC 3, AC 4) - **PASSED ✅**
| Trade | Glcs | Class | Darwin Calc'n | CalculateSalesCredit |
|---|---|---|---|---|
| [id] | TELE | GILTS | Yes | **true** |
| [id] | TELE | GILTS | No | **false** |

The change in the static took effect on the next RFQ with no service restart.

### 2. TOMS trades (AC 2) - **PASSED ✅**
[id]: Darwin Calc'n No, CalculateSalesCredit **false**.

### 3. Multi-leg trades (AC 2) - **PASSED ✅**
Every leg of the switch and the butterfly carries the same value, as agreed with Fation: switch [ids], butterfly [ids].

### 4. Allocation payloads (AC 5) - **PASSED ✅**
[id]: the PostTradeEvent.Allocations payload does not contain CalculateSalesCredit.

### 5. Field presence and STP Hub acknowledgement (AC 7, AC 8) - **PASSED ✅**
The field is present and boolean on every payload above, and STP Hub acknowledged each one with Status OK.

---
### 6. Not covered in this cycle
**AC 6 (D2D default):** D2D integration is on hold on the ORCA side.

---
**Sign-off:** [Approved to close / Approved to close except AC 6].
@Murat Guney
```
