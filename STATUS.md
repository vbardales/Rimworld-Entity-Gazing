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
stage:        done
settings_audit: complete
licence:      original
licence_at:   MIT in root LICENSE; original mod, no third-party mod source or assets identified
dependencies: declared
showcase:     complete
tested_on:
workshop:     3806760893
remaining:
  - "unverified: the nine Pickle features have run once, badly, and are queued again. The first English pass a0a5 played 23 of 23 with exitReason failed, 22 of them on three faults in the suite itself rather than in the mod: an invented PawnKindDef name, a teardown hook calling ctx.Get with nothing stored, and a container filled by transfer from a map. All three fixed at 6d297f6, with a new out-of-game test that checks every def name the features quote. The French pass 0e2e was already staged at 20:47:50, before the fixes reached disk at 20:50:31, so it replays the old code and its report teaches nothing. Both passes resubmitted against 6d297f6: English 20260924-205511-379-6612, French 20260924-205511-970-b230. The working tree must stay at 6d297f6 until those two report, since a request carries no SHA and staging copies whatever is on disk at launch."
  - "unverified: the place worker drawing the watch area on the ground has no scenario in the suite. The out-of-game tests prove the type exists and the patch adds the node, neither proves anything is drawn. It wants a @review capture of the build menu, so it is a scenario still to write rather than a defect."
  - "unverified: whether the distance settings survive the game being closed and reopened. The reload feature covers a save written and read inside one process, which is not a restart: that needs two launches chained under one lock."
  - "unverified: what a particular button editor such as RIMMSQOL does with the EG_Settings shortcut. The suite proves the mechanism any such mod uses, not one editor version."
  - "unverified: French load without Anomaly; the shared DefInjected checker raises two MayRequire translation-gating notices, a DLC-off runtime check rather than a demonstrated defect."
  - "unverified: the Workshop item exists but has never been subscribed to or opened, so the showcase has not been seen in place."
session:      local_2c8cbd89-28f1-4b1a-9830-51a1cae086d3
updated:      2026-09-24, mod session
---

# Entity Gazing — status

## Workflow audit — 2026-09-24

**done → preTest.** This section is the current record and supersedes the stage conclusions below;
their results are kept. Audited at `c6dc0a5` and re-verified at `3b85067`, with
`Mod/About/PublishedFileId.txt` untracked at the start and committed as part of this pass. No game was launched.

### Why the downgrade

One criterion of `preTest → done` is not met: **Pickle suites written, with their scope justified.**
This repository contains no `.feature` file, no Gherkin of any kind, and nothing anywhere that
argues they are not applicable. Silence is not a justification, and the protocol is explicit that
any non-applicability has to be written down.

The gap is real rather than formal. Sixteen manual scenarios exist precisely because they need a
running colony — the gaze itself, the pain field, a reload, a settings window, a shortcut revealed
by a third-party editor. That is the definition of what belongs in Gherkin. And under the current
bar for `tested`, **a manual test is no longer a thing that can be signed off**: what was left to
tick by hand is either automated and green, or listed as not applicable with its reason. So those
sixteen are not the last mile before `tested`; they are the specification of the suites that do not
exist. `TESTING.md` now carries that specification: what to write, what to drop because an
out-of-game test already proves it, and the three passes to run it in.

Nothing else regressed. Every criterion up to and including `l10n → preTest` was re-verified and
holds.

### What was verified, this pass

| Transition | Verdict |
|---|---|
| dansMonoRepo → horsMonoRepo | validated: standalone repository, GitHub remote, pushed, STATUS present, `original`/public consistent, naming consistent, documentation in English with distributed copies |
| → ModIcon générée | validated: 128×128, 21 KB, present in `Mod/About`; the build is current and the shipped assembly is not older than its sources |
| → Preview générée | validated: 896×504, 479 KB, inspected |
| → preOptions | validated: English description, accent colours distinct, no suffix on an original creation |
| preOptions → options | validated: settings reachable through Mod options, `EG_Settings` hidden by its own def and opening the same window, 18 settings checks green |
| options → l10n | validated: EN/FR complete, no hard-coded UI string, DefInjected paths and case correct |
| l10n → preTest | validated: Anomaly declared as the only dependency, `MayRequire` on all three gameplay defs, the patch conditional |
| preTest → done | **not met**: no Pickle suite, no justification |

