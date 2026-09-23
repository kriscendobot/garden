---
title: Graph structure and garbage collection
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

The formula graph and the ephemeral reference graph have
**complementary structural properties** — the design exploits this
complementarity deliberately:

| | Formula graph | Ephemeral reference graph |
|---|---|---|
| Topology | **Acyclic** | May be cyclic |
| Scope | Durable | Scoped to sessions |
| GC mechanism | **Simple local reference counting** | (Sessions bound it) |
| Distributed GC needed? | **No** | n/a |

The formula graph is acyclic *across peers* but admits **limited
cycles among certain co-formula groups** that must present unique,
unforgeable identifiers to the network while being constructed as
facets of a shared underlying capability:

- **Promise-and-resolver pairs**
- **Agent handle pairs**

These groups are treated as units for GC purposes; cycles inside a
group are permitted, cycles between groups are not.

The acyclicity gives Formula Persistence two large simplifications:

1. **No distributed garbage collection protocol** for the durable
   layer. Local reference counting suffices.
2. **No need for market-based distributed-GC mechanisms** to handle
   misaligned-incentive cycles (cf. Drexler & Miller 1988), because
   such cycles cannot exist in the durable graph.
