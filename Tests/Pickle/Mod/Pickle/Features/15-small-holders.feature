@requires:saltbabe.smallholdingplatform
Feature: the holders of Small Holding Platform are watched like the vanilla ones

  # Mod/Patches/OptionalCompat.xml patches these defs only when they exist (gated on each def, no
  # dependency). What it must give them: the watch range, the joy kind and the giver's thingDefs entry,
  # so that an occupied holder is offered as entity gazing and the game computes watch cells from the
  # configured range. Needs the pass map wsl-deps.small-holders.map (this feature is skipped without it).
  # Written 2026-11-19, NOT PLAYED yet.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: an occupied SmallHoldingPlatform is offered as entity gazing
    Given Entity Gazing spawns a "SmallHoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers a gazing job
    And Entity Gazing this map offers the entity gazing recreation type

  Scenario: the SmallHoldingPlatform computes watch cells from the configured range
    Given Entity Gazing spawns a "SmallHoldingPlatform"
    And Entity Gazing tethers a downed "Fingerspike" to it
    Then Entity Gazing the watch cells lie 2 to 6 cells along the facing axis
    And no errors were logged

  Scenario: an occupied SmallHoldingSpot is offered as entity gazing
    Given Entity Gazing spawns a "SmallHoldingSpot"
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Watcher" with no recreation
    When Entity Gazing asks the giver for a job for "Watcher"
    Then Entity Gazing the giver offers a gazing job

  Scenario: the SmallHoldingSpot computes watch cells from the configured range
    Given Entity Gazing spawns a "SmallHoldingSpot"
    And Entity Gazing tethers a downed "Fingerspike" to it
    Then Entity Gazing the watch cells lie 2 to 6 cells along the facing axis
    And no errors were logged
