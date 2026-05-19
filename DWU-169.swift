Feature: Price Format configuration for bonds in Bond Referential
  As a Trader
  I want to be able to define if a bond is priced in Decimal or 32nd format
  So that the price display aligns with market conventions

  Background: 
    Given that the user with a Trader role is authenticated in Darwin UAT
    And navigates to the "Bond Referential" screen

  Scenario: UI validation and location of the Price Format field
    # Covers AC1: New "Price Format" field in Bond Referential > Static > View/Edit
    # Covers AC2: Must be a dropdown with "Decimal" and "32nd"
    # Covers AC3: Placed under the "Quote Group" field
    # Covers AC4 (Partial): Display of the mandatory field asterisk (*)
    When the user opens the "Bond Reference Data" tab for a bond
    Then the "Price Format*" field is visible in the "Classifications" section
    And it is spatially located just below the "Quote Group" field
    And the dropdown menu contains only the "Decimal" and "32nd" options

  Scenario Outline: default value validation according to the instrument lifecycle
    # Covers AC5: Default "Decimal" for existing instruments
    # Covers AC6: Default "Decimal" for new instruments
    When the user opens the form for an instrument of type "<instrument_type>"
    Then the "Price Format" field shows the "Decimal" option pre-selected by default

    Examples:
      | instrument_type |
      | New (Creation)  |
      | Existing        |

  Scenario: mandatory validation when editing an instrument
    # Covers AC4: The parameter must be a mandatory input
    Given that the user is editing a bond's configuration
    When the user attempts to save the form leaving the "Price Format" field empty
    Then the system displays a required field validation error
    And the "Save" button remains disabled or blocks the transaction

  Scenario: Price Format persistence in the database
    # Main AC of this story truncated to the persistence layer
    Given that the user selected the "32nd" option for the Price Format
    When the user clicks on "Save"
    Then the system displays the confirmation message "The bond was updated successfully."
    And upon reloading the bond data, the dropdown must keep the "32nd" option persisted by the backend
  
  
  /*
  Scenario: impact of the 32nd configuration on transactional display
    # Covers the main objective of the User Story (Business value)
    Given that the user successfully configured and saved a bond with the Price Format set to "32nd"
    When the user queries the price of said bond in the transactional screens (e.g. Bond Pricer)
    Then the system visually formats the fraction using the 32nd convention (e.g. "99-30")
    And the system does not render the price in pure decimal format (e.g. "99.9375")
  */