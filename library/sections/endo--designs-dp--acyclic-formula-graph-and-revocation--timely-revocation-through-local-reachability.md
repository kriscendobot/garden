---
title: Timely revocation through local reachability
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

The acyclicity of the formula graph enables **timely destruction and
severance** of capabilities the user has revoked:

> *Once a reference is locally unreachable in the petname graph, the
> corresponding live reference can be made immediately unreachable
> and gracefully destroyed. All heaps that refer to it and all CapTP
> sessions that retain it can be terminated or severed. There is no
> need to wait for distributed garbage collection to propagate; the
> user agent controls local reachability and acts on it directly.*

This is a key UI affordance of the Endo Daemon, Chat, and Familiar
system. **The user agent gives the user a place to stand to locally
control reachability of local resources**, while still participating
in a distributed reference network.

> *The user does not need to trust the distributed system to honor
> revocation — revocation is enforced locally, at the persistence
> layer, before any distributed protocol is consulted.*
