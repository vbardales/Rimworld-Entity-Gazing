# Pictures for the Workshop page, not verification. Nothing here asserts anything the other
# thirteen features do not: this one exists so the gallery images are taken in a scene chosen for
# them, in the zen meadow studio, rather than cropped by hand out of the test colony's evidence.
#
# VALID ONLY IN THE STUDIO PASS: wsl-deps.studio.map stages the ScreenshotStudio companion and
# this Background loads the fixture it packages. The other passes exclude this file by name.
#
# Every shot is @review: a green scenario proves an image was produced, not that it shows what
# the page says. Each one is opened and looked at before it goes into the gallery folder.
#
# What each capture has to show:
#   gaze         watchers standing 2 to 6 cells from a held fingerspike, a platform in the middle
#   holding spot the same, on the floor marker
#   watch area   the cross of four outlined rects drawn around a holder being placed
#   settings     the Mod options window alone, no HUD
#   pain field   a watcher's health tab listing the pain field a nociosphere applies
@review @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.clearscreen @requires:nelim.pickletools.inspecttabs @requires:nelim.pickletools.screenshotmode
Feature: shots for the Workshop page

  Background:
    Given the save "nelim-zen-meadow-studio" is loaded
    And I close all dialogs
    And Nelim's Pickle Tools: I frame the studio "display"

  Scenario: colonists gazing at a held entity
    Given Entity Gazing spawns a "HoldingPlatform" where the camera looks
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    And Entity Gazing spawns the colonist "Wren" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Iris"
    And Entity Gazing "Iris" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And Entity Gazing asks the giver for a job for "Wren"
    And Entity Gazing "Wren" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Iris" is watching the holder
    And Entity Gazing "Basil" is watching the holder
    And Entity Gazing "Wren" is watching the holder
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - gaze"

  Scenario: the holding spot is watched too
    Given Entity Gazing spawns a "HoldingSpot" where the camera looks
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Iris"
    And Entity Gazing "Iris" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Iris" is watching the holder
    And Entity Gazing "Basil" is watching the holder
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - holding spot"

  Scenario: the watch area drawn under the build designator
    When Entity Gazing holds the build designator for "HoldingPlatform"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - watch area"

  Scenario: the settings window, uncluttered
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "publication - settings"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs

  Scenario: the pain field a nociosphere applies to its audience
    Given Entity Gazing spawns a "HoldingPlatform" where the camera looks
    And Entity Gazing tethers a downed "Nociosphere" to it
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Iris"
    And Entity Gazing "Iris" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Iris" carries the hediff "PainField"
    When I select "Iris"
    And I move the camera to "Iris"
    And Nelim's Pickle Tools: I open the "Health" inspect tab
    Then Nelim's Pickle Tools: the "Health" inspect tab is open
    When I take a screenshot "publication - pain field"
