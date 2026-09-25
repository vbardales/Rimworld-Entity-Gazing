@review
Feature: the build menu draws the watch area on the ground

  # The half of the patch that no assertion can reach.
  #
  # PlaceWorker_WatchArea overrides DrawGhost and nothing else, so it draws while a holder is being
  # PLACED, never once it is built and selected. So this cannot be a scenario about a spawned
  # building - it has to hold the build designator, put the pointer on a cell, and photograph what
  # the game draws there.
  #
  # The out-of-game suite proves the place worker is on both defs and that the patch put it there.
  # Neither proves a single pixel. TESTING.md kept exactly this one step of its scenario 2 when it
  # dropped the rest for that reason.
  #
  # The cell is chosen at run time and not written here. The first run named (60, 60) and came back
  # red on both scenarios, with the capture answering in one word: Undiscovered. Unexplored rock
  # under the mountain, nothing standable, so no watch cell and a brown screen. A coordinate in a
  # feature is a claim about one saved map's geography, and this suite should not be making one.
  #
  # What to look for in the capture: a cross of four outlined rectangles around the ghost of the
  # holder, one per cardinal direction, each five cells wide, starting two cells out and ending at
  # six. An outline that is missing, or that hugs the ghost, is the finding.
  #
  # An outline cut into an irregular shape is NOT a finding: EverPossibleToWatchFrom filters the
  # cells by line of sight and by room, so a holder placed against rock gets the area a watcher
  # could really use. The first green run showed exactly that for the holding spot, and it is why
  # the step now asks for nine clear cells all round - true behaviour, unreadable review.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Entity Gazing frames open ground for a placement

  Scenario: the watch area is drawn around a holding platform being placed
    When Entity Gazing holds the build designator for "HoldingPlatform"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When I take a screenshot "entity gazing watch area under the build designator"
    Then no errors were logged

  Scenario: the same area is drawn for a holding spot
    When Entity Gazing holds the build designator for "HoldingSpot"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When I take a screenshot "entity gazing watch area for the holding spot"
    Then no errors were logged
