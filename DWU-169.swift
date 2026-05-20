Feature: Reference Data - Price Format Configuration in Bond Referential
  As a Trader
  I want to configure the Price Format per bond in the Referential screen
  So that instrument prices display according to market convention (Decimal or 32nd)

  Background:
    Given that the user is authenticated in Darwin UAT
    And navigates to the "Static Data" window
    And opens the "Bond Referential" screen under View/Edit mode

  Scenario: Verification of Price Format field positioning and elements
    # Covers AC1, AC2, AC3
    When the user inspects the "Classifications" section of a selected bond
    Then the "Price Format" field must be visible
    And it must be spatially located directly underneath the "Quote Group" dropdown
    And the "Price Format" component must be a dropdown containing the enums "Decimal" and "32nd"

  Scenario: Validation of mandatory input constraints on new instruments
    # Covers AC4
    Given that the user is creating a new bond instrument
    When the user attempts to save the record with the "Price Format" field empty
    Then the system must block the save operation
    And the "Price Format" field must display a visual validation error indicating it is mandatory (*)

  Scenario Outline: Default values verification for existing and new records
    # Covers AC5, AC6
    Given that the user loads an instrument record categorized as "<instrument_lifecycle>"
    Then the "Price Format" dropdown must display "<default_value>" by default

    Examples:
      | instrument_lifecycle | default_value | qa_justification                                  |
      | Existing Legacy Bond | Decimal       | Verifies DB migration scripts set correct default |
      | Newly Created Bond   | Decimal       | Verifies UI initialization rule sets correct enum |

  Scenario: End-to-End API payload mapping confirmation
    # Shift-Left QA covering integration from Dev Evidence logs
    Given that the user modifies the "Price Format" to "32nd" on the UI for ISIN "ES0000012000"
    When the user saves the changes to the system
    Then the outbound network payload must transmit the string value "ThirtySecond" inside the "pricingFormat" JSON token
    And a subsequent GET request on the Ref Data CAPI returns "ThirtySecond" successfully with an HTTP 200 OK status
