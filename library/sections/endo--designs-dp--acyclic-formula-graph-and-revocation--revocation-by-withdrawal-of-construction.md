---
title: Revocation by withdrawal of construction
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

Formula Persistence introduces a **fourth revocation mechanism**
distinct from the three already named in the literature (inline
caretakers, revocation lists, expiry):

> **Revocation by withdrawal of the constructor.**
>
> Removing or invalidating a formula withdraws the recipe for
> constructing the capability. This cascades into the disincarnation
> of the corresponding live reference and anything that depends upon
> it for its own construction.

| Mechanism | Distributed protocol? | Granularity | Immediacy |
|---|---|---|---|
| Inline caretaker | No (local) | Per-reference | Immediate, but requires the caretaker to remain alive |
| Revocation list | Yes (must propagate) | Per-key | Eventual |
| Expiry | No | Coarse-grained (time-based) | Deferred |
| **Withdrawal of constructor** | **No (local)** | **Per-cohort** | **Immediate** |

The mechanism is **immediate, local, and requires no distributed
protocol** — a stronger guarantee than caretakers (which must remain
alive), revocation lists (which must propagate), or expiry (which is
coarse-grained).

This pattern — *control reachability at the petname level; the rest
of the graph follows* — is a worked example of the same
**user-agency-at-the-graph-root** discipline that the OCapN-family
protocols rely on at the network boundary. See
[[endo-but-for-bots--llm-designs-dcpg--persistence-and-graph]] for
the cross-peer extension of the same retention discipline (the third
clause of local-GC reachability: "no peer's set in retentionEdges
contains it").
