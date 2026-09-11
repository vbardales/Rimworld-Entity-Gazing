# Changelog

Format inspired by [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file serves the repository and the writing of Steam patch notes; RimWorld does not display it in game.

## [Unreleased]

Nothing released yet. The mod has never been published and has never been watched running in a
colony.

### Added

- **Entity gazing**, a recreation type of its own, `EG_EntityGazing` — the point of the mod. The
  Anomaly DLC ships no recreation content whatsoever, and tolerance being counted per type, an
  eleventh type is worth more than another building on a type the colony already has.
- The **holding platform** becomes a recreation source, by patch. It gains a `joyKind`, a
  `JoyGainFactor`, a watch distance range of 2 to 6 cells and the place worker that draws that
  range at build time. It costs nothing: the platform was already built for study.
- `JoyGiver_WatchEntity`, the mod's only class. It is the vanilla `JoyGiver_WatchBuilding` plus one
  condition — the platform must be holding a living pawn — without which colonists would gaze at
  empty platforms.
- French translation.

### Notes

- The walk, the facing and the joy gain are the base game's own television pair,
  `JoyGiver_WatchBuilding` and `JobDriver_WatchBuilding`, which apply unmodified because a holding
  platform is a `Building`.
- The close watch distance is the design: a nociosphere's `PainField` reaches 5.9 cells, so part of
  the audience stands inside it. The price of the show comes out of a vanilla mechanic, not a line
  of this mod's code, and it varies by entity.
- No thought is granted, deliberately.
- `HoldingSpot` is not covered, though it carries the same comp and class.
- `watchBuildingInSameRoom` is not set, where all five vanilla watch buildings set it. A watcher may
  therefore be able to stand outside the containment room, through a wall — and out of the pain
  field. Both gaps are written up in the README and have a scenario in `TESTING.md`.
