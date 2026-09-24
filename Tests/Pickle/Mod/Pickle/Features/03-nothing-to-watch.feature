Feature: an empty or dead holder is not a show

  # The mod's one override exists for this condition and nothing else. If these two scenarios pass
  # while the assembly is not being used, colonists would be contemplating an empty steel frame
  # with chains hanging off it, and nothing anywhere would say so.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: an empty platform is never offered
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers nothing

  Scenario: a corpse on the platform stops being a show
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fleshbeast" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers a gazing job
    When Entity Gazing the tethered entity dies
    And Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers nothing
    And no errors were logged
