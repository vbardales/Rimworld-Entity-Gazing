# Backlog

Work not yet done, in the order the workflow asks for it. Defects that exist now are in
[BUGS.md](BUGS.md). What has been read, at which version, is in
[docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

## Before `done → tested`: three checks with no scenario

TESTING.md's own conversion table owes these three, and a check with no scenario is not a check that
passed. Each is a scenario to write rather than a missing capability: the launcher already does what
all three need.

### 1. The mod loading without Anomaly

Scenario 1 of the table asks for **one pass per DLC state**, and only the DLC-on state has ever run.
The out-of-game suites prove the class lives in `Assembly-CSharp` and the defs carry `MayRequire`,
which is why the assembly loads at all; they cannot show what the game does with the DLC switched
off.

How: a `Tests/Pickle/wsl-deps.sans-anomaly.map` holding `!ludeon.rimworld.anomaly`, plus
`nelim.pickletools.expansions path:PickleTools/ExpansionSteps/Mod` for the assertion
`the expansion "Ludeon.RimWorld.Anomaly" is not active`. One request, `-DepMap`. Worth knowing
before spending it: Headless/README.md says the `!<packageId>` line was tested in a sandbox and
**never yet seen in a real run** — "whether the game really leaves the DLC out of a loaded save is
what the first real pass has to show". So this pass proves the harness as much as the mod, and a red
here may belong to either.

This also settles BUGS.md 3, and the two `MayRequire` translation-gating notices the shared
DefInjected checker raises.

### 2. The place worker drawing the watch area on the ground

The table kept this one deliberately when it dropped the rest of scenario 2, because it is the only
visual half: out of game we prove the type exists and the patch adds the node, never that anything
is drawn. It wants a `@review` capture of the build menu with a holder selected.

`ScreenshotMode` supplies what such a capture needs — `developer mode is turned off for the capture`
in particular, since the runner starts the game with it on and its toolbar would be in frame.

### 3. The distance settings surviving the game being closed and reopened

The reload feature covers a save written and read inside one process, which is not a restart.

How: two features, a writer and a reader, played as `-Filter write -Then read` — one request, one
lock, two launches, staged once. The design to copy is RimmsqolSteps': its reader **refuses to pass
when the writer ran in this process**, so a restart test that never restarted comes back red instead
of green.

## Before `tested → prepublished`

- **`PUBLICATION.md` does not exist.** AUDIT.md requires it: the order of the Workshop captures with
  what each shows, the thank-you comments to post, the dependencies and DLC to declare, and the
  adult-content answers. The CI also reads its `### <version>` fenced block as the Steam change note.
- **The description's missing sections**, in AUDIT.md's order after the body: `IF I GO QUIET` with
  the adoption clause word for word, `AI-GENERATED`, `THANKS` crediting Pickle and RimLogging as
  development-only tools, the ATTRIBUTION line, then the source link. Only the last is present. See
  BUGS.md 1 for why this is a hand edit on Steam and not a file change.
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
