# Pictures for the Workshop page, not verification. Nothing here asserts anything the other
# thirteen features do not: this one exists so the gallery images are taken in a scene chosen for
# them, in the Sanctuary, rather than cropped by hand out of the test colony's evidence.
#
# VALID ONLY IN THE SANCTUARY PASS: wsl-deps.sanctuary.map stages Sanctuary Backlot, its body, trousers and face mods
# (the fixture "Nelims-tribe" and the named places), the studio companions and the lantern mod. The other passes skip this file.
#
# Every shot is @review: a green scenario proves an image was produced, not that it shows what
# the page says. Each one is opened and looked at before it goes into the gallery folder.
#
# THE STORY (one story, GALLERY.md). Nelim, the colony's only colonist, keeps a creature chained in the walled
# enclosure `enclosure-south`. One late afternoon she finds that watching it is the best entertainment she has, and
# she calls her two friends over. They stand round it while the light goes: the audience gathers (1), she sees how
# the game places the thing that will hold it (2), shows the other kind of holder (3), the night falls and the
# creature that hurts has its say, at a price (4); the dial the player turns is the last picture (5).
# Nelim is the protagonist of every frame (main character rule): her own trousers, corset and face come from the
# fixture and the pass (nothing here dresses her); Iris and Basil are her guests, dressed in colours chosen to
# stand off hers. Dusk is lit by what a camp would hold: stick lanterns, a torch, a campfire.
#
# SHOOTING PLAN, in gallery order after 0- (the Preview). Place: the enclosure, holder on cell (149, 214), camera
# centred ON the holder after the colonists have walked, then zoomed. Time: the same afternoon, an hour apart at most.
#   1. gaze          17h. Nelim, Iris and Basil in a half circle round a platform and a held fingerspike; two stick lanterns
#                    and a campfire behind them in the foreground-south; zoom 5, subject in the middle third. Says: the
#                    audience arrives, the colonists look at it, a thing the mod adds.
#   2. watch area    18h. The ghost of a holding platform at the pointer with the cross of four outlined rects, Nelim at
#                    its east edge looking on, a lantern lit near her; zoom 7 (the rects need room). Says: the game
#                    shows where people will stand before you build.
#   3. holding spot  18h. The other holder, a floor marker, Nelim and Basil close beside it, one lantern, a daylily pot;
#                    zoom 4 (a closer portrait than 1). Says: it works for the cheaper holder too.
#   4. pain field    19h, dusk. A nociosphere on a platform, Nelim and Basil at arm's reach, a torch and a campfire
#                    lighting their faces; zoom 4; the hediff proven first, so their faces carry the pain Facial
#                    Animation draws. Says: the price, on the faces.
#   5. settings      the Mod options window alone, on the backdrop for a tall window, cropped sideways.
@review @requires:nelim.sanctuarybacklot @requires:nelim.pickletools.screenshotstudio @requires:nelim.pickletools.stagedecor @requires:nelim.pickletools.clearscreen @requires:nelim.pickletools.screenshotmode @requires:nelim.pickletools.colonistrace @requires:Mlie.StickLantern
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
    Given I set the hour to 17
    And Entity Gazing spawns a "HoldingPlatform" at x=149 z=214
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Nelim's Pickle Tools: I place the decor "DR_StickLantern" at (144, 218)
    And Nelim's Pickle Tools: the decor "DR_StickLantern" at (144, 218) is lit
    And Nelim's Pickle Tools: I place the decor "DR_StickLantern" at (154, 218)
    And Nelim's Pickle Tools: the decor "DR_StickLantern" at (154, 218) is lit
    And Nelim's Pickle Tools: I place the decor "Campfire" at (149, 210)
    And Nelim's Pickle Tools: the decor "Campfire" at (149, 210) is lit
    And Nelim's Pickle Tools: "Nelim" stands at (153, 216)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Iris" with no recreation where the camera looks
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    And Nelim's Pickle Tools: "Iris" wears "Apparel_BasicShirt" dyed rgb (36, 112, 122)
    And Nelim's Pickle Tools: "Iris" wears "Apparel_Pants" dyed rgb (52, 48, 56)
    And Nelim's Pickle Tools: "Basil" wears "Apparel_BasicShirt" dyed rgb (204, 150, 52)
    And Nelim's Pickle Tools: "Basil" wears "Apparel_Pants" dyed rgb (52, 48, 56)
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
    And Nelim's Pickle Tools: the decor is removed

  Scenario: the watch area drawn under the build designator
    # The studio maps keep no steel and the designator prices what it is about to place, honestly: a red
    # "40 (not enough stored)" label sat on the ghost in the first studio run. Stock it so the label is true.
    # The designator draws at the pointer, which is the camera centre: the enclosure's centre, (149, 214).
    Given I set the hour to 18
    And Nelim's Pickle Tools: I place the decor "DR_StickLantern" at (156, 217)
    And Nelim's Pickle Tools: the decor "DR_StickLantern" at (156, 217) is lit
    And Nelim's Pickle Tools: "Nelim" stands at (156, 214)
    And Entity Gazing zooms the camera to 7 cells
    And Entity Gazing has steel stocked near the placement
    When Entity Gazing holds the build designator for "HoldingPlatform"
    Then Entity Gazing the game is about to draw a watch area at the pointer
    When Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - watch area"
    And Nelim's Pickle Tools: the decor is removed

  Scenario: the holding spot is watched too
    Given I set the hour to 18
    And Entity Gazing spawns a "HoldingSpot" at x=149 z=214
    And Entity Gazing tethers a downed "Fingerspike" to it
    And Nelim's Pickle Tools: I place the decor "DR_StickLantern" at (146, 217)
    And Nelim's Pickle Tools: the decor "DR_StickLantern" at (146, 217) is lit
    And Nelim's Pickle Tools: I place the decor "PlantPot" at (152, 211)
    And Nelim's Pickle Tools: "Nelim" stands at (152, 215)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    And Nelim's Pickle Tools: "Basil" wears "Apparel_BasicShirt" dyed rgb (204, 150, 52)
    And Nelim's Pickle Tools: "Basil" wears "Apparel_Pants" dyed rgb (52, 48, 56)
    When Entity Gazing asks the giver for a job for "Nelim"
    And Entity Gazing "Nelim" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 600 ticks
    Then Entity Gazing "Nelim" is watching the holder
    And Entity Gazing "Basil" is watching the holder
    When Entity Gazing centres the camera on the holder
    And Entity Gazing zooms the camera to 4 cells
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - holding spot"
    And Nelim's Pickle Tools: the decor is removed

  Scenario: Nelim inside a nociosphere's reach
    Given I set the hour to 19
    And Entity Gazing spawns a "HoldingPlatform" at x=149 z=214
    And Entity Gazing tethers a downed "Nociosphere" to it
    And Nelim's Pickle Tools: I place the decor "TorchLamp" at (145, 217)
    And Nelim's Pickle Tools: the decor "TorchLamp" at (145, 217) is lit
    And Nelim's Pickle Tools: I place the decor "Campfire" at (153, 211)
    And Nelim's Pickle Tools: the decor "Campfire" at (153, 211) is lit
    And Nelim's Pickle Tools: "Nelim" stands at (152, 215)
    And Entity Gazing "Nelim" has no recreation
    And Entity Gazing spawns the colonist "Basil" with no recreation where the camera looks
    And Nelim's Pickle Tools: "Basil" wears "Apparel_BasicShirt" dyed rgb (204, 150, 52)
    And Nelim's Pickle Tools: "Basil" wears "Apparel_Pants" dyed rgb (52, 48, 56)
    When Entity Gazing asks the giver for a job for "Nelim"
    And Entity Gazing "Nelim" starts the offered job
    And Entity Gazing asks the giver for a job for "Basil"
    And Entity Gazing "Basil" starts the offered job
    And I wait 1200 ticks
    Then Entity Gazing "Nelim" carries the hediff "PainField"
    When Entity Gazing centres the camera on the holder
    And Entity Gazing zooms the camera to 4 cells
    And Nelim's Pickle Tools: studio presentation mode is enabled
    And I take a screenshot "publication - pain field"
    And Nelim's Pickle Tools: the decor is removed

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
