# Entity Gazing — Pickle suite

In-game acceptance tests. Development only: the companion under `Mod/` is never published, and
nothing here is part of the Workshop payload.

Nine features, written and **never run**. Writing them is the `preTest → done` criterion; running
them and reading their captures is `done → tested`.

## What is in Gherkin, and what deliberately is not

Pickle costs a machine for tens of minutes a run. Everything provable without the game stays in
`_tools/`, where 76 checks already run in under a minute. What is left here needs a map, a spawned
building, a tethered pawn, a window or a reload.

| Feature | Why only a running game can show it |
|---|---|
| 01 loading | that the loader admitted the defs beside Anomaly, and that the patch reached both holders |
| 02 the gaze | a map, a tethered entity and the job system; the vanilla utility computing watch cells |
| 03 nothing to watch | the mod's one override refusing an empty holder and a corpse |
| 04 holding spot | the inverted half of the patch, on the def that already had a building node |
| 05 pain field | a hediff actually arriving on a colonist who came to look, and not arriving for a fleshbeast |
| 06 settings | a window belonging to this mod, editing the instance the mod applies from |
| 07 shortcut | a worker drawing, enabling and opening |
| 08 language | captures a person reads, in the language the pass was started in |
| 09 reload | state surviving a save being written and read again |

**Dropped rather than converted.** The manual scenario that checked the patch had landed on the
right nodes is proved out of game, by running the game's own patch engine against the real Anomaly
defs and counting nodes. Repeating it here would confiscate the machine to learn nothing. Its one
visual half, that the place worker draws the watch area on the ground, is not yet covered: see the
gap below.

**Why the giver is asked rather than waited for.** A scenario that sets a need low and hopes the
colonist picks this activity within N ticks depends on the schedule, the pathing and every other
recreation source on the map. It fails for reasons that are not the mod's and passes without saying
much. Asking the giver on a real map with a real holder runs exactly the mod's one override and the
vanilla code beneath it, deterministically.

## The passes

| Pass | Map | Language | What it establishes |
|---|---|---|---|
| minimal English | none needed | English | the mod stands on its own; the only pass whose captures are clean |
| minimal French | none needed | French | the same UI and job text in the other language |

**No `wsl-deps` map.** The minimal set the staging script mounts is enough: Core, the DLC, Harmony,
RimLogging, Pickle, Anomaly and this mod. No scenario here uses a shared PickleTools step, and the
captures use Pickle's own screenshot step rather than ScreenshotMode.

**No "with the optional mods" pass is owed.** The mod declares no optional integration: its
`loadAfter` names only `Ludeon.RimWorld` and `Ludeon.RimWorld.Anomaly`, both vanilla. Inventing a
second run under a different name to fill the row would be a duplicate, not a pass.

**No incompatibility pass is owed.** Nothing is declared `incompatibleWith`, and no document claims
a conflict. If one is ever declared, it takes a pass of its own whose job is to go and look at
whether the claim is still true, asserting the documented symptom rather than expecting a red.

**No `@requires:` tag anywhere.** Nothing here needs an optional mod, a DLC beyond Anomaly, or a
companion tool, so no scenario can be skipped for want of a condition. That is worth stating: a
skipped scenario is not a passed one, and the cheapest way to avoid that trap is to owe nothing.

## Running it

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Pickle-Status.ps1
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod EntityGazing -Language English -EvidenceDir EntityGazing/Tests/Pickle/Evidence/en
powershell.exe -ExecutionPolicy Bypass -File scripts/Run-PickleWsl.ps1 -Mod EntityGazing -Language French  -EvidenceDir EntityGazing/Tests/Pickle/Evidence/fr
```

From the collection root. The status call is read-only. Never launch the Windows game, never start a
second one, never stage by hand, and never remove another session's run or reservation.

**One watcher for every ticket this session holds, not one per ticket.** Queue what is to be
queued, then arm a single `Monitor` over `Pickle-Status.ps1` and let it report on all of them. It is
read-only: it reports a start, an end, and a ticket that vanished without ever holding the lock. It
never launches, stops or reserves anything. It expires after about thirty minutes, so a long queue
means rearming it — still one watcher, rearmed, never one per run. No cron, no standalone task: the
watcher lives and dies with the session that queued the work.

## Evidence

`Evidence/` is on disk and out of git. What is kept out of a run, what is deleted with it, and what
short summary is committed under `docs/runs/` instead: see the evidence section of the mod's
[TESTING.md](../../TESTING.md).

Read `exitReason` before any count, and compare scenarios played against features discovered. A run
killed in flight leaves something that looks exactly like a result.

## Known gap in this suite

The place worker drawing the watch area on the ground has no scenario. The out-of-game suite proves
the type exists and that the patch adds the node; neither proves anything is drawn. Covering it
needs a capture of the build menu with the holder selected, which is a screenshot a person reads
rather than an assertion — so it is a `@review` scenario waiting to be written, not a defect.

## Building the steps

```powershell
dotnet build Tests/Pickle/Source/EntityGazing.PickleSteps.csproj -c Release
```

Pickle loads step assemblies when the game starts: a DLL changed during a run is not the code that
run is testing. Rebuild, then queue.
