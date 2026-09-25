# Entity Gazing — Pickle suite

In-game acceptance tests. Development only: the companion under `Mod/` is never published, and
nothing here is part of the Workshop payload.

Thirteen features, thirty-two scenarios, spread over four passes because two of them cannot share a
game with the rest. Writing them was the `preTest → done` criterion; running them all and reading
their captures is `done → tested`.

## What is in Gherkin, and what deliberately is not

Pickle costs a machine for tens of minutes a run. Everything provable without the game stays in
`_tools/`, where 78 checks already run in under a minute. What is left here needs a map, a spawned
building, a tethered pawn, a window, a reload, a second launch or a DLC switched off.

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
| 10 place worker | the watch area drawn on the ground under the build designator — an image, not an assertion |
| 11 / 12 restart | a value that has to outlive the process, which one process cannot show |
| 13 without Anomaly | what the game does with the patch, the window and the shortcut when the defs are gone |

**Dropped rather than converted.** The manual scenario that checked the patch had landed on the
right nodes is proved out of game, by running the game's own patch engine against the real Anomaly
defs and counting nodes. Repeating it here would confiscate the machine to learn nothing.

**Why the giver is asked rather than waited for.** A scenario that sets a need low and hopes the
colonist picks this activity within N ticks depends on the schedule, the pathing and every other
recreation source on the map. It fails for reasons that are not the mod's and passes without saying
much. Asking the giver on a real map with a real holder runs exactly the mod's one override and the
vanilla code beneath it, deterministically.

## The four passes

Twenty-five scenarios run in the two ordinary passes. The other seven cannot: the restart pair
needs two launches, and the DLC-off feature needs a game staged without Anomaly. Every scenario is
covered by exactly one pass, and the four together are what `tested` asks for.

| Pass | Features | Scenarios | Language | What it establishes |
|---|---|---|---|---|
| minimal English | 01–10 | 25 | English | the mod stands on its own; the captures are clean |
| minimal French | 01–10 | 25 | French | the same UI and job text in the other language |
| restart | 11, 12 | 2 | English | a global setting outliving the process |
| without Anomaly | 13 | 5 | English | the mod with the DLC switched off |

The restart pair and the DLC-off feature are **excluded from the ordinary passes by name**, and
that exclusion is not optional. `11-restart-write` leaves 9 to 12 on disk on purpose and stands the
teardown down; `12-restart-read` refuses to pass when the writer ran in the same process. Playing
either inside the plain run makes the run wrong rather than red.

## Running it

File a request; never call the launcher yourself and never arm a watcher. The dispatcher wakes the
owner at `START`, `END` and `RUN_DONE` — see `Rimworld-Ticket-Dispatcher/docs/WELCOME.md`, which is
the authority for all of this, and `docs/SUBMIT.md` for every option.

From the collection root, with the session id from `get_session` and the mod's SHA in the label.
`PLAIN` below is the filter the two ordinary passes share:

```
PLAIN = Entity Gazing - Pickle tests,!11-restart-write,!12-restart-read,!13-without-anomaly
```

```powershell
$S = 'Rimworld-Ticket-Dispatcher\scripts\Submit-PickleRun.ps1'
$Plain = 'Entity Gazing - Pickle tests,!11-restart-write,!12-restart-read,!13-without-anomaly'

powershell.exe -ExecutionPolicy Bypass -File $S -Mod EntityGazing -Owner local_ID -Label 'final English SHA' -Filter $Plain -EvidenceDir EntityGazing/Tests/Pickle/Evidence/en
powershell.exe -ExecutionPolicy Bypass -File $S -Mod EntityGazing -Owner local_ID -Label 'final French SHA' -Language French -Filter $Plain -EvidenceDir EntityGazing/Tests/Pickle/Evidence/fr
powershell.exe -ExecutionPolicy Bypass -File $S -Mod EntityGazing -Owner local_ID -Label 'restart SHA' -Filter '11-restart-write' -Then '12-restart-read' -EvidenceDir EntityGazing/Tests/Pickle/Evidence/restart
powershell.exe -ExecutionPolicy Bypass -File $S -Mod EntityGazing -Owner local_ID -Label 'without Anomaly SHA' -DepMap wsl-deps.no-anomaly.map -Filter '13-without-anomaly' -EvidenceDir EntityGazing/Tests/Pickle/Evidence/no-anomaly
```

The suite name comes first in every filter that carries an exclusion. A filter of exclusions alone
keeps every scenario of every suite the game discovered, not only this one.

One request per pass. A request carries no SHA: the mod is staged when its ticket is played, which
can be hours later, so the working tree stays on the revision under test until `RUN_DONE` arrives.

To see the machine without launching anything, which is read-only:

```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/Pickle-Status.ps1
```

Never launch the Windows game, never start a second one, never stage by hand, and never remove
another session's run or reservation.

## The restart pair, and why it is two features

A distance setting is global rather than per save, so it has to outlive the process — and no
scenario inside one process can show that. 09-reload covers a save written and read again, which is
not a restart.

`-Filter 11-restart-write -Then 12-restart-read` takes the machine lock once, stages once, and
launches the game twice. Two queue tickets would not do: any run that stages this mod in between
rewrites the settings file the first launch left for the second.

The reader's first step refuses to pass when the writer ran in this same process. That guard is the
test: without it a reader reads the values still sitting in the `EntityGazingSettings` instance and
reports a restart that never happened. The design is RimmsqolSteps'.

## The pass without Anomaly

`wsl-deps.no-anomaly.map` holds `!ludeon.rimworld.anomaly`, which takes the DLC out of
`ModsConfig.xml` for that pass only, and stages `PickleTools/ExpansionSteps` for the one assertion
the pass cannot do without: that the DLC really is inactive. Without it, a staging that quietly
failed to remove Anomaly would run the whole feature against a game that still has it, and every
"no def exists" would fail in a way that reads like a mod defect.

The feature carries **no `@requires:` tag**, deliberately. That tag means "this scenario needs that
mod active", and there is no tag for an absence; inventing one would skip the scenario in every
pass forever while the suite read as though it covered the case.

Worth knowing before reading its first report: `PickleTools/Headless/README.md` records that the
`!<packageId>` line has only ever been exercised in a sandbox with a fake game, and that "whether
the game really leaves the DLC out of a loaded save is what the first real pass has to show". A red
there may belong to the harness rather than to the mod.

The test companion declares Anomaly in `loadAfter` and **not** in `modDependencies`, so that this
pass can be staged at all. The distributed mod does declare it; that difference is intended, and
what a player without the DLC actually sees is one of the things this pass is there to show.

## Evidence

`Evidence/` is on disk and out of git. What is kept out of a run, what is deleted with it, and what
short summary is committed under `docs/runs/` instead: see the evidence section of the mod's
[TESTING.md](../../TESTING.md). The shared report folder holds every mod's screenshots — never copy
it whole, and delete the archive of your own run once you have taken what you need from it.

Read `exitReason` before any count, and compare scenarios played against features discovered. A run
killed in flight leaves something that looks exactly like a result.

## Building the steps

```powershell
dotnet build Tests/Pickle/Source/EntityGazing.PickleSteps.csproj -c Release
```

Pickle loads step assemblies when the game starts: a DLL changed during a run is not the code that
run is testing. Rebuild, then file the request.