Out-of-game suites re-run at `c6dc0a5`, not taken from the previous record:

```
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1             23 passed, 0 failed
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1  35 passed, 0 failed
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Settings-Tests.ps1    18 passed, 0 failed
```

Seventy-six checks, all green, against the build that is in the repository.

### Second pass, same day: the shared checkers, run rather than quoted

The first pass re-ran the mod's own suites but took the monorepo checkers and the two protocol
gates from the previous session's record. The protocol says to verify artefacts and real results
rather than a declared status, so they were run here, against `3b85067`.

| Check | Result |
|---|---|
| `scripts/Check-XmlFields.ps1` | 4 files, no unknown field: every element maps to a 1.6 field |
| `scripts/Check-DefRefs.ps1` | every reference points at the right def type, every `ParentName` resolves |
| `scripts/Check-TypeRefs.ps1` | 77 element names searched, no reference outside RimWorld and Unity |
| `scripts/Check-DefInjected.ps1` | 11589 defs indexed, 4 keys checked, **0 errors**, 2 `MayRequire` notices |
| `_tools/Run-Tests.ps1` | 23 passed, 0 failed |
| `_tools/Run-Functional-Tests.ps1` | 35 passed, 0 failed |
| `_tools/Run-Settings-Tests.ps1` | 18 passed, 0 failed |

`Check-XmlClasses.ps1` was not run: it requires a `-TypeLists` argument and no type list exists in
`scripts/`. Its ground is covered twice over here — `Check-TypeRefs` found no third-party type, and
the form suite resolves every `Class=` in the patch against the loaded assemblies — so this is a
tool that does not apply rather than a check skipped.

**The two `MayRequire` notices stay `unverified`, which is what TRANSLATIONS.md prescribes** for an
unresolved target: not a success. Both French DefInjected files carry keys for defs gated on
Anomaly while sitting in an ungated folder. With the DLC off and the game in French, the injection
has no def to land on. Whether that is silent or a logged warning is a runtime question, so it
belongs to `done → tested` and not to a stage gate. If it turns out to be noisy, the fix is a
`LoadFolders.xml` with an `IfModActive` branch — a file this mod does not have today.

**Translation gate, re-verified at the source rather than by its record.** Every player-facing
string in `Source/` goes through `.Translate()`: the settings title, the help line, both distance
labels and the reset button. The only bare literals are two Scribe keys and two defNames, which
TRANSLATIONS.md excludes by name. Nothing player-facing is hard-coded, so `localization`,
`translation_en` and `translation_fr` stay `complete`. The last commits to touch player-facing text
were the settings work; the two after it changed only the LICENSE files, so no field is reset to
`unchecked`.

**Settings gate.** MOD_SETTINGS.md is satisfied on the ground the protocol allows for this
transition — sources, defs and the applicable automated tests, with in-game verification belonging
to `tested`. Primary access is Mod options, the shortcut is hidden by its own def with no
per-frame visibility override, and both routes open the same instance. No customization mod is
required to reach the settings.

None of this moves the stage. The Pickle gap below is unchanged.

### The 0.1.0 pre-publication

The Workshop item exists: **3806760893**, created by a first upload whose only purpose was to bring
back a published file ID. `Mod/About/PublishedFileId.txt` is committed, which is the one step that
does not get a second chance — lost, the next upload creates a second item. `CHANGELOG.md` now opens
on `## [0.1.0]`, the creation of a published file ID, describing what the upload contained: `Mod/`
as it stood at `c6dc0a5`.

**This changes no stage.** A pre-publication is an act, not a state; the item is private, as Steam
creates every item, and nothing about it says the mod is tested or released. The version that
arrives with `published` is 1.0.0.

### `.dds` and evidence

