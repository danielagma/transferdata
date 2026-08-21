Feature: Bank state staleness detection in Order Management Client API (DWU-450)
  As a Trading System
  I need to detect when the Bank State data is stale
  So that I prevent order request pile-ups when the Gateway is down or disconnected

  Background:
    Given the Order Management Client API is running
    And the staleness threshold is configured (default: 60 seconds)

  # Covers AC: Update IsBankStateOn to check freshness, Update IsAnyMarketOn, Update IsOrderActionAllowed
  Scenario: Fresh bank state allows normal order processing
    Given the Order Management Gateway is actively publishing BankState heartbeats
    And the BankState EventDateTime age is less than the staleness threshold
    When the system evaluates the bank state
    Then IsBankStateOn returns true
    And IsAnyMarketOn and IsOrderActionAllowed respect the freshness check and return true
    And the Order Management Client API accepts incoming order requests

  # Covers AC: Return false if older than threshold, Log warning, Prevent request acceptance
  Scenario: Stale bank state safely rejects new orders and logs warning
    Given the Order Management Gateway stops publishing BankState updates (e.g., service goes down)
    And the BankState EventDateTime age exceeds the staleness threshold
    When the system evaluates the bank state
    Then IsBankStateOn immediately returns false
    And the system treats the bank state as OFF
    And the Order Management Client API strictly rejects new order requests
    And a warning log is generated containing the market and the timestamp (StaleBankStateDetected)

  # Covers Dev Evidence (Configuration behavior verified)
  Scenario: System fallback when staleness configuration is missing
    Given the Order Management Client API starts
    But the specific configuration key (OrderManagement:BankState:StalenessThresholdSeconds) is missing
    When the service initializes
    Then the system safely defaults the staleness threshold to 60 seconds
    And the service starts successfully without throwing a fatal exception
