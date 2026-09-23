---
title: Mitigating heap bloat through the formula floor
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security, patterns]
status: current
parent: endo--designs-dp--acyclic-formula-graph-and-revocation
---

Because formula-backed values can be reincarnated on demand, **the
ephemeral heap is never load-bearing for capability continuity.** If a
connected peer is imposing an undue burden by retaining ephemeral
state, the user can intervene:

- The user can force the offending worker to restart, discarding its
  ephemeral heap. Any formula-backed values reconstruct on demand.
- The OS can obligate a worker to restart as out-of-memory mitigation,
  with the same consequence.
- If neither suffices, the user can manually sever the offending peer.

Heap bloat in the ephemeral layer is mitigated by interventions **one
layer down**, in the formula graph. The formula graph provides the
**floor** from which the system can always recover.
