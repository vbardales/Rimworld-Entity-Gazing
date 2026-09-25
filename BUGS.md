# Known defects

Things that are wrong now, as opposed to work not yet done, which is in [BACKLOG.md](BACKLOG.md).
Nothing here is a gameplay defect: the two Pickle passes are green in both languages, and the three
out-of-game suites are green. What follows is documentation that contradicts either the protocols
or itself.

## 1. The published Steam description names no AI tool — and cannot be fixed from the repository

`Mod/About/About.xml` ends its description with *"Created with AI assistance."* PUBLISHING.md
requires the real tools to be named — "Claude", "Codex", "DALL-E" — and says so explicitly against
writing "un outil d'IA". README.md and ATTRIBUTION.md do name them; the description does not.

The reason this is a defect and not a chore: `SetItemDescription` is called **only when the item is
created**. Item 3806760893 was created at 0.1.0, so the live page already carries the generic
sentence, and editing `About.xml` will never update it. It has to be corrected by hand on the Steam
page. Fixing the file too is still worth doing, so the repository and the page agree.

While that edit is being made, the same description is missing the sections AUDIT.md wants in order
after the body — `IF I GO QUIET`, `AI-GENERATED`, `THANKS`, the ATTRIBUTION line — and the thanks
owed to Pickle and RimLogging as development-only tools. That is a `tested → prepublished` item and
lives in BACKLOG.md; only the AI naming is a defect today.

## 2. `Tests/Pickle/README.md` is stale in four places

Written before the suite ever ran, and not updated since it did.

- "Nine features, written and **never run**." They have run five times.
- "76 checks already run in under a minute." There are 78: 24 form, 36 behaviour, 18 settings.
- Its "Running it" section tells a session to call `scripts/Run-PickleWsl.ps1` itself. WELCOME.md
  §2 says the opposite in as many words: file a request, keep no process.
- Its "One watcher for every ticket" paragraph tells a session to arm a `Monitor`. WELCOME.md §3
  says not to watch the queue at all, and Virginie said the same: the dispatcher wakes the owner.

The last two are the ones that matter — a reader following that file would take the machine by hand
and arm a watcher nobody wants.

## 3. `About.xml` declares Anomaly as a hard dependency while the documents call it optional

`modDependencies` names `Ludeon.RimWorld.Anomaly`. README.md, the Steam description and the
CHANGELOG all say "Without it the mod loads but adds no recreation activity" — which describes a mod
that degrades, not one that refuses. The defs carry `MayRequire` precisely so it can load.

Both readings are defensible and this is a decision rather than an error, which is why it is here
rather than silently changed: a hard dependency makes the mod list demand the DLC of a player who
does not have it. The DLC-off pass in BACKLOG.md is what would settle what such a player actually
sees, and it should be run before the declaration is either kept or dropped.
