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
- **Both of Anomaly's entity holders** become recreation sources, by patch: the steel holding
  platform and the holding spot. Each gains a `joyKind`, a `JoyGainFactor`, a watch distance range
  of 2 to 6 cells, the same-room requirement every vanilla watch building carries, and the place
  worker that draws that range at build time. It costs nothing: they were already built for study.
- The **holding spot gives less** than the platform, 0.8 against 1, following the game's own
  description of it. An entity roped to the floor is a poorer show than one clamped to a frame.
- `JoyGiver_WatchEntity`, the mod's only class. It is the vanilla `JoyGiver_WatchBuilding` plus one
  condition — the platform must be holding a living pawn — without which colonists would gaze at
  empty platforms.
- French translation.

- **A test suite**, in `_tools/`. Nothing a player sees changes. Two scripts, neither of which
  starts the game: one on the shape of the mod, one on whether the base game still does what the mod
  hands it to do. They read the installed game's own data and assembly, so they check what the mod
  assumes rather than what its prose claims.
- **A mutation campaign**, `_tools/Run-Mutations.ps1`, which breaks the mod on purpose on a copy and
  checks that the right test turns red. Every mutation has been watched doing so; the tests that
  cannot be reddened that way are named at the foot of each suite instead of being passed over.

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
