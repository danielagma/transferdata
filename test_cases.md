Feature: Add Bond Sector to Bond Referential (DWU-375)
  As a reference data user
  I want Darwin to view and maintain Bond Sector in Bond Referential
  So that Treasury instruments can be grouped in the correct trading sector

  Background:
    Given the user is logged into Darwin
    And navigates to the Bond Referential module
    And selects a U.S Treasury instrument to View/Edit

  # Covers AC1, AC3, AC5
  Scenario: UI placement and strict dropdown validation
    When the user navigates to the "Bond Reference Data" tab
    And looks under the "Classifications" section
    Then a new field named "Bond Sector" is displayed directly below "Internal Sector"
    And the field is optional and allows a blank value
    And the field is a strict dropdown containing exactly the following values: Short, 2Y, 3Y, 5Y, 7Y, 10Y, 20Y, 30Y, TIPS, STRIPS
    And the user is successfully prevented from typing free text or custom values into the field

  # Covers AC4, AC6
  Scenario: Manual assignment and persistence of Bond Sector
    When the user selects a valid value (e.g., "10Y") from the Bond Sector dropdown
    And clicks the Save button
    Then the instrument is saved successfully without errors
    When the user reloads the instrument data
    Then the Bond Sector field correctly displays the saved value ("10Y")
    And the network payload confirms the "bondSector" attribute was updated successfully

  # Covers AC2 (Happy Path)
  Scenario: Bulk Upload with valid Bond Sector values
    Given the user prepares a Bulk Upload CSV file containing U.S Treasury instruments
    And the "Bond Sector" column contains valid Enum values (e.g., "TIPS", "5Y") or is left blank
    When the user uploads the file via the Bond Referential Bulk Upload function
    Then the upload is processed successfully
    And the instruments are updated with their respective Bond Sector values

  # Covers AC2 (Unhappy Path)
  Scenario: Bulk Upload rejects invalid Bond Sector values with row-level error
    Given the user prepares a Bulk Upload CSV file
    And includes an instrument with an invalid "Bond Sector" value (e.g., "15Y", "FreeText")
    When the user uploads the file via the Bulk Upload function
    Then the system triggers a row-level validation error for that specific instrument
    And the instrument's existing Bond Sector is NOT updated
    And other valid instruments in the same file are processed successfully
