# Backlog

Work not yet done, in order workflow asks. Defects existing now in
[BUGS.md](BUGS.md). What read, at which version, in
[docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

## `done → tested`, closed 2026-09-26

All seven scenarios across features 10–13 ran, all four Pickle passes green: ordinary
English and French (25/25 each), restart pair (94b5 on d9ca1da, replayed as 63c8 on 9352e70,
tree that ships), pass without Anomaly (1d08, 5/5), place worker (e986). See
`STATUS.md` and `docs/runs/pickle.md` for run IDs and revisions.

## Before `tested → prepublished`

- **`PUBLICATION.md` held Steam change note and did not exist.** Written 2026-09-25. AUDIT.md requires it: order of Workshop captures with
  what each shows, thank-you comments to post, dependencies and DLC to declare, adult-content answers. CI also reads its `### <version>` fenced block as Steam change note.
- **Mod bootstrapped onto CI**, 2026-09-27 (`c8fbeb3`, another session). `.github/workflows/publish-tag.yml`
  and `script-tests.yml` exist, `About.xml`'s `<description>` now generated from `PUBLICATION.md`'s
  Markdown block by `.github/scripts/about-description.mjs`, form test 25 checks against same
  converter, not hand-rolled copy. `Mod/README.template.md` and `.steamignore`
  not needed by this standard - Markdown source lives in `PUBLICATION.md`, not
  template under `Mod/`.
- **Live Steam page still carries old, hand-edited BBCode description.** `About.xml`'s new
  plain-text form never sent: `SetItemDescription` only fires when item created, and
  no dry-run or publish ran yet. PickleTools line and plain-text conversion both need same
  hand edit of item 3806760893 to reach players, whenever edit next made.
- **No dry-run run for this mod yet.** `AGENTS.md` requires one, recorded with run ID
  and SHA, before `publish` can be dispatched - and only Virginie approves `steam-production`
  environment after.
- **`PUBLICATION.md`'s `### 1.0.0` change-note block** still needs date filled in on day of
  upload, screenshot order still undecided - gallery needs captures nothing has taken
  yet.
- ~~The mutation campaign has not been rerun.~~ Done 2026-09-25: all 35 woke their test. Still
  not covered: functional test 36, teardown-hook guard, no mutation and
  needs none — came up red on first run, on hook nobody had looked at.

## Not blocking anything, worth knowing

- What particular button editor such as RIMMSQOL does with `EG_Settings` shortcut. Suite
  proves mechanism any such editor uses, not one version of one editor. `RimmsqolSteps` exists
  and would drive real thing, in pass that stages it.
- Workshop item never subscribed to or opened, so showcase not seen in
  place.