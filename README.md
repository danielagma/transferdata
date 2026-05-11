Feature: Vertical display of the Order Book (Escalator View MVP)
  As a Trader
  I want to see the market depth widget stacked vertically
  So that I can quickly scan price levels and order flow

  Background: 
    Given that the user is authenticated in Darwin UAT
    And navigates to the "Bond Pricer" screen
    And right-clicks on an instrument that has available market depth

  Scenario: validation of widget access from the context menu
    # Covers AC3: Inclusion of the option in the menu
    When the context menu is displayed
    Then the system shows the "View Escalator" option
    And the option is spatially located just below "View Order Book"

  Scenario: validation of the stacked visual structure (Top/Bottom) and column omission
    # Covers AC1 and AC2: Asks on top, Bids on bottom, no MKT, quantity alignment
    Given that the user selects the "View Escalator" option
    When the market depth widget renders on the screen
    Then the "Asks" section (offers in pink) is positioned in the upper half of the widget
    And the "Bids" section (bids in blue) is positioned in the lower half
    And the market columns ("MKT") are excluded from the display in both sections
    And the Ask quantities (Q) are aligned to the right of the price
    And the Bid quantities (Q) are aligned to the left of the price

  Scenario: preservation of the own order indicator (Own Order)
    # Covers AC4 (Regression 1): Maintain "Own Order" functionality
    Given that the user has active own orders in the market for the selected instrument
    When the user opens the "Escalator View"
    Then the system displays the visual indicator with the user's initials (e.g., "JC") inside the price cell corresponding to their order
    But the indicator does not deform the cell alignment nor hide the numerical values

  Scenario: intentional deactivation of parameter auto-population (Click behavior)
    # Covers AC4 (Regression 2): Click must not auto-populate
    Given that the "Escalator View" widget is open and displaying data
    When the user left-clicks on a price or quantity cell
    Then the system does not auto-populate the order parameters in the transaction ticket
    And the application remains stable without showing uncontrolled errors in the interface

  Scenario Outline: tolerance to partial absence of market depth (Edge Case QA)
    # Shift-Left scenario to prevent UI collapses
    Given that the selected instrument has market conditions of type "<book_condition>"
    When the user opens the "Escalator View"
    Then the widget renders without collapsing the main structure
    And the dataless section is handled correctly without misaligning the populated section

    Examples:
      | book_condition      | qa_justification                                          |
      | Only Asks (No Bids) | Prevents the bottom table from collapsing the visual grid |
      | Only Bids (No Asks) | Prevents the top table from deforming the layout          |
