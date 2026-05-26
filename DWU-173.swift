Feature: Ladder View - Aggressive Order Submission (DWU-173)

  As a trader
  I want to execute aggressive orders directly from the Escalator view using a single click
  So that I can immediately take liquidity at a selected price level in fast-moving markets

  Background:
    Given the user has logged into Darwin
    And the user navigates to the "Order Management" screen
    And the user opens the Escalator View for a selected instrument

  # Scenario 1: Execution of an aggressive Buy order
  # Covers AC1, AC2, AC3, AC4 and AC6
  Scenario: Successful submission of an aggressive Buy order
    Given the VWAP mode is disabled
    And the user selects a quantity
    When the user clicks on the Buy column at a price level within the Ask zone
    Then the system executes an aggressive Buy order immediately against available liquidity
    And a green confirmation banner is displayed
    And the UI updates dynamically to reflect the consumed liquidity and ladder shift

  # Scenario 2: Execution of an aggressive Sell order
  # Covers AC1, AC2, AC3, AC4 and AC6
  Scenario: Successful submission of an aggressive Sell order
    Given the VWAP mode is disabled
    And the user selects a quantity
    When the user clicks on the Sell column at a price level within the Bid zone
    Then the system executes an aggressive Sell order immediately against available liquidity
    And a green confirmation banner is displayed
    And the UI updates dynamically to reflect the consumed liquidity and ladder shift

  # Scenario 3: Block aggressive order execution when VWAP is active
  # Covers AC5
  Scenario: Block aggressive order submission when VWAP is active
    Given the VWAP mode is enabled
    And the user selects a quantity
    When the user clicks on the opposing column at any price level to aggress
    Then the system does not execute any order
    And a confirmation banner is not displayed
    And the market quantities and ladder structure remain unchanged
