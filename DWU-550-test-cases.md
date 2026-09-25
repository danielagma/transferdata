# DWU-550 · Test cases (versión 2, 2026-09-24)

Fuente: [`stories/DWU-550.md`](../../stories/DWU-550.md), tabla de 15 AC del ticket, tabla de mapeo legacy
de Fation (24-ago) y el análisis de UAT2 del 2026-09-21.

**Sustituye a la versión del 2026-09-09** (24 escenarios, en el historial de git). Ahora son **6
escenarios, uno por trade**, sólo lo que QA ejecuta en UAT2. Las líneas `# INFERENCIA` son lectura de QA,
no texto del ticket.

## Lo que no ejecuta QA · se pide como evidencia de desarrollo

| AC | Qué pide | Por qué no es de QA |
|---|---|---|
| 2 | la tabla de mapeo en base de datos, columnas y filas | acceso a base de datos |
| 3 | el parámetro de espera, 100 s por defecto, configurable | configuración del servicio |
| 12 | caída de la base de datos durante el lookup | hay que simular el fallo |
| 14 | actualizar el mapeo por seeding, con reinicio | scripts y reinicio del servicio |
| 15 | enmienda manual de back office, con reinicio | reinicio del servicio |

## Antes de ejecutar

- **Contraparte.** La contraparte del trade la decide la cuenta de cliente de Tradeweb. Con la de
  Daniel sale `TELE`, y `TELE` no está en la tabla de mapeo. **Los escenarios 1, 4 y 5 salen con
  `TELE`; los 2, 3 y 6 necesitan una cuenta de cliente `CBOA`** (las 15 filas del mapeo son de `UAMZ` y
  `CBOA`).
- **Nombre del fondo.** El match es literal contra la tabla (`ALLIANZ D300 GOVEUR`, `AMUNDI C100 SRK1/1`…).
  Las cuentas de allocation de Tradeweb tienen que llamarse así.
- **Toggle compartido.** Capturar el estado de `Allocation Reporting` antes y devolverlo al final.
- **El escenario 6** depende de que Tradeweb deje mandar una allocation con el fondo vacío o inválido.
  Si no, pasa a desarrollo.

```gherkin
Feature: Amundi and UBS allocation flow, hold the STP Hub publication and migrate the counterparty (DWU-550)
  As the STP Hub
  I need Darwin to hold a trade for flagged counterparties until its allocation arrives
  So that the trade is published with the migrated counterparty of the allocation fund

  Background:
    Given the environment is UAT2
    And the static screen is BONDS > TRADE REFERENCE DATA > Counterparty Relationship Maintenance
    And the allocation waiting time is its default of 100 seconds
    # INFERENCIA: "held" is not logged by any named event. It is observed as the absence of
    # PublishingStpHubEvent during the window and its presence afterwards, comparing timestamps

  # Covers AC 1, AC 10
  Scenario: Allocation Reporting False publishes the trade immediately
    Given the Counterparty Relationship row of the trade's counterparty and product class shows an "Allocation Reporting" True/False toggle
    And "Allocation Reporting" is set to False on that row
    When a Tradeweb D2C trade is executed against that counterparty
    Then the trade is published to STP Hub immediately, with no waiting period
    And "Counterparty.Glcs" in the payload is the original counterparty

  # Covers AC 4, AC 5, AC 6
  Scenario: Allocation with a mapped fund migrates the counterparty
    Given "Allocation Reporting" is set to True for counterparty "CBOA" and the trade's product class
    When a Tradeweb D2C trade is executed against "CBOA" with an allocation to fund "AMUNDI C100 SRK1/1"
    Then the trade is not published before the allocation event arrives
    And after the allocation event arrives the trade is published once
    And "Counterparty.Glcs" in the payload is "009AQ7"
    # Mapping row from the ticket: CBOA | AMUNDI C100 SRK1/1 | 009AQ7
    # INFERENCIA: the allocation fund is read from Allocations[n].FundBreakdown, as in DWU-425

  # Covers AC 7
  Scenario: Allocation with a fund not in the mapping keeps the original counterparty
    Given "Allocation Reporting" is set to True for counterparty "CBOA" and the trade's product class
    When a Tradeweb D2C trade is executed against "CBOA" with an allocation to a fund that is not in the mapping table
    Then the trade is published once, after the allocation event arrives
    And "Counterparty.Glcs" in the payload is "CBOA"

  # Covers AC 8, AC 11
  Scenario: No allocation within the waiting period publishes with the original counterparty
    Given "Allocation Reporting" is set to True for the trade's counterparty and product class
    When a Tradeweb D2C trade is executed without allocation
    Then the trade is not published before the waiting period ends
    And the trade is published once, about 100 seconds after it was received
    And "Counterparty.Glcs" in the payload is the original counterparty
    When an allocation for that trade arrives after the waiting period
    Then the allocation does not change the published trade and no second trade is published
    # INFERENCIA: a late allocation from Tradeweb has to be produced by hand; if it cannot, AC 11 goes to dev

  # Covers AC 9
  Scenario: Several allocations use only the first one
    Given "Allocation Reporting" is set to True for the trade's counterparty and product class
    When a Tradeweb D2C trade is executed with allocations to three accounts
    Then the trade is published once
    And "Counterparty.Glcs" in the payload is the migration value of the first allocation fund, or the original counterparty if that fund is not mapped

  # Covers AC 13
  Scenario: Allocation with a missing or invalid fund keeps the original counterparty
    Given "Allocation Reporting" is set to True for counterparty "CBOA" and the trade's product class
    When a Tradeweb D2C trade is executed against "CBOA" with an allocation whose fund is missing or invalid
    Then the allocation is rejected
    And the trade is published once with "Counterparty.Glcs" equal to "CBOA"
    # INFERENCIA: the rejection is observed as TradeAllocationReceivedEventHandlerFailed
```

## Comandos

| Para qué | Comando |
|---|---|
| Payload del trade y su hora | `Event.Type: "PublishingStpHubEvent" and "<TRADE_ID>"` |
| La allocation recibida | `"<TRADE_ID>" and Event.Type: *Allocation*` |
| Allocation rechazada | `Event.Type: TradeAllocationReceivedEventHandlerFailed` |
| ACK | `"<MESSAGE_ID>"` |
