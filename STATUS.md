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
  - "mouth flaw (open): MouthLipsSmirk pokes out of the east profile on the FA head; Virginie refused changing the mouth (2026-11-08). Scene 4 probes HeadPointy in 95f1; if the lip stays outside, NPT has the step `the Beauty2 mouth offset is {float}` (NSB Beauty2Mouth patch, D 0.03, NOT PLAYED): ask NPT if it plays under our DepMap. Images 1, 3, 4 in Art/Gallery carry the flaw until replayed (git rm with the replay). Journal of older entries: docs/runs/status-journal-2026-11-09.md."
  - "RESULT 2026-11-13 21:30: aa47 (gallery-42) GREEN 4 of 4, full-size PNG in Tests/Pickle/Inbox/gallery-42 (keep until built). Opened at 1920x1080: 1 candidate (about 4.0, camp east, west and south ground bare), 3 candidate (dog front, scarf, platform whole), 4 candidate (face rounded like 3, same as 1; torch, grass, camp in frame), 2 REDO again: steel stone gone but the west half is still bare because my props at z 205 and z 223 were skipped (the kept-free area (130,204)-(168,223) covers those rows). Asked NPT (local_5c111699) which west cells really hold logo flowers, since no flowers show in the capture; waiting for the cell list or a narrower guard. Fallback if the whole west is logo ground: reframe scene 2 (zoom). Then replay scene 2 only as a small ticket, build all four together. Older: waiting 2026-11-13 21:22: ticket aa47 (gallery-42, scenes 1 to 4 replay for full-size PNG, DepMap wsl-deps.sanctuary.map, tree c99069f frozen until RUN_DONE; scene 2 west half dressed on rows z 205 and 223 outside the logo guard, steel stock dropped). score-gallery 2026-11-13: 1 candidate, 2 REDO, 3 candidate, 4 candidate (face shape vs 1 and 3 unverified, jpg too small). At RUN_DONE: open all four at full size, compare the face of 4 with 1 and 3, score-gallery, build pal8 (settings crop, under 2 MB), git rm old Art/Gallery and Gallery-clean 1 to 4 in the same commit, subtitles, one review. Candidates 1, 3, 4 built 2026-11-13 from gallery-42 (commit 508cd36, old scene 2 images removed); gallery-40, 41, 42 evidence deleted after build. Waiting: ticket 7e5e (gallery-43, scene 2 only, west decor, narrow logo guard): then build 2 (pal8, subtitle) and send ONE review of 1 to 4."
  - "RESULT 2026-11-13: ticket 4304 (gallery-41) green 2 of 2, 95f1 (gallery-40) green 4 of 4. Both folders were minified to 1280x720 jpg and moved to Tests/Pickle/Evidence at 19:27 by a prune that was not mine (I ran Prune-Evidence dry run only): the full-size PNG captures needed for the pal8 build are gone. Scene 2 (4304): decor better but west half still bare; scene 4: torch, grass, camp in frame, face looked like the earlier scenes at jpg size. Next: refile a gallery replay (scenes 1 to 4, gallery-42) with the west half of scene 2 dressed, keep the Inbox until all four are built (no prune). Older entry follows. Was waiting 2026-11-10 11:48: ticket 20261110-114811-208-4304 (gallery-41, scenes 2 and 4 only, DepMap wsl-deps.sanctuary.map, tree 403912f frozen until RUN_DONE). Director verdict on gallery-40 (score-gallery, read on the pictures): 1 and 3 candidate (about 4.0), 2 REDO (decoration 3.5, west half bare), 4 REDO (decoration 3.0, torch and tall grass outside the tight frame, adequacy 3.0, and the HeadPointy probe changed her face shape: rounder than 1 and 3, Virginie saw it 2026-11-10). Scene 4 now drops the pin, frame 3.5, more camp; mouth lip sits on the profile edge in 1 and 3 (tiny at 1:1, kept). At RUN_DONE: open both captures, compare the face shape with 1 and 3, then build all four (pal8 from rgb24, under 2 MB), git rm old Art/Gallery and Gallery-clean 1 to 4 in the same commit, subtitles, one review. gallery-40 stays in Inbox until 1 and 3 are built. Was GREEN: ticket 20261109-235754-877-95f1 (gallery-40, scenes 1 to 4, DepMap wsl-deps.sanctuary.map) passed 4 of 4, 0 [decor-skipped] in the log, Player.log clean. Captures in Tests/Pickle/Inbox/gallery-40/screenshots (kept until rated). Opened at full frame: props off the logo, Nelim ponytail and profile as canon, no lip seen outside the east profile (not yet zoomed). Next: zoom the mouth on scene 4, rebuild Art/Gallery candidates 1 to 4 (pal8, settings crop, under 2 MB), score-gallery verdict, subtitles, Virginie accepts per image, then mountPreview. Was waiting 2026-11-09 23:57 (every prop moved to x above the PiT logo limit of its row). Before that: RED 2026-11-09 (resume): f9e9 (gallery-39) failed 0 of 1: 'no TorchLamp stands at (156, 217)', log '[decor-skipped] TorchLamp asked (156, 217): the cell is kept free of decor' (guard 243 cells): (156, 217) is on the logo, NPT's 'free east of x 153' was wrong there. Scene 1 lantern also at (156, 217). Asked NPT via TM for the exact free cells; then move torch, stool (156, 219 unchecked), lantern, replay 1, 3, 4. Inbox/gallery-39 deleted after study (red, no capture opened). protocols_read_sha now 239c9196."
  - "unverified: Run-Functional-Tests.ps1 check 36 (teardown hook guard) fails on this machine since 2026-10-11 with FileNotFoundException for RimWorks.Pickle 4.9.1.0 while reading Tests/Pickle/Mod/Pickle/Assemblies/EntityGazing.PickleSteps.dll (SAME as a fresh build). Environment, not the mod: the checker cannot resolve the installed Pickle. Other 35 functional, 25 form and 18 settings checks pass. Needs the checker pointed at Pickle 4.9.1.0 before it is trusted again."
  - "blocking prepublished: Workshop gallery not accepted yet. Candidates of gallery-5 withdrawn 2026-10-15 (Nelim drawn bare: the pass map lacked Sanctuary Backlot's body and trouser mods; my director verdict 'all accepted' was wrong). Feature 14 rewritten (shooting plan, lit dusk decor, dressed guests with hair, brows and mouths, zoom 4 to 7); the pass map now stages the whole Backlot block plus Stick Lantern. Waiting: ticket 20261015-181221-470-1f86 (gallery-8, pending in the queue, tree 1c102f6). Then: open every capture, check Nelim wears trousers and corset, centring, lanterns lit; rebuild candidates under Art/Gallery/ (pal8, settings crop 910:1080:505:0, under 2 MB each), director verdict, Virginie accepts or refuses per image, reindex, order table in PUBLICATION.md. Art/Gallery/ holds only 0-preview.png now. AUDIT.md 9.c needs the order accepted before mountPreview."
  - "blocking prepublished: the live Steam page still carries the 2026-09-25 hand-edited description, one generation behind About.xml (missing the PickleTools line, and in BBCode rather than the CI's plain text). The dry-run shows what update_description=true would send; nothing has been sent yet."
  - "unverified: what a particular button editor such as RIMMSQOL does with the EG_Settings shortcut. The suite proves the mechanism any such mod uses, not one editor version."
  - "unverified: the Workshop item exists but has never been subscribed to or opened, so the showcase has not been seen in place."
