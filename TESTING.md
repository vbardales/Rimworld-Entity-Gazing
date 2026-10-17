# Entity Gazing — in-game test scenarios

Mod never watched in real colony. This file = list of what must be seen, and what counts as pass.

Two test suites run beside it, in `scripts/`. Neither starts game. They check defs well formed, game still has every named field and class, the one override still takes its slot, patch lands where aimed. None is a single tick of play. That is what this file is for.

Not shipped: lives beside `Mod/`, never inside, so Steam never receives it.

## Before starting

- RimWorld 1.6 with **Anomaly** DLC. Dev mode on, so silent failures become red text.
- Log to read afterwards, attach to any report:
  `C:\Users\nelim\AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios\Player.log`
- Materials and subjects: **holding platform** costs steel, needs research in normal game. Debug actions → Spawn thing → `HoldingPlatform` and `HoldingSpot`, and Debug actions → Spawn pawn → entity such as `Nociosphere`, `Fleshbeast` or `Shambler`. Entity must be **downed** before tethered. Mod covers both holders; scenario 13 compares them.
- Colonists with recreation already low, schedule block set to Recreation. Debug actions → Needs → set recreation to zero faster than waiting.

Useful conversions: 60 ticks = one second at normal speed, 2500 ticks = one in-game hour. Full gaze = **4000 ticks**, about hour and half game time.

Numbers this file leans on, all read from defs: watch distance **2 to 6** cells in rect **5** wide, **5** participants max, `JoyGainFactor` **1**, base chance **2**, sight required, no chair wanted.

---

## 1. It loads, with and without the DLC

Everything else depends on this. All three gameplay defs carry `MayRequire="Ludeon.RimWorld.Anomaly"` and patch wrapped in `PatchOperationConditional`, so mod supposed to be inert, not broken, when DLC off.

1. Start game with mod active and **Anomaly disabled**.
2. Read log.

**Pass:** no red line, no `Could not resolve cross-reference`, no failed patch. Assembly still loads — always does, by design — but nothing of mod appears in game.
**Fail:** any error naming `EG_`, `HoldingPlatform`, or `EntityGazing.JoyGiver_WatchEntity`.

3. Enable Anomaly, restart, read log again.

**Pass:** still clean, three defs exist. Check with Debug actions → **Def lookup**, or debug inspector: `EG_EntityGazing`, `EG_WatchEntity` (the job) and `EG_WatchEntity` (the giver).

Failed `PatchOperationAdd` is likely fault here and **loud** — game names file and xpath. Silently wrong one is next test.

## 2. The patch landed where it was aimed

Scenario for the one real subtlety in XML. `HoldingPlatform` already has `<statBases>`, so patch adds *inside* it; `<building>` does not exist on def, so patch creates it at root and relies on inheritance merging it with parent's.

1. Build or spawn holding platform.
2. Debug inspector on it, or Debug actions → Def lookup → `HoldingPlatform`.

**Pass, check all four:**

- `JoyGainFactor` is **1**, platform's other stats **still there**. If patch had created second `<statBases>` sibling, game reads only one and platform loses original stats — failure this test exists for.
- `building.joyKind` is `EG_EntityGazing`.
- `building.watchBuildingStandDistanceRange` is `2~6`.
- **Rest of `<building>` block survived.** Holding platform inherits building settings from `HoldingPlatformBase`; if new node replaced rather than merged, they gone. Other half of same risk, easy to miss, because platform with broken `<building>` block still looks normal until you try to tether something.

3. Select platform in build menu, before placing.

**Pass:** watch area drawn on ground — that is `PlaceWorker_WatchArea`, added by same patch. No area drawn = place worker did not land.

## 3. An occupied platform becomes a recreation source

1. Spawn entity, down it, tether to platform.
2. Select platform.

**Pass:** inspect pane names it as recreation source, recreation type reads **entity gazing**. French: `contemplation d'entité`.

3. Open colonist's Needs tab, Recreation, hover list of types.

**Pass:** entity gazing among types colony can offer. Whole point of mod, so if absent, stop and read log.

## 4. A colonist goes and watches, on their own

Translation validation: repeat scenarios 3 and 4 in English and French, Anomaly enabled, for both holding platform and holding spot. Check recreation source, Needs tooltip, active job report against text inventory in STATUS.md. Also observe opportunistically started job, since its report allows vanilla opportunistic prefix. Fail on raw keys, English fallback in French, broken accents, malformed prefixes or clipping. Record game version, date, language, holder, results. Language checks not yet executed in running colony.

The one behaviour everything else supports.

1. Colonist with recreation low, schedule block on Recreation, occupied platform in reach.
2. Let it run. Do not force job.

