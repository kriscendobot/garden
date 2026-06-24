---
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 12
status: current
---

> Abstract: The root README of `kriskowal/frb` (Functional Reactive Bindings), a large tutorial-plus-reference document (~2600 lines) for a JavaScript library that incrementally maintains consistency between object properties and collection contents through one- and two-way bindings declared in a small query language. Two ingest cycles to date (both 2026-06-24): the first filed the four conceptual sections (overview, design properties, architecture, the bindings API and query language); the second filed eight thematic tutorial sections grouping the query-language operators (binding fundamentals and paths; aggregations; mapping and filtering; order and grouping; windowing and structure; map lookups; equality and content; the scalar expression language). Still deferred: the tutorial's declarative/observer machinery (Parameters, Elements and Components, Observers, Nested Observers, Bindings, Binding Descriptors, Converters, Computed Properties, Debugging with Traces; lines ~1333-1767), the entire Reference section (lines ~1768-2616), and the grammar/compiler source.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/frb--readme--overview.md) | reactive-bindings | current |
| [properties](../sections/frb--readme--properties.md) | reactive-bindings | current |
| [architecture](../sections/frb--readme--architecture.md) | reactive-bindings | current |
| [bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | reactive-bindings | current |
| [tutorial-bindings-and-paths](../sections/frb--readme--tutorial-bindings-and-paths.md) | reactive-bindings | current |
| [tutorial-aggregations](../sections/frb--readme--tutorial-aggregations.md) | reactive-bindings | current |
| [tutorial-mapping-and-filtering](../sections/frb--readme--tutorial-mapping-and-filtering.md) | reactive-bindings | current |
| [tutorial-order-and-grouping](../sections/frb--readme--tutorial-order-and-grouping.md) | reactive-bindings | current |
| [tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | reactive-bindings | current |
| [tutorial-maps-and-lookups](../sections/frb--readme--tutorial-maps-and-lookups.md) | reactive-bindings | current |
| [tutorial-equality-and-content](../sections/frb--readme--tutorial-equality-and-content.md) | reactive-bindings | current |
| [tutorial-expression-language](../sections/frb--readme--tutorial-expression-language.md) | reactive-bindings | current |

## Provenance

- Repository default branch `master`; README last modified 2013-09-15 by Kris Kowal. Repo HEAD equals the README commit (`131db347`); idempotency re-checked 2026-06-24 (file-specific commit unchanged from the first cycle).
- Two ingest cycles, both 2026-06-24. Cycle 1 (begin-ingest, job `scholar-ingest-new-forks`) filed the four conceptual sections. Cycle 2 (job `scholar-ingest-frb`) filed the eight operator-tutorial sections above and added the `frb-incremental-update` and `frb-compiled-observer-tree` concepts.
- Deferred to a follow-on `scholar-ingest-frb` job: the tutorial's declarative/observer machinery (Parameters, Elements and Components, Observers, Nested Observers, Bindings, Binding Descriptors, Converters, Computed Properties, Debugging with Traces; lines ~1333-1767); the Reference section (Architecture, Bindings, Bind, Compute, Observe, Evaluate, Stringify, Grammar, Semantics, Language Interface, Syntax Tree, Observers and Binders; lines ~1768-2616); and the grammar/compiler source (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`).
- Bot fork: `kriscendobot/frb` (content identical to upstream).

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
