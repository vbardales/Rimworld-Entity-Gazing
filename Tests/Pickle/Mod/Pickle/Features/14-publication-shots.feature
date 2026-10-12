# Pictures for the Workshop page, not verification. Nothing here asserts anything the other
# thirteen features do not: this one exists so the gallery images are taken in a scene chosen for
# them, in the Sanctuary, rather than cropped by hand out of the test colony's evidence.
#
# VALID ONLY IN THE SANCTUARY PASS: wsl-deps.sanctuary.map stages Sanctuary Backlot (the fixture
# "Nelims-tribe" and the named places) and the studio companions. The other passes skip this file.
#
# Every shot is @review: a green scenario proves an image was produced, not that it shows what
# the page says. Each one is opened and looked at before it goes into the gallery folder.
#
# The story (the series is one story, GALLERY.md): the evening a colony decides that the thing it keeps chained up
# is also its best entertainment. The set is the walled enclosure `enclosure-south`, at dusk, emptied of its nest boxes,
# and every picture moves a little: the audience first (the gaze), then how the game places the holder (the watch area),
# then the other holder, then the price (the pain field), then the dial the player turns (the settings).
#
# Shot plan, in gallery order after 0- (the Preview):
#   1. gaze          three colonists standing 2 to 6 cells from a held fingerspike, a platform in the middle (hour 20)
#   2. watch area    the cross of four outlined rects drawn around a holder being placed (hour 20)
#   3. holding spot  the same on the floor marker, two colonists (hour 20)
#   4. pain field    one colonist inside a nociosphere's reach, the hediff proven first (hour 21)
#   5. settings      the Mod options window alone, no HUD
#
# The colonists are generated, not dressed: a first pass, to see the composition. Apparel and faces are a
# second pass once the frame is accepted. The entity is the subject and no face is meant to read.
@review @requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.clearscreen @requires:nelim.pickletools.screenshotmode
Feature: shots for the Workshop page

  Background:
    Given the save "Nelims-tribe" is loaded
    And I close all dialogs
    And Nelim's Sanctuary: the animals are removed from the sanctuary "enclosure-south"
    And Nelim's Sanctuary: the sanctuary "enclosure-south" is emptied
    And Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And I set the weather to "Clear"
    And Entity Gazing zooms the camera to 10 cells

  Scenario: colonists gazing at a held entity
    Given I set the hour to 20
    And Entity Gazing spawns a "HoldingPlatform" where the camera looks
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

  Scenario: the watch area drawn under the build designator
    # The studio maps keep no steel and the designator prices what it is about to place, honestly: a red
    # "40 (not enough stored)" label sat on the ghost in the first studio run. Stock it so the label is true.
    Given I set the hour to 20
    And Entity Gazing has steel stocked near the placement
    When Entity Gazing holds the build designator for "HoldingPlatform"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - watch area"

  Scenario: the holding spot is watched too
    Given I set the hour to 20
    And Entity Gazing spawns a "HoldingSpot" where the camera looks
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

  Scenario: a colonist inside a nociosphere's reach
    Given I set the hour to 21
    And Entity Gazing spawns a "HoldingPlatform" where the camera looks
    And Entity Gazing tethers a downed "Nociosphere" to it
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Iris"
    And Entity Gazing "Iris" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Iris" carries the hediff "PainField"
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - pain field"

  Scenario: the settings window, uncluttered
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "publication - settings"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