session:      local_d552515a-9ab6-4523-b8d5-7b638d027134
code_review_sha: 64ca3de280fc2c29018f50dd456653aa527f02d7
publication_changelog_review_sha: bbe5af21606d3db0b5ce075310b7a70898fcef82
echo_review_sha: c993b5086c85424c846e488bce7ace8f65c65d97
social_preview_sha256: bf815321504874e93aef419a64a1e79b0358bf52478de244b8f403c146a0e636
updated:      2026-11-09, shootGallery session (EnG)
protocols_read_sha: 80d05a395e1803f96a90bcf05cffca22c0210641
---
# Entity Gazing — status

## NSB (sync-nsb, 2026-11-07)

Redone after Audit found the 2026-11-06 sync wrong (it queried `-- Docs`, NSB tracks lowercase `docs/`; "unchanged" was false, about 40 commits since 2026-11-06, read with `-- ':(icase)docs'`). Changes that touch this mod: (1) `enclosure-south` was refused as bare on 2026-11-06 ("refusé, à embellir") and sits at n° 16 of the owner's third decor order (2026-11-07: troughs, bamboo bundles, pen markers, shade trees, "animals keep room"); once decorated the scenes 1 to 4 frame a different place and must be replayed (decor of the scenes is mine, NSB decor stays). (2) Shogun's whole wardrobe validated 2026-11-06, including the cold scarf `Apparel_SmallAnimalScarf` deep blue `#1F3A5F`, same neck slot as the collar (no collar with it): option for scene 3 if the brown collar stays unreadable. (3) Nelim 1.7 body hair validated 2026-11-07 (ticket 69b4), her profile outfits unchanged; no mouth or lid change. Owner rules 2026-11-05 applied: NSB places, colonists and animals free; outside NSB needs express validation; colonist properties change only with validation; every outfit free; every included animal shown (rule 5). Nothing in the scenarios changed by this sync. Not read this run: NSB-ROSTER.md in full, APPARENCES-CANON.md, CATALOGUE-ANIMAUX.md (no commit on them since 2026-11-06 except b4198c9/28c2e0d/c87f0aa wardrobe docs, only the Shogun diff read).

