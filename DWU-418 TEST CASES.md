# QA Test Cases: DWU-418

Feature: PostTrade fields requiring custom transformation for TOMS-originated trades (DWU-418)
  As a Trading System
  I need to apply custom transformation logic to specific fields for TOMS-originated trades
  So that TOMS values unconditionally override standard venue mappings with the correct business logic

  Background:
    Given the STP Hub payload assembly pipeline is running
    And a trade event is received from TransFicc

  # Covers AC: Gateway Scope, Source of Truth, Execution Order, and Unconditional Override
  Scenario: Custom transformations are isolated to TOMS and override previous mappings
    Given an ITradeEvent is received via the Toms.Inbound gateway
    When the mapping pipeline reaches the DWU-418 execution step
    Then the transformation logic is unconditionally applied to the target fields
    And any previously mapped values from DWU-415, DWU-419, or DWU-420 are successfully overwritten
    But if the event originates from any other gateway (e.g., TradeWeb, Bloomberg EUGV)
    Then the DWU-418 logic is bypassed and base mappings remain untouched

  # Covers Field Mapping: EventType and Side transformations
  Scenario: EventType and Side apply specific TOMS conditional logic
    Given a TOMS ITradeEvent is being processed
    When the payload is assembled
    Then PostTradeEvent.EventType maps "AE" to "New", "CAE"/"PCA" to "Amend", and "XAE"/"PXA" to "Cancel"
    And PostTradeEvent.Trade.Side derives from DealerDirection
    And if TransactionType equals PXM or PXT, the Side verb is successfully inverted

  # Covers Field Mapping: MiFID Decision Makers and PriceType
  Scenario: MiFID MktIdType fields and PriceType fallback logic
    Given a TOMS ITradeEvent is being processed
    When the payload is assembled
    Then Mifid.ExecutionMktIdType maps to "ALGO" if ExecutionDecisionMakerIsAlgo is true, otherwise "PERSON"
    And Mifid.InvestmentMktIdType maps to "ALGO" if InvestmentDecisionMakerIsAlgo is true, otherwise "PERSON"
    And Trade.Price.PriceType is strictly set to "Price"

  # Covers Field Mapping: Counterparty GLCS and Axe conditional logic
  Scenario: Counterparty fallback and Axe logic calculation
    Given a TOMS ITradeEvent is being processed
    When the payload is assembled
    Then Trade.Counterparty.Glcs fetches a valid GLCS Code, otherwise maps the TOMS field CustomerAccountCounterparty
    And Trade.Instrument.Axe.IsAxed takes into account TomsTradeReceiveEvent.AxeSide to calculate TradeModel.WasAxed

  # Covers Field Mapping & Dev Evidence: SourceOriginalName (VOICE to STW override)
  Scenario: SourceOriginalName correctly maps to STW while leaving Exchange as VOICE
    Given a TOMS ITradeEvent where the ExecutedPlatformName is technically "VOICE"
    When the system transforms the source names
    Then PostTradeEvent.Trade.SourceOriginalName unconditionally returns "STW"
    And the Exchange field remains mapped to "VOICE"

  # Covers Field Mapping: IdType translation and InternalTrade parsing
  Scenario: Instrument IdType conversion and LongNotes parsing
    Given a TOMS ITradeEvent is being processed
    When the payload is assembled
    Then Instrument.IdType is correctly translated by querying the SecurityFlagConversionTable.json file
    And InternalTradeId is mapped to the <Text> value only if <LongNotes><LongNote><Index>2</Index> is populated
    And InternalTradeType maps to "Main" if IsInternalMirror is true, otherwise "Mirror"