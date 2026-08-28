# QA Test Cases: DWU-509

Feature: Connect Darwin to Treasury Direct Marketable Securities API (DWU-509)
  As a trader
  I want Darwin to connect to Treasury Direct
  So that Darwin can retrieve U.S Treasury security data directly from Treasury Direct for use in downstream UST setup processes

  Background:
    Given the Darwin reference-data-service is deployed and running

  # Covers AC1, AC2, AC4
  Scenario: Successful startup routine retrieves and logs Treasury Securities Auctions Data
    Given the reference-data-service initiates its startup validation routine
    When Darwin connects to the U.S. Treasury Fiscal Data API endpoint
    Then a successful call is made to the Treasury Securities Auctions Data API returning a valid response
    And the system logs the event (including the RecordCount and a sample JSON) using existing technical logging

  # Covers AC3, AC4
  Scenario: Graceful handling and logging of unsuccessful API responses
    Given the reference-data-service initiates its startup validation routine
    When the U.S. Treasury Fiscal Data API returns an error or is unreachable
    Then Darwin gracefully handles the unsuccessful API response without crashing the service
    And the failure details (ErrorSummary or exception) are properly written to the technical logs