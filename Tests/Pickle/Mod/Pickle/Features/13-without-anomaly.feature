Feature: the mod without the DLC it is built on

  # TESTING.md's table asks scenario 1 for one pass per DLC state, and until now only the DLC-on
  # state had ever run. This is the other one. It needs its own pass, because a DLC is switched off
  # at staging and never inside a scenario:
  #
  #   -DepMap wsl-deps.no-anomaly.map -Filter 13-without-anomaly
  #
  # NO @requires: TAG, and that is the considered choice rather than an omission. `@requires:` says
  # "this scenario needs that mod ACTIVE"; what this file needs is the opposite, and Pickle has no
  # tag for an absence. Tagging it `@requires:ludeon.rimworld.anomaly` would skip it in the pass
  # written for it, and a packageId invented to mean "absent" would skip it in every pass forever -
  # a scenario that never runs while reading as a suite that covers the case. AUDIT.md is explicit
  # that a scenario skipped for want of its condition is not a scenario passed. So the selection is
  # the filter's job, and the other passes exclude this file by name. Tests/Pickle/README.md holds
  # the four commands.
  #
  # What the out-of-game suites already prove, and what they cannot. They prove
  # CompEntityHolderPlatform lives in Assembly-CSharp like all expansion code, so the mod's
  # assembly resolves and loads with the DLC absent, and that the three gameplay defs carry
  # MayRequire. They cannot show what the game does with the patch, the settings window or the
  # shortcut when the defs those point at are not there.
  #
  # Worth knowing when reading a red here: Headless/README.md records that the `!<packageId>` line
  # has only ever been exercised in a sandbox with a fake game, and that "whether the game really
  # leaves the DLC out of a loaded save is what the first real pass has to show". This is that
  # pass. A failure may belong to the harness rather than to the mod, which is why the background
  # asserts the DLC really is gone before anything else is asked.

  Background:
    Given Nelim's Pickle Tools: the expansion "Ludeon.RimWorld.Anomaly" is not active
    And mod "nelim.entitygazing" is loaded

  Scenario: the mod loads anyway, and quietly
    Then no errors were logged
    And no warnings from mod "Entity Gazing"

  Scenario: the three gameplay defs are gated away with the DLC
    Then no def "EG_EntityGazing" exists
    And no def "EG_WatchEntity" exists

  Scenario: there are no holders to patch, and the patch says nothing about it
    Then no def "HoldingPlatform" exists
    And no def "HoldingSpot" exists
    And no errors were logged

  # The shortcut is NOT gated: EG_Settings carries no MayRequire, so it is still here with the DLC
  # gone. That is deliberate - the settings window is the mod's own and needs neither a map nor a
  # holder - and what has to be shown is that it stays hidden and opens cleanly rather than
  # throwing on defs that are not there. MOD_SETTINGS.md's "no empty page or shortcut" rule is what
  # this scenario is really reading, and a person should look at the answer.
  Scenario: the settings still open and close without the activity existing
    Given the save "test-colony" is loaded
    And I close all dialogs
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    And Entity Gazing setting "minimumDistance" reads 2
    And Entity Gazing setting "maximumDistance" reads 6
    When I close all dialogs
    Then no errors were logged

  Scenario: the shortcut is present and still hidden
    Given the save "test-colony" is loaded
    And I close all dialogs
    Then def "EG_Settings" of type "MainButtonDef" exists
    And Entity Gazing the shortcut is hidden on a clean configuration
    And no errors were logged
