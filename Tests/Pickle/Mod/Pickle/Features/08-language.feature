@review
Feature: the mod's own texts in the language this pass runs

  # Two passes cover this, one per language, fixed at staging. Never switched inside a scenario:
  # that reloads every def under the runner, the world goes null, and the step waits for a language
  # that never arrives.
  #
  # In developer mode - which every Pickle run is - a key missing from the active language shows as
  # accented gibberish rather than English. So the captures below are read for that: accented text
  # means a missing key, clean English inside a French run means a string that never went through
  # Translate at all.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: every keyed text this mod owns resolves in the active language
    Then Entity Gazing every keyed text exists in the language this pass runs
    And Entity Gazing the recreation type is named in the language this pass runs

  Scenario: the settings window is captured for review in this language
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    When I take a screenshot "entity gazing settings in this language"
    And I close all dialogs
    Then no errors were logged

  Scenario: a colonist mid-gaze is captured for review in this language
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fleshbeast" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    And Entity Gazing "Watcher" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Watcher" is watching the holder
    When I take a screenshot "entity gazing job report in this language"
    Then no errors were logged
