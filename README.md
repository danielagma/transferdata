Feature: Allow User Customization of Quantity Bar Values (DWU-260)
  As a trader
  I want to configure the quantity bar values shown in the Escalator Market Depth widget
  So that the preset quantities match my specific trading preference

  Background:
    Given the user is logged into Darwin
    And the Escalator Market Depth widget is open

  # Covers AC1, AC4, AC5
  Scenario: Navigation to settings and default values verification
    When the user navigates to "Settings" -> "Order Management" -> "Fast Size Buttons"
    Then the Fast Size Buttons configuration page is successfully displayed
    And the newly created configuration displays the default values: 1, 5, 10, 25, 50, and 100
    And the configuration is tied specifically to the current user profile

# Covers AC9, AC13
  Scenario: Validation restricts invalid data types, zero, negative numbers, and duplicates
    Given the user is on the Fast Size Buttons settings page
    When the user attempts to enter invalid values (e.g., decimals, 0, negative numbers, letters, or duplicate quantities)
    Then the system triggers the appropriate validation error messages (e.g., "Must be an integer number", "Must not be zero")
    And the system strictly prevents saving the configuration

  # Covers AC8
  Scenario: Validation strictly enforces button quantity limits
    Given the user is on the Fast Size Buttons settings page
    When the user attempts to save a configuration with 0 buttons or more than 6 buttons
    Then the system triggers a validation error message
    And the system prevents saving the configuration

  # Covers AC10, AC2, AC3, AC12
  Scenario: Auto-sorting logic and real-time Escalator widget update
    Given the user is on the Fast Size Buttons settings page
    When the user enters valid quantity values in a random, non-sequential order (e.g., 50, 5, 100, 10)
    And the user saves the configuration
    Then the system automatically sorts and saves the values in ascending numerical order from left to right
    And the configured values immediately replace the default buttons in the active Escalator widget without requiring a restart

  # Covers AC11
  Scenario: Quantity bar maintains strict width and visual layout with fewer than 6 buttons
    Given the user is on the Fast Size Buttons settings page
    When the user successfully configures and saves fewer than 6 quantity values (e.g., 4 values)
    Then the quantity bar in the Escalator widget consistently occupies its original full width
    And the unused button positions (e.g., the last 2 slots) remain visually blank

  # Covers AC6
  Scenario: User-defined quantity values persist across platform sessions
    Given the user has successfully saved a custom Fast Size Buttons configuration
    When the user closes and reopens the Escalator widget
    And the user logs out and logs back into the Darwin platform
    Then the custom quantity values strictly persist and are displayed accurately in the Escalator widget

  # Covers AC7
  Scenario: Custom preset quantity buttons successfully apply to order execution
    Given the Escalator widget displays a custom configured quantity button
    When the user selects the custom quantity button
    And the user submits an order from the Escalator widget
    Then the system applies the exact customized quantity to the generated order
