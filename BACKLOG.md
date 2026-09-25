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

- **`PUBLICATION.md` held the Steam change note and did not exist.** Written 2026-09-25. AUDIT.md requires it: the order of the Workshop captures with
  what each shows, the thank-you comments to post, the dependencies and DLC to declare, and the
  adult-content answers. The CI also reads its `### <version>` fenced block as the Steam change note.
- **The Workshop page's description is done**, by hand on 2026-09-25, and read back to confirm. Any
  later change to `About.xml`'s description needs the same hand edit: no update will carry it.
- **One line is already owed to it: PickleTools.** PUBLISHING.md asks for the credit as soon as a
  pass stages a piece of it, and `wsl-deps.no-anomaly.map` now stages `ExpansionSteps`. It has a
  private Workshop page, `3806142401`, and the mention carries the link and the same "development
  only" wording as Pickle and RimLogging. Not done the same day because `About.xml` is under `Mod/`
  and three requests were already queued against that tree; it goes in after they report.
- **`Mod/README.template.md` and `Mod/.steamignore` do not exist**, and the day this mod is
  bootstrapped onto the CI the template becomes the source of the page — overwriting the hand edit
  at every publication. Both are under `Mod/`, so they wait for the queue too. See PUBLICATION.md.
- **`PUBLICATION.md` now exists**, with the `### 1.0.0` change-note block in the shape the release
  plugin enforces. Its date is filled in on the day of the upload, and its screenshot order is
  still undecided — the gallery needs captures nothing has taken yet.
- **No `Mod/README.template.md` and no `.github/workflows`.** The template is not a trap waiting to
  fire — the wrapper plugin checks the description sources in `verifyConditions`, before any tag or
  release is created, and `bootstrap-release.sh` skips a repository without one. What is real is
  that the day this mod is bootstrapped, the template becomes the source of the Workshop page and
  overwrites it at every publication, so it has to carry what the page says today before that day.
- ~~The mutation campaign has not been rerun.~~ Done 2026-09-25: all 35 woke their test. What it
  still does not cover is functional test 36, the teardown-hook guard, which has no mutation and
  needs none — it came up red on its first run, on a hook nobody had looked at.

## Not blocking anything, worth knowing

- What a particular button editor such as RIMMSQOL does with the `EG_Settings` shortcut. The suite
  proves the mechanism any such editor uses, not one version of one editor. `RimmsqolSteps` exists
  and would drive the real thing, in a pass that stages it.
- The Workshop item has never been subscribed to or opened, so the showcase has not been seen in
  place.
