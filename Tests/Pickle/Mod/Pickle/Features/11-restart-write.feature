Feature: distances written, for the next launch to read

  # The first half of the restart pair, and it is not playable on its own: it deliberately leaves
  # values on disk and stands the teardown down, so a run that plays this and not 12-restart-read
  # leaves 9 to 12 behind for whatever plays next. Play the two together, and only together:
  #
  #   -Filter 11-restart-write -Then 12-restart-read
  #
  # which takes the machine lock once, stages once, and launches the game twice. Two queue tickets
  # would not do: any run that stages this mod in between rewrites the file this launch is leaving.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: a changed range is written to the settings file
    When Entity Gazing sets the distances to 9 and 12
    And Entity Gazing keeps its distances for the next launch
    Then Entity Gazing its settings file records 9 and 12
    And Entity Gazing the holders carry a watch range of 9 to 12
    And no errors were logged
