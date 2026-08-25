# QA Test Cases: DWU-425

Feature: Process Allocation events from Bloomberg, TW and Bondvision (DWU-425)
  As the STP Hub (downstream component)
  I need Darwin to generate a PostTradeEvent.Allocations payload 
  So that I can route post-trade breakdown data to external platforms (Murex, Calypso, etc.)

  Background:
    Given Darwin is configured to process events from D2C inquiry-posttrade gateways
    And all sourcing integrations for PostTradeEvent.Allocations are implemented and available in the test environment

  # Covers AC: Generate PostTradeEvent.Allocations on every incoming allocation event, Payloads are written to log
  Scenario: Allocation payload is successfully generated and written to log for traceability
    Given Darwin receives an ITradeAllocationEvent from TransFicc through any inquiry-posttrade gateway
    When the event is processed and assembled by Darwin
    Then Darwin generates exactly one PostTradeEvent.Allocations payload for that input event
    And the full payload is written to log with enough context to support validation and traceability (e.g., Trade.SourceId and AllocationId)

  # Covers AC: Data validation and error handling cover the entire message assembly pipeline (Hardcoded defaults & Conversions)
  Scenario: Payload structural requirements and hardcoded values are correctly applied
    Given a PostTradeEvent.Allocations payload is successfully assembled
    When the data is normalized across all sourcing systems
    Then the payload Type is strictly set to "ALLOC"
    And the MessageId is generated as a string with a minimum length of 10 characters
    And Operation.Date is derived from TransficcHeader.OriginatorSendingTimestampNanos and formatted as "YYYY-MM-DD"
    And Operation.Time is derived from TransficcHeader.OriginatorSendingTimestampNanos and formatted as "HH:MM:SS:MMM"

  # Covers AC: Allocation list is produced and consistent
  Scenario: Allocation array is populated with valid breakdown entries
    Given the input ITradeAllocationEvent contains one or more allocations
    When Darwin assembles the payload
    Then the Allocations[] array is populated with the expected entries
    And each entry contains a valid AllocationId and FundBreakdown
    And each entry contains the correct Quantity
    And the QuantityType for all entries is hardcoded to "NOTIONAL"

  # Covers AC: Integration tests confirm end-to-end data flow from all sourcing systems
  Scenario: End-to-end integration flow completes without errors
    Given an integration test sends an ITradeAllocationEvent through the supported inquiry-posttrade gateways
    When the end-to-end assembly of the allocation payload is completed
    Then the payload is published to the outbound IBM MQ queue for STP Hub
    And the system successfully handles the acknowledgement message from the inbound IBM MQ queue
    And no TradeAllocationReceivedEventHandlerFailed events are observed
