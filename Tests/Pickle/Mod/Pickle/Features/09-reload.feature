Feature: nothing of this mod is lost across a reload

  # The mod claims no save data of its own: the recreation type, the job and the patched holders
  # come back because the defs come back, and the distances are global rather than per save. That
  # claim is only testable where a save is actually written and read again.
  #
  # This is a reload inside one process, which is not a restart. Whether the distances survive the
  # game being closed and reopened is a two-process question, and it is listed as unverified in
  # STATUS.md rather than pretended here: a restart pass needs the writer and the reader to be two
  # launches under one lock, chained with -Then and no staging in between.

  Scenario: an occupied platform is still a recreation source after a reload
    Given the save "test-colony" is loaded
    And I close all dialogs
    And Entity Gazing spawns a "HoldingPlatform"
    And Entity Gazing tethers a downed "Fleshbeast" to it
    Then Entity Gazing this map offers the entity gazing recreation type
    When the save "test-colony" is loaded
    And I close all dialogs
    Then def "EG_EntityGazing" of type "JoyKindDef" exists
    And Entity Gazing the holders carry a watch range of 2 to 6
    And no errors were logged
