Feature: a colonist gazes at an occupied holding platform

  # The behaviour the whole mod exists for, and the one thing no out-of-game test can reach: it
  # needs a map, a spawned building, a tethered pawn and the game's own job system.
  #
  # The giver is asked directly rather than waited for. Setting a need low and hoping the colonist
  # picks this activity within N ticks depends on the schedule, the pathing and every other
  # recreation source on the map: it fails for reasons that are not the mod's, and passes without
  # saying much. Asking the giver runs exactly the mod's one override and the vanilla code beneath.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: an occupied platform is offered as entity gazing
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    Then Entity Gazing this map offers the entity gazing recreation type

  Scenario: the giver sends a colonist to an occupied platform
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers a gazing job

  Scenario: the watcher stands in the patched range and gains that recreation
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    And Entity Gazing "Watcher" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Watcher" is watching the holder
    And Entity Gazing "Watcher" stands 2 to 6 cells from the holder
    And Entity Gazing "Watcher" has gained entity gazing recreation
    And no errors were logged

  # The out-of-game suite proves the range is written into the def. This proves the game computes
  # standing cells from it, which is a different claim and the one that matters in play.
  Scenario: the game computes watch cells from the patched range
    Given Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    Then Entity Gazing the watch cells lie 2 to 6 cells from the holder
