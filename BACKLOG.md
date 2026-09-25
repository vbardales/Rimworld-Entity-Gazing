# Backlog

Work not yet done, in the order the workflow asks for it. Defects that exist now are in
[BUGS.md](BUGS.md). What has been read, at which version, is in
[docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

## Before `done → tested`: two passes that have never run

The three checks TESTING.md's table owed are **written** as of 2026-09-25 — features 10, 11, 12 and
13, seven scenarios — and none of them has ever been played. A scenario written is not a scenario
passed, and these three in particular are the ones most likely to be wrong on their first run,
because each rests on something this mod has never exercised.

### The restart pair, 11 and 12

```
-Filter '11-restart-write' -Then '12-restart-read'
```

One lock, one staging, two launches. What could go wrong on the first run, in the order it would
show: the settings file's name is built from the mod's folder name and the **Mod** class's type
name, read from `Verse.Mod.GetSettings` rather than guessed, and a wrong guess reads as "no
settings file" whatever the mod wrote. The writer stands the teardown down through a static flag,
so if `InterfaceSteps.Restore` ever stops honouring it the writer's values are wiped before the
second launch. And the reader's guard fails loudly by design when the two features are played in
one process, which is what happens if someone drops the `-Then` and files two requests.

### The pass without Anomaly, 13

```
-DepMap wsl-deps.no-anomaly.map -Filter '13-without-anomaly'
```

`PickleTools/Headless/README.md` records that the `!<packageId>` line has only ever been exercised
in a sandbox with a fake game, and that "whether the game really leaves the DLC out of a loaded save
is what the first real pass has to show". **This pass proves the harness as much as the mod**, and a
red may belong to either — which is why the feature's background asserts the DLC is really gone,
through `ExpansionSteps`, before anything else is asked.

It also settles BUGS.md 2, and the two `MayRequire` translation-gating notices the shared
DefInjected checker raises.

### And the ordinary passes have to be replayed

Features 10 through 13 did not exist when `5eb3` and `1a55` ran. The two ordinary passes now carry
25 scenarios instead of 23, and their filter now has to exclude 11, 12 and 13 by name. Four passes
in total, and `Tests/Pickle/README.md` holds the four commands.

## Before `tested → prepublished`

- **`PUBLICATION.md` does not exist.** AUDIT.md requires it: the order of the Workshop captures with
  what each shows, the thank-you comments to post, the dependencies and DLC to declare, and the
  adult-content answers. The CI also reads its `### <version>` fenced block as the Steam change note.
- **The description correction has to be made by hand on Steam.** See BUGS.md 1. The file is ready;
  the page is not, and no commit can change that.
- **No `Mod/README.template.md` and no `.github/workflows`.** OPERATIONS.md is explicit that a mod
  without the template "must not be published with the generated workflow": semantic-release creates
  the tag and the GitHub release first, then the Steam step throws, leaving a release that never
  reached Steam.
- **The mutation campaign has not been rerun** since the settings and packaging work, and README.md
  says so. It is 35 mutations over three suites that now hold 78 checks.

## Not blocking anything, worth knowing

- What a particular button editor such as RIMMSQOL does with the `EG_Settings` shortcut. The suite
  proves the mechanism any such editor uses, not one version of one editor. `RimmsqolSteps` exists
  and would drive the real thing, in a pass that stages it.
- The Workshop item has never been subscribed to or opened, so the showcase has not been seen in
  place.
