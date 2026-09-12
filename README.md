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

## Both holders, and the trap that comes with them

Anomaly ships two entity holders, and the mod covers both: the steel **holding platform**, and the
**holding spot**, the floor marker you use before you can build one. They share a comp and a class,
so they watch identically. The spot gives less — a `JoyGainFactor` of 0.8 against the platform's 1,
following the game's own line that it is *not as good as a steel holding platform, but a lot better
than nothing*.

Patching the two is not symmetrical, and that is the one real trap in the file. `HoldingPlatform`
has a `statBases` and **no** `building` node; `HoldingSpot` has both. So the platform's building
settings are created at the root and the spot's are added inside the node it already has. Do it the
other way round and you get two sibling nodes, of which the game reads one — silently, with a holder
that looks perfectly normal until someone tries to use it.

Watchers are held to the same room, as on all five vanilla watch buildings. That one is not
cosmetic either: without it a colonist can stand behind the containment wall and stay clear of the
pain field the whole design rests on.

## Tests

```
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
```

Two suites, no RimWorld launched, well under a minute for both. They read the installed game — its
`Data` folder and its `Assembly-CSharp` — so they check what this mod assumes rather than what this
page claims.

The first is about form: 23 form tests covering well-formed XML, every element still a field on its
1.6 class, translation keys that name a real def and a real field, packaging, and the documents
against the defs. The last group is the one that keeps this page honest — every number quoted here
and in the changelog is read back out of the XML, so changing a value and not the prose turns the
suite red.

The second is about behaviour, because this mod owns almost none of its own. It checks that the one
override still takes the base class's vtable slot rather than a new one, which is the difference
between the mod working and colonists gazing at empty platforms with no error anywhere. It runs the
game's own patch engine on the shipped patch file against the real Anomaly defs, and reads the
result. And it scans every method body in the game to find who reads each setting these defs write
— the fault nothing else catches, a setting no code on its path ever reads.

The numbers in this file are recomputed at every run: Anomaly shipping no recreation content, ten
recreation types in Core with five from a building, the nociosphere's pain field at 5.9 cells. A
RimWorld release that moves one of those is reported instead of quietly ageing the page.

```
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Mutations.ps1
```

A green suite proves nothing on its own, so a third script breaks the mod on purpose — 33 mutations
on a copy, each aimed at one test. Every one of them has been watched turning its test red. Which
tests that leaves unproven, and why, is written at the foot of each suite rather than left to
assumption.

## Not yet tested in a running colony

Nothing above plays. The mod has never been watched running in a colony.

[TESTING.md](TESTING.md) holds the fourteen scenarios that have to be watched there — the gaze
itself, the empty platform nobody looks at, the pain field that is the price of the show — with what
counts as a pass for each.

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