Rerun 2026-11-07 afternoon (TM `nsb-sync` warn): new NSB commits ac34b0a and c40e82f (Ottawa, Ursule, Wrille side and back views, Ursule power armor), nothing on Nelim or Shogun, no effect on the scenes. Read in full this run: SHOGUN-PROFIL.md (wardrobe table), CATALOGUE-ANIMAUX.md, APPARENCES-CANON.md (Nelim, Shogun lines), LOOKS-VALIDATION.md (Nelim rows). Nelim's NSB daily outfit is `LTS_Tunika` emerald (validated 2026-11-04); the gallery's wine shirt, charcoal trousers and ink corset are an outfit of the mod's story, outfits free, rule 4.

Sync 2026-11-08 (evening, diffs only): NSB owner validated `enclosure-south` on 2026-11-08 (NPT lot 5g, ticket 2901, fixture `Nelims-tribe-decor-mods-u`, "c'est validable"): the place now carries the Nelim logo in flowers (growing zones 3 to 15). **Owner rule 2026-11-07 (SANCTUAIRE-LIEUX.md): nothing on the logo flowers, no brazier, awning, trough or rock.** The scenes put brazier, campfire, torch, stool and lantern around (149, 214): replay must keep every prop off the logo cells (ask NPT/NSB for the logo cell list; NPT step "the cells of the growing zones in the area from (x, z) to (x, z) are kept free of decor" serves it). Colonists, Shogun, catalogue: no NSB doc change since 2026-11-07, rules unchanged. NPT new steps that serve the gallery: "the light of the map is dimmed to at most N" and "refreshed" (dusk capture of scene 4 at 19h, COMPILED NOT PLAYED, ask NPT before relying on it), "the building X at (x, z) is put out" (torches), "puts down what it carries". Not read in full: places other than `enclosure-south`. Nothing in the scenarios changed by this sync. Mouth diagnostic: none exists (NPT 2026-11-08: f885f9d is a PickleTools commit, made-of placement and logo guard, not a diagnostic; the nelim-mouth runs died, not refiled). Probe 8c4d (HeadPointy, scene 4) is the only mouth test.

Sync 2026-11-08 (night, diffs only, NSB 564f12b..23c4f55, NPT none since 2026-11-08): NSB owner validated `enclosure-south` (efc2141) and the `enclosure` overview (b5e64e8, tickets 5136/d534); logo rule unchanged (nothing on the flowers, SANCTUAIRE-LIEUX.md). Other commits touch workshops, right-bank, gravel-yard, left-bank telescope, batches 5k/5l: no effect on scenes 1 to 4. No colonist, animal or catalogue doc changed (Nelim, Shogun, rules 1 to 5 as above). Nothing in the scenarios changed by this sync.

Sync 2026-11-09 (night, diffs only, NSB since 2026-11-08 20:00, NPT same): NSB cc61d17 touches NSB-ROSTER only for Quill eyes (not Nelim, not Shogun); 1677380 copied the final decor save `Nelims-tribe-decor-mods-z3.rws` to Fixtures, `Nelims-tribe.rws` stays the old Sanctuary until NSB repoints the scenarios (DepMap wsl-deps.sanctuary.map unchanged here, replay on the old save as before; re-sync when NSB repoints). NPT: new step `the Beauty2 mouth offset is {float}` (D 0.03, NOT PLAYED, hosted in the NSB Beauty2Mouth patch, fails when not loaded: candidate for the mouth flaw, not used until NPT says it plays), `carries the item X made of Y`, screenshot-studio skip steps (none needed). Logo guard list from PiT 2026-11-09: rightmost guarded x per row z 206-222 is 148 to 157; every prop moved to x above the row limit (header and scenario agree, Check-ShotlistVsScenario OK). Rules 1 to 5 unchanged, no colonist or animal outside NSB, no property change.

Sync 2026-11-13 (diffs only, NSB since 2026-11-09 20:00, NPT since 2026-11-09): NSB `docs/` renamed `Docs/` (18abf53, 0 content change on NELIM-PROFIL, SHOGUN-PROFIL, SANCTUAIRE-LIEUX, APPARENCES-CANON, NSB-ROSTER, VALIDE, CATALOGUE-ANIMAUX); no colonist, animal, place or rule change. NSB added `sanctuary-beauty2-mouth.feature` and filed ticket b25c (Beauty2Mouth, East, West, South control): the mouth flaw probe of NSB, read its result before asking NPT again. NPT: `docs/steps.md` moved to `Docs/steps.md` (9e497b1); new steps that may serve the gallery: filth removed from the map or around a cell (8530c4a), ScreenshotStudio hides the tab bar, speed controls and mouse-over readout (65f21b3), decor burns (9adf950), pot with a grown plant (eba5c2e). None used yet, none played here. Rerun 2026-11-13 (later): NSB no commit today; NPT 4 commits today (assertion a colonist works at a building, blueprint with materials, garment dye reaches animals, render nodes logged and hidden by text, memory thoughts cleared, all DLLs rebuilt NOT PLAYED): none needed by scenes 1 to 4. Garment dye on animals is the one to keep in mind for the Shogun scarf (already coloured by apparel def, no step needed). Rules 1 to 5 unchanged, no colonist or animal outside NSB, no property change. Nothing in the scenarios changed by this sync.

Places read: 2026-11-08. Tribe read: 2026-11-13 (renames only, diff of the seven docs above). Steps read: 2026-11-13.

| Place | Shots | Changes for the gallery | Last read |
|---|---|---|---|
| enclosure-south (149, 214), 12 cells, listed free for a photo | 1 to 4 (platform or holding spot at (149, 214)) | decor added per shot (lanterns, torch, campfire, daylilies, tall grass, removed at the end); animals kept out in scene 4; scene 3 keeps all animals but Shogun out of (136,206)-(160,222); NSB decor pass pending (n° 16, owner 2026-11-07), replay after it | 2026-11-07 |

| Colonist | Shots | Outfit per shot | Last read of profile | Exceptions |
|---|---|---|---|---|
| Nelim | 1 to 4 | wine CollarShirt, charcoal Pants, ink Corset (all four); slate Jacket added in 4 (cold evening). Outfits free. | 2026-11-07 (diff only: 1.7 body hair validated) | none. Owner answered "non" on 2026-11-06 to hairstyle `Ponytails`, colour (90, 58, 32) and the expression change: scenes play canon `Roo_HD_Hair_Highpony`, hair rgb (56, 36, 18) (`#382412`, roster), mouth `MouthLipsSmirk`, no mouth or lid override (no `MouthSad` in 4). Replay needed. |

| Animal | Shots | Outfit | Last read of sheet | Exceptions |
|---|---|---|---|---|
| Shogun (Labrador, linked to Nelim) | 3 | canon `Apparel_leatherdogcollar` `#3B2F2F` worn by the save's own pawn (illegible in gallery-26 capture); option: validated cold scarf `Apparel_SmallAnimalScarf` `#1F3A5F` (replaces the collar, outfit free, to justify in the plan) | profile and catalogue 2026-11-07 | none; NSB's own pawn `LabradorRetriever59410` since 2026-11-06 (no spawn) |

| Included animal (rule 5) | Shot(s) | |
|---|---|---|
| none: the mod defines no PawnKindDef or race (Defs: EntityGazing.xml, SettingsButton.xml) | n/a | no gap |

## Workflow audit — 2026-10-02

**tested → showcase** (`workflow_stage: options`). Audited at `affc5e2`; working tree has only untracked
`Art/*.ico` and `desktop.ini` files plus `.github/` edits from another session, none touching `Mod/`. No game launched.
Supersedes stage in older sections; their results stay.

- **Defect (blocks `options → l10n`):** plural rule (TRANSLATIONS.md, 2026-09-25) postdates earlier `complete`.
  `EG_MinimumDistance` and `EG_MaximumDistance` print number through one key, no `.One`/`.Many`, in EN and FR. Not fixed: audit does not.
- **Checked, fine:** `.dds` rule in `.gitignore`; no `.dds` on disk or in git. `PublishedFileId.txt` present (3806760893), committed in `e6164c0`;
  CHANGELOG already has `[0.1.0]`. No `@wip`; `@requires` only on feature 14, ran under `wsl-deps.studio.map`.
  No manual test left (TESTING.md). `upstream_mod_remotes: N/A`, licence `original`: no upstream repo to base on or send PRs to.
- **Evidence trimmed 164 MB to 48 MB** (`Tests/Pickle/Evidence/`, gitignored, never in git): dropped superseded `studio` and `studio-1` (kept `studio-2`, 2026-09-30, 5/5)
  and every `report.html` / `messages.ndjson` (26 MB each). Kept per scenario: latest `summary.md`, `junit.xml`, `Player.log`, screenshots of current revision.
- **`Art/` reworked (`bdccf57`, 2026-10-02):** `Art/Preview.png`, `preview-overlay.html`, `render-preview.cjs`, `preview-268.png`, `preview-background.png`, `preview-qa.json`, `cutout-icon.cjs`, `ModIcon-cutout.png`, `ModIcon-badge.png` and `steam/00-preview.png` left tree. Older sections below citing them describe 2026-09 Preview pipeline; files stay in git history. Shipped images: `Mod/About/Preview.png` and `Mod/About/ModIcon.png`; sources `Art/Preview-source.png`, `Art/ModIcon-source.png`; palette `Art/preview-palette.json`.
- **Plural fix** (`85ec8b6`): `translation_fr: complete` after Virginie's review of that revision; `localization` and `translation_en` wait for EN and FR replays.
- **Unverified, unchanged:** Workshop gallery order; live description one generation behind `About.xml`.
- **Next:** add plural forms (EN + FR), rebuild, rerun `scripts/Run-Tests.ps1`, replay `08-language` in EN and FR, then new audit.

Older dated audits (2026-09) live in `docs/runs/status-archive-2026-09.md`.

## Ecosystem (PiI, 2026-11-13, source: 8 Steam searches by Chrome, corpus scan of 3 defNames and 1 label; full table `docs/inventory/ecosystem-steam/EntityGazing.md` in the protocols repo)

Verdict: no duplicate, fork or replacement of the idea; the mod goes on. No mod gives recreation from entities or holding platforms. Neighbours work on the same entities without recreation: Name Your Entities 3229905841, Abuse Held Entities 3281694053, Tameable Entities 3781878408 (nothing to merge). No mod links, patches, retextures or translates Entity Gazing by title. To check by Pickle later (holders our patch may not cover): Small Holding Platform 3528001923 (2x2 platform and spot) and HoldingPlatform Retexture 3553624791. Nothing subscribed by PiI.

