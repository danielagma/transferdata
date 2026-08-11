Feature: Escalator: Refreshed User Experience and Rename to "Ladder" (DWU-334)
  As a trader
  I want the Escalator widget to be refreshed and renamed to Ladder
  So that I have a modernized, cleaner UI that correctly identifies the tool

  Background:
    Given the user is logged into Darwin
    And the user has access to the Order Management and Bond Pricer modules

  # Covers AC1, AC7
  Scenario: Global renaming and replacement of the Escalator widget
    When the user navigates through the application (e.g., Widgets dropdown menu, Order Management area)
    Then the term "Escalator" is no longer displayed anywhere in the UI
    And the widget is globally renamed and labeled strictly as "Ladder"
    And the new Ladder widget successfully replaces all legacy instances of the escalator widget

  # Covers AC2, AC3, AC4, AC6
  Scenario: UI layout update, control cleanup, and color consistency
    When the user opens the Ladder widget
    Then the UI layout strictly matches the newly approved mockup
    And existing controls are displayed in their updated mockup positions
    And obsolete controls not present in the mockup are successfully removed
    But the "Quantity Bar" remains fully visible and functional at the bottom of the widget
    And the Buy and Sell indicators maintain their colors consistent with the current application theme

  # Covers AC5, AC8
  Scenario: Context menu integration from Bond Pricer
    Given the user is viewing the Bond Pricer grid
    When the user right-clicks on any specific bond instrument
    Then the context menu successfully displays the option "View Ladder" instead of View Escalator
    When the user clicks "View Ladder"
    Then the refreshed Ladder widget opens successfully
    And all existing underlying functionality remains completely unchanged and working