Both rules are in `.gitignore`, and both are preventive: **this repository has neither today.** No
`.dds` exists on disk or in the history — the mod ships no texture of its own — and no Pickle run
has ever been made, so there is no evidence folder to clean out. Nothing was deleted, because there
was nothing to delete, and saying so is more useful than a tidy-up that did not happen.

What the rules buy is the next run. `Tests/Pickle/Evidence/`, `evidence/` and
`pickle-reports-archive/` stay out of git for the reason PickleTools measured at ten gigabytes in a
day. What gets committed instead is a short text summary per run under `docs/runs/`, cited from
here. `TESTING.md` says which files are worth keeping out of a run, which are deleted with it, and
that a report about a superseded build is the most expensive kind of file to keep, because it looks
like proof.

### To reach `done` again

Write the Pickle suites specified in `TESTING.md`, and justify in writing anything left out of
them. Their execution is **not** required for `done`; that belongs to `done → tested`.


## Audit fixes — 2026-09-13

This is the current record and supersedes the earlier audit findings below. Historical
results and the earlier downgrade are retained for traceability. Work is based on
`0a5123f49c308b08d9e7323a0b451bc7276994f5`, plus the previous uncommitted STATUS audit.
The fixes are local and uncommitted; no publication or push was performed.

- Added English ATTRIBUTION.md and matching distributed copy, plus Mod/LICENSE copied
  from the existing MIT notice. Preserved the original provenance category and named the
  game, build-only reference package, AI artwork and development assistance separately.
- Corrected the final About source link to the required Steam format and the stale
  four-types comment to five. Updated README, About and CHANGELOG for configurable distance.
- Added EntityGazingSettings and EntityGazingMod, with integer distance sliders from 1 to
  20 cells, minimum <= maximum, defaults 2/6 and a reset action. Normalization also handles
  out-of-range persisted values. Values apply globally to both holder Defs after loading
  and after edits. Native ModSettings/Scribe saves them on closing the settings dialog.
  Existing watchers may finish at their previous positions; subsequent position selection
  uses the changed range. Missing holder Defs are safe when Anomaly is disabled.
- Added EG_Settings MainButtonDef with native buttonVisible=false, no visibility override
  and no new dependency. Its worker opens RimWorld.Dialog_ModSettings with the same
  EntityGazingMod instance used by the ordinary Mod options route. Inspected the installed
  1.6.4871 rev590 implementations of MainButtonDef, MainButtonWorker, Mod and
  Dialog_ModSettings: visibility reads buttonVisible, and dialog close calls WriteSettings.
  No RIMMSQOL or other editor version has been interactively tested.
- Added five Keyed settings texts in English and French, with matching numeric placeholders
  on the two distance labels. The shortcut label and description use native English Def
  values and French DefInjected entries. The original two translated gameplay fields remain.
  Reviewed the full new source and all nine XML files: no additional owned UI text or
  dynamically constructed translation key exists. Names, serialization keys and Def IDs
  are not UI text. Input is slider-only; empty/nonnumeric typed input is not applicable.
- Added manual scenarios 15/16 for settings, actual colony effects, restart/global persistence,
  new/existing saves, DLC off, FR/EN layout and optional button editors. All sixteen scenarios
  remain unexecuted in game. Neither source inspection nor desktop tests certify that runtime.

Verification commands for this working tree:

```powershell
dotnet build Source/EntityGazing.csproj --no-restore -c Release
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Settings-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod ./Mod
```

Build succeeded with zero warnings/errors and updated the distributed DLL. Its SHA256 is
`28406083AFC7EC8FE0C90273357BF29E822FAF4F79023AF208E3207E06BF97FC`.
Settings checks execute normalization, reset and ApplyTo against actual game field types,
using holder fixtures without Unity-dependent constructors. They save and read primitive
values with native Scribe, including missing and out-of-range stored fields. Full Scribe
FinalizeLoading invokes Unity and cannot run in the desktop harness; the harness explicitly
ends LoadingVars with ForceStop instead. There are no cross references or post-load callbacks
in this settings class. Game restart/window lifecycle verification remains in scenario 15.

