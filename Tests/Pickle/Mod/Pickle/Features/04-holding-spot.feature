Feature: the holding spot is watched too, and is a poorer show

  # The floor marker carries the same comp and the same class as the steel platform, so it watches
  # identically. It is also the def whose patch is the inverted one: it already has a building node
  # and gets its settings added inside it, where the platform's are created at the root. Reverse
  # the two and the spot ends up with two sibling nodes, the game reads one, and the spot looks
  # perfectly normal until someone uses it. That is what this feature would catch in play.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: an occupied holding spot is offered as entity gazing
    Given Entity Gazing spawns a "HoldingSpot"
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers a gazing job
    And Entity Gazing this map offers the entity gazing recreation type

  Scenario: the spot computes watch cells from the same range as the platform
    Given Entity Gazing spawns a "HoldingSpot"
    And Entity Gazing tethers a downed "Fingerspike" to it
    Then Entity Gazing the watch cells lie 2 to 6 cells along the facing axis
    And no errors were logged