## Repository and publication

- Git root and Git directory local to `C:\Users\nelim\Documents\rimworld\EntityGazing`.
  Standalone repository, not parent monorepo or submodule.
- GitHub visibility checked with `gh repo view` on 2026-09-12: **PUBLIC**.
  Describes repository; no Workshop publication recorded.
- Mod name: **Entity Gazing**. No suffix needed: original creation, not
  continuation or private extraction. Existing name test enforces convention.
- Both `url` field and description in `Mod/About/About.xml` link to
  https://github.com/vbardales/Rimworld-Entity-Gazing.
- Dependency: Anomaly, explicitly declared in `modDependencies`.

## Licence and provenance

Mod released under **MIT**, as stated in `LICENSE`, README and About description.
Provenance category **`original`**: local source implements own small subclass
of vanilla RimWorld logic; no source or assets from another mod identified in this audit.
Ludeon credited in README. Based on repository evidence, not exhaustive external
provenance investigation.

Classification distinguishes `original` (own creation), `open` (reuse from explicitly
licensed source), `silent` (reuse from source without explicit permission), and `forbidden`
(reuse explicitly refused). MIT is licence granted for this mod; `original` describes its
provenance. Neither `silent` nor `forbidden` applies to evidence here.

## Maintenance rules

Translation validation required before `preTest`, including for this historical `done`
stage. After changes to text, UI code, Defs, patches or language resources, reset affected
`localization`, `translation_en` and `translation_fr` fields to `unchecked` and repeat
inventory and resource checks below. `complete` means ready for `preTest`; in-game translation
validation stays separate requirement tracked in `remaining`.

After mod change, run both suites and update this card with results and remaining defects.
After actual colony testing, record version/date and scenario results in `TESTING.md`, fill
`tested_on` here, and only then advance to `tested` when appropriate. After Workshop publication,
record item ID and verification result. Never turn unexecuted check into pass.

`remaining` uses `feature` for missing functionality, `defect` for known issue, and `unverified`
for checks still awaiting evidence.

## Translation audit — 2026-09-30

TRANSLATIONS.md's French gender-agreement rule and systematic-review requirement (both
2026-09-30) applied at `51bdc9a`. 2026-09-13 audit above predates settings gate
(MOD_SETTINGS.md); this pass covers mod as it ships now.

French lives in five files: `Mod/Languages/French/Keyed/Settings.xml`,
`Mod/Languages/French/DefInjected/JoyKindDef/EntityGazing.xml`,
`Mod/Languages/French/DefInjected/JobDef/EntityGazing.xml`, and
`Mod/Languages/French/DefInjected/MainButtonDef/Settings.xml` — 9 rows total, all read by
hand, not by pattern search.

None of these texts agree with pawn's gender (settings help/labels address
player, job report string and joy label describe activity, not pawn), so no
`{PAWN_gender ? ... : ... : ...}` switch applies anywhere in mod. Nothing flagged.

`FRENCH_REVIEW.md` (mod root) generated by `scripts/Make-FrenchReview.ps1` (shared; local copy deleted 2026-10-11) from
shipped XML at this revision, for Virginie's own reading. `translation_fr` stays `partial`
until she reviews it; see `remaining`.
Shared DefInjected checker indexed 11,588 Defs and checked both keys with zero errors
and no unresolved targets. Also emitted two `MayRequire` notices: target Defs require
Anomaly while French files in common language folder. Conditional-load
verification item, not injection-path error; no-Anomaly load scenario must also check
French translation log for missing-target warnings.

No translation resource or gameplay change required. English and French display in running colony remains unverified; `TESTING.md` scenarios 3 and 4 now specify both languages,
both holders, opportunistic reports, raw keys, fallback, accents and clipping. Historical
`done` stage preserved and does not certify those runtime checks.

## Preview source migration — 2026-10-03

Copy, typography, layout and palette consolidated in `Art/Preview.config.json`. Canonical inputs: `Art/Preview-source.png`, `Art/echo.png` and `Art/ModIcon-source.png`; temporary renderer diagnostics belong under ignored `Art/.render/`. Existing Preview, gallery and ICO outputs preserved because present and coherent; no render run. Superseded JSON files and generated QA intermediates removed. Nothing published.

