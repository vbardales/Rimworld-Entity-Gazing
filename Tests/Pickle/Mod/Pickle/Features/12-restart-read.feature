Feature: distances survive the game being closed and reopened

  # The claim this pair exists for: the distances are global rather than per save, so they have to
  # outlive the process, and no scenario inside one process can show that. 09-reload covers a save
  # written and read again, which is not a restart.
  #
  # The first step is the guard. It refuses to pass when the writer ran in this same process, which
  # is what a restart test that never restarted looks like: the values still sitting in the same
  # EntityGazingSettings instance, read from memory while appearing to come from disk. Borrowed
  # from RimmsqolSteps, whose reader does the same, because it is the only version that cannot be
  # fooled by the cheap form of the test.
  #
  # One scenario rather than two, deliberately. The teardown puts the distances back to 2 to 6
  # after every scenario, which is exactly what should happen once this pair has been read - but it
  # means a second scenario here would measure the defaults and call the restart broken. The guard
  # turns the teardown back on, so this file also cleans up after its writer.

  Scenario: the previous launch's distances are loaded, and the game computes from them
    Given Entity Gazing the distances kept by the previous launch are in place
    Then Entity Gazing setting "minimumDistance" reads 9
    And Entity Gazing setting "maximumDistance" reads 12
    And Entity Gazing its settings file records 9 and 12
    When the save "test-colony" is loaded
    And I close all dialogs
    And Entity Gazing spawns a "HoldingPlatform"
    Then Entity Gazing the holders carry a watch range of 9 to 12
    And Entity Gazing the watch cells lie 9 to 12 cells along the facing axis
    And no errors were logged
