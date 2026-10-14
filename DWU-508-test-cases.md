Feature: CalculateSalesCredit in the PostTradeEvent payload (DWU-508)

  Background:
    Given the environment is UAT2
    And the static screen is STATIC > TRADE REFERENCE DATA > Counterparty Relationship, field "Darwin Calc'n"
    And the "Darwin Calc'n" value of the row under test is captured on the day of the trade

  # DWU-656 · Covers AC 1, AC 2, AC 4, AC 8
  Scenario Outline: D2C venue trade takes the flag from the Darwin Calc'n static
    Given a <venue> outright is executed
    And its payload carries Counterparty.Glcs and Instrument.Class
    When the Counterparty Relationship row for that Glcs and product class is read
    Then PostTradeEvent.Trade.Counterparty.CalculateSalesCredit is present and is a boolean
    And it is true if the row shows "Darwin Calc'n" Yes, and false if the row shows No
    And STP Hub acknowledges the payload

    Examples:
      | venue      |
      | Tradeweb   |
      | Bloomberg  |
      | BondVision |

  # DWU-657 · Covers AC 3, AC 4
  Scenario: The lookup key is the combination of GLCS code and product class
    Given the row TELE / GILTS has "Darwin Calc'n" No
    And the row TELE / EUROGOVIES has "Darwin Calc'n" Yes
    When a GILTS trade and a EUROGOVIES trade are executed against TELE
    Then the GILTS payload carries CalculateSalesCredit false
    And the EUROGOVIES payload carries CalculateSalesCredit true

  # DWU-658 · Covers AC 2, AC 4
  Scenario: A static change takes effect on the next RFQ without restarting any service
    Given the row TELE / GILTS has "Darwin Calc'n" No
    And a Tradeweb GILTS outright against TELE publishes CalculateSalesCredit false
    When "Darwin Calc'n" is set to Yes on TELE / GILTS and saved
    And a new Tradeweb GILTS outright against TELE is executed with no service restart
    Then the new payload carries CalculateSalesCredit true

  # DWU-659 · Covers AC 1, AC 2, AC 8
  Scenario: TOMS D2C trade takes the flag from the Darwin Calc'n static
    Given a TOMS manual trade is booked, then amended and cancelled
    And its payloads carry Counterparty.Glcs and Instrument.Class
    When the Counterparty Relationship row for that Glcs and product class is read
    Then CalculateSalesCredit is present and is a boolean in the New, Amend and Cancel payloads
    And it is true if the row shows Yes, and false if the row shows No
    And STP Hub acknowledges each payload

  # DWU-660 · Covers AC 2
  Scenario Outline: Every leg of a multi-leg trade carries the same flag
    Given the row TELE / GILTS has "Darwin Calc'n" set to <static>
    When a Tradeweb GILTS <structure> is executed against TELE
    Then the payload of every leg carries CalculateSalesCredit <value>

    Examples:
      | structure | static | value |
      | switch    | Yes    | true  |
      | switch    | No     | false |
      | butterfly | Yes    | true  |
      | butterfly | No     | false |

  # DWU-662 · Covers AC 5
  Scenario: Allocation payloads do not carry the field
    Given "Allocation Reporting" and "Calypso Flow" are off on the row TELE / GILTS
    When a Tradeweb GILTS outright pre-allocated to Test 1 and Test 2 is executed
    Then the PostTradeEvent.Allocations payload is published
    And it does not contain a CalculateSalesCredit field

  # DWU-663 · Covers AC 1, AC 6
  Scenario: D2D trade payloads default the flag to false
    Given a D2D order is filled in ORCA
    When its PostTradeEvent.Trade payload is published
    Then CalculateSalesCredit is present and is false
    And the value is false whatever the "Darwin Calc'n" value of its counterparty row
```
