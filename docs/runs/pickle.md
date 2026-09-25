# Pickle run history

One line per run. A report is deleted as soon as a newer one replaces it; this file is what
survives, so it carries the verdict and the cause rather than a pointer to bytes that are gone.

- 2026-09-24 19:26 · en · a0a5 · 42c9981 · failed · 23 run, 1 passed · three faults, all in the suite: a PawnKindDef name that does not exist, a teardown hook calling ctx.Get with nothing stored, a container filled by transfer from a map
- 2026-09-24 20:47 · fr · 0e2e · 42c9981 · discarded · staged before the fixes reached disk, so it replayed code already known bad
- 2026-09-25 11:10 · en · 6612 · 6d297f6 · failed · 23 run, 16 passed · three faults, all in the suite: the patcher named by packageId where Pickle stores the display name, a holder spawned factionless so JoyKindsOnMapTempList never saw it, and a watch range measured as a straight line where the game measures it along the facing axis
- 2026-09-25 14:08 · en · a657 · 57097e7 · failed · 23 run, 22 passed · one fault: the teardown hook destroying a holder that belonged to the map the reload had discarded. Every step of that scenario passed; only the hook was red. Both @review captures read and good
- 2026-09-25 14:14 · fr · b7bf · 57097e7 · failed · 23 run, 22 passed · identical to a657, same scenario, same hook. Settings window and job report both correct French
