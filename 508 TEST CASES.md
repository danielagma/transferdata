# QA Test Cases: DWU-508

Feature: Add CalculateSalesCredit field payload for D2C trades (DWU-508)
  As a trading system
  I need to include a CalculateSalesCredit boolean in the PostTradeEvent payload
  So that downstream systems know whether to calculate sales credit based on static data

  Background:
    Given the Darwin Trade Service is running
    And static data contains configured Counterparty Relationships with the "Darwin Calc'n" flag

  # Covers AC1, AC2, AC3, AC4
  Scenario Outline: D2C Trade payload populates CalculateSalesCredit based on static data
    Given a Counterparty Relationship exists for a specific GLCS code and Product Class
    And the "Darwin Calc'n" flag is set to "<ui_flag_value>"
    When a D2C trade matching this relationship is executed and the payload is assembled
    Then the PostTradeEvent.Trade.Counterparty payload includes the CalculateSalesCredit field
    And the value is strictly set to the boolean <json_value>

    Examples:
      | ui_flag_value | json_value |
      | yes           | true       |
      | no            | false      |

  # Covers AC6
  Scenario: D2D Trades default to false
    Given a Direct-to-Dealer (D2D) trade is executed
    When the PostTradeEvent.Trade payload is assembled
    Then the CalculateSalesCredit field is included in the payload
    And the value defaults unconditionally to false

  # Covers AC5
  Scenario: Allocation events strictly omit the CalculateSalesCredit field
    Given a trade allocation event occurs
    When the PostTradeEvent.Allocations payload is assembled
    Then the CalculateSalesCredit field is NOT added to the event payload