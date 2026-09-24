# Entity Gazing — in-game test scenarios

Nothing in this mod has ever been watched happening in a colony. This file is the list of what has
to be seen, and what counts as a pass for each.

Two test suites run beside it, in `_tools/`, and neither of them starts the game. They check that
the defs are well formed, that the game still has every field and class they name, that the one
override still takes the slot it means to, and that the patch lands where it aims. None of that is
a single tick of play, which is what this file is for.

It is not shipped: it lives beside `Mod/`, never inside it, so Steam never receives it.

## Before starting

- RimWorld 1.6 with the **Anomaly** DLC. Development mode on, so that silent failures become red
  text.
- The log to read afterwards, and to attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`
- Materials and subjects: a **holding platform** costs steel and needs research in a normal game.
  Debug actions → Spawn thing → `HoldingPlatform` and `HoldingSpot`, and Debug actions → Spawn pawn
  → an entity such as `Nociosphere`, `Fleshbeast` or `Shambler`. An entity has to be **downed**
  before it can be tethered. Both holders are covered by the mod and scenario 13 compares them.
- Colonists with recreation already low, and a schedule block set to Recreation. Debug actions →
  Needs → set recreation to zero is faster than waiting.

Useful conversions: 60 ticks is one second at normal speed, 2500 ticks is one in-game hour. A full
gaze is **4000 ticks**, so about an hour and a half of game time.

The numbers this file leans on, all read out of the defs: watch distance **2 to 6** cells in a rect
**5** wide, **5** participants at most, `JoyGainFactor` **1**, base chance **2**, sight required,
no chair wanted.

---

## 1. It loads, with and without the DLC

Everything else depends on this. All three gameplay defs carry `MayRequire="Ludeon.RimWorld.Anomaly"` and
the patch is wrapped in a `PatchOperationConditional`, so the mod is supposed to be inert rather
than broken when the DLC is off.

1. Start the game with the mod active and **Anomaly disabled**.
2. Read the log.

**Pass:** no red line, no `Could not resolve cross-reference`, no failed patch. The assembly still
loads — it always does, and that is by design — but nothing of the mod appears in game.
**Fail:** any error naming `EG_`, `HoldingPlatform`, or `EntityGazing.JoyGiver_WatchEntity`.

3. Enable Anomaly, restart, read the log again.

**Pass:** still clean, and the three defs exist. Check with Debug actions → **Def lookup**, or the
debug inspector: `EG_EntityGazing`, `EG_WatchEntity` (the job) and `EG_WatchEntity` (the giver).

A failed `PatchOperationAdd` is the likely fault here and it is **loud** — the game names the file
and the xpath. A silently wrong one is the next test.

## 2. The patch landed where it was aimed

This is the scenario for the one real subtlety in the XML. `HoldingPlatform` already has a
`<statBases>`, so the patch adds *inside* it; `<building>` does not exist on the def, so the patch
creates it at the root and relies on inheritance merging it with the parent's.

1. Build or spawn a holding platform.
2. Debug inspector on it, or Debug actions → Def lookup → `HoldingPlatform`.

**Pass, and check all four:**

- `JoyGainFactor` is **1**, and the platform's other stats are **still there**. If the patch had
  created a second `<statBases>` sibling, the game would read only one and the platform would have
  lost its original stats — that is the failure this test exists for.
- `building.joyKind` is `EG_EntityGazing`.
- `building.watchBuildingStandDistanceRange` is `2~6`.
- **The rest of the `<building>` block survived.** The holding platform inherits building settings
  from `HoldingPlatformBase`; if the new node replaced rather than merged, they are gone. This is
  the other half of the same risk and it is easy to miss, because a platform with a broken
  `<building>` block still looks normal until you try to tether something to it.

3. Select the platform in the build menu, before placing it.

**Pass:** the watch area is drawn on the ground — that is `PlaceWorker_WatchArea`, added by the
same patch. If no area is drawn, the place worker did not land.

## 3. An occupied platform becomes a recreation source

1. Spawn an entity, down it, have it tethered to the platform.
2. Select the platform.

**Pass:** the inspect pane names it as a source of recreation, and the recreation type reads
**entity gazing**. In French, `contemplation d'entité`.

3. Open a colonist's Needs tab, Recreation, and hover the list of types.

**Pass:** entity gazing is among the types the colony can offer. This is the whole point of the
mod, so if it is absent here, stop and read the log.

## 4. A colonist goes and watches, on their own

Translation validation: repeat scenarios 3 and 4 in English and French, with Anomaly
enabled, for both the holding platform and holding spot. Check the recreation source,
Needs tooltip and active job report against the text inventory in STATUS.md. Also observe
an opportunistically started job, since its report allows the vanilla opportunistic prefix.
Fail on raw keys, English fallback in French, broken accents, malformed prefixes or clipping.
Record game version, date, language, holder and results. These language checks have not yet
been executed in a running colony.

The one behaviour everything else supports.

1. A colonist with recreation low, a schedule block on Recreation, an occupied platform in reach.
2. Let it run. Do not force the job.

**Pass:** the colonist walks to the platform, stops **two to six cells away**, faces it, and the
job description reads *watching the contained entity* (French: *observe l'entité captive*).
Recreation rises. The bar's tooltip credits **entity gazing**.
**Fail, and each means something different:**

- Never goes → the giver is not being picked. Check `baseChance`, the schedule, and whether the
  platform is reachable and in a socially proper room (see scenario 9).
- Goes and stands on the platform's own cell, or ten cells away → the distance range did not land;
  go back to scenario 2.
- Goes and the job ends instantly → `JobDriver_WatchBuilding` is failing its own checks. The log
  usually says why.

3. Let the job run to the end rather than interrupting it.

**Pass:** it lasts about 4000 ticks, an hour and a half of game time, unless something interrupts.

## 5. An empty platform is never watched

**This is the gameplay giver's occupancy condition.** `JoyGiver_WatchEntity` exists for this single
condition and nothing else; if this test fails, the assembly is not being used at all.

1. Leave a holding platform built and **empty**.
2. Colonists with recreation at zero, Recreation scheduled, nothing else on offer.
3. Let it run for a full day.

**Pass:** nobody ever walks over to stare at an empty steel frame. The platform does not appear as
an available recreation source while it is empty.
**Fail:** a colonist gazes at nothing. That means the vanilla `JoyGiver_WatchBuilding` is running
instead of the mod's subclass — check that `giverClass` reads `EntityGazing.JoyGiver_WatchEntity`
and that the assembly loaded.

## 6. A dead entity is not a show

The same condition, second half: `held != null && !held.Dead`.

1. An occupied platform, a colonist mid-gaze.
2. Kill the entity while it is still tethered. Debug actions → Kill, or damage it.

**Pass:** the corpse on the platform stops being a recreation source. No new colonist starts a
gaze. The one already watching may finish their job — the check runs when the job is chosen, not
every tick — but nobody starts a new one.

## 7. The pain field is the price of the show

The design claim of the whole mod, and it is meant to come out of vanilla rather than out of this
mod's code.

1. Tether a **nociosphere** specifically. It carries a `CompProperties_CauseHediff_AoE` applying
   `PainField` out to **5.9** cells.
2. Let several colonists gaze, standing at their various distances.

**Pass:** the watchers standing inside 5.9 cells pick up the `PainField` hediff and hurt; the ones
at the far end of the range may not. Recreation still rises — pain is the cost, not a veto.

3. Repeat with a **fleshbeast**, which has no such comp.

**Pass:** nobody hurts. The price varies by entity, on its own, with no code of ours. That is the
point: it is a vanilla mechanic being used, not simulated.

If you decide the cost is too harsh, use Mod options -> Entity Gazing to set a minimum distance above 5.9 cells.

## 8. Several watchers, and no chairs

1. Five or more colonists free at once, one occupied platform, recreation low all round.

**Pass:** up to **five** watch at the same time (`joyMaxParticipants`), spread across the watch
area, all facing the platform. A sixth does something else.

**Pass, and check it explicitly:** nobody drags a chair over. `desireSit` is false, deliberately —
you do not pull up a seat in front of a cage of horrors. A colonist sitting down here means the
giver being used is not the one this mod declares.

## 9. The room has to be proper

The patch sets `socialPropernessMatters`, the same flag the vanilla televisions carry.

1. Put a holding platform inside a **prison** room, with an entity on it.
2. A free colonist with recreation low, nothing else on offer.

**Pass:** the free colonist does not go. Prisoners in that room might.

This is worth watching rather than assuming, because containment rooms and prison rooms are easy to
confuse in a real base, and a platform in the wrong sort of room simply produces a recreation
source nobody ever uses — with no error anywhere.

## 10. Sight is required

1. A colonist blinded, or with both eyes destroyed. Debug actions → damage, or spawn one.
2. Recreation low, an occupied platform available, nothing else on offer.

**Pass:** they never go. `requiredCapacities` is `Sight` alone, and this activity is nothing but
looking.

**Pass, second half:** a colonist with **no hands** goes anyway. Hands are not required and must not
be — you very much do not touch.

## 11. On the way past

`allowOpportunisticPrefix` is true, so the job may be taken as a detour rather than as a decision.

1. A colonist with a long walk that passes near an occupied platform, recreation somewhat low but
   not desperate.

**Pass:** they sometimes stop and watch on the way, then carry on. This is a *sometimes*, not an
*always*; it is not a fail unless it never happens across a long session.

## 12. Save, quit, reload

The mod adds no colony save data. Global viewing-distance settings are stored separately.

1. Mid-gaze, save. Quit to the menu. Reload.

**Pass:** the colony loads with no error naming `EG_` or `EntityGazing`, and the colonist either
resumes or picks a new job. Nothing in the log about a missing class or an unresolved reference.

2. With the same save, **disable the mod** and load it again.

**Pass:** the save opens. The recreation type disappears from the colony, which is expected and
harmless; there is no orphaned component to complain about.

## 13. The holding spot works too, and is a poorer show

`HoldingSpot`, the floor marker you use before you can build a platform, carries the same
`CompProperties_EntityHolderPlatform` and the same `Building_HoldingPlatform` class. The mod covers
both.

1. Build a holding spot, no platform anywhere, tether an entity to it.
2. Colonists with recreation low.

**Pass:** they go and watch it, exactly as they would a platform. The watch area is drawn when the
spot is selected in the build menu.

3. Compare the recreation gained here with the same gaze at a platform.

**Pass:** the spot gives noticeably less. Its `JoyGainFactor` is **0.8** against the platform's
**1**, following the game's own description of it — *not as good as a steel holding platform, but a
lot better than nothing*. An entity roped to the floor is a poorer show than one clamped to a frame.

**This scenario also guards the patch's one real trap,** which is inverted between the two defs. The
spot already has a `<building>` node where the platform has none, so its settings are added *inside*
it while the platform's are created at the root. Get that backwards and the spot ends up with two
`<building>` nodes, the game reads one, and the spot keeps its original settings while silently
gaining none of the new ones. Worth a look in Debug → Def lookup: the spot's `building` block must
still carry `sowTag` and `artificialForMeditationPurposes` **alongside** the new `joyKind`.

## 14. Watchers stay in the room

`watchBuildingInSameRoom` is set on both holders, as all five vanilla watch buildings set it. This
is not cosmetic: it is what keeps the audience inside the pain field.

1. Put a holder in a sealed containment room with an entity on it.
2. Colonists outside, in an adjacent room, within six cells of it through the wall.

**Pass:** nobody watches from out there. Watching happens inside the room or not at all.
**Fail:** a colonist stands on the far side of a wall and gazes. They would be watching through
solid stone, and — worse for the design — standing clear of the pain field that is the whole price
of the show.

## 15. Settings, bounds, defaults and persistence

Preconditions: RimWorld 1.6 with Anomaly and Entity Gazing; no customization mod. Start
with a fresh mod configuration, then repeat with an existing colony save. Reset to default
settings before running the earlier gameplay scenarios. Repeat this scenario in EN and FR.

1. Open Mod options -> Entity Gazing. Expect minimum 2 and maximum 6, readable labels/help,
   correct accents and no raw keys, fallback, clipping or errors in Player.log.
2. Move each slider to both ends. Expect integer values between 1 and 20, always min <= max.
   There is no text entry, so empty or nonnumeric input is not applicable.
3. Set 8 to 12, close the dialog, and start new watching jobs at both holder types in a
   sufficiently large room. Expect new viewing positions within 8 to 12 cells. Current jobs
   may finish at their old positions. The nociosphere's 5.9-cell field should not reach them.
4. Reopen settings, restart the game and reload the save. Expect 8 to 12 retained. Start a new
   colony and expect the same global values. Observe new jobs and check logs again.
5. Restore defaults. Expect both controls and both holder ranges to return to 2 to 6.
6. Disable Anomaly and restart. Open and save settings without exceptions; no activity exists.

Record game version, language, new/existing save, observed ranges, log path and outcome.
Not executed in game yet.

## 16. Optional MainButtons shortcut

Preconditions: default configuration, then RIMMSQOL or another compatible button editor.
Record the exact editor version; repeat the checks in EN and FR.

1. Without an editor, expect no visible or greyed-out Entity Gazing main button. The ordinary
   Mod options entry must still work.
2. With the editor, find EG_Settings and reveal it. Click it: expect the same native settings
   window and values as Mod options. Change to 7 to 10 and close; reopen through Mod options
   and expect 7 to 10. Reverse the route and verify shared values and persistence after restart.
3. Hide the shortcut through the editor, restart, and expect it to stay hidden. Remove the
   editor and verify Mod options still works. Restore 2 to 6 before gameplay regressions.
4. Check labels, help, accents, clipping and Player.log throughout. Expect no errors.

Not executed in game; no third-party integration version is certified yet.
---

# What is still missing, and what it takes to close it

Everything above is a **manual** scenario, and none has been played. Under the current bar for
`tested`, a manual scenario is not a form of test that can be signed off: what was left to tick by
hand is either automated and green, or listed as not applicable with its reason. So the sixteen
above are not the last mile — they are the specification for the Pickle suites that do not exist
yet.

## The Pickle suites this mod needs, and the passes to run them in

None is written. This is the gap that keeps the mod at `preTest`, and this section is here so the
work is specified rather than rediscovered.

What belongs in Gherkin is only what a running game can show. Anything an out-of-game suite already
proves must stay out: a scenario that repeats `_tools/` confiscates the machine for tens of minutes
at every run and adds nothing.

| Scenario above | Where it belongs |
|---|---|
| 1 loads with and without the DLC | Gherkin, one pass per DLC state |
| 2 the patch landed where it aimed | already proved out of game, by the patch-engine test — **drop** |
| 3, 4, 5, 6 the gaze itself | Gherkin, the heart of it |
| 7 the pain field | Gherkin |
| 8, 10, 11 participants, sight, opportunistic | Gherkin |
| 9 socially proper room | Gherkin |
| 12 save, quit, reload | Gherkin, nothing else survives a reload |
| 13 the holding spot | Gherkin |
| 14 watchers stay in the room | Gherkin |
| 15 settings bounds and persistence | partly proved out of game; only the window lifecycle and the restart are Gherkin |
| 16 the MainButtons shortcut | Gherkin, with a `@requires` on the button editor |

**Three passes, and the file has to say so or the mod is merely tried.**

1. **Without the optional mods** — the minimal set the staging script mounts: Core, the DLC,
   Harmony, RimLogging, Pickle, the hard dependencies and this mod. It proves the mod stands on its
   own, and it is the only pass whose screenshots are clean.
2. **With the optional mods** — what `loadAfter` names plus what the dependency map adds. It proves
   the mod stands in the scenery it will actually load in.
3. **One pass per language**, `-Language French` and English. The language is fixed at staging and
   never switched during a run: switching reloads every def under the runner and the step waits for
   a language that never arrives.

There is no declared incompatibility, so no incompatibility pass is owed. If one is ever declared,
it takes a pass of its own whose job is to go and look at whether the claim is still true.

`@requires:` is owed on scenario 16 alone, since the button editor is the only optional thing any
scenario needs. A scenario skipped for want of its condition is not a scenario passed: that pass
has to be run with a map that mounts the editor, and its report read before it is cited.

## The bar for `tested`

Four conditions, and the first three are recent:

- **No scenario left in `@wip`.** One set aside is either repaired and replayed, or deleted with
  its reason. A remaining `@wip` is not a pass, it is a postponement.
- **Every conditional scenario has run.** Each `@requires:` has had its own pass, on a map that
  mounts what it requires, and that report has been read — `setName` and the suite and scenario
  names checked before it is cited, because the report folder is shared by the whole machine.
- **No manual test left to sign off.** Automated and green, or listed as not applicable with its
  reason.
- **`@review` screenshots actually opened and looked at.** That one is not another manual test: it
  is reading an image a scenario has already proved to be in the right state. A green `@review`
  says the journey happened, never that the picture shows anything.

Read `exitReason` before any number in a report, and check scenarios played against features
discovered. A run killed in flight leaves something that looks exactly like a result.

## Evidence: what is kept, and what goes

Reports are **kept on disk, never in git**. Screenshots and `Player.log` grow without bound, and
`.gitignore` here excludes `Tests/Pickle/Evidence/`, `evidence/` and `pickle-reports-archive/`.

Ask the launcher to keep a run with `-EvidenceDir Tests/Pickle/Evidence/<run>`: it copies the report
into the mod **before the lock is released**, which the shared rolling archive does not survive.

**Keep, out of a run:**

- `summary.md`, `summary.json` and `junit.xml` — small, and they carry `exitReason`.
- the `@review` screenshots of the pass **without the optional mods**, which are the only clean
  ones, and only those a scenario actually points at.
- `Player.log` **only** when the run failed or something has to be explained. A green run's log
  proves nothing that the summary does not.

**Delete:**

- every screenshot of the passes with optional mods, unless one is the sole proof of something.
- every report about a build that has been superseded. A report on an older DLL says nothing about
  the current one, and it is the most expensive kind of file to keep: it looks like proof.
- everything a newer report replaces, as soon as it replaces it. This decision is never left to the
  next run.

**Commit instead:** one short text summary per run under `docs/runs/`, named for its date and the
commit it ran against, cited by `STATUS.md`. History as one text line per run, never as folders.

Never delete a report a `STATUS.md` field still points at. Repoint it first, and list what goes and
what stays before deleting anything.
