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

Read by a sweep across every mod, rather than by asking each thread in turn. It lives at the
root, never inside `Mod/`, so Steam never receives it.

The fields above were read off the disk on 2026-09-12. Three cannot be, and wait for whoever
holds this mod:

- **`stage`** — one of `port`, `showcase`, `preTest`, `done`, `tested`, `published`. Filled in
  from the session group where one exists; confirm it.
- **`tested_on`** — the date of the last run in game. Empty means never.
- **`remaining`** — what is left, in three kinds: `feature` for something missing from a first
  release, `defect` for a known fault left unfixed, `unverified` for what could not be checked.
  The line already there is true of nearly the whole repository; replace it once it stops being.

`licence` vocabulary: `open` an explicit licence, `silent` no licence and a dead source,
`alive` no licence but a living source, `forbidden` a written refusal, `original` nothing reused.
