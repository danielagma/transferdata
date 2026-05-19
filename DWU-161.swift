Feature: Dynamic vertical resizing of the Contracts section
  As a Trader
  I want the contracts table to utilize all available vertical space
  So that I can view the maximum number of records without needing to scroll internally

  Background: 
    Given that the user is authenticated in Darwin UAT
    And navigates to the "Futures Maintenance" screen
    And opens the "View/Edit Futures Details" window of an instrument with multiple contracts
    And the application window is not maximized to full screen

  Scenario: dynamic vertical expansion of the contracts table
    # Covers AC1: In-line expansion with empty space
    When the user dynamically increases the height of the application window
    Then the height of the "Contracts" section proportionally increases to fill the new empty space
    And the number of visible rows within the table increases without needing to use the internal scroll

  Scenario: static preservation of top attributes
    # Covers AC2: No impact on the top form
    Given that the user visually records the position and size of the top form fields (e.g., Prefix, Description, Currency)
    When the user resizes the application window vertically (increasing and decreasing)
    Then the top form fields maintain their original dimensions, alignment, and spacing
    But they must not stretch, shrink, or overlap with one another

  Scenario: preservation of dynamic horizontal resizing
    # Covers AC3: Original horizontal behavior remains intact
    When the user dynamically widens the application window horizontally
    Then the "Contracts" section expands its width adapting to the new resolution
    And the internal columns of the table are distributed correctly
    And the vertical resizing behavior continues to function independently

  Scenario Outline: UI protection against extreme height reductions (Edge Case QA)
    # Prevents the table from disappearing if the monitor is very small
    When the user reduces the height of the application window to an extreme size (e.g., "<vertical_resolution>px")
    Then the system protects the legibility of the top form
    And the "Contracts" section respects a minimum visible height (min-height)
    But the table never collapses to 0 pixels in height
    And a general scrollbar appears in the main window to allow navigation

    Examples:
      | vertical_resolution | qa_justification                      |
      | 768                 | Standard resolution for older laptops |
      | 600                 | Forced limit to evaluate CSS behavior |