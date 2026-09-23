---
title: Schema-on-query model
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

> Abstract: DialogDB decouples raw data from interpretation via a **schema-on-query** approach: no predefined schema requirements, facts can be added with any attribute at any time, different applications can interpret the same facts differently, and schema evolution happens organically without migrations. This inverts the traditional schema-on-write pipeline (define schema, validate, write, query) into write-facts then query-with-implicit-schema, apply time constraints, apply merge strategy. It is the architecture-level statement of the same principle the concept model calls schema-on-read: the shape is imposed by the reader, not enforced at write.

DialogDB decouples raw data from interpretation, using a schema-on-query approach:

- No predefined schema requirements.
- Facts can be added with any attribute at any time.
- Different applications can interpret the same facts differently.
- Schema evolution happens organically without migrations.

This is fundamentally different from traditional schema-on-write databases. Traditional flow: define schema, validate data, write data, query data. DialogDB flow: write facts, query with implicit schema, apply time constraints, apply merge strategy.

The approach enables evolution without migration, multiple interpretations of the same data, temporal queries (as-of specific points in causal timelines), conflict resolution at query time, access-pattern flexibility (all patterns efficiently supported by the indexes), and zero schema planning (no need to anticipate query patterns in advance).

The concept model (`notes/concept.md`) names the same idea **schema-on-read** and realizes it as concepts that are lenses over the claim store; this section is its storage-and-query-engine framing.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.