The general suite now includes the shortcut Def in field/translation checks and verifies
distributed licence/provenance copies and the exact source-link suffix. The real-assembly
compilation probe now checks the process exit code as well as compiler errors, so an SDK
failure cannot silently pass. Historical mutation results apply to their old test versions;
the mutation campaign has not been rerun or extended to certify these new checks.

Final result: **dansMonoRepo -> done**, with settings_audit and EN/FR localization complete.
All cumulative gates through done are now satisfied for this local distributed build;
`tested` remains unverified. Executed results: **23 form/XML + 35 technical functional +
18 settings checks = 76 passed, zero failed**. The shared DefInjected checker indexed
11589 Defs, checked four paths and reported zero errors, with the same two MayRequire
notices on the original gameplay translations. Those notices remain a DLC-off runtime
check, not a demonstrated defect. No new notice concerns the settings translations.
`git diff --check` also passed. The only next workflow transition is done -> tested:
execute and record the sixteen colony scenarios, including FR/EN, new/existing saves,
options, logs and the optional shortcut. Workshop publication is not required for it.
The options gate uses the user's explicit override: source and applicable automated checks
are sufficient here; interactive checks belong to tested. No new image or dependency is
needed. Earlier directly inspected image and GitHub validations remain independent and
unchanged. Remaining runtime checks are unverified, not known defects.

## Ordered workflow audit — 2026-09-13

This section supersedes historical stage conclusions below, without deleting their results.
**Previous stage: done. Retained stage: dansMonoRepo.** Stage values use the literal
names in the requested workflow, not letter codes. `dansMonoRepo` is the baseline before
the first fully satisfied gate; it does **not** mean the repository has physically returned
to a monorepo. `detached: yes` remains true. No relocation or monorepo remote is required.

Scope: standalone Git root `C:\Users\nelim\Documents\rimworld\EntityGazing`, distributed
folder `Mod/`. Read parent `AGENTS.md`, `PUBLISHING.md`, `STYLE_RIMWORLD.md`,
`MOD_SETTINGS.md` and `TRANSLATIONS.md`; the user's audit criteria take precedence,
including source/automated verification for options and game checks only for tested.

Started on `24e5b6896d3c7339d31bf3839088b590c0340716`, with existing local edits in
STATUS.md and TESTING.md. During the audit HEAD advanced externally to
`0a5123f49c308b08d9e7323a0b451bc7276994f5`; the intervening diff contains only those
two documentation files. Source, tests and distributed artifacts are unchanged, so their
checks remain applicable. This audit edits only STATUS.md and creates ignored build
verification output under `.build/audit/`. Existing scenarios and historical results are
preserved. No commit, push, publication, feature implementation or image generation performed.

| Transition | Direct result, independent of earlier blockers |
|---|---|
| dansMonoRepo -> horsMonoRepo | **Defect found.** Root ATTRIBUTION.md and distributed Mod/LICENSE are absent. Standalone Git, initialized STATUS/README/CHANGELOG/root MIT LICENSE, coherent naming, origin and public GitHub repository are verified. |
| horsMonoRepo -> ModIcon generated | Build and delivered DLL currency **validated**; PNG icon **validated**, 128 x 128, 21365 bytes. Existing gameplay implementation builds and passes its suites; later settings work is separately identified below. |
| ModIcon generated -> Preview generated | **Validated independently:** shipped PNG 896 x 504, 551129 bytes, below 1 MB; direct image inspection performed. |
| Preview generated -> preOptions | English description and unadorned original-public name **validated**; title has no affix or linking word to reduce. Warm secondary and cool cyan accent in the palette are distinct; secondary has no applicable text here. **Defect found** against PUBLISHING.md: raw Source URL instead of the final Steam-formatted source link. |
| preOptions -> options | **Defect found; settings_audit: partial.** See inventory below. No in-game test is demanded for this gate. |
| options -> l10n | Existing text inventory and EN/FR resources **validated independently**. Complete translation fields refer to the current two texts, not passage through the blocked settings gate or future settings text. |
| l10n -> preTest | Existing dependencies **validated independently**: Anomaly required, Core/Anomaly loadAfter, 1.6 declared, native game references used, guarded Defs and conditional holder patches coherent. No LoadFolders or optional third-party integration. Krafs.Rimworld.Ref is build-time only; Harmony is not used. |
| preTest -> done | Existing test/scenario criteria **validated independently**: 14 written manual scenarios and both automated suites executed successfully, including XML checks. Earlier cumulative blockers prevent done. |
| done -> tested | **Not verified.** No colony scenarios, game logs, FR/EN UI, new-game or existing-save validation executed in this audit. TESTING.md explicitly records the absence of in-game runs. |

