# QA Test Cases: DWU-441

Feature: [Sentinel] Send Trade Agreed Message for Tradeweb Sweep Trades (DWU-441)
  As a trader
  I want trades executed on Tradeweb Sweep to be transaction reported
  So that I am MiFID II compliant

  Background:
    Given the Darwin Trade Service and Sentinel Gateway Adapter are running
    And the post-trade feed is receiving events from Tradeweb

  # Covers AC1, AC3
  Scenario: Tradeweb sweep trades are correctly identified and enriched
    Given a sweep trade arrives on the Tradeweb post-trade feed
    When the trade contains isSweepTrade=True in the TradeEvent.venueSpecificInfo
    Then Darwin correctly identifies the trade and enriches it in the same manner as non-sweep trades
    And a PostTradeMessageDeliveredEventPublished event is logged
    And the event explicitly sets RfqId to "(null)", HasRfqPostTradeInfo to false, and NotSentinelReportable to false

  # Covers AC2
  Scenario: Trade agreed message is successfully sent to Sentinel
    Given a valid Darwin Tradeweb sweep trade has been identified and processed
    When the RfqTradeMatchHandlerSweepAccepted event is logged successfully
    Then a MessageSentToSentinel event is confirmed in the SentinelGatewayAdapter logs
    And the Sentinel XML extract contains the correct trade parameters including Code, QtyNominal, Price, and ExecutedPlatformName (Tradeweb)

  # Derived from Dev Evidence: STP Hub logic interaction
  Scenario: Tradeweb sweep trades explicitly skip STP Hub publishing
    Given a Tradeweb sweep trade is successfully processed for Sentinel reporting
    When the system evaluates STP Hub publishing logic
    Then a StpHubEventPublishingSkipped event is logged
    And the log explicitly states the Reason: "The trade is a Tradeweb sweep trade" and IsTradewebSweep: true

  # Derived from Dev Evidence (Notes): Out-of-scope instruments
  Scenario: Non-Darwin sweep trades are gracefully ignored
    Given a Tradeweb sweep trade arrives on the feed for an instrument not managed by Darwin
    When the post-trade feed processes the event
    Then a PostTradeMessageReceivedEventNotSupported event is logged
    And the log strictly outputs the Reason: "Only Darwin trades are supported" without causing errors
