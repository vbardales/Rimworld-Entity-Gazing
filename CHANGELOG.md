# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it in game.

## [Unreleased]

Nothing since 0.1.0. The version that arrives with publication is 1.0.0, and it is not here yet.

## [0.1.0] — 2026-09-24

Creation of a published file ID. A first upload whose only purpose was to create the Workshop
item and bring back `Mod/About/PublishedFileId.txt`, which is item **3806760893**. Steam creates
every item private; this one has not been made public, and the entry says nothing about the mod
being tested or released.

What the upload contained is `Mod/` exactly as it stood at commit `c6dc0a5`, and nothing but that
file has changed since.

### Added

- **Entity gazing**, a recreation type of its own, `EG_EntityGazing` — the point of the mod. The
  Anomaly DLC ships no recreation content whatsoever, and tolerance being counted per type, an
  eleventh type is worth more than another building on a type the colony already has.
- **Both of Anomaly's entity holders** become recreation sources, by patch: the steel holding
  platform and the holding spot. Each gains a `joyKind`, a `JoyGainFactor`, a watch distance range
  of 2 to 6 cells, the same-room requirement every vanilla watch building carries, and the place
  worker that draws that range at build time. It costs nothing: they were already built for study.
- The **holding spot gives less** than the platform, 0.8 against 1, following the game's own
  description of it. An entity roped to the floor is a poorer show than one clamped to a frame.
- `JoyGiver_WatchEntity`, the mod's gameplay giver. It is the vanilla `JoyGiver_WatchBuilding` plus
  one condition — the platform must be holding a living pawn — without which colonists would gaze
  at empty platforms.
- **Global viewing-distance settings**, 1 to 20 cells with defaults 2 to 6, reachable through Mod
  options, with an optional MainButtons shortcut that is hidden by its own def and opens the same
  window.
- French translation, settings labels included.
- Distributed MIT licence and provenance documentation.

### Notes

- The walk, the facing and the joy gain are the base game's own television pair,
  `JoyGiver_WatchBuilding` and `JobDriver_WatchBuilding`, which apply unmodified because a holding
  platform is a `Building`.
- The close watch distance is the design: a nociosphere's `PainField` reaches 5.9 cells, so part of
  the audience stands inside it. The price of the show comes out of a vanilla mechanic, not a line
  of this mod's code, and it varies by entity.
- No thought is granted, deliberately.
- The patch is not symmetrical between the two holders, and cannot be: `HoldingPlatform` has no
  `building` node and gets one created at the root, `HoldingSpot` has one and gets its settings
  added inside it. Reversing the two produces sibling nodes the game silently half-reads.

### Development, not shipped

- **Three test suites** in `_tools/`, none of which starts the game: the shape of the mod, what the
  base game still does with what the mod hands it, and the settings. 76 checks, all green.
- **A mutation campaign**, `_tools/Run-Mutations.ps1`, which breaks the mod on purpose on a copy
  and checks that the right test turns red. Every mutation was recorded doing so before the
  settings work; it has not been rerun since.
- **Sixteen manual scenarios** in `TESTING.md`, none of them played in a colony.
