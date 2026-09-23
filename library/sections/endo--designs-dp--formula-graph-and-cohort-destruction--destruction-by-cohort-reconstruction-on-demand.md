---
title: Destruction by cohort, reconstruction on demand
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
