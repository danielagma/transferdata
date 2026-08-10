Feature: Hidden View Functionality of Escalator View in Market Widget (DWU-283)
  As a trader
  I want to expand or collapse the additional order entry controls within the Market Depth widget
  So that I can reduce screen space usage when those controls are not needed

  Background:
    Given the user is logged into Darwin
    And a Market Depth Escalator (Ladder) widget is open for a selected bond

  # Covers AC1, AC4, AC9 (Second part)
  Scenario: Default compact state of a newly opened Escalator widget
    When the user opens a completely new Market Depth widget
    Then an accordion control icon is displayed at the bottom right of the widget
    And the accordion defaults to a closed (compact) state
    And the ladder section, quantity bar, and cancellation controls are fully visible
    And the additional order entry controls are hidden from view

  # Covers AC2, AC5
  Scenario: Expanding the accordion to reveal additional order entry controls
    Given the accordion control is currently in a closed state
    When the user clicks the accordion control icon
    Then the additional controls section successfully expands beneath the ladder
    And the following controls are displayed: Book, Order Type, Time in Force, VWAP, and Pause
    And the ladder section remains fully visible above the expanded controls

  # Covers AC3, AC4
  Scenario: Collapsing the accordion hides additional controls
    Given the accordion control is currently in an expanded state
    When the user clicks the accordion control icon again
    Then the additional controls section successfully collapses
    And the Book, Order Type, Time in Force, VWAP, and Pause controls are hidden
    And the ladder section, quantity bar, and cancellation controls remain fully visible

  # Covers AC6, AC7, AC8
  Scenario: Accordion state changes do not refresh the widget or clear user data
    Given the user has populated the widget with active values (e.g., selected a quantity, changed Order Type to MKT, and manually entered a Book)
    And real-time market data is streaming in the ladder
    When the user toggles the accordion control multiple times (expands and collapses)
    Then the widget does not refresh or reload at any point
    And the live market data streaming remains uninterrupted
    And all manually entered values, selected quantities, and active orders remain completely intact and unchanged

  # Covers AC9 (First part)
  Scenario: Accordion state persists across user sessions
    Given the user expands the accordion control
    And the user saves the layout/widget settings
    When the user reloads the Darwin platform or logs out and back in
    Then the system remembers the exact state the user left it in
    And the accordion control successfully renders in the expanded state upon reloading
