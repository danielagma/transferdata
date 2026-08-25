# QA Test Cases: DWU-425

**Feature:** Process Allocation events from Bloomberg, TW and Bondvision (DWU-425)
  As the STP Hub (downstream component)
  I need Darwin to generate a `PostTradeEvent.Allocations` payload 
  So that I can route post-trade breakdown data to external platforms (Murex, Calypso, etc.)

**Background:**
  Given Darwin is configured to handle `ITradeAllocationEvent` from TransFicc through D2C inquiry-posttrade gateways
  And all sourcing integrations for `PostTradeEvent.Allocations` are implemented and available in the test environment

**Scenario 1:** Generate PostTradeEvent.Allocations on every incoming allocation event
  Given Darwin receives an `ITradeAllocationEvent` from TransFicc through any inquiry-posttrade gateway
  When the event is processed by Darwin
  Then Darwin generates exactly one `PostTradeEvent.Allocations` payload for that input event

**Scenario 2:** Allocation payload is written to log (traceability)
  Given a `PostTradeEvent.Allocations` payload has been successfully assembled
  When the payload is produced
  Then the full payload is written to log with enough context to support validation and traceability (for example, Trade.SourceId and AllocationId)

**Scenario 3:** Allocation list is produced and consistent
  Given the input `ITradeAllocationEvent` contains one or more allocations
  When Darwin assembles the payload
  Then the `Allocations[]` array is populated with the expected allocation entries, including AllocationId, FundBreakdown, Quantity, and QuantityType

**Scenario 4:** Integration tests (end-to-end for allocations)
  Given all sourcing integrations for `PostTradeEvent.Allocations` are implemented and available in the test environment
  When an integration test sends an `ITradeAllocationEvent` through the supported inquiry-posttrade gateways
  Then the test confirms end-to-end assembly of the allocation payload (including the Allocations[] list)
  And confirms the payload is written to log and published to stp hub