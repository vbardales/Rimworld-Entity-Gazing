---
localization: complete
translation_en: complete
translation_fr: complete
mod:          Entity Gazing
packageId:    nelim.entitygazing
repo:         Rimworld-Entity-Gazing
remote:       https://github.com/vbardales/Rimworld-Entity-Gazing.git
local_path:   C:\Users\nelim\Documents\rimworld\EntityGazing
visibility:   public
detached:     yes
workflow_stage: shootGallery[1.0.0]
settings_audit: passed
licence:      original
licence_at:   MIT in root LICENSE; original mod, no third-party mod source or assets identified
upstream_mod_remotes: N/A
dependencies: declared
showcase:     complete
tested_on:    "85ec8b6 (Mod/ tree unchanged since; replays f107 EN and e3a7 FR green, 3 of 3 each; earlier green passes at 9352e70 and 574dce1 kept in docs/runs/pickle.md)"
workshop:     3806760893
dry_run:      "green: run 36332659615 of publish-tag.yml, SHA 66cc74acffd8f82b556cac2c784d27a1f76193a4, version 1.0.0, options preview+description+tags. Build reproduced Mod/ byte for byte, change note and description both read and matched the documents, DRY RUN: nothing was sent to Steam. Not yet followed by a publish - see remaining."
remaining:
  - "unverified: Run-Functional-Tests.ps1 check 36 (teardown hook guard) fails on this machine since 2026-10-11 with FileNotFoundException for RimWorks.Pickle 4.9.1.0 while reading Tests/Pickle/Mod/Pickle/Assemblies/EntityGazing.PickleSteps.dll (SAME as a fresh build). Environment, not the mod: the checker cannot resolve the installed Pickle. Other 35 functional, 25 form and 18 settings checks pass. Needs the checker pointed at Pickle 4.9.1.0 before it is trusted again."
  - "done 2026-10-12: plural replay green in EN (20261011-210631-678-f107) and FR (20261011-210632-668-e3a7), 08-language, tree 85ec8b6, exitReason passed, 3 of 3, both settings captures read (2 cells / 2 cases). Count 1 is covered by the keys-resolve scenario, not shown on screen."
  - "done (defect closed by the replays above), fixed in 85ec8b6 (EG_Cells.One/.Many, EN+FR). Was awaiting replay: tickets 20261002-201530-351-9376 (EN) and 20261002-201531-154-9a23 (FR) at 145b343. Was: plural keys missing (TRANSLATIONS.md, Counts and plurals, 2026-09-25). EG_MinimumDistance and EG_MaximumDistance display a count ({0}, 1 to 20) through a single key in Keyed/Settings.xml, EN and FR: 1 shows as '1 cells' / '1 cases'. Need .One/.Many forms in both languages and Translate calls choosing by count in Source/EntityGazingMod.cs:73,75. Audit 2026-10-02 did not fix it, by rule. Mod/ then changes, so the DLL, Pickle 08-language and the tested bar need a re-run."
  - "verified: every Pickle pass is green, and every @review capture was opened and read. The restart pair replayed as 63c8 against 9352e70, the tree that ships: exitReason passed both launches, 1 + 1 scenarios, two distinct Player.log files a minute apart, the reader guard passed. Ordinary English 6494 and French 168e against 574dce1: exitReason passed, ten features discovered, 25 of 25 scenarios run, none skipped, none @wip, none conditional. The restart pair 94b5 (two launches under one lock, two distinct Player.log files 94 s apart, the reader guard passed so the static was fresh) and the pass without Anomaly 1d08 (5 of 5, the first real use of a pass map ! line) against d9ca1da. The place worker e986 against 5bcee70, whose holding spot capture was then made legible by a wider clearing and read again in 6494 and 168e. Mod/ changed twice since `tested`: 4716bd3 (the PickleTools link) and the CI bootstrap (About.xml's description switched from hand-written BBCode to plain text generated from PUBLICATION.md). No Pickle scenario reads the description text, and `scripts/Run-Tests.ps1` stayed 25 of 25 through both, so the changes are not re-run rather than untested."
  - "decided 2026-09-27: About.xml keeps Anomaly as a hard modDependencies entry. Feature 13 supplied the evidence - loads quietly without the DLC, three gameplay defs gated away, settings clean, shortcut hidden - and Virginie confirmed keeping the hard declaration. See BUGS.md 1, closed."
  - "defect 2026-10-17: ticket 20261015-181221-470-1f86 (gallery-8, tree 1c102f6) FAILED 0 of 5, exitReason failed: every scenario stops at step \"the animals are removed from the sanctuary enclosure-south\" (Exception has been thrown by the target of an invocation). Shared Sanctuary step, to report to NPT with the evidence folder Tests/Pickle/Evidence/gallery-8; no ticket refiled before its answer."
  - "blocking prepublished: Workshop gallery not accepted yet. Candidates of gallery-5 withdrawn 2026-10-15 (Nelim drawn bare: the pass map lacked Sanctuary Backlot's body and trouser mods; my director verdict 'all accepted' was wrong). Feature 14 rewritten (shooting plan, lit dusk decor, dressed guests with hair, brows and mouths, zoom 4 to 7); the pass map now stages the whole Backlot block plus Stick Lantern. Waiting: ticket 20261015-181221-470-1f86 (gallery-8, pending in the queue, tree 1c102f6). Then: open every capture, check Nelim wears trousers and corset, centring, lanterns lit; rebuild candidates under Art/Gallery/ (pal8, settings crop 910:1080:505:0, under 2 MB each), director verdict, Virginie accepts or refuses per image, reindex, order table in PUBLICATION.md. Art/Gallery/ holds only 0-preview.png now. AUDIT.md 9.c needs the order accepted before mountPreview."
  - "blocking prepublished: the live Steam page still carries the 2026-09-25 hand-edited description, one generation behind About.xml (missing the PickleTools line, and in BBCode rather than the CI's plain text). The dry-run shows what update_description=true would send; nothing has been sent yet."
  - "unverified: what a particular button editor such as RIMMSQOL does with the EG_Settings shortcut. The suite proves the mechanism any such mod uses, not one editor version."
  - "unverified: the Workshop item exists but has never been subscribed to or opened, so the showcase has not been seen in place."
  - "done 2026-10-02: French review by Virginie, stated in chat at revision 85ec8b6 (the `Translation audit` review line is hers to write). Was: unverified: French review (TRANSLATIONS.md, 2026-09-30). FRENCH_REVIEW.md generated 2026-09-30 at 51bdc9a, 5 files / 9 rows: 1 Keyed, 3 DefInjected. No text agrees with a pawn's gender, so no {PAWN_gender} switch is expected anywhere in this mod - nothing flagged."
session:      local_d552515a-9ab6-4523-b8d5-7b638d027134
code_review_sha: 64ca3de280fc2c29018f50dd456653aa527f02d7
echo_review_sha: 99fb29405b55c583d44987fd7f9472869953635c
social_preview_sha256: bf815321504874e93aef419a64a1e79b0358bf52478de244b8f403c146a0e636
updated:      2026-10-15, shootGallery session
protocols_read_sha: c283fedfcc80166d175245f9553ab4095716c1fa
---

# Entity Gazing — status

## Workflow audit — 2026-10-02

**tested → showcase** (`workflow_stage: options`). Audited at `affc5e2`; the working tree has only untracked
`Art/*.ico` and `desktop.ini` files plus `.github/` edits from another session, none touching `Mod/`. No game launched.
This supersedes the stage in older sections; their results stay.

- **Defect (blocks `options → l10n`):** the plural rule (TRANSLATIONS.md, 2026-09-25) postdates the earlier `complete`.
  `EG_MinimumDistance` and `EG_MaximumDistance` print a number through one key with no `.One`/`.Many`, in EN and FR. Not fixed: an audit does not.
- **Checked, fine:** `.dds` rule in `.gitignore`; no `.dds` on disk or in git. `PublishedFileId.txt` present (3806760893), committed in `e6164c0`;
  CHANGELOG already has `[0.1.0]`. No `@wip`; `@requires` only on feature 14, which ran under `wsl-deps.studio.map`.
  No manual test left (TESTING.md). `upstream_mod_remotes: N/A`, licence `original`: no upstream repo to base on or send PRs to.
- **Evidence trimmed 164 MB to 48 MB** (`Tests/Pickle/Evidence/`, gitignored, never in git): dropped superseded `studio` and `studio-1` (kept `studio-2`, 2026-09-30, 5/5)
  and every `report.html` / `messages.ndjson` (26 MB each). Kept per scenario: latest `summary.md`, `junit.xml`, `Player.log`, screenshots of the current revision.
- **`Art/` reworked (`bdccf57`, 2026-10-02):** `Art/Preview.png`, `preview-overlay.html`, `render-preview.cjs`, `preview-268.png`, `preview-background.png`, `preview-qa.json`, `cutout-icon.cjs`, `ModIcon-cutout.png`, `ModIcon-badge.png` and `steam/00-preview.png` left the tree. Older sections below that cite them describe the 2026-09 Preview pipeline; the files stay in git history. The shipped images are `Mod/About/Preview.png` and `Mod/About/ModIcon.png`; sources `Art/Preview-source.png`, `Art/ModIcon-source.png`; palette `Art/preview-palette.json`.
- **Plural fix** (`85ec8b6`): `translation_fr: complete` after Virginie's review of that revision; `localization` and `translation_en` wait for the EN and FR replays.
- **Unverified, unchanged:** Workshop gallery order; live description one generation behind `About.xml`.
- **Next:** add plural forms (EN + FR), rebuild, rerun `scripts/Run-Tests.ps1`, replay `08-language` in EN and FR, then a new audit.

Older dated audits (2026-09) live in `docs/runs/status-archive-2026-09.md`.

## Repository and publication

- Git root and Git directory are local to `C:\Users\nelim\Documents\rimworld\EntityGazing`.
  This is a standalone repository, not the parent monorepo or a submodule.
- GitHub visibility was checked with `gh repo view` on 2026-09-12: **PUBLIC**.
  This describes the repository; no Workshop publication is recorded.
- Mod name: **Entity Gazing**. No suffix is needed: this is an original creation, not a
  continuation or private extraction. The existing name test enforces that convention.
- Both the `url` field and the description in `Mod/About/About.xml` link to
  https://github.com/vbardales/Rimworld-Entity-Gazing.
- Dependency: Anomaly, explicitly declared in `modDependencies`.

## Licence and provenance

The mod is released under **MIT**, as stated in `LICENSE`, README and About description.
The provenance category is **`original`**: the local source implements its own small subclass
of vanilla RimWorld logic; no source or assets from another mod were identified in this audit.
Ludeon is credited in README. This is based on repository evidence, not an exhaustive external
provenance investigation.

The classification distinguishes `original` (own creation), `open` (reuse from an explicitly
licensed source), `silent` (reuse from a source without explicit permission), and `forbidden`
(reuse explicitly refused). MIT is the licence granted for this mod; `original` describes its
provenance. Neither `silent` nor `forbidden` applies to the evidence here.

## Maintenance rules

Translation validation is required before `preTest`, including for this historical `done`
stage. After changes to text, UI code, Defs, patches or language resources, reset the affected
`localization`, `translation_en` and `translation_fr` fields to `unchecked` and repeat the
inventory and resource checks below. `complete` means ready for `preTest`; in-game translation
validation remains a separate requirement tracked in `remaining`.

After a mod change, run both suites and update this card with results and remaining defects.
After actual colony testing, record version/date and scenario results in `TESTING.md`, fill
`tested_on` here, and only then advance to `tested` when appropriate. After Workshop publication,
record the item ID and verification result. Never turn an unexecuted check into a pass.

`remaining` uses `feature` for missing functionality, `defect` for a known issue, and `unverified`
for checks still awaiting evidence.

## Translation audit — 2026-09-30

TRANSLATIONS.md's French gender-agreement rule and systematic-review requirement (both
2026-09-30) applied at `51bdc9a`. The 2026-09-13 audit above predates the settings gate
(MOD_SETTINGS.md); this pass covers the mod as it ships now.

French lives in five files: `Mod/Languages/French/Keyed/Settings.xml`,
`Mod/Languages/French/DefInjected/JoyKindDef/EntityGazing.xml`,
`Mod/Languages/French/DefInjected/JobDef/EntityGazing.xml`, and
`Mod/Languages/French/DefInjected/MainButtonDef/Settings.xml` — 9 rows total, all read by
hand, not by pattern search.

None of these texts agree with a pawn's gender (the settings help/labels address the
player, the job report string and joy label describe the activity, not a pawn), so no
`{PAWN_gender ? ... : ... : ...}` switch applies anywhere in this mod. Nothing flagged.

`FRENCH_REVIEW.md` (mod root) was generated by `scripts/Make-FrenchReview.ps1` (shared; the local copy was deleted 2026-10-11) from the
shipped XML at this revision, for Virginie's own reading. `translation_fr` stays `partial`
until she reviews it; see `remaining`.
The shared DefInjected checker indexed 11,588 Defs and checked both keys with zero errors
and no unresolved targets. It also emitted two `MayRequire` notices: the target Defs require
Anomaly while the French files are in the common language folder. This is a conditional-load
verification item, not an injection-path error; the no-Anomaly load scenario must also check
the French translation log for missing-target warnings.

No translation resource or gameplay change was required. English and French display in a
running colony remains unverified; `TESTING.md` scenarios 3 and 4 now specify both languages,
both holders, opportunistic reports, raw keys, fallback, accents and clipping. The historical
`done` stage is preserved and does not certify those runtime checks.

## Preview source migration — 2026-10-03

Copy, typography, layout and palette are consolidated in `Art/Preview.config.json`. Canonical inputs are `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; temporary renderer diagnostics belong under ignored `Art/.render/`. Existing Preview, gallery and ICO outputs were preserved because they were present and coherent; no render was run. Superseded JSON files and generated QA intermediates were removed. Nothing published.

## Preview echo decision, 2026-10-12

Virginie validated the Preview at the commit named by `echo_review_sha`: `Art/echo-concept.png` (conceptual echo, no capture shows the entity yet), `echo.panelWidth` 36 (height limited to the panel), `iconBadge.translate` `-12.5%, 12.5%`. `Mod/About/Preview.png` and `Art/Gallery/0-preview.png` are byte copies. Re-ask when the gallery captures are accepted (STYLE_RIMWORLD.md, Echo).
