Feature: Fast Order Cancellation Buttons in Market Depth Widget (DWU-284)
  As a trader
  I want to cancel my active orders directly from the Market Depth Ladder
  So that I can manage my orders without opening another screen

  Background:
    Given the user is logged into Darwin
    And the user navigates to the "Order Management" screen
    And the user opens an Escalator Market Depth widget for a selected instrument

# Covers AC1 and AC9
  Scenario: Visibility of the cancellation trash icon is strictly bound to own active orders
    Given the logged-in trader has active working orders at one or more price levels
    When the user observes the active orders column in the Escalator Market Depth widget
    Then a trash icon is displayed inline on every price level row where the trader has an active order
    And the trash icon is completely absent from any price level row where the trader does not have active orders

  # Covers AC3, AC7, AC8 and AC10
  Scenario: Immediate cancellation of a single active order
    Given the trader has exactly one active working order at a specific price level
    When the user single-clicks the trash icon on that price level
    Then the cancellation request is processed immediately
    And a green confirmation banner is displayed confirming the order cancellation
    And the active order is removed from the dedicated own orders column
    And the trash icon disappears from that price level
    And the Order Blotter updates dynamically to reflect the cancelled status
    And the market depth quantities belonging to other traders remain entirely unaffected

  # Covers AC2, AC4 and AC7
  Scenario: LIFO cancellation of multiple aggregated orders at the same price level
    Given the trader has successfully submitted "Order A" at a specific price level
    And the trader subsequently submits "Order B" at that exact same price level
    When the user single-clicks the trash icon on that price level once
    Then the system immediately cancels "Order B" applying Last-In-First-Out (LIFO) logic
    And "Order A" remains active in the dedicated own orders column
    And the trash icon remains visible on that price level
    When the user single-clicks the trash icon again
    Then the system successfully cancels "Order A"
    And the trash icon disappears from that price level
    And the Order Blotter updates dynamically to reflect both cancellations
