---
title: Clock-embedded indexing, query-driven replication, and convergence preference
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

> Abstract: How the divergence clock pays off in storage and sync. Because every datalog query reduces to a range scan over indexed facts, the clock enables **query-driven partial replication**: identify required segments from a query's `{the, of, is}` predicates, pull only the tree segments (and index nodes leading to them) containing matching facts, preserve causality via the lexicographic `${since}/${at}/${drift}` ordering within replicated segments, and resolve conflicts locally because concurrent facts with the same `since` co-locate in nearby segments. The **indexing strategy** embeds the clock into each key: EAVT, AEVT, VEAT, and TEAV index trees (entity/attribute/value/time orderings) each key facts with `since/at/drift` appended, so range queries co-locate related facts regardless of when created, conflicting facts (same entity/attribute/value, different cause) appear adjacent, the TEAV index supports efficient "as of"/temporal total-ordering queries, and partial replication is preserved. Finally, a **convergence preference**: like blockchain's longest-chain rule, sites that pull more frequently increment `since` sooner and supersede changes from less-frequently-pulling (lower-`since`) sites — a preference for convergence over divergence. Nothing stops an offline site from *rebasing* rather than merging its changes to avoid being overridden, but as with git that disturbs other sites by disputing previously-agreed history.

## Query-driven partial replication

The divergence-clock design enables efficient partial replication through query-driven segment loading. Since all datalog queries reduce to range scans over indexed facts, the system can:

1. **Identify required segments** based on query predicates `{ the, of, is }`.
2. **Replicate relevant subtrees**: pull only tree segments containing facts matching the query constraints, plus the index nodes leading to them.
3. **Maintain causality**: the lexicographic ordering of `${since}/${at}/${drift}` preserves causal relationships within replicated segments.
4. **Resolve conflicts locally**: concurrent facts with the same `since` values co-locate in nearby tree segments, enabling local conflict resolution.

This allows querying without full database replication, unlike traditional CRDTs.

## Indexing strategy with divergence clocks

Multiple index trees index facts by different orderings, with the divergence clock embedded in the key structure:

```
EAVT (Entity-Attribute-Value-Time):  "user:123/name/Alice/5/A/1" -> { the, of, is, cause:{since:5, at:"A", drift:1} }
AEVT (Attribute-Entity-Value-Time):  "name/user:123/Alice/5/A/1" -> ...
VEAT (Value-Entity-Attribute-Time):  "Alice/user:123/name/5/A/1" -> ...
TEAV (Time-Entity-Attribute-Value):  "5/A/1/user:123/name/Alice" -> ...
```

This ensures:

1. **Range queries work efficiently**: scanning all facts about `user:123` in EAVT co-locates related facts regardless of creation time.
2. **Conflicts are discoverable**: facts with the same entity/attribute/value but different cause appear adjacent in each index.
3. **Temporal queries are supported**: TEAV enables efficient "as of" queries and total ordering of all operations.
4. **Partial replication is preserved**: tree segments contain related facts by the primary index components, with temporal information encoded in the path.

## Convergence preference

This design shares tradeoffs with the "longest chain rule" in some blockchains: sites that pull more frequently increment `since` sooner and consequently supersede changes made by sites that pull less frequently (and thus have lower `since` values). This is a **preference for convergence over divergence**. Nothing prevents sites that stayed offline from *rebasing* their changes rather than merging them as-is, enabling them to rewrite history so their changes aren't overridden — but, as with git, this comes at the cost of disturbing other sites (less than git, but history previously agreed upon by certain sites may become disputed).

Source: [notes/divergence-clock.md](https://github.com/dialog-db/dialog-db/blob/abb5ca3f7c1b7bde278034eed41b66207a2b1d4e/notes/divergence-clock.md) at commit `abb5ca3f`.
