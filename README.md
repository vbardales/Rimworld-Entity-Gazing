# Entity Gazing

A RimWorld mod that lets colonists go and look at the horrors you keep chained up, as recreation —
and, with it, a recreation type the base game does not have.

Needs the Anomaly DLC. Without it the mod loads and adds nothing.

## Why it is worth a mod

**The Anomaly DLC contains no recreation content at all.** Not one `JoyKindDef`, not one
`JoyGiverDef`, not a single `joyKind` anywhere in it. You capture entities, bolt them to a platform
in the middle of your base, study them for knowledge, and then nobody ever looks at them again.

| Data folder | `JoyKindDef` | `JoyGiverDef` | `joyKind` |
|---|---|---|---|
| Core | 10 | 20 | 60 |
| Anomaly | 0 | 0 | 0 |

The new type matters more than the new activity. Two rules make that so:

- **Expectations ask for up to six different types**, not six pieces of furniture.
- **Tolerance is counted per type.** A colonist who has played chess all week is just as tired of
  poker.

So an eleventh type is worth far more than another building on a type the colony already had. Of
the base game's ten types, only five come from a building at all — Gaming_Cerebral,
Gaming_Dexterity, HighCulture, Telescope and Television. And this one costs nothing extra: the
platform was already built for study.

## The viewing distance is the real setting

Watchers stand two to six cells away, which is deliberately close. A nociosphere carries a
`CompProperties_CauseHediff_AoE` that applies `PainField` out to 5.9 cells, so a good share of the
audience will be standing inside it.

That is the price of the show, and it comes out of an existing vanilla mechanic rather than a line
of code. It varies by entity on its own — a fleshbeast hurts nobody. Widening
`watchBuildingStandDistanceRange` in the patch makes the activity harmless.

No thought is granted, deliberately. A positive one would reward contemplating an abomination; a
negative one would turn a source of recreation into a source of malus. The joy gained is already
the reward and the pain field already the price.

## What it is

| | |
|---|---|
| **Cost** | Nothing. It patches the holding platform you already built |
| **Recreation type** | `EG_EntityGazing`, its own |
| **Watched from** | 2 to 6 cells, in a rect 5 wide |
| **Chair** | Not needed |
| **Capacity required** | Sight |
| **Save data** | None of its own |

## How it works

The walk, the facing and the joy gain are the base game's own television logic:
`JoyGiver_WatchBuilding` driving `JobDriver_WatchBuilding`, unmodified.

They apply here because a holding platform is a `Building`. That is not a given: the same family of
drivers raises an `InvalidCastException` on a `Plant`, which is why an anima tree cannot be wired up
this way.

One class, `JoyGiver_WatchEntity`, is the mod's entire assembly. It adds a single condition to the
vanilla giver: the platform must actually be holding a living pawn. Without it, naming
`HoldingPlatform` in a vanilla `JoyGiverDef` would be enough — but colonists would then go and
contemplate empty platforms, which is to say a steel frame with chains hanging off it.

`CompEntityHolderPlatform` belongs to Anomaly but lives in `Assembly-CSharp` like all expansion
code, so the class exists even without the DLC and no reflection is needed. The defs carry
`MayRequire` instead.

## Known gap

The mod covers the **holding platform** only. `HoldingSpot`, the early-game version, carries the
same `CompProperties_EntityHolderPlatform` and the same `Building_HoldingPlatform` class, so it
would work the same way and is simply not wired up. Adding it means one more `li` in the giver's
`thingDefs` and a second patch — which has to add *into* that def's existing `<building>` node
rather than create one.

## Not yet tested in a running colony

Nothing here has been watched happening in game. The mod builds, the defs and the patch are what
this page describes, and that is the whole of what has been verified.

## Languages

English and French.

## Credits

Written with Claude Code (Anthropic), under human direction and review.

Thanks to Ludeon Studios, whose television carries every bit of this mod's behaviour.

## If I go quiet

If I do not answer within a reasonable time after being contacted, anyone may freely update this or
any other of my mods, including publishing a continuation of it. All credit must be preserved.

## Licence

MIT. See [LICENSE](LICENSE).
