---
title: Two reference graphs, one daemon
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
parent: endo--designs-dp--formula-graph-and-cohort-destruction
---

The **live reference graph** passes through the heaps of distributed
processes and is a mix of:

- **Formula-backed references** — backed by a node in the formula
  graph, reconstructable on demand.
- **Ephemeral references** — bounded by sessions, can suffer
  partition, not reconstructable across incarnations.

Both pass over CapTP. The formula graph is **flat across peers**
(every formula is owned by some peer); the live graph weaves through
many heaps. Formula Persistence keeps the durable layer narrow and
the ephemeral layer wide.

Creating a formula is **not a matter of mere message passing.** It
requires appealing to a user agent — typically by proposing code that
can construct the live reference, then persisting that code along with
its petnamed dependencies. **Formula creation is a deliberate act of
policy**, not an automatic consequence of holding a reference.

Consequently, Formula Persistence does not entirely avoid the problem
of programming explicitly against partition. Programs must still be
aware that ephemeral references can vanish. What it offers is a more
ergonomic way to do so:

- The formula graph provides a **declarative substrate for recovery.**
- The petname database provides a **human-legible map** of what has
  been made durable and why.

This is a **hybrid approach**, sitting between systems that mask
partition entirely (Waterken) and systems that expose it at every
reference (E). See
[[endo--designs-dp--waterken-and-e-as-endpoints]] for the two
endpoints, and
[[endo--designs-dp--acyclic-formula-graph-and-revocation]] for the
graph-structural properties that make destruction-by-cohort + local
revocation possible.
