Feature: the optional MainButtons shortcut

  # The shortcut must be hidden by its own def rather than pushed down every frame, must stay
  # revealable by a customization mod, and must open the same settings instance as Mod options. The
  # out-of-game suite reads the def and finds no visibility override; a running game is what shows
  # the worker actually drawing, enabling and opening.
  #
  # No @requires tag: nothing here needs a third-party editor. The reveal is done the way one would
  # do it, by setting the same field, which is the mechanism any such mod uses. Whether a specific
  # editor version finds this button is a separate claim, and it belongs to a pass that stages that
  # editor - it is not asserted here, and it is listed as unverified in STATUS.md.

  Background:
    Given the save "test-colony" is loaded
    And I close all dialogs

  Scenario: hidden on a clean configuration, and not merely greyed out
    Then Entity Gazing the shortcut is hidden on a clean configuration

  Scenario: revealed, it draws, enables and opens the same settings
    When Entity Gazing reveals its shortcut as a customization mod would
    Then Entity Gazing the shortcut is drawn and enabled
    When Entity Gazing activates its shortcut
    Then Entity Gazing sees its own settings window open
    And Entity Gazing the open window edits the same settings instance
    When I close all dialogs
    And Entity Gazing hides its shortcut again
    Then Entity Gazing the shortcut is hidden on a clean configuration
    And no errors were logged