GitHub read-only checks: `gh repo view vbardales/Rimworld-Entity-Gazing --json visibility,name,url`
returned PUBLIC and the expected repository; `git ls-remote origin HEAD` returned
`0a5123f49c308b08d9e7323a0b451bc7276994f5`. Initial sandbox access failed; both checks
succeeded on an approved retry. Visibility and at least one pushed commit are established.
The existing `original` classification is consistent with the inspected local subclass and
original-art records; no reused third-party mod implementation was found. This is a source
inventory, not a claim of exhaustive external provenance research. ATTRIBUTION.md must
record that provenance explicitly; do not invent a licence for RimWorld or third-party work.

### Executed checks and artifact evidence

- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1`:
  **23 passed, 0 failed**, including all five XML files, reflected fields, references,
  French paths/coverage and image dimensions. Its packaging checks do not check for the
  missing distributed licence or ATTRIBUTION: a green suite does not override those findings.
- `powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1`:
  **35 passed, 0 failed**, using installed RimWorld **1.6.4871 rev590**. Actual patch-engine
  application to both holders, reflection/IL readers and source compilation succeeded.
  These are technical integration tests outside a colony; no RIMMSQOL integration was tested.
- `powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod ./Mod`:
  **11588 Defs indexed, 2 keys checked, 0 errors**, plus two MayRequire notices. No unresolved
  path found. French loading without Anomaly remains a runtime verification, not a proven
  translation defect. English comes from the two native Def fields; French values are complete,
  meaningful and nonempty. Neither has parameters, tags or grammar tokens. The entire C#
  class adds no UI strings; patches add only values and references, not further owned text.
- `dotnet build Source/EntityGazing.csproj --no-restore -c Release -t:Rebuild
  -p:OutputPath=C:\Users\nelim\Documents\rimworld\EntityGazing\.build\audit\`:
  **succeeded, 0 warnings, 0 errors**, after approved retry for SDK-directory access.
  Rebuilt and shipped DLL SHA256 both equal
  `26E734F3CE8C293885B2026C363A89D4FF3E9F847A726CEDC4A09775A46540B1`.
  The distributed DLL was not overwritten. The initial environment access error is not a code defect.
- Directly viewed shipped Preview and ModIcon, plus `Art/preview-268.png`. Preview title,
  version and subject remain identifiable, with no clipping or overlap. No concrete camera
  concern found; no historical camera-comparison record is required. Read palette, HTML and
  existing QA JSON; historical contrast/font measurements below were not remeasured.
- Mutation campaign not rerun: historical results remain historical. No change to tested
  implementation requires a new mutation campaign for this audit.

### Settings audit

Inspected the full C# source, project, Defs, patches and distributed file inventory. There is
no Verse.Mod settings entry, ModSettings persistence, settings window, MainButtonDef or
MainTabWindow. Therefore neither a settings page nor a shortcut exists; no UI default,
input bound, apply-time, persistence or integration test can currently be executed.

Concrete useful option: the viewing distance, currently `2~6` on both holders. README and
About explicitly call it the real setting and explain editing the Def to change exposure
to the nociosphere's 5.9-cell pain field. TESTING.md scenario 7 also suggests changing XML
if the cost is too harsh. This is an identified player customization use, not merely an
arbitrary constant to expose. The current XML-only route fails the requested access contract.
The deliberate close-distance default should be preserved by any later settings work.

Other inspected constants (duration 4000, maximum participants 5, chance 2, stand width 5,
joy factors 1/0.8, sight and same-room constraints) implement the fixed recreation design.
No independent need to expose every one of these is established; no extra option is demanded.
The absence of a shortcut is correct only for a justified no-settings mod, which this documented
distance customization does not establish. `not_applicable` would therefore be unsupported.

Future passage of options requires the useful setting through Mod options, a hidden-by-default
optional MainButtons route to the same configuration, and applicable automated checks for
defaults, bounds, effects and persistence. Interactive FR/EN and customization-mod checks
belong to tested under the user's overriding rule; none is claimed here. Any newly added
UI text must invalidate and repeat the relevant translation checks.

### Next transition and nonblocking observations

Strictly to reach **horsMonoRepo**: initialize English ATTRIBUTION.md with actual provenance
and credits, and include the existing MIT notice as Mod/LICENSE; verify those files and any
applicable duplicate attribution copies. Repository creation, relocation, remote restoration,
new images, Workshop upload and in-game execution are not required for that transition.
The later settings and description defects remain separately tracked, not prerequisites
invented for the first gate.

Optional maintenance: the introductory comment in Mod/Defs/EntityGazing.xml still says four
building-based recreation types while the installed-game check finds five. It is an English
source comment, not player-facing translation text. No gameplay correction follows from it.
Workshop publication is outside this audit's stage chain and is not a blocker for tested.

Codex maintains this file for this mod and updates it after changes, checks and reported in-game
results. It stays at the repository root, outside the published `Mod/` directory.

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

## Verification on 2026-09-12

- `_tools/Run-Tests.ps1`: **23 passed, 0 failed**.
- `_tools/Run-Functional-Tests.ps1`: **35 passed, 0 failed**.
- Total: **58 automated checks passed**, against the installed RimWorld assemblies and data.
  These cover structure, compatibility and integration outside a running game; they do not
  simulate a colony or directly establish every gameplay outcome.
- XML: all five shipped files parse; def fields, references, patch classes, DLC guards and
  French translation keys are checked. The actual game patch engine applies the shipped patch
  to Anomaly defs; both holders retain their settings without duplicate structural nodes.
- C#: inheritance, override slot, method signature and compilation against the real game
  assembly are checked, together with the vanilla readers of the configured fields.
- `TESTING.md`: **14 manual functional scenarios**, with setup and pass criteria, covering DLC
  on/off, patch effects, recreation, empty/dead entities, pain, capacity, access, sight,
  opportunistic use, saves, both holders and same-room restrictions. **Not executed in game**.
- `_tools/Run-Mutations.ps1`: 34 mutation cases exist. The earlier documentation reports a
  successful campaign; it was not rerun in this audit. It does not prove all 58 checks have been
  observed failing; the suite footers explain the limits.
- Corrected About description from four to five building-based recreation types, matching
  the installed-game check. The metadata test now also checks the description's GitHub link.
- Preview and icon dimensions and size limits pass. Full-resolution sources are under `Art/`.
  The formerly referenced monorepo image prompt is not present in this repository.

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

## Translation audit — 2026-09-13

Applied the parent workspace's `PUBLISHING.md` translation gate and `TRANSLATIONS.md`
protocol to revision `24e5b6896d3c7339d31bf3839088b590c0340716`. Reviewed all shipped
Defs, both conditional holder patches, both French resources and the entire
`Source/JoyGiver_WatchEntity.cs`. There are no LoadFolders, version-specific content,
custom settings, generated language resources or optional third-party integrations.

| Def type and path | English source | French DefInjected value |
|---|---|---|
| JoyKindDef: `EG_EntityGazing.label` | entity gazing | contemplation d'entité |
| JobDef: `EG_WatchEntity.reportString` | watching the contained entity. | observe l'entité captive. |

English is supplied by `Mod/Defs/EntityGazing.xml`; an English DefInjected copy is
unnecessary. French resources are `Mod/Languages/French/DefInjected/` followed by
`JoyKindDef/EntityGazing.xml` and `JobDef/EntityGazing.xml`. Both entries are nonempty,
unique within their Def type and match the source meaning. Accents and punctuation are
preserved. Neither text contains parameters, grammar tokens, rich-text tags or line breaks.
No missing translation or placeholder was found.

The C# override only checks holder occupancy and delegates to vanilla; it emits no UI text
and constructs no translation keys. The patches add numeric settings, flags, class and Def
references, including the inventoried joy kind, without introducing further text. Vanilla
renders the recreation UI and optional opportunistic report prefix; the mod explicitly
reuses no dependency Keyed keys. Their runtime composition is included in the pending
language checks. IDs, class names, XML comments, About metadata and repository documentation
are outside the in-game text inventory, as prescribed by the protocol.

Validation commands run from this repository:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File _tools/Run-Functional-Tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File ../scripts/Check-DefInjected.ps1 -TransMod ./Mod
```

