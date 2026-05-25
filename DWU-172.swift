Feature: Ladder View - Quantity Bar Passive Order Submission (DWU-172)

  As a trader
  I want to execute passive orders directly from the Escalator view using a single click
  So that I can place resting orders without additional steps and execution latency

  Background:
    Given the user has logged into Darwin
    And the user navigates to the "Order Management" screen
    And the user opens the Escalator View for a selected instrument

  # Scenario 1: Successful submission of a passive Buy order
  # Covers AC1, AC2, AC3, AC4 and AC6
  Scenario: Successful submission of a passive Buy order
    Given the VWAP mode is disabled
    And the user selects a quantity
    When the user clicks on the Buy column at a price level within the Bid zone
    Then the system submits a passive Buy order
    And a green confirmation banner is displayed
    And the Bid quantity is updated with the new volume
    And the own order indicator is displayed for that price

  # Scenario 2: Successful submission of a passive Sell order
  # Covers AC1, AC2, AC3, AC4 and AC6
  Scenario: Successful submission of a passive Sell order
    Given the VWAP mode is disabled
    And the user selects a quantity
    When the user clicks on the Sell column at a price level within the Ask zone
    Then the system submits a passive Sell order
    And a green confirmation banner is displayed
    And the Ask quantity is updated with the new volume
    And the own order indicator is displayed for that price

  # Scenario 3: Block passive order submission when VWAP is active
  # Covers AC5
  Scenario: Block passive order submission when VWAP is active
    Given the VWAP mode is enabled
    And the user selects a quantity
    When the user clicks on any column at a price level
    Then the system does not submit any order
    And a confirmation banner is not displayed
    And the market quantities and price levels remain unchanged
