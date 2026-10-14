Feature: Amundi and UBS allocation flow (DWU-550)

  Background:
    Given the environment is UAT2
    And the trades are Tradeweb GILTS outrights against TELE
    And "Calypso Flow" is off on the row TELE / GILTS
    And the "Allocation Reporting" value of TELE / GILTS is captured before each trade and set back to No at the end

  # Covers AC 1, AC 10
  Scenario: Allocation Reporting off publishes the trade immediately
    Given the row TELE / GILTS shows an "Allocation Reporting" True/False toggle
    And "Allocation Reporting" is No on TELE / GILTS
    When a Tradeweb GILTS outright pre-allocated to Test 1 and Test 2 is executed
    Then the trade payload is published with no waiting period
    And Counterparty.Glcs is "TELE"
    And the allocation payload is published to STP Hub as before

  # Covers AC 4, AC 5, AC 8
  Scenario: No allocation within the waiting period publishes with the original counterparty
    Given "Allocation Reporting" is Yes on TELE / GILTS
    When a Tradeweb GILTS outright is executed with no allocation
    Then no trade payload is published during the waiting period
    And one trade payload is published about 100 seconds after the trade event
    And Counterparty.Glcs is "TELE"

  # Covers AC 7
  Scenario: Allocation with a fund not in the mapping keeps the original counterparty
    Given "Allocation Reporting" is Yes on TELE / GILTS
    And no mapping row exists for TELE with fund Test 1 or Test 2
    When a Tradeweb GILTS outright pre-allocated to Test 1 and Test 2 is executed
    Then one trade payload is published after the allocation event and before the 100 seconds end
    And Counterparty.Glcs is "TELE"
    And no allocation payload is published to STP Hub for that trade

  # Covers AC 6
  Scenario: Allocation with a mapped fund migrates the counterparty
    Given "Allocation Reporting" is Yes on TELE / GILTS
    And the mapping row TELE | Test 2 | <migration value> is seeded and the service was restarted
    When a Tradeweb GILTS outright pre-allocated to Test 2 is executed
    Then one trade payload is published after the allocation event and before the 100 seconds end
    And Counterparty.Glcs is "<migration value>"
    And no allocation payload is published to STP Hub for that trade

  # Covers AC 9
  Scenario: Only the first allocation fund is validated
    Given "Allocation Reporting" is Yes on TELE / GILTS
    And the mapping row TELE | Test 2 | <migration value> is seeded and no row exists for Test 1
    When a Tradeweb GILTS outright pre-allocated first to Test 1 and then to Test 2 is executed
    Then exactly one trade payload is published
    And Counterparty.Glcs is "TELE"

  # Covers AC 11
  Scenario: An allocation after the waiting period is ignored
    Given "Allocation Reporting" is Yes on TELE / GILTS
    And a Tradeweb GILTS outright with no allocation was published about 100 seconds after the trade event
    When an allocation for that trade is sent after the publication
    Then no second trade payload is published for that trade
    And the published Counterparty.Glcs stays "TELE"
```
