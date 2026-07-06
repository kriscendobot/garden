---
title: EAV / AEV / VAE indexing
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: DialogDB maintains three indexes over the same facts, each a Probabilistic B-Tree keyed by a different column ordering, so every major query pattern is covered without access-pattern planning: **EAV** (Entity-Attribute-Value) for "what properties does entity X have?", **AEV** (Attribute-Entity-Value) for "which entities have attribute Y?", and **VAE** (Value-Attribute-Entity) for "which entities have attribute Y with value Z?". Comprehensive indexing means no access-pattern planning, no schema migrations for new patterns, consistent performance across unexpected patterns, and the flexibility to use data in ways the original creator did not anticipate. This is the Datalog-fact-database counterpart of Datomic's covering indexes.

DialogDB maintains multiple indexes for efficient access to facts from different perspectives:

- **EAV Index** (Entity-Attribute-Value): optimized for retrieving all attributes of a given entity — "What properties does entity X have?"
- **AEV Index** (Attribute-Entity-Value): optimized for retrieving all entities with a specific attribute — "Which entities have attribute Y?"
- **VAE Index** (Value-Attribute-Entity): optimized for finding entities with specific attribute values — "Which entities have attribute Y with value Z?"

This comprehensive indexing strategy means:

- **No access pattern planning**: all major query patterns are covered by one of the indexes.
- **No schema migrations**: new access patterns don't require index changes.
- **Consistent performance**: no degradation for unexpected query patterns.
- **Flexibility**: applications can use data in ways not anticipated by the original creator.

Each index is itself a content-addressed Probabilistic B-Tree, so the three share the deterministic-layout and cheap-diff properties of the storage layer; maintaining three orderings is the space cost that buys pattern-agnostic query performance.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.
