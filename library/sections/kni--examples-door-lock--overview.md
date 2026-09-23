---
title: "Guarded door-lock state machine"
source: examples/door-lock.kni
source_repo: kriskowal/kni
source_commit: 3c17d8a313ba0cd0aded521aca5ebd2db568e3ec
source_date: 2018-03-09
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: Two rooms share a door-state subroutine whose guarded choices make unlock, open, close, lock, traversal, and a conditional bell event explicit graph transitions over `Open` and `Unlocked`.

The `Door()` procedure renders the door differently from the two variables. Blue and red choice labels both reuse the same guarded transitions: walking requires an open and unlocked door, opening requires unlocked, and locking/unlocking is permitted only while closed. Red adds a bell whose consequence is conditional on the door being closed and locked.

The example demonstrates decision-graph authoring as a visible finite-state controller: user feedback is rendered from state, offered actions are filtered by guards, and every chosen action performs a local, named mutation or edge transition. Reusing the procedure keeps one state model consistent across two contexts.

Source: [examples/door-lock.kni](https://github.com/kriskowal/kni/blob/3c17d8a313ba0cd0aded521aca5ebd2db568e3ec/examples/door-lock.kni) at commit `3c17d8a3`.