The form suite passed 23/23 checks, including XML validity, French target fields and
coverage of the Defs' translatable fields reflected from the installed game. The functional
suite passed 35/35 checks. Manual source/resource review above supplements these suites
with text inventory, duplicate/nonempty checks and meaning review.
The shared DefInjected checker indexed 11,588 Defs and checked both keys with zero errors
and no unresolved targets. It also emitted two `MayRequire` notices: the target Defs require
Anomaly while the French files are in the common language folder. This is a conditional-load
verification item, not an injection-path error; the no-Anomaly load scenario must also check
the French translation log for missing-target warnings.

No translation resource or gameplay change was required. English and French display in a
running colony remains unverified; `TESTING.md` scenarios 3 and 4 now specify both languages,
both holders, opportunistic reports, raw keys, fallback, accents and clipping. The historical
`done` stage is preserved and does not certify those runtime checks.

## Preview overlay — 2026-09-13

- Final shipped image: `Mod/About/Preview.png`, 896 x 504, 551129 bytes (538.2 KiB).
- Illustration retained unchanged: `Art/Preview-source.png`, copied byte-for-byte to
  `Art/Preview.png` as the canonical text-free source. No replacement or regeneration.
- Composition: `Art/preview-overlay.html`; reproducible renderer: `Art/render-preview.cjs`
  (Node with playwright and sharp, installed Chrome). Layout parameters remain in the CSS.
