---
mod:          Entity Gazing
packageId:    nelim.entitygazing
repo:         Rimworld-Entity-Gazing
remote:       https://github.com/vbardales/Rimworld-Entity-Gazing.git
local_path:   C:\Users\nelim\Documents\rimworld\EntityGazing
visibility:   public
detached:     yes
stage:        done
licence:      original
licence_at:   MIT in root LICENSE; original mod, no third-party mod source or assets identified
dependencies: declared
showcase:     complete
tested_on:
workshop:
remaining:
  - unverified: all fourteen manual scenarios in TESTING.md await execution in a running colony
  - unverified: Workshop upload and in-place showcase have not been verified
session:      Codex, maintainer of this standalone local repository
updated:      2026-09-13
---

# Entity Gazing — status

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

After a mod change, run both suites and update this card with results and remaining defects.
After actual colony testing, record version/date and scenario results in `TESTING.md`, fill
`tested_on` here, and only then advance to `tested` when appropriate. After Workshop publication,
record the item ID and verification result. Never turn an unexecuted check into a pass.

`remaining` uses `feature` for missing functionality, `defect` for a known issue, and `unverified`
for checks still awaiting evidence.

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
