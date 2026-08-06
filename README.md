Feature: Show Quantity Redesigned in Market Depth Widget (Iceberg Orders - DWU-413)
  As a trader
  I want to enter a Show Qty in the Ladder widget
  So that only part of my total order quantity is displayed to the market (Iceberg mode)

  Background:
    Given the user is logged into Darwin
    And a Market Depth Escalator (Ladder) widget is open for a selected bond

  # Covers AC1, AC2, AC12
  Scenario: Default UI state and Quick Quantity buttons behavior
    Given an editable "Show Qty" field is displayed next to the "Total Qty" field
    And the "Show Qty" field defaults to blank upon opening the widget
    When the user selects any quick quantity button from the bottom bar
    Then the selected value populates only the "Total Qty" field using existing behavior
    And the "Total Qty" field remains fully editable
    And the "Show Qty" field remains blank and unaffected

  # Covers AC10, AC11
  Scenario: Iceberg mode restrictions when using MULTI venue
    Given the selected routing venue is set to a specific single venue (e.g., EBM)
    And the user has entered a valid value in the "Show Qty" field
    When the user changes the routing venue to "MULTI"
    Then the system automatically clears the "Show Qty" field
    And Iceberg mode is immediately deactivated
    And Iceberg mode remains unavailable as long as the venue is "MULTI"

  # Covers AC3, AC8, AC9
  Scenario: Automatic locking and unlocking of Order Type and TiF fields
    Given the "Show Qty" field is blank
    When the user enters any value into the "Show Qty" field
    Then the order is placed into Iceberg mode
    And the "Order Type" field automatically defaults to "LMT" and becomes disabled (greyed out)
    And the "TiF" field automatically defaults to "GTD" and becomes disabled (greyed out)
    When the user clears the value from the "Show Qty" field
    Then the "Order Type" and "TiF" fields remain as LMT/GTD
    And both fields become editable again

  # Covers AC4, AC5, AC6, AC7 and Validation Matrix (Scenarios 1-5)
  Scenario: Show Qty strict mathematical and instrument validation rules
    Given the selected instrument has specific minimum quantity and increment rules in Ref Data
    And the "Total Qty" is populated with a valid amount
    When the user inputs a valid value into the "Show Qty" field (e.g., entering '5' to represent 5 million)
    Then the system accepts the Show Qty ONLY if all the following mathematical rules are met:
      * It is greater than 0
      * It is at least the instrument's minimum quantity
      * It is a valid multiple of the instrument's minimum quantity increments
      * It is less than or equal to the "Total Qty"
    And the system prevents order submission and displays an error if any of these conditions fail

  # Covers AC15
  Scenario: Total Qty dependency validation check
    Given a valid Iceberg order is configured (e.g., Show Qty = 5, Total Qty = 20)
    When the user edits the "Total Qty" to a value strictly below the current "Show Qty" (e.g., Total Qty = 2)
    Then the system immediately marks the "Show Qty" field as invalid (e.g., red highlight/error message)
    And the system strictly prevents the order from being submitted until the values are corrected

  # Covers AC13, AC14 (Success Path)
  Scenario: Successful Iceberg order submission payload and UI reset
    Given a validly formatted Iceberg order is configured in the UI with Total Qty and Show Qty
    When the user successfully submits the order and it is acknowledged by the venue
    Then the system sends both Total Qty and Show Qty values accurately to ORCA
    And the "Show Qty" field automatically resets to blank for the next order

  # Covers AC13, AC14 (Failure Path)
  Scenario: Failed Iceberg order submission UI retention
    Given a validly formatted Iceberg order is configured in the UI with Total Qty and Show Qty
    When the user submits the order but it gets rejected by the backend/venue
    Then the system sends both Total Qty and Show Qty values accurately to ORCA
    And the "Show Qty" value remains populated in the UI to allow the user to retry without re-entering
