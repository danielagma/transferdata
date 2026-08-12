Feature: Fast Execution/Take Best Buttons in Market Depth Widget (DWU-414)
  As a trader
  I want to use Take Best buttons
  So that I can quickly submit an order at the current best available Buy or Sell price

  Background:
    Given the user is logged into Darwin
    And a Market Depth (Ladder) widget is open for a selected bond with active market data

  # Covers AC1, AC10, AC12
  Scenario: Take Best accordion default state and UI components
    When the user views the lower section of the Ladder widget
    Then a "Take Best" accordion section is displayed
    And the section is hidden (collapsed) by default
    And the accordion uses "+" and "-" icons for expand and collapse controls
    When the user expands the accordion
    Then one "Buy" button and one "Sell" button are displayed within the section

  # Covers AC2, AC3, AC4, AC7
  Scenario: Real-time data mapping and color customization
    Given the Take Best accordion is expanded
    When the system receives live market data
    Then the Buy button accurately displays the current best available Sell quantity and price
    And the Sell button accurately displays the current best available Buy quantity and price
    And the Buy button is styled with the application's "Bid" color
    And the Sell button is styled with the application's "Ask" color
    When the best available market prices or quantities change
    Then the displayed values on both buttons update immediately to reflect the new market state

  # Covers AC8
  Scenario: Disabled state when no executable price is available
    Given the market has no best executable price or quantity available for the Sell side
    When the user views the Take Best section
    Then the Take Best Buy button is automatically disabled and greyed out
    And the button cannot be clicked

  # Covers AC5, AC6, AC11
  Scenario: Fast execution order submission and default parameters
    Given the Take Best Buy and Sell buttons are active and displaying valid prices/quantities
    When the user clicks the Buy (or Sell) button
    Then a Buy (or Sell) order is instantly submitted using the exact quantity and price displayed on the button
    And the order payload automatically enforces the default Order Type "LMT"
    And the order payload automatically enforces the default Time in Force "FAK"

  # Covers AC9
  Scenario: Take Best buttons compatibility with VWAP mode
    Given the user enables VWAP mode on the Ladder widget
    When the user expands the Take Best section
    Then the Take Best buttons look exactly the same as in normal mode
    And the buttons remain fully functional for order submission
