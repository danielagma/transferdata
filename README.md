Feature: Apply Existing Pricing Format in Market Depth and Escalator Widgets (DWU-344)
  As a trader
  I want prices displayed in the Market Depth and Ladder widgets to use the Pricing Format configured for each bond
  So that prices are displayed consistently throughout Darwin

  Background:
    Given the user is logged into Darwin
    And the user navigates to the "Order Management" screen

  # --- MARKET DEPTH WIDGET SCENARIOS ---

  # Covers AC1, AC3, AC4, AC6, AC7 and AC8 for Market Depth
  Scenario: Market Depth widget consistently renders the Decimal pricing format
    Given a specific bond is configured with the "Decimal" Pricing Format in Referential Data (DWU-169)
    When the user opens the "Market Depth" and "Bond Pricer" widgets for this specific bond
    Then all price values inside the Market Depth grid are displayed in decimal format
    And the manual order entry price fields display the value in decimal format
    And the displayed decimal format visually matches the formatting shown in the Bond Pricer widget

  # Covers AC1, AC3, AC5, AC6, AC7 and AC8 for Market Depth
  Scenario: Market Depth widget consistently renders the 32nds pricing format
    Given a specific bond is configured with the "32nds" Pricing Format in Referential Data (DWU-169)
    When the user opens the "Market Depth" and "Bond Pricer" widgets for this specific bond
    Then all price values inside the Market Depth grid are displayed in 32nds fractional format
    And the manual order entry price fields display the value in 32nds fractional format
    And the displayed 32nds format visually matches the formatting shown in the Bond Pricer widget

  # --- ESCALATOR (LADDER) WIDGET SCENARIOS ---

  # Covers AC2, AC3, AC4, AC6, AC7 and AC8 for Escalator
  Scenario: Escalator widget consistently renders the Decimal pricing format
    Given a specific bond is configured with the "Decimal" Pricing Format in Referential Data (DWU-169)
    When the user opens the "Escalator" and "Bond Pricer" widgets for this specific bond
    Then all price values inside the Escalator price ladder grid are displayed in decimal format
    And the displayed decimal format visually matches the formatting shown in the Bond Pricer widget

  # Covers AC2, AC3, AC5, AC6, AC7 and AC8 for Escalator
  Scenario: Escalator widget consistently renders the 32nds pricing format
    Given a specific bond is configured with the "32nds" Pricing Format in Referential Data (DWU-169)
    When the user opens the "Escalator" and "Bond Pricer" widgets for this specific bond
    Then all price values inside the Escalator price ladder grid are displayed in 32nds fractional format
    And the displayed 32nds format visually matches the formatting shown in the Bond Pricer widget
