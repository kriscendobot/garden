---
title: Logical-clock survey — vector, Merkle, and hybrid logical clocks
source: notes/divergence-clock.md
source_repo: dialog-db/dialog-db
source_commit: abb5ca3f7c1b7bde278034eed41b66207a2b1d4e
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: Before proposing its own clock, the note surveys the two ways to lift the same-lineage causal-reference limitation, then three logical-clock families. The first lift — **partially extending the causal-reference space** so references share an attribute *namespace* (the `the` prefix before `/`) rather than the exact `{the, of}` — would extend consistency guarantees from fact to schema granularity while keeping references in nearby tree segments, but introduces a subtle rule about what can be updated consistently and undermines open-ended cooperation by making cross-schema guarantees impossible (incentivizing schema centralization, which the author notes may be a mixed blessing). The second lift — a **causal index** modeled loosely on Datomic's transaction ID, but without Datomic's central authority — leads into a logical-clock comparison. **Vector clocks** (`{site: time}` maps) establish partial order but grow with the number of sites; production CRDTs like Automerge encode cleverly but require DAG traversal to divergence points, and this does not by itself fix the atomic-multi-fact problem. **Merkle clocks** (Merkle-CRDT paper) use hash references instead of per-site times — Dialog's current design is essentially this with a single same-lineage link — but two hash-`cause` assertions still can't be told concurrent without traversing the causal DAG to find an ancestor or common ancestor, needing an indexing strategy. **Hybrid Logical Clocks (HLC)** synthesize wall-clock with Lamport clock, correcting drift so a new change never appears in the past; elegant and totally comparable, but *bad at identifying concurrency* — a smaller change after a larger one won't appear concurrent, so HLC doesn't account for two sites changing state unaware of each other (the same failure as the current design).

## Two ways to lift the limitation

### Partially extending the causal-reference space

Instead of requiring all causal references share the same `{ the, of }`, require they share an attribute namespace (the slice of `the` before `/`). This extends consistency guarantees from fact granularity to schema granularity while keeping causal information in nearby (same or adjacent) tree segments. The downside: it introduces a subtle nuance about what can and cannot be updated with consistency guarantees, and undermines the open-ended cooperation model — cross-schema consistency becomes impossible, creating an incentive to centralize around schemas. (The author notes such standardization pressure *may* be desirable, but worries namespace-limited transactional guarantees are error-prone; ideally the limit is avoided while making within-namespace guarantees more optimal, as queries are.)

### Causal index

Revisit causal references, modeling them more like Datomic's (with a transaction ID). Datomic's approach can't be used directly because it assumes a central authority, but a different logical clock should work.

## Logical-clock candidates

### Vector clocks

Popular CRDTs use vector clocks — collections of `{ site, time }` pairs where `site` is a unique process identifier and `time` is the max Lamport timestamp across all sites observed. Two vector clocks establish partial order: if each time in one is `>=` the other and at least one is `>`, it orders after; otherwise they are concurrent. Problem: clock size grows with the number of participating sites. Production CRDTs (Automerge) encode cleverly, essentially only the site's own time, but recovering the rest requires DAG traversal until divergence points. This also does not necessarily fix the consistency-guarantee problem.

### Merkle clocks

The Merkle-CRDT paper proposes hash references instead, removing the need to track per-site times. Dialog's current design is more or less this, except it imposes a single causal link to the same lineage; it could instead use the tree `root` hash as a causal reference. But two assertions whose `cause` fields are just hashes still can't be identified as concurrent without traversing the causal DAG until one is found to be an ancestor of the other or a common ancestor is found — and efficient traversal needs an indexing strategy.

### Hybrid Logical Clocks (HLC)

HLC synthesizes wall clock with a Lamport clock: it takes timestamps and corrects time drift by making intentional drifts, so a new change never appears in the past when local time lags the last change. Elegant, and makes any two assertions comparable to determine which took place. It is not Byzantine-fault tolerant (but neither is the overall design). The weakness: HLC makes identifying *concurrent* changes far harder — a smaller change happening after a larger one won't appear concurrent, exhibiting the same problem as the current design. HLC does not account for two sites making changes unaware of each other.

Source: [notes/divergence-clock.md](https://github.com/dialog-db/dialog-db/blob/abb5ca3f7c1b7bde278034eed41b66207a2b1d4e/notes/divergence-clock.md) at commit `abb5ca3f`.
