---
title: Frame, thesis, and position in the design space
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
notes: Sourced from an **unmerged draft PR**. The standard idempotency check against the default branch returns nothing (file not on `master`); re-check this section against PR head `aefc1b87da0c`. If the PR rebases or merges, re-ingest from the new HEAD; if the PR closes without merging, mark this and all `endo--designs-dp--*` sections as **stale**. See [[journal-library-conventions]] § "Sources from unmerged PRs" for the discipline.
---

The thesis of *Formula Persistence (Pass by Construction)* is that the
Endo Daemon's petname graph **is** the persistence root — not a layer
on top of sturdy references or web-keys. The system persists
**construction**, not content: each capability is described by a
*formula*, a recipe for reconstructing the live reference and its
transitive dependencies on demand.

This design sits between two long-standing positions:

| Property | Waterken (masked partition/revival) | E (exposed partition/revival) | Formula Persistence |
|---|---|---|---|
| Partition and revival | Masked | Exposed per-reference | Exposed **per-cohort** |
| Persistence mechanism | Orthogonal | Manual + sturdy refs | **Formula graph** |
| Programming model | Simple (no partition code) | Defensive (per-reference) | Moderate (cohort-aware) |
| Restart cost | Snapshot restore | Reference re-establishment | Formula evaluation (lazy) |
| Upgrade story | Difficult (heap assumptions) | Natural (references re-resolve) | Natural (formulas re-evaluate) |
| Retention: live references | Indefinite (partition masked) | Distributed acyclic GC | Scoped to cohort |
| Retention: durable references | Indefinite (web-keys) | Weak (sturdyrefs) | Local reference counting (formula graph) |
| Availability | Sacrificed for consistency | Maintained per-reference | Maintained per-cohort |
| Petname relationship | Built on top of references | Built on top of references | **Petnames *are* the persistence root** |

Three properties are doing the structural work:

1. **Petnames are the persistence root.** Waterken and E build petname
   systems *on top of* sturdy references / web-keys. Formula
   Persistence inverts that relationship: the petname graph is the
   persistence layer, and live references are derived from it on
   demand.
2. **Destruction by cohort + reconstruction on demand.** When a
   reference in a cohort partitions, the *entire* dependent subgraph
   of live references is destroyed and may later be rebuilt from
   formulas. The system does not attempt to patch a partially broken
   live graph.
3. **Acyclic formula graph + locally reference-counted.** No
   distributed GC is needed for the durable layer; cycles are
   permitted only in the ephemeral session-scoped layer (see
   [[endo--designs-dp--acyclic-formula-graph-and-revocation]]).

These three properties together make instant restart, timely
revocation, and ergonomic upgrade all available to the user agent
without the distributed-GC obligations that orthogonal persistence
entails (see
[[endo--designs-dp--system-fit-and-not-orthogonal]]).

The design relates to but is distinct from the *cross-peer GC
protocol* ([[endo-but-for-bots--llm-designs-dcpg--retention-set-model]])
and the *locator-terminology rename*
([[endo-but-for-bots--llm-designs-dlt--terminology-rename]]): those
two operate **within** the formula-persistence model — they describe
*how* peers communicate retention and *what* the wire representations
of formula keys are. This design names the model itself and explains
why the formula graph exists in the shape it does.
