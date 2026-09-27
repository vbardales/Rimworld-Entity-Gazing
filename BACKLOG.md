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
- **The Workshop page's description is done**, by hand on 2026-09-25, and read back to confirm. Any
  later change to `About.xml`'s description needs the same hand edit: no update will carry it.
- ~~One line was owed to PickleTools.~~ Done 2026-09-27, once `tested` freed `About.xml`: all three
  test tools now linked in the description (Pickle, RimLogging, PickleTools), in `About.xml` and in
  `PUBLICATION.md`'s Markdown source alike. **Not yet hand-applied to the live Steam page** — the
  next hand edit of item 3806760893's description has this line to carry too.
- ~~Whether Anomaly should stay a hard dependency.~~ Decided 2026-09-27: it stays. See `BUGS.md` 1.
- **`Mod/README.template.md` and `Mod/.steamignore` do not exist**, and the day this mod is
  bootstrapped onto the CI the template becomes the source of the page — overwriting the hand edit
  at every publication. Both are under `Mod/`, so they wait for the queue too. See PUBLICATION.md.
- **`PUBLICATION.md` now exists**, with the `### 1.0.0` change-note block in the shape the release
  plugin enforces. Its date is filled in on the day of the upload, and its screenshot order is
  still undecided — the gallery needs captures nothing has taken yet.
- **No `.github/workflows`, and no `Mod/README.template.md` — which this mod now does not need.**
  The standard Virginie chose on 2026-09-25 puts the description in one Markdown block under
  `## Steam description` of `PUBLICATION.md`, and generates `About.xml`'s `<description>` from it.
  That block is written, so the source already carries the page's text, and
  `bootstrap-release.sh` picks the standard configuration on its own because the heading is there.
  Nothing is adopted: no workflow, no config, and `About.xml` keeps its hand-written BBCode link
  until the migration, as `OPERATIONS.md` requires of a mod that has not moved.
  Two copies of one text exist meanwhile, and form test 25 is what keeps them in step.
- ~~The mutation campaign has not been rerun.~~ Done 2026-09-25: all 35 woke their test. What it
  still does not cover is functional test 36, the teardown-hook guard, which has no mutation and
  needs none — it came up red on its first run, on a hook nobody had looked at.

## Not blocking anything, worth knowing

- What a particular button editor such as RIMMSQOL does with the `EG_Settings` shortcut. The suite
  proves the mechanism any such editor uses, not one version of one editor. `RimmsqolSteps` exists
  and would drive the real thing, in a pass that stages it.
- The Workshop item has never been subscribed to or opened, so the showcase has not been seen in
  place.
