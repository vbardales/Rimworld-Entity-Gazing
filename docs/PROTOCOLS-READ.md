# Protocols read by this mod's session

What was read, at which version, and — as much use as the rest — which documents turned out not to
bear on this mod, so that a change to one of them is not a reason to read it again.

Recorded on 2026-09-25, mod at `9d8ccdd`, stage `done`.

## Where the versions come from, and why it is not what WELCOME.md says

WELCOME.md §5 asks for `git log -1 --format='%h %ad' -- <file>` in the monorepo. **That recipe now
returns the wrong answer for six of these files.** Monorepo commit `90d51374`, "the protocol
documents leave the monorepo; the protocols repository owns them", deleted AGENTS.md, AUDIT.md,
PUBLISHING.md, TRANSLATIONS.md, STYLE_RIMWORLD.md, MOD_SETTINGS.md, EXTERNAL_TOOLS.md and three
files under `scripts/`. The copies at the monorepo root are the work tree of another repository,
`vbardales/Rimworld-protocols`, whose git dir is `../rimworld-protocols.git`, and the monorepo
lists them in `.git/info/exclude`. So a monorepo `git log` on AUDIT.md names the commit that
*removed* it — a date and a hash that look perfectly plausible and mean the opposite of what the
reader wants.

The versions below therefore come from:

```
git --git-dir=../rimworld-protocols.git --work-tree=. log -1 --format='%h %ad' --date=short -- <file>
```

Its work tree was clean when this was written, so nothing here is `modified, not committed`.

**A second way the same command lies, on Windows.** The steps catalogue is tracked as
`PickleTools/docs/steps.md`, lowercase. This note first recorded it as untracked, because
`PickleTools/README.md` is linked one way and the folder opens the other: NTFS is case-insensitive,
so `Docs/steps.md` reads perfectly, while git's index knows only `docs/steps.md` and answers a
`git log` on the other spelling with silence. Silence reads exactly like "generated, not tracked".
Corrected after TicketDispatcher said so, and checked rather than taken on trust: the tracked blob
and the file read here have the same SHA-256.

So both halves of this exercise have now been wrong once, in the two ways a version command can
fail without erroring — naming a deletion, and naming nothing at all.

## Read, and load-bearing for this mod

| Document | Repository | Version | What it decided here |
|---|---|---|---|
| `AUDIT.md` | protocols | `49cd841` 2026-09-25 | The `done → tested` criteria, read again rather than recalled — which is what kept the stage at `done` with two green suites. |
| `AGENTS.md` | protocols | `3a1d2cb` 2026-09-24 | Evidence discipline: keep only what still proves something, one text line per run under `docs/runs/`, never copy the shared report folder whole. |
| `TRANSLATIONS.md` | protocols | `b83933b` 2026-09-23 | The three STATUS fields and what `complete` may claim. All three are `complete` here, and the in-game half is now proved by the two passes. |
| `Rimworld-Ticket-Dispatcher/docs/WELCOME.md` | dispatcher | `79668cc` 2026-09-25 | Small tickets, one request per pass, no watcher of my own. §5 is what this file answers. |
| `Rimworld-Ticket-Dispatcher/docs/SUBMIT.md` | dispatcher | `79668cc` 2026-09-25 | Every option of a request, and the launcher's exit codes — including that 0 is not a verdict. |
| `PickleTools/Headless/README.md` | PickleTools | `b2712fc` 2026-09-25 | The two mechanisms the three missing checks need: `!<packageId>` in a pass map for a DLC-off pass, and `-Then` for a restart under one lock. Also the trap list: a step that waits needs `TimeoutSeconds`, `I select` is an exact match on `LabelCap`. |
| `PickleTools/docs/steps.md` | PickleTools | `d6d8db1` 2026-09-25 | `ExpansionSteps` has exactly the assertion a DLC-off pass needs, and `ScreenshotMode` the one a build-menu capture needs. |
| `PickleTools/README.md` | PickleTools | `2b7b6d0` 2026-09-25 | How a tool is staged from a pass map, and that its `About.xml` packageId must match the map line. |
| `EntityGazing/TESTING.md` | this mod | `f063460` | The conversion table that owes the three checks with no scenario. |
| `EntityGazing/Tests/Pickle/README.md` | this mod | `f063460` | Stale in four places, listed in BUGS.md. |

## Read, and not useful for this mod — do not re-read on a change

| Document | Version | Why it does not bear here |
|---|---|---|
| `PUBLISHING.md` | `0743ff9` 2026-09-25 | Governs `tested → prepublished` and beyond. Two findings were worth keeping (the generic AI mention in the published description, and the description being write-once), and they are in BUGS.md; the rest waits until this mod is `tested`. |
| `STYLE_RIMWORLD.md` | `7311308` 2026-09-25 | Showcase guidance. `showcase: complete` here, icon and preview delivered and checked. Only "ModIcon: contrôle, pas génération" would matter again, and only if she replaces the icon. |
| `Rimworld-Release-Admin/docs/OPERATIONS.md` | `d403592` 2026-09-25 | The CI publication runbook. This mod has no `.github/workflows` at all, so none of it applies yet; two prerequisites it names are missing and are recorded in BUGS.md. |
| `scripts/SEARCHING.md` | `372c447` 2026-09-23 | Corpus search. Nothing here asks who else declares a defName or owns a texture path. Worth re-reading only for such a question. |

## Not read, because they do not exist

`PUBLICATION.md`, `BACKLOG.md`, `NOTES.md` and `BUGS.md` were asked for and were absent.
`BACKLOG.md` and `BUGS.md` are written with this note; `PUBLICATION.md` belongs to
`tested → prepublished` and is listed in BACKLOG.md rather than invented now.
