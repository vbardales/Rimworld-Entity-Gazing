Feature: Entity Gazing loads with its runtime contracts

  # Everything below depends on this. The out-of-game suites prove the defs are well formed and
  # that their classes resolve against the installed assembly; only a started game proves the
  # loader actually admitted them beside Anomaly and Harmony.

  Scenario: the mod loads without startup errors
    Then mod "nelim.entitygazing" is loaded
    And mod "nelim.entitygazing" loads after "ludeon.rimworld.anomaly"
    And no errors were logged

  Scenario: its three gameplay defs and its shortcut are present
    Then def "EG_EntityGazing" of type "JoyKindDef" exists
    And def "EG_WatchEntity" of type "JobDef" exists
    And def "EG_WatchEntity" of type "JoyGiverDef" exists
    And def "EG_Settings" of type "MainButtonDef" exists

  # Pickle records the patcher under the mod's display name, not its packageId. The first run of
  # this scenario named "nelim.entitygazing" and was answered "patched by Entity Gazing": the patch
  # had landed all along, the assertion was spelling the mod a way nothing stores.
  Scenario: the patch reached both of Anomaly's entity holders
    Then def "HoldingPlatform" was patched by mod "Entity Gazing"
    And def "HoldingSpot" was patched by mod "Entity Gazing"

  Scenario: a clean profile loads the documented defaults
    Then Entity Gazing setting "minimumDistance" reads 2
    And Entity Gazing setting "maximumDistance" reads 6
    And Entity Gazing the holders carry a watch range of 2 to 6
