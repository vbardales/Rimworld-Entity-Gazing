# Known defects

Things that are wrong now, as opposed to work not yet done, which is in [BACKLOG.md](BACKLOG.md).
Nothing here is a gameplay defect: the two Pickle passes are green in both languages, and the three
out-of-game suites are green.

## 1. `About.xml` declares Anomaly a hard dependency while the documents call it optional

`modDependencies` names `Ludeon.RimWorld.Anomaly`. README.md, the Steam description and the
CHANGELOG all say "Without it the mod loads but adds no recreation activity" — which describes a
mod that degrades, not one that refuses. The defs carry `MayRequire` precisely so it can load.

**Left as it is on purpose, and now testable.** Both readings are defensible, and this is a decision
rather than an error: a hard dependency makes the mod list demand the DLC of a player who does not
have it, and dropping it would instead make the mod silently inert for them. Feature 13, in the
pass without Anomaly, is what will show which of those a player actually meets. Changing the
declaration before reading that report would be guessing.

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
