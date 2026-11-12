# Known defects

Things that are wrong now, as opposed to work not yet done, which is in [BACKLOG.md](BACKLOG.md).
Nothing here is a gameplay defect: the two Pickle passes are green in both languages, and the three
out-of-game suites are green.

## 1. `About.xml` declares Anomaly a hard dependency while the documents call it optional — closed

`modDependencies` names `Ludeon.RimWorld.Anomaly`. README.md, the Steam description and the
CHANGELOG all say "Without it the mod loads but adds no recreation activity" — which describes a
mod that degrades, not one that refuses. The defs carry `MayRequire` precisely so it can load.

**Decided 2026-09-27: the hard dependency stays.** Feature 13 supplied the evidence a decision
needed: with the DLC really absent, the mod loads without error, its three gameplay defs are gated
away, and nothing else breaks. That is the state a player reaches after removing the DLC once the
mod is already enabled — `modDependencies` cannot stop that, only fresh enabling through the mod
list, which is exactly where it should ask for the DLC. Virginie confirmed keeping it. The
README/CHANGELOG wording about loading without Anomaly still describes that reachable state
correctly and needs no change.

The **test companion** is a different matter and has been changed: `Tests/Pickle/Mod/About/About.xml`
now names Anomaly in `loadAfter` only. A development companion whose whole job includes running
with the DLC switched off cannot declare it as a dependency, or the pass written for that case
cannot be staged.

---

Closed on 2026-09-25: the Steam page's AI mention. `Mod/About/About.xml` said *"Created with AI
assistance"* where PUBLISHING.md requires the real tools named. The file now names Claude Code
(Anthropic), Codex (OpenAI) and DALL-E, and carries `IF I GO QUIET`, `AI-GENERATED` and `THANKS` in
AUDIT.md's order, with Pickle and RimLogging credited as development-only tools. Because
`SetItemDescription` fires only when an item is created, the live page could not follow from a
commit: it was edited by hand on the Workshop page for item 3806760893 the same day, and the public
page was read back afterwards to confirm it rather than trusting the "changes saved" banner.

Closed on 2026-09-25: `Tests/Pickle/README.md` was stale in four places, two of which told a reader
to call the launcher by hand and arm a `Monitor` that WELCOME.md §3 forbids. Rewritten around the
four passes. The same session fixed WELCOME.md §5 itself, in the dispatcher's repository
(`fea3728`): its recipe for recording a document's version returned the commit that *deleted*
AUDIT.md, because the protocol documents now live in `vbardales/Rimworld-protocols`.
