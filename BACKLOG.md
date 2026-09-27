# Backlog

Work not yet done, in the order the workflow asks for it. Defects that exist now are in
[BUGS.md](BUGS.md). What has been read, at which version, is in
[docs/PROTOCOLS-READ.md](docs/PROTOCOLS-READ.md).

## `done → tested`, closed 2026-09-26

All seven scenarios across features 10–13 have run, and all four Pickle passes are green: ordinary
English and French (25/25 each), the restart pair (94b5 on d9ca1da, replayed as 63c8 on 9352e70,
the tree that ships), the pass without Anomaly (1d08, 5/5), and the place worker (e986). See
`STATUS.md` and `docs/runs/pickle.md` for the run IDs and revisions.

## Before `tested → prepublished`

- **`PUBLICATION.md` held the Steam change note and did not exist.** Written 2026-09-25. AUDIT.md requires it: the order of the Workshop captures with
  what each shows, the thank-you comments to post, the dependencies and DLC to declare, and the
  adult-content answers. The CI also reads its `### <version>` fenced block as the Steam change note.
- **The mod is bootstrapped onto the CI**, 2026-09-27 (`c8fbeb3`, another session). `.github/workflows/publish-tag.yml`
  and `script-tests.yml` exist, `About.xml`'s `<description>` is now generated from `PUBLICATION.md`'s
  Markdown block by `.github/scripts/about-description.mjs`, and form test 25 checks against that
  same converter instead of a hand-rolled copy of it. `Mod/README.template.md` and `.steamignore`
  turned out not to be needed by this standard - the Markdown source lives in `PUBLICATION.md`, not
  a template under `Mod/`.
- **The live Steam page still carries the old, hand-edited BBCode description.** `About.xml`'s new
  plain-text form has never been sent: `SetItemDescription` only fires when the item is created, and
  no dry-run or publish has run yet. The PickleTools line and the plain-text conversion both need the
  same hand edit of item 3806760893 to reach players, whenever that edit is next made.
- **No dry-run has been run for this mod yet.** `AGENTS.md` requires one, recorded with its run ID
  and SHA, before a `publish` can be dispatched - and only Virginie approves the `steam-production`
  environment after that.
- **`PUBLICATION.md`'s `### 1.0.0` change-note block** still needs its date filled in on the day of
  upload, and its screenshot order is still undecided - the gallery needs captures nothing has taken
  yet.
- ~~The mutation campaign has not been rerun.~~ Done 2026-09-25: all 35 woke their test. What it
  still does not cover is functional test 36, the teardown-hook guard, which has no mutation and
  needs none — it came up red on its first run, on a hook nobody had looked at.

## Not blocking anything, worth knowing

- What a particular button editor such as RIMMSQOL does with the `EG_Settings` shortcut. The suite
  proves the mechanism any such editor uses, not one version of one editor. `RimmsqolSteps` exists
  and would drive the real thing, in a pass that stages it.
- The Workshop item has never been subscribed to or opened, so the showcase has not been seen in
  place.
