---
title: Formula graph and destruction-by-cohort — the petname database as persistence root
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
---

## Inversion: petnames as the persistence root

The petname database is a graph database mapping human-readable,
self-assigned names to capabilities — a tree of named paths mapped to
locators. As in E, a locator serves to re-establish connectivity. But
**here** a locator names a node in the **formula graph**, via which
the daemon resolves to the *latest incarnation* of the underlying
capability.

The petname database is not a layer on top of sturdy references; it
*is* the persistence system.

## Formulas as construction recipes

Each formula records two things:

1. How to arrive at a live reference for a capability.
2. How to construct the capability's dependencies.

A formula is **not a snapshot of state**. It is a recipe for producing
state. The system persists *construction*, not content.

## Destruction by cohort, reconstruction on demand

A capability is a member of a **cohort**: itself and the live
references for its transitive dependencies. The system responds to
partition with **destruction by cohort**: when any reference in the
cohort becomes partitioned, the entire subgraph of dependent live
references is collectively destroyed. The system then offers
**reconstruction on demand**: affected capabilities may later be
reincarnated from their formulas when partition heals and a consumer
requests them.

This is the *pass by construction* property — rather than attempting
to patch a partially broken graph of live references, the system
destroys the affected cohort and rebuilds from formulas on demand.

When a cohort is destroyed, the system provides a window for the
hosting process to shut down gracefully (flushing external storage,
releasing resources). During this window, partition of individual
references becomes observable. But the moment the daemon has committed
to disincarnation, the incarnation lives only in limbo and cannot be
reached through the daemon; its severance is, from that point on,
inconsequential.

> *Rather than obligate the code to react to partition, we automate
> reconstruction. We require the code to manually persist anything
> that might need to survive reconstruction, and provide formula-
> based storage mechanisms to that end. We find this burden tolerable
> given that every system in which software can be upgraded
> necessarily has the same obligation.*

## Two reference graphs, one daemon

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
