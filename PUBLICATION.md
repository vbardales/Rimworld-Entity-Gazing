# Publication

What the Steam Workshop page asks for and the repository holds nowhere else. It serves twice: for
an upload, and for whoever takes the mod over. Workshop item **3806760893**.
`Mod/About/PublishedFileId.txt` holds the id and must never be lost: without it the next upload
creates a second item.

The mod is at `done`. Nothing here is due until `tested`, and this file exists early because the
release plugin refuses a publication without it and because the change note has a shape that is
easy to get wrong.

## The description, and the trap waiting in it

**Today the page is hand-edited, and that is the only way.** `About.xml`'s description was sent
once, by the in-game upload that created the item: RimWorld calls `SetItemDescription` only when
`creating` is true. The page was corrected by hand on 2026-09-25 to name the AI tools and to carry
`IF I GO QUIET`, `AI-GENERATED` and `THANKS`. `Mod/About/About.xml` holds the same text, so the two
agree, and any further change means the same hand edit.

**The day this mod is bootstrapped onto the CI, that reverses.** `semantic-release-steam` compiles
the description from `Mod/README.template.md` and **overwrites the page at every publication**. So
before the first CI release:

- `Mod/README.template.md` has to exist, in Markdown, carrying what the page now says. Its absence
  is caught early rather than late: the wrapper plugin's `verifyConditions` calls `checkMod` for
  every mod before semantic-release creates anything, so the run stops with no tag and no GitHub
  release. That is what the wrapper is for, and `bootstrap-release.sh` also skips a repository that
  has no template. The error message still describes the failure it prevents.
- `Mod/.steamignore` has to list `/README.template.md` and `/README.md`, or both ship to players.
- Once both exist, the template is the source and the Steam page is no longer edited by hand.

Neither file is written yet, deliberately: they live under `Mod/`, which is the staged payload, and
three Pickle requests are queued against the current tree.

## Steam description

The single Markdown source, under the standard Virginie chose on 2026-09-25. **Nothing reads it
yet.** This mod is not on the CI, so the live page and `Mod/About/About.xml` are still what count
today, and the block below exists because `OPERATIONS.md` requires the source to carry the text of
the page *before* the first publish that would send it — and because `bootstrap-release.sh` picks
the standard configuration on its own when `PUBLICATION.md` carries a `## Steam description` line.

Two things will change on the day it is adopted, and neither is an accident:

- **The five section labels become real headings.** They are plain uppercase lines on the page
  today; `##` converts to `[h2]`. That is the intended change, and the dry-run diff is where it is
  read before anything is sent.
- **The link line changes shape.** `[Source code on GitHub](url)` converts to the BBCode link the
  page already shows, and generates `Source code on GitHub (url)` in `About.xml` — which today
  carries the BBCode form by hand. `OPERATIONS.md` says a mod that has not migrated keeps its
  hand-written link, so `About.xml` is left alone until then. The first `--sync-about --write` is
  the migration: read the diff.

Until that day this block and `About.xml` are two copies of one text, which is exactly how prose
drifts. Form test 25 compares them and goes red if they part company.

```markdown
Colonists can go and look at the horrors you keep chained up, as recreation.

The Anomaly DLC contains no recreation content at all - not one recreation type, not one giver, nothing. You capture entities, bolt them to a holding platform in the middle of your base, study them for knowledge, and then nobody ever looks at them again. This adds the obvious missing thing: watching them, the way a colonist watches a television.

## WHY IT IS WORTH A MOD

The base game has ten recreation types and only five of them come from a building. Expectations ask for up to six different types, and tolerance is counted per type, not per building - a colonist who has played chess all week is just as tired of poker. An eleventh type is therefore worth far more than a tenth building of a type you already had. This one costs nothing extra: the platform was already built for study.

## THE VIEWING DISTANCE IS THE REAL SETTING

Watchers stand two to six cells away, which is deliberately close. A nociosphere projects a pain field out to 5.9 cells, so a good share of the audience will be standing inside it. That is the price of the show, and it comes out of an existing vanilla mechanic rather than a line of code - it varies by entity, and a fleshbeast hurts nobody. Change the viewing distance in Mod options → Entity Gazing. The default is 2 to 6 cells; allowed distances are 1 to 20 cells. Settings are global and saved when the window closes. Changes affect new viewing positions on both holders; current watchers may finish where they are.

An empty platform is never watched. The gameplay giver adds that occupancy check; the viewing distance is configurable. Movement - walking there, facing it, accumulating recreation - is the base game's own television logic.

Needs Anomaly. Without it the mod loads but adds no recreation activity.

No colony save data of its own; viewing-distance settings are stored globally.

## IF I GO QUIET

If I do not answer within a reasonable time after being contacted, anyone may freely update this or any other of my mods, including publishing a continuation of it. All credit must be preserved.

## AI-GENERATED

The code, the documentation and the tests were written with Claude Code (Anthropic) and Codex (OpenAI), under human direction and review. The icon and the preview image were generated with DALL-E (OpenAI).

## THANKS

Ludeon Studios, whose television logic supplies the watching activity: this mod adds a condition to it and changes nothing else.

Pickle and RimLogging, which run this mod's in-game acceptance tests. Both are development tools only; neither is a dependency of what you are downloading.

This mod is MIT licensed. Provenance and artwork credits are in ATTRIBUTION.md in the repository. RimWorld and Anomaly by Ludeon Studios.

[Source code on GitHub](https://github.com/vbardales/Rimworld-Entity-Gazing)
```

## The change note: the CI checks this shape, it does not write it

