Feature: Display of prices in 32nd format in the Bond Pricer
  As a Trader
  I want Bond Pricer prices to respect the referential configuration
  So that I can view fractions in 32nd format according to market convention

  Background: 
    Given that the user is authenticated in Darwin
    And navigates to the "Bond Pricer" screen

  Scenario: preservation of decimal format for non-configured bonds
    # Covers AC1
    Given that the system loads a bond whose "Price Format" configuration is "Decimal"
    When the system renders the instrument row in the table
    Then the price fields are displayed in standard numerical format (e.g. "98.1250")
    And no hyphen separators or fractions are applied

  Scenario: total column coverage for the 32nd convention
    # Covers AC2 and AC3
    Given that the system loads a bond whose "Price Format" configuration is "32nd"
    When the system renders the instrument row in the table
    Then the 32nd format is strictly applied to the 27 price columns defined in the data dictionary
    And non-price fields (e.g. Yield or Spread) maintain their original format

  Scenario Outline: strict conversion of decimal prices to 32nd format (Bloomberg convention)
    # Covers AC4 applying visual rules deduced from the system mockup
    Given that the backend (CAPI) sends a raw price with the decimal value "<decimal_price>" for a bond configured in 32nd
    When the Bond Pricer processes the price to render it on the grid
    Then the system formats the price by separating the Handle with a hyphen
    And applies the exact visual convention displaying the text "<expected_format>"
    But it must not show fractions with an 8 denominator (must simplify them or use symbols)

    Examples:
      | decimal_price | expected_format | applied_rule_based_on_mockup                                 |
      | 102.0156      | 102-00+         | The 4/8 (half of a 32nd) are represented with "+"            |
      | 99.1641       | 99-05 1/4       | The 2/8 are visually simplified to 1/4                       |
      | 98.4609       | 98-14 3/4       | The 6/8 are visually simplified to 3/4                       |
      | 98.0938       | 98-03           | Zero fractions are omitted (no 0/8 or anything is shown)     |
      | 110.8594      | 110-27+         | Integral validation: Handle + 27/32 + remainder of 4/8 (+)   |

  Scenario: editing and calibration restrictions for bonds in 32nd
    # Covers AC5: Block or manage editing in this iteration
    Given that the user views a price cell in 32nd format
    When the user attempts to edit the cell value by double-clicking
    Then the system blocks manual 32nd format text input
    But if the system allows editing, the user must only be able to input decimal values
    And the system re-converts it to 32nd upon confirming the action