## Preview echo decision, 2026-10-12

Virginie validated Preview at commit named by `echo_review_sha`: `Art/echo-concept.png` (conceptual echo, no capture shows entity yet; replaced 2026-10-25 by `Art/echo-source.png`, echo-concept.png deleted, owner choice), `echo.panelWidth` 36 (height limited to panel), `iconBadge.translate` `-12.5%, 12.5%`. `Mod/About/Preview.png` and `Art/Gallery/0-preview.png` are byte copies. Re-ask when gallery captures accepted (STYLE_RIMWORLD.md, Echo).

## Shotlist, estimates (2026-11-07, Nelim alone, GALLERY.md a to k with the 2026-11-07 rules: decor not sparse, story readable in the image, redo under 4/5)

Story: Nelim alone with the creature she keeps chained in `enclosure-south`, one clear late afternoon (17h, 18h, 18h, 19h), her dog Shogun comes to look in scene 3; full plan in the header of `Tests/Pickle/Mod/Pickle/Features/14-publication-shots.feature`. No guest colonist (owner, 2026-10-25). Scene 5 (Mod options window) is an interface capture, set aside.

| # | a time | b decor | c living | d Nelim | e action and instant | f composition | g says (in the image) | j at 268 px | Plan | Capture verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 gaze | 17h Clear, 600 ticks | stool, lit brazier, lit campfire, stick lantern, daylilies, tall grass | daylilies, grass | wine CollarShirt, charcoal Pants, ink Corset, Highpony, canon smirk | watching, in profile beside the platform, fingerspike about to strain | medium, platform decentred | a camp set to watch the creature | platform + Nelim | 4.5 | redo in ticket 7940 (gallery-27: Nelim far south, back turned, 3.0 / 3.5) |
| 2 watch area | 18h Clear | lit lantern, lit brazier, stool, daylilies, tall grass, steel | grass, daylilies | same outfit | carries Steel, mid-haul into the cross | medium (zoom 5), ghost centre, Nelim in the east arm (153,214) | the game shows where people will stand | four outlined rects | 4.5 | REFUSED by Virginie 2026-11-07 (gallery-27: Nelim small at the edge, load read as a stone); redo in ticket 01f5 |
| 3 holding spot | 18h Clear, 600 ticks | stool, lit brazier, lit campfire, lantern, daylilies | Shogun front in a slate blue scarf `#1F3A5F` (Apparel_SmallAnimalScarf: cool evening, like her jacket; owner yes 2026-11-07), daylilies | same outfit | watching, Shogun beside her, she turns to him | close | even her dog comes to look | dog face + marker | 4.0 | redo in ticket 7940 (gallery-27: dog on the platform, collar unreadable, 4.0 / 3.0) |
| 4 pain field | 19h dusk, 1200 ticks | stool, lit campfire, lit brazier, torch, daylily, tall grass | grass, daylily | same + slate Jacket | PainField, gaze on the creature | tight face | the price, on her face | face + platform | 4.0 | ACCEPTED by Virginie 2026-11-07, candidate 4, image 4.0 / adequacy 4.0 (gallery-27) |

k (series): one story in the header, variety (medium, wide, close, tight), opening 1, closing 4, rhythm 17h to 19h: ok. Plan mean 4.25 (the two 4.0 are j and e risks on the thumbnail).

Opus director pass 2026-11-07. Kept for the next replay (after NSB decorates `enclosure-south`, n° 16): same stool, brazier and daylily bed at the same cells in every scene so the place reads as one; scene 2 steel stack on the ground, she is mid-walk; scene 3 Kibble pile near Shogun; scene 4 one dropped item near the stool. Rejected: selection brackets and an open tooltip (interface, hidden by presentation mode), Bioferrite, ElectricInhibitor and Beer (not the story, power or drug props), lighting by the nociosphere alone (not playable), zooming tighter on scene 1 (scene 2 needs the wide shot).