`release-steam-plugin.mjs` runs in **documented mode** — `bootstrap-release.sh` writes
`documented: true` for every mod it bootstraps — and in that mode the Steam change note is the
fenced block under `### <version>` of this file, **sent as written**. The plugin reads it, refuses a
block over the Steam byte limit, and refuses one whose first line does not carry the version:

```
^\[(b|h[1-3])\].*<version>.*\[/(b|h[1-3])\]$
```

Any of `[b]`, `[h1]`, `[h2]` or `[h3]` satisfies it, which is what PUBLISHING.md's `[b]1.3.0[/b]`
needs. It was `[h2]` only until `a2abeda` in `Rimworld-Release-Admin`, relaxed the same day.

The comment beside that check says where it comes from: semantic-release used to generate the
version heading, a block sent as written has only the heading it carries, and Steam shows an entry
with no version at all when it has none — Architect Studio 1.0.5. A published note can only be
fixed by hand, so the check runs in `verifyConditions`, before any tag exists.

So the first line is written here, not generated. The usual form is a link to the comparison
between the two tags:

`[h2][url=https://github.com/<owner>/<repo>/compare/v<previous>...v<version>]<version>[/url] (<date>)[/h2]`

**1.0.0 is the exception, and this mod is at that exception.** There is no tag in this repository
yet — 0.1.0 was an in-game upload, not a release — so a `compare/v0.1.0...v1.0.0` link would point
at nothing. The heading links to the release itself instead, which the CI creates after a
successful upload.

### 1.0.0

```
[h2][url=https://github.com/vbardales/Rimworld-Entity-Gazing/releases/tag/v1.0.0]1.0.0[/url] (TO BE DATED)[/h2]

First release.

[b]Entity gazing[/b], a recreation type of its own. The Anomaly DLC ships no recreation content at all, and since tolerance is counted per type rather than per building, an eleventh type is worth more than another building of a type the colony already had.

[b]Both entity holders[/b] become recreation sources, by patch: the steel holding platform and the holding spot. Watchers stand 2 to 6 cells away, in the same room, and the distance is configurable from 1 to 20 in Mod options. It costs nothing to build: the platform was already there for study.

[b]An empty platform is never watched.[/b] The one gameplay class this mod owns adds that condition to the base game's television logic and changes nothing else.

English and French.
```

The date is filled in on the day of the upload, and the version heading is checked by the dry-run
before any tag exists. `CHANGELOG.md` needs its own `## [1.0.0]` section, non-empty: that one is
the GitHub release notes, read separately by the same plugin.

## Screenshots, in the order to upload

Steam shows the first one large, so the most demonstrative goes first, not the prettiest. Every
image is opened and looked at before it is uploaded; a filename is not evidence of what it holds.

**Not decided yet, and it needs images this repository does not have.** What exists today is
`Mod/About/Preview.png`, the banner, and two `@review` captures per language under
`Tests/Pickle/Evidence/` — the settings window, and a colonist mid-gaze with the inspect pane open.
The gaze capture is a candidate for the first slot; the others a gallery would want, and nothing
has taken yet, are the watch area drawn under the build designator (feature 10 will produce one),
a holding spot being watched, and a colonist picking up the nociosphere's pain field.

## Dependencies and DLC

- **Anomaly is required**, and declared in `About.xml` as `modDependencies`. Whether that hard
  declaration is right is an open question recorded in `BUGS.md`: every document says the mod loads
  without the DLC and merely adds nothing, which describes an optional dependency. The pass without
  Anomaly is what will settle it, and the Workshop DLC box follows whatever that decides.
- **No other dependency.** `loadAfter` names only `Ludeon.RimWorld` and `Ludeon.RimWorld.Anomaly`,
  both vanilla. Nothing is `incompatibleWith`.
- Pickle and RimLogging run the tests and are **development only**: neither is a dependency of what
  players download, and the description says so.

## Content boxes

Nothing to declare. The mod adds no art of its own beyond the icon and banner, both of which have
been opened and looked at: a dim room, silhouettes seen from behind, a containment platform. No
nudity, no sexual content, no gore. The entities are the base game's, drawn by the base game.

## After an upload

- Commit `Mod/About/PublishedFileId.txt` immediately if it ever changes. It already exists here.
- Steam creates every item private. `RimWorld` never calls `SetItemVisibility`: going public is a
  hand action on the page, and it is what turns `prepublished` into `published`.
- Read the public page afterwards — description, change note, images — rather than the banner that
  says the change was saved.

## Thanks to post on the mods' pages

**Nothing to post, and the reason is not an omission.** This mod studies and extends the base
game's own watch-building logic and depends on no third-party mod. `WORKSHOP_COMMENTS.md` is keyed
by the recipient's Workshop id, and there is no external recipient here.

Pickle and PickleTools have Workshop pages and belong in the description as development tools.
Both are the author's own or the collection's own, so for the **comments** register they are
`not_applicable`: a thank-you comment to oneself is not one. If either ever needs one, the global
`WORKSHOP_COMMENTS.md` decides, and this project is added to a covering entry rather than posting a
second comment.

**PickleTools is owed a line in the description that it does not yet have**, and that is new as of
2026-09-25. PUBLISHING.md asks for it as soon as a pass of the mod stages a piece of it, and
`Tests/Pickle/wsl-deps.no-anomaly.map` now stages `ExpansionSteps`. It has a private Workshop page,
`3806142401`, so the mention carries the link and the same "development only" wording as Pickle and
RimLogging.

It was not added the same day the page was corrected, and the reason is the queue rather than
oversight: `About.xml` lives under `Mod/`, three Pickle requests were already filed against the
tree as it stood, and a request carries no SHA. It goes in with the next hand edit of the page,
once those have reported.
