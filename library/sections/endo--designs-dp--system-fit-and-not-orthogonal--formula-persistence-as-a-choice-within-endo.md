---
title: Formula Persistence as a choice within Endo
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

Formula Persistence is **not intrinsic to Endo.** Endo provides a
shared model for passable values (data and capabilities), patterns,
and message passing. Other systems built on Endo make different
choices along the entangled dimensions:

- The choice of **CapTP** determines message ordering.
- The choice of a **Network** determines the range within which pass-
  invariant equality can be relied upon.
- The **Daemon** chooses Formula Persistence.

For example, the **Agoric chain** uses Endo components with
**orthogonal persistence** to ensure that all honest validators
produce the same deterministic computation, independent of whether
they crashed and restarted or simply continued. Formula Persistence is
a design choice particular to the *user agent*, where the priorities
are fast convergence, user agency over retention, and timely
revocation — not determinism across validators.

That said, **the Daemon can host a worker that is itself constrained
to determinism and keeps its own replay transcript.** The Daemon
serves as host for the purpose of connecting the worker to the broader
network and vending capabilities, without imposing its own persistence
model on the worker's internals.
