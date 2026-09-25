# Pickle run history

One line per run. A report is deleted as soon as a newer one replaces it; this file is what
survives, so it carries the verdict and the cause rather than a pointer to bytes that are gone.

- 2026-09-24 19:26 · en · a0a5 · 42c9981 · failed · 23 run, 1 passed · three faults, all in the suite: a PawnKindDef name that does not exist, a teardown hook calling ctx.Get with nothing stored, a container filled by transfer from a map
- 2026-09-24 20:47 · fr · 0e2e · 42c9981 · discarded · staged before the fixes reached disk, so it replayed code already known bad
- 2026-09-25 11:10 · en · 6612 · 6d297f6 · failed · 23 run, 16 passed · three faults, all in the suite: the patcher named by packageId where Pickle stores the display name, a holder spawned factionless so JoyKindsOnMapTempList never saw it, and a watch range measured as a straight line where the game measures it along the facing axis
- 2026-09-25 14:08 · en · a657 · 57097e7 · failed · 23 run, 22 passed · one fault: the teardown hook destroying a holder that belonged to the map the reload had discarded. Every step of that scenario passed; only the hook was red. Both @review captures read and good
- 2026-09-25 14:14 · fr · b7bf · 57097e7 · failed · 23 run, 22 passed · identical to a657, same scenario, same hook. Settings window and job report both correct French
- 2026-09-25 16:26 · en · 5929 · 82656f8 · passed · 1 run, 1 passed · fix check on the reload scenario alone, confirming the guarded teardown hooks. Its archive was 2.06 GB for that one scenario, almost all of it the shared screenshot folder copied whole
- 2026-09-25 17:48 · en · 5eb3 · 64f5de0 · passed · 23 discovered, 23 run, 23 passed · no @wip, no conditional scenario, both @review captures read and correct. Its archive was 10 MB, not 2 GB: the shared screenshot folder had been cleared in between
- 2026-09-25 18:2x · fr · 1a55 · 64f5de0 · passed · 23 discovered, 23 run, 23 passed · identical to 5eb3. Both @review captures read: clean French throughout, "Observe l'entité captive."

## Mutation campaigns

- 2026-09-25 · 35 mutations · 64f5de0 · all 35 woke the test they were aimed at; nine also woke a second, recorded as collateral. Functional test 36, the teardown-hook guard, has no mutation and needs none: it came up red on its first run
