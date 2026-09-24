Feature: the pain field is the price of the show

  # The design claim of the whole mod, and it is meant to come out of vanilla rather than out of
  # this mod's code. A nociosphere applies PainField out to 5.9 cells; watchers stand 2 to 6. The
  # out-of-game suite compares the two numbers. Only a running game shows the hediff actually
  # arriving on a colonist who came to look.
  #
  # The contrast scenario matters as much: a fleshbeast carries no such comp, so the same setup
  # hurts nobody. That is the price varying by entity, with no line of the mod's code involved.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: a watcher near a tethered nociosphere picks up the pain field
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Nociosphere" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    And Entity Gazing "Watcher" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Watcher" stands 2 to 6 cells from the holder
    And Entity Gazing "Watcher" carries the hediff "PainField"

  Scenario: the same gaze at a fleshbeast hurts nobody
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fleshbeast" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    And Entity Gazing "Watcher" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Watcher" is watching the holder
    And no errors were logged
