# Pictures for the Workshop page, not verification. Nothing here asserts anything the other
# thirteen features do not: this one exists so the gallery images are taken in a scene chosen for
# them, in the Sanctuary, rather than cropped by hand out of the test colony's evidence.
#
# VALID ONLY IN THE SANCTUARY PASS: wsl-deps.sanctuary.map stages Sanctuary Backlot and its body, trousers and face mods (the fixture
# "Nelims-tribe" and the named places) and the studio companions. The other passes skip this file.
#
# Every shot is @review: a green scenario proves an image was produced, not that it shows what
# the page says. Each one is opened and looked at before it goes into the gallery folder.
#
# The story (the series is one story, GALLERY.md): the evening Nelim, the colony's only colonist, decides that the
# thing she keeps chained up is also her best entertainment. Nelim is the protagonist of every frame (GALLERY.md, the
# main character rule): she wears her trousers and her own face, and the others are her guests. The set is the walled
# enclosure `enclosure-south`, at dusk, emptied of its nest boxes and kept free of animals. Every picture moves a
# little: the audience first (the gaze), then how the game places the holder (the watch area), then the other holder,
# then the price (the pain field), then the dial the player turns (the settings).
#
# Composition: the holder is put on a chosen cell (149, 214), the centre of the enclosure, and the camera is
# centred on it AFTER the colonists have walked to their viewing cells, then zoomed in close, so the subject is the
# middle of the frame. A frame that is too wide or off-centre is refused, not accepted.
#
# Shot plan, in gallery order after 0- (the Preview):
#   1. gaze          Nelim and two guests watching a held fingerspike, a platform in the middle (hour 18)
#   2. watch area    the cross of four outlined rects around a holder being placed, Nelim beside it (hour 18)
#   3. holding spot  the same on the floor marker, Nelim and one guest (hour 18)
#   4. pain field    Nelim and a guest at a nociosphere's reach, the hediff proven first (hour 19)
#   5. settings      the Mod options window alone, on the backdrop for a tall window, cropped sideways
@review @requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.clearscreen @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.colonistrace
Feature: shots for the Workshop page

  Background:
    Given the save "Nelims-tribe" is loaded
    And I close all dialogs
    And Nelim's Sanctuary: the animals are removed from the sanctuary "enclosure-south"
    And Nelim's Sanctuary: the sanctuary "enclosure-south" is emptied
    And Nelim's Sanctuary: the animals are kept out of the sanctuary "enclosure-south"
    And Nelim's Sanctuary: I am at the sanctuary "enclosure-south"
    And I set the weather to "Clear"
    And Nelim's Sanctuary: Nelim has her own face

  Scenario: Nelim and her guests gazing at a held entity
    Given I set the hour to 18
    And Entity Gazing spawns a "HoldingPlatform" at x=149 z=214
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Nelim's Pickle Tools: "Nelim" stands at (153, 216)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Nelim"
    And Entity Gazing "Nelim" starts the offered job
    And Entity Gazing asks the giver for a job for "Iris"
    And Entity Gazing "Iris" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 600 ticks
    And Nelim's Sanctuary: the appearance of "Nelim" is logged
    Then Entity Gazing "Nelim" is watching the holder
    And Entity Gazing "Iris" is watching the holder
    And Entity Gazing "Basil" is watching the holder
    When Entity Gazing centres the camera on the holder
    And Entity Gazing zooms the camera to 5 cells
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - gaze"

  Scenario: the watch area drawn under the build designator
    # The studio maps keep no steel and the designator prices what it is about to place, honestly: a red
    # "40 (not enough stored)" label sat on the ghost in the first studio run. Stock it so the label is true.
    # The designator draws at the pointer, which is the camera centre: the enclosure's centre, (149, 214).
    Given I set the hour to 18
    And Nelim's Pickle Tools: "Nelim" stands at (156, 214)
    And Entity Gazing zooms the camera to 7 cells
    And Entity Gazing has steel stocked near the placement
    When Entity Gazing holds the build designator for "HoldingPlatform"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - watch area"

  Scenario: the holding spot is watched too
    Given I set the hour to 18
    And Entity Gazing spawns a "HoldingSpot" at x=149 z=214
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Nelim's Pickle Tools: "Nelim" stands at (153, 216)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Nelim"
    And Entity Gazing "Nelim" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Nelim" is watching the holder
    And Entity Gazing "Basil" is watching the holder
    When Entity Gazing centres the camera on the holder
    And Entity Gazing zooms the camera to 5 cells
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - holding spot"

  Scenario: Nelim inside a nociosphere's reach
    Given I set the hour to 19
    And Entity Gazing spawns a "HoldingPlatform" at x=149 z=214
    And Entity Gazing tethers a downed "Nociosphere" to it
    And Nelim's Pickle Tools: "Nelim" stands at (153, 216)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    When Entity Gazing asks the giver for a job for "Nelim"
    And Entity Gazing "Nelim" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Nelim" carries the hediff "PainField"
    When Entity Gazing centres the camera on the holder
    And Entity Gazing zooms the camera to 5 cells
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - pain field"

  Scenario: the settings window, uncluttered
    # A tall window goes on the backdrop for height (GALLERY.md, window captures). The picture is cropped
    # sideways afterwards: 5 px of backdrop each side of the window, the height whole.
    Given Nelim's Pickle Tools: all animals are removed
    And Nelim's Sanctuary: I am at the sanctuary "window-backdrop-for-height"
    When Entity Gazing opens its settings window
    Then Entity Gazing sees its own settings window open
    When Nelim's Pickle Tools: screenshot mode is enabled around the open windows
    And I take a screenshot "publication - settings"
    And Nelim's Pickle Tools: screenshot mode is disabled
    And I close all dialogs
