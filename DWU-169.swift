Feature: Reference Data - Price Format Configuration in Bond Referential
  As a Trader
  I want to configure the Price Format per bond in the Referential screen
  So that instrument prices display according to market convention (Decimal or 32nd)

  Background:
    Given that the user is authenticated in Darwin UAT
    And navigates to the "Static Data" window
    And opens the "Bond Referential" screen under View/Edit mode

  Scenario Outline: Validation of Price Format field properties, location, and defaults
    # Covers AC1, AC2, AC3, AC5, and AC6 in a single optimized execution flow
    Given that the user loads an instrument record categorized as "<instrument_lifecycle>"
    When the user inspects the "Classifications" section of the form
    Then the "Price Format" field must be visible
    And it must be spatially located directly underneath the "Quote Group" dropdown
    And the "Price Format" component must be a dropdown containing the enums "Decimal" and "32nd"
    And the active selection must display "<default_value>" by default

    Examples:
      | instrument_lifecycle | default_value | qa_justification                                  |
      | Existing Legacy Bond | Decimal       | Verifies DB migration scripts set correct default |
      | Newly Created Bond   | Decimal       | Verifies UI initialization rule sets correct enum |

Scenario: Verification of mandatory constraint enforcement via UI dropdown controls
    # Replaces old AC4 validation since the UI prevents blank inputs by design
    Given that the user opens the "Price Format" configuration dropdown
    When the user inspects the available list entries
    Then the dropdown must only contain the active enums "Decimal" and "32nd"
    And the system must not provide an empty, blank, or "None" selection item
    And the user is structurally prevented from clearing the active selection


  Scenario: End-to-End API payload mapping confirmation
    # Shift-Left QA covering integration from Dev Evidence logs
    Given that the user modifies the "Price Format" to "32nd" on the UI for ISIN "ES0000012000"
    When the user saves the changes to the system
    Then the outbound network payload must transmit the string value "ThirtySecond" inside the "pricingFormat" JSON token
    And a subsequent GET request on the Ref Data CAPI returns "ThirtySecond" successfully with an HTTP 200 OK status