- Single palette source: `Art/preview-palette.json`, loaded by the HTML.
  The veil follows the dark stone floor's warm brown-olive material. The secondary ink extends
  the dominant ochre family of the floor and lamp pool, lightened for the dark background.
  The accent comes from the entity's turquoise glow, strengthened in saturation and lightness;
  its cool cyan-green hue contrasts with the dominant warm ochre rather than repeating it.
- Exact existing title and summary retained. No status tag or reduced title words apply to
  this original public mod. The badge reads the highest stable supported version from the
  shipped About.xml: 1.6. Triangle and rotated digits use the guide's coordinates.
- Actual browser fonts verified through Chrome platform-font inspection: Segoe UI Semibold
  for the title, Segoe UI Regular for the summary, Segoe UI Bold for the badge; no fallback.
  Capture waits for `document.fonts.ready` and the source image to decode.
- QA evidence: `Art/preview-qa.json`, `Art/preview-background.png` (text hidden), and
  `Art/preview-268.png`. Contrast was checked against every background pixel in the title
  and summary rectangles, a stricter area than the glyphs or four corners alone.
  Minimum ratios: title 11.18:1, summary 5.27:1, badge 10.61:1. Tag not applicable.
- Visually reviewed at 896 x 504 and 268 px wide: no clipping or overlap; title and version
  identifiable; rule visible; warm secondary and cool accent distinct in the saved palette.
  The secondary is intentionally unused in this title, since it has no affix or status tag.
- Both mod test suites rerun: 23 form and 35 functional checks pass. No publication performed.
