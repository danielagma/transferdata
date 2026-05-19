Feature: Decimal precision configuration for Bond Referential
  As a Trader
  I want to be able to configure data precision up to 8 decimal places
  So that I can support the 1/32 price format in the Bond Pricer

  Background: 
    Given that the user is authenticated in the UAT environment
    And navigates to the "Bond Referential" screen
    And opens the "View/Edit" configuration of an active bond
    And selects the "View Defaults" tab

  Scenario: successful configuration of the maximum precision limit
    When the user enters the value "8" in all 5 precision fields (Driver, Bid Offer Spread, Price, Yield, Relative Value)
    Then the system does not display any validation error messages
    And the "Save" button is enabled
    When the user clicks on "Save"
    Then the system displays the confirmation message "The bond was updated successfully."

  Scenario Outline: strict validation of limits and disallowed characters
    When the user enters the value "<input>" in the "Price" field under Column Format
    Then the system displays the validation message "<expected_error>"
    But the "Save" button remains disabled

    # QA Note: The error messages here must be fixed by the Dev. 
    # I am putting the expected logical ones, not the "Must be smaller than 8" which is wrong.
    Examples:
      | input | expected_error         | qa_justification                     |
      | 9     | Maximum precision is 8 | Upper limit exceeded                 |
      | -1    | Minimum precision is 0 | Prevention of negative values        |
      | 8.5   | Must be an integer     | Prevention of decimals in config     |
      | abc   | Invalid input          | Prevention of text injection         |
      |       | Field is required      | Handling of null (empty) fields      |

  Scenario Outline: persistence of the precision configuration in the backend (CAPI)
    # AC2 modified for the referential layer: Validating the database, not the Pricer UI
    Given that the user successfully saved a precision of "8" for the "<configured_field>" field in View Defaults
    When the user reloads the bond configuration (Hard Refresh)
    Then the interface must retrieve and display the value "8" from the database
    And the system must not silently revert the value to "5"

    Examples:
      | configured_field        |
      | Driver                  |
      | Bid Offer Spread        |
      | Price                   |
      | Yield                   |
      | Relative Value Measures |


  /*
  Scenario Outline: impact of the precision configuration on Bond Pricer metrics
    Given that the user successfully saved a precision of "8" for the "<configured_field>" field in View Defaults
    When the user navigates to the "Bond Pricer" screen
    And queries the same previously configured bond
    Then the system displays the "<pricer_metric>" metric value rendered exactly with 8 decimal places
    And the system does not silently truncate or round to the default 5 decimals

    Examples:
      | configured_field        | pricer_metric           |
      | Driver                  | Driver                  |
      | Bid Offer Spread        | Bid Offer Spread        |
      | Price                   | Price                   |
      | Yield                   | Yield                   |
      | Relative Value Measures | Relative Value Measures |
  */