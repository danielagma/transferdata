Feature: Escalator View: Add scrollbar & Recenter Control to Ladder Widget (DWU-318)
  As a trader
  I want to scroll through the Ladder and quickly return to the current market
  So that I can review different price levels and instantly navigate back to the active trading area

  Background:
    Given the user is logged into Darwin
    And a Market Depth Escalator (Ladder) widget is open for a selected bond

  # Covers AC1, AC4, AC6
  Scenario: Initial load centers on the best available price levels
    When the Ladder widget finishes loading
    Then a vertical scroll bar is successfully displayed on the right side of the grid
    And a Recenter button (target icon) is displayed next to the cancellation controls
    And the default view is automatically centered, displaying the current best bid and best ask price levels

  # Covers AC2, AC3
  Scenario: Safe navigation through price levels using the vertical scroll bar
    Given the user has active orders placed on specific price levels in the Ladder
    When the user scrolls up and down using the vertical scroll bar
    Then the trader can successfully navigate and view all available price levels
    And the scrolling action updates the visible UI only
    And live market data continues to stream and update without freezing
    And no active orders are modified, interrupted, or cancelled during the scroll

  # Covers AC5, AC7, AC8
  Scenario: Recenter button instantly snaps view to current market without impacting orders
    Given the user has active orders placed in the Ladder
    And the user has scrolled far away from the current market best bid and ask
    When the user clicks the Recenter button
    Then the Ladder view instantly returns to the default market centered position (best bid and best ask visible)
    And the recenter action is strictly a UI navigation event
    And no active orders are modified or cancelled by this action
