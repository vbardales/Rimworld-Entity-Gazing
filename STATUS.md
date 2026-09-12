---
mod:        Entity Gazing
packageId:  nelim.entitygazing
repo:       Rimworld-Entity-Gazing
visibility: public
detached:   yes
stage:      done
licence:    original
licence_at: MIT, LICENSE at the root; no ATTRIBUTION, nothing is reused
showcase:   complete
tested_on:
workshop:
remaining:
  - unverified: never seen running in a colony; the fourteen scenarios of TESTING.md, none played
  - unverified: never uploaded to the Workshop, so the showcase has never been seen in place
session:    local_2c8cbd89-28f1-4b1a-9830-51a1cae086d3
updated:    2026-09-12, mod session
---

# Entity Gazing — status

One card per mod, read by a sweep across the whole repository rather than by asking each thread in
turn. It lives at the root, never inside `Mod/`, so Steam never receives it.

This card is maintained by the session that holds this mod, and the fields above were confirmed
against the disk rather than inferred. What each one says today:

- **`stage: done`** — written, documented, and checked as far as it can be without the game.
  Fifty-six tests in two suites under `_tools/` all pass, and a mutation campaign has watched each
  of them fail. The next stage is `tested`, and only a colony can grant it.
- **`tested_on:`** — empty, and honestly so. Nothing here has been watched happening in play.
- **`showcase: complete`** — preview at 896 by 504 and icon at 128 square, both within weight, with
  the full-resolution originals under `Art/`. The prompt kept for regenerating them is
  `PROMPT_ENTITYGAZING.md`, at the monorepo root, outside git as all of those are.
- **`licence: original`** — the mod reuses nothing. MIT, and no `ATTRIBUTION.md` because there is
  nobody to attribute but Ludeon, which the README does.

## When to change it

- After a session in a colony: set `tested_on`, and turn the first `unverified` line into what
  actually happened. If something broke, it becomes a `defect` line rather than disappearing.
- After a Workshop upload: fill `workshop` with the item id, drop the second `unverified` line, and
  remember that the description and the `packageId` freeze at that moment.
- After any change to the mod: the two suites are the check, and `remaining` is where anything they
  cannot see goes.

`remaining` takes three kinds of line: `feature` for something missing from a first release,
`defect` for a known fault left unfixed, `unverified` for what could not be checked.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source, `alive` no
licence but a living source, `forbidden` a written refusal, `original` nothing reused.
