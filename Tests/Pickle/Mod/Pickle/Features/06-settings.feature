Feature: the settings window, and what it changes in play

  # The out-of-game suite proves the settings class normalizes, resets and survives Scribe. None of
  # that opens a window. What only a running game shows: that the window belongs to this mod, that
  # it edits the same instance the mod applies from, and that a changed range reaches both holders
  # rather than just the object in memory.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: the primary route opens this mod's own window on the live settings
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    And Entity Gazing the open window edits the same settings instance
    When I close all dialogs
    Then no errors were logged

  Scenario: a changed range reaches both holders
    When Entity Gazing sets the distances to 4 and 9
    Then Entity Gazing the holders carry a watch range of 4 to 9
    And Entity Gazing setting "minimumDistance" reads 4
    And Entity Gazing setting "maximumDistance" reads 9

  # A changed range has to move where the game actually puts watchers, not only what the def says.
  Scenario: the game computes watch cells from a changed range
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    When Entity Gazing sets the distances to 4 and 9
    Then Entity Gazing the watch cells lie 4 to 9 cells from the holder
    And no errors were logged
