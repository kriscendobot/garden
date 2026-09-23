---
title: Why not orthogonal persistence?
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security]
status: current
parent: endo--designs-dp--system-fit-and-not-orthogonal
---

The design rules out orthogonal persistence on three grounds:

### The upgrade problem dissolves the distinction

The obligation to manually persist important state is **shared** by
Formula Persistence and any orthogonally-persistent system that must
support upgrades. An upgrade may invalidate assumptions encoded in a
heap snapshot; the program must reconstruct its working state from
durable inputs afterward.

> *The orthogonal persistence machinery provides comfort during
> normal operation but does not eliminate the need for reconstruction
> logic. Formula Persistence accepts this reality as a starting point
> rather than discovering it as a consequence.*

### Instant restart

Because the formula graph encodes how to reconstruct **all**
capabilities, a node can restart instantly. There is no heap snapshot
to load, no replay log to process. Formulas are evaluated **lazily**
as capabilities are demanded.

### What is sacrificed

| | |
|---|---|
| **Determinism** | Reconstruction from formula may produce observably different results from one incarnation to the next (e.g., if a dependency's behavior has changed). |
| **Ephemeral state** | Heap state not captured in a formula or manually persisted is lost across incarnations. |
