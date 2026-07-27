Feature: Manual Quantity Input Field in Escalator Quantity Bar (DWU-261)
  As a trader
  I want to manually enter a custom quantity directly from the quantity bar
  So that I can quickly trade using quantities that are not available in the preset buttons

  Background:
    Given the user is logged into Darwin
    And the user opens an Escalator Market Depth widget for a selected instrument

  # Covers AC1, AC2 and AC3
  Scenario: Default state and saving a custom manual quantity
    Given the Escalator widget is displayed
    Then the "Man Qty" field is editable and empty by default
    When the user enters a valid integer into the "Man Qty" field
    And the user exits edit mode by pressing Enter or clicking outside the cell
    Then the custom quantity is saved and actively selected

  # Covers AC4 and AC6
  Scenario: Custom quantity selection overrides and unhighlights preset buttons
    Given the user has selected one or more preset quantity buttons
    And the selected preset buttons are highlighted with an orange background
    When the user enters and saves a custom quantity in the "Man Qty" field
    Then the "Man Qty" field is highlighted with an orange background
    And the orange highlight is immediately removed from all previously selected preset buttons

  # Covers AC5
  Scenario: Preset button selection overrides and clears the manual quantity
    Given the user has a custom quantity saved and highlighted in the "Man Qty" field
    When the user selects any preset quantity button
    Then the selected preset button is highlighted with an orange background
    And the orange highlight is removed from the "Man Qty" field
    And the numerical value within the "Man Qty" field is completely cleared

  # Covers AC8
  Scenario: CLR button resets all quantity selections and highlights
    Given the user has an active quantity selection highlighted in orange
    When the user clicks the "CLR" button
    Then the "Man Qty" numerical value is cleared
    And all active orange background highlights are removed from the "Man Qty" field and all preset buttons
    And the user must reselect a quantity before placing a new order

  # Covers AC7 (Path 1: Custom Manual Quantity)
  Scenario: Order execution uses the exact custom manual quantity
    Given the user has entered and saved a custom value in the "Man Qty" field
    And the "Man Qty" field is highlighted with an orange background
    When the user submits an order by clicking on a price level in the Escalator ladder
    Then the system creates and submits the order using the exact custom numerical value entered manually

  # Covers AC7 (Path 2: Single Preset Button)
  Scenario: Order execution uses a single selected preset quantity
    Given the user has clicked a single preset quantity button (e.g., 50)
    And only that specific preset button is highlighted in orange
    When the user submits an order by clicking on a price level in the Escalator ladder
    Then the system creates and submits the order using the exact value of the selected preset button

  # Covers AC7 (Path 3: Aggregation of Multiple Presets)
  Scenario: Order execution uses the mathematical sum of multiple preset quantities
    Given the user has clicked multiple preset quantity buttons (e.g., 10 and 25)
    And all selected preset buttons are highlighted in orange
    When the user submits an order by clicking on a price level in the Escalator ladder
    Then the system creates and submits the order using the mathematical sum of the selected preset buttons (e.g., 35)