**Pass:** colonist walks to platform, stops **two to six cells away**, faces it, job description reads *watching the contained entity* (French: *observe l'entité captive*). Recreation rises. Bar tooltip credits **entity gazing**.
**Fail, each means something different:**

- Never goes → giver not picked. Check `baseChance`, schedule, whether platform reachable and in socially proper room (see scenario 9).
- Goes and stands on platform's own cell, or ten cells away → distance range did not land; go back to scenario 2.
- Goes and job ends instantly → `JobDriver_WatchBuilding` failing own checks. Log usually says why.

3. Let job run to end, do not interrupt.

**Pass:** lasts about 4000 ticks, hour and half game time, unless something interrupts.

## 5. An empty platform is never watched

**This is gameplay giver's occupancy condition.** `JoyGiver_WatchEntity` exists for this single condition only; if test fails, assembly not used at all.

1. Leave holding platform built and **empty**.
2. Colonists with recreation zero, Recreation scheduled, nothing else on offer.
3. Run full day.

**Pass:** nobody ever walks over to stare at empty steel frame. Platform does not appear as available recreation source while empty.
**Fail:** colonist gazes at nothing. Means vanilla `JoyGiver_WatchBuilding` running instead of mod's subclass — check `giverClass` reads `EntityGazing.JoyGiver_WatchEntity` and assembly loaded.

## 6. A dead entity is not a show

Same condition, second half: `held != null && !held.Dead`.

1. Occupied platform, colonist mid-gaze.
2. Kill entity while still tethered. Debug actions → Kill, or damage it.

**Pass:** corpse on platform stops being recreation source. No new colonist starts gaze. One already watching may finish job — check runs when job chosen, not every tick — but nobody starts new one.

## 7. The pain field is the price of the show

Design claim of whole mod, meant to come from vanilla, not this mod's code.

1. Tether **nociosphere** specifically. Carries `CompProperties_CauseHediff_AoE` applying `PainField` out to **5.9** cells.
2. Let several colonists gaze, standing at various distances.

**Pass:** watchers inside 5.9 cells pick up `PainField` hediff and hurt; ones at far end of range may not. Recreation still rises — pain is cost, not veto.

3. Repeat with **fleshbeast**, which has no such comp.

**Pass:** nobody hurts. Price varies by entity, on its own, no code of ours. Point: vanilla mechanic used, not simulated.

If cost too harsh, use Mod options -> Entity Gazing to set minimum distance above 5.9 cells.

## 8. Several watchers, and no chairs

1. Five or more colonists free at once, one occupied platform, recreation low all round.

**Pass:** up to **five** watch at once (`joyMaxParticipants`), spread across watch area, all facing platform. Sixth does something else.

**Pass, check explicitly:** nobody drags chair over. `desireSit` false, deliberately — you do not pull up seat in front of cage of horrors. Colonist sitting down here = giver used is not the one this mod declares.

## 9. The room has to be proper

Patch sets `socialPropernessMatters`, same flag vanilla televisions carry.

1. Put holding platform inside **prison** room, entity on it.
2. Free colonist with recreation low, nothing else on offer.

**Pass:** free colonist does not go. Prisoners in that room might.

Worth watching, not assuming: containment rooms and prison rooms easy to confuse in real base, and platform in wrong sort of room just produces recreation source nobody uses — no error anywhere.

## 10. Sight is required

1. Colonist blinded, or both eyes destroyed. Debug actions → damage, or spawn one.
2. Recreation low, occupied platform available, nothing else on offer.

**Pass:** never go. `requiredCapacities` is `Sight` alone, activity is nothing but looking.

**Pass, second half:** colonist with **no hands** goes anyway. Hands not required and must not be — you very much do not touch.

## 11. On the way past

`allowOpportunisticPrefix` true, so job may be taken as detour, not decision.

1. Colonist with long walk passing near occupied platform, recreation somewhat low but not desperate.

**Pass:** sometimes stop and watch on way, then carry on. *Sometimes*, not *always*; not fail unless never happens across long session.

## 12. Save, quit, reload

Mod adds no colony save data. Global viewing-distance settings stored separately.

1. Mid-gaze, save. Quit to menu. Reload.

**Pass:** colony loads with no error naming `EG_` or `EntityGazing`, colonist either resumes or picks new job. Nothing in log about missing class or unresolved reference.

2. Same save, **disable mod**, load again.

**Pass:** save opens. Recreation type disappears from colony, expected and harmless; no orphaned component to complain.

## 13. The holding spot works too, and is a poorer show

`HoldingSpot`, floor marker used before you can build platform, carries same `CompProperties_EntityHolderPlatform` and same `Building_HoldingPlatform` class. Mod covers both.

1. Build holding spot, no platform anywhere, tether entity to it.
2. Colonists with recreation low.

**Pass:** go and watch it, exactly like platform. Watch area drawn when spot selected in build menu.

3. Compare recreation gained here with same gaze at platform.

**Pass:** spot gives noticeably less. Its `JoyGainFactor` **0.8** vs platform's **1**, following game's own description — *not as good as a steel holding platform, but a lot better than nothing*. Entity roped to floor = poorer show than one clamped to frame.

**This scenario also guards patch's one real trap,** inverted between two defs. Spot already has `<building>` node where platform has none, so its settings added *inside* it while platform's created at root. Get backwards and spot ends with two `<building>` nodes, game reads one, spot keeps original settings and silently gains none of new. Worth look in Debug → Def lookup: spot's `building` block must still carry `sowTag` and `artificialForMeditationPurposes` **alongside** new `joyKind`.

## 14. Watchers stay in the room

`watchBuildingInSameRoom` set on both holders, as all five vanilla watch buildings set it. Not cosmetic: keeps audience inside pain field.

1. Put holder in sealed containment room with entity on it.
2. Colonists outside, adjacent room, within six cells through wall.

**Pass:** nobody watches from out there. Watching happens inside room or not at all.
**Fail:** colonist stands far side of wall and gazes. Watching through solid stone, and — worse for design — standing clear of pain field that is whole price of show.

## 15. Settings, bounds, defaults and persistence

Preconditions: RimWorld 1.6 with Anomaly and Entity Gazing; no customization mod. Start with fresh mod configuration, then repeat with existing colony save. Reset to default settings before running earlier gameplay scenarios. Repeat in EN and FR.

1. Open Mod options -> Entity Gazing. Expect minimum 2 and maximum 6, readable labels/help, correct accents, no raw keys, fallback, clipping or errors in Player.log.
2. Move each slider to both ends. Expect integer values 1 to 20, always min <= max. No text entry, so empty or nonnumeric input not applicable.
3. Set 8 to 12, close dialog, start new watching jobs at both holder types in sufficiently large room. Expect new viewing positions within 8 to 12 cells. Current jobs may finish at old positions. Nociosphere's 5.9-cell field should not reach them.
4. Reopen settings, restart game, reload save. Expect 8 to 12 retained. Start new colony, expect same global values. Observe new jobs, check logs again.
5. Restore defaults. Expect both controls and both holder ranges return to 2 to 6.
6. Disable Anomaly and restart. Open and save settings without exceptions; no activity exists.

Record game version, language, new/existing save, observed ranges, log path, outcome.
Not executed in game yet.

## 16. Optional MainButtons shortcut

Preconditions: default configuration, then RIMMSQOL or other compatible button editor. Record exact editor version; repeat checks in EN and FR.

1. Without editor, expect no visible or greyed-out Entity Gazing main button. Ordinary Mod options entry must still work.
2. With editor, find EG_Settings and reveal it. Click: expect same native settings window and values as Mod options. Change to 7 to 10 and close; reopen through Mod options, expect 7 to 10. Reverse route, verify shared values and persistence after restart.
3. Hide shortcut through editor, restart, expect stays hidden. Remove editor, verify Mod options still works. Restore 2 to 6 before gameplay regressions.
4. Check labels, help, accents, clipping, Player.log throughout. Expect no errors.

Not executed in game; no third-party integration version certified yet.
---

# What is still missing, and what it takes to close it

Everything above written as **manual** scenario, none ever played as one. Under current bar for `tested`, manual scenario cannot be signed off: what was left to tick by hand is either automated and green, or listed not applicable with reason. So sixteen above never last mile — they were specification for Pickle suites, now all converted or deliberately dropped.

**Conversion complete as of 2026-09-25.** Thirteen features, thirty-two scenarios, four passes. Table below = what was decided, kept as record of why each line went where it went; `Tests/Pickle/README.md` = live description of suite and four commands that run it. Three lines that took longest to close also named there: DLC-off pass, place worker's drawing, restart, each needing something ordinary pass cannot do.

## The Pickle suites this mod needs, and the passes to run them in

Section = specification suite was written from. Kept because it records reasoning, not because anything still outstanding.

Only what running game can show belongs in Gherkin. Anything out-of-game suite already proves must stay out: scenario repeating `scripts/` confiscates machine for tens of minutes every run and adds nothing.

| Scenario above | Where it belongs | Where it went |
|---|---|---|
| 1 loads with and without the DLC | Gherkin, one pass per DLC state | 01 for DLC on, **13 for DLC off**, own pass |
| 2 the patch landed where it aimed | **split.** Steps 1 and 2, def shape, proved out of game by running game's own patch engine — drop. Step 3 stays: that place worker actually *draws* watch area on ground is visual, out-of-game suites only prove type exists and node landed | steps 1–2 dropped; **step 3 is 10**, `@review` capture under build designator |
| 3, 4, 5, 6 the gaze itself | Gherkin, heart of it | 02 |
| 7 the pain field | Gherkin | 05 |
| 8, 10, 11 participants, sight, opportunistic | Gherkin | 02, 03 |
| 9 socially proper room | Gherkin | 02 |
| 12 save, quit, reload | Gherkin, nothing else survives reload | 09 |
| 13 the holding spot | Gherkin | 04 |
| 14 watchers stay in the room | Gherkin | 02 |
| 15 settings bounds and persistence | partly proved out of game; only window lifecycle and restart are Gherkin | 06 for window, **11 and 12 for restart**, as `-Then` pair |
| 16 the MainButtons shortcut | Gherkin, with `@requires` on button editor | 07, and **no `@requires`** — see below |

**Four passes, file must say so or mod merely tried.** Two ordinary ones on minimal set staging script mounts — Core, DLC, Harmony, RimLogging, Pickle, Anomaly, this mod — one English, one French; then restart pair, and pass without Anomaly. Language fixed at staging, never switched during run: switching reloads every def under runner, step waits for language that never arrives.

Last two exist because ordinary pass cannot hold them. Restart = two processes, so `-Filter 11-restart-write -Then 12-restart-read`: one lock, one staging, two launches. DLC switched off at staging, so DLC-off feature needs own map file, `wsl-deps.no-anomaly.map`, carrying `!ludeon.rimworld.anomaly`. Both excluded by name from ordinary passes, exclusion not cosmetic: restart pair's writer leaves values on disk on purpose, playing it inside plain run makes that run wrong rather than red. `Tests/Pickle/README.md` holds four commands.

**No "with the optional mods" pass owed**, a finding not omission: mod declares no optional integration at all. Its `loadAfter` names only `Ludeon.RimWorld` and `Ludeon.RimWorld.Anomaly`, both vanilla. Inventing second run under different name to fill row = duplicate, not pass.

**No incompatibility pass owed** either: nothing declared `incompatibleWith`. If ever declared, takes own pass whose job is check whether claim still true.

**No `@requires:` tag owed anywhere, and DLC-off feature is case proving rule, not breaking it.** Scenario 16 looked like it needed one, since button editor reveals shortcut — but editor sets same field suite sets, so mechanism testable without it. What *particular* editor version does with this button = separate claim, stays `unverified` rather than dressed up as skipped scenario.

Feature 13 tempts tag hardest and must not have one. `@requires:` means "this scenario needs that mod **active**"; 13 needs opposite, Pickle has no tag for absence. `@requires:ludeon.rimworld.anomaly` would skip it in very pass written for it, and packageId invented to mean "absent" would skip it in every pass forever — scenario that never runs, inside suite that reads as covering case. So 13 selected by filter, excluded from others by name, nothing skipped anywhere.

Scenario skipped for want of condition is not scenario passed, cheapest way to avoid trap is owe nothing.

Suite, scope, commands live in [Tests/Pickle/README.md](Tests/Pickle/README.md).

## The bar for `tested`

Four conditions, first three recent:

- **No scenario left in `@wip`.** One set aside either repaired and replayed, or deleted with reason. Remaining `@wip` not pass, postponement.
- **Every conditional scenario has run.** Each `@requires:` had own pass, on map mounting what it requires, report read — `setName` and suite and scenario names checked before citing, because report folder shared by whole machine.
- **No manual test left to sign off.** Automated and green, or listed not applicable with reason.
- **`@review` screenshots actually opened and looked at.** Not another manual test: reading image scenario already proved in right state. Green `@review` says journey happened, never that picture shows anything.

Read `exitReason` before any number in report, check scenarios played against features discovered. Run killed in flight leaves something looking exactly like result.

## Evidence: what is kept, and what goes

Reports **kept on disk, never in git**. Screenshots and `Player.log` grow without bound, `.gitignore` here excludes `Tests/Pickle/Evidence/`, `evidence/` and `pickle-reports-archive/`.

Ask launcher to keep run with `-EvidenceDir Tests/Pickle/Evidence/<run>`: copies report into mod **before lock released**, which shared rolling archive does not survive.

**Keep, out of a run:**

- `summary.md`, `summary.json`, `junit.xml` — small, carry `exitReason`.
- `@review` screenshots of pass **without optional mods**, only clean ones, and only those scenario actually points at.
- `Player.log` **only** when run failed or something must be explained. Green run's log proves nothing summary does not.

**Delete:**

- every screenshot of passes with optional mods, unless sole proof of something.
- every report about superseded build. Report on older DLL says nothing about current one, most expensive kind of file to keep: looks like proof.
- everything newer report replaces, as soon as it replaces it. Never left to next run.

**Commit instead:** one short text summary per run under `docs/runs/`, named for date and commit it ran against, cited by `STATUS.md`. History as one text line per run, never folders.

Never delete report a `STATUS.md` field still points at. Repoint first, list what goes and what stays before deleting anything.