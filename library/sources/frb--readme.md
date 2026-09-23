---
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 21
status: current
---

> Abstract: The root README of `kriskowal/frb` (Functional Reactive Bindings), a large tutorial-plus-reference document (~2600 lines) for a JavaScript library that incrementally maintains consistency between object properties and collection contents through one- and two-way bindings declared in a small query language. Three ingest cycles to date (all 2026-06-24): the first filed the four conceptual sections (overview, design properties, architecture, the bindings API and query language); the second filed eight thematic tutorial sections grouping the query-language operators (binding fundamentals and paths; aggregations; mapping and filtering; order and grouping; windowing and structure; map lookups; equality and content; the scalar expression language); the third filed the tutorial's declarative/observer machinery (parameters and components; the observer/binder programmatic interface; converters/computed/traces) and the Reference section (the programmatic module API; the grammar; the per-operator semantics; the syntax tree and language interface; the observers and binders building blocks). Still deferred: the grammar/compiler **source** files (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`), tracked by the follow-on `scholar-ingest-frb-3` job; the README itself is now fully ingested.

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
| [tutorial-parameters-and-components](../sections/frb--readme--tutorial-parameters-and-components.md) | reactive-bindings | current |
| [tutorial-observer-interface](../sections/frb--readme--tutorial-observer-interface.md) | reactive-bindings | current |
| [tutorial-bindings-interface](../sections/frb--readme--tutorial-bindings-interface.md) | reactive-bindings | current |
| [tutorial-converters-computed-and-traces](../sections/frb--readme--tutorial-converters-computed-and-traces.md) | reactive-bindings | current |
| [reference-programmatic-api](../sections/frb--readme--reference-programmatic-api.md) | reactive-bindings | current |
| [reference-grammar](../sections/frb--readme--reference-grammar.md) | reactive-bindings | current |
| [reference-semantics](../sections/frb--readme--reference-semantics.md) | reactive-bindings | current |
| [reference-syntax-tree-and-language-interface](../sections/frb--readme--reference-syntax-tree-and-language-interface.md) | reactive-bindings | current |
| [reference-observers-and-binders](../sections/frb--readme--reference-observers-and-binders.md) | reactive-bindings | current |

## Provenance

- Repository default branch `master`; README last modified 2013-09-15 by Kris Kowal. Repo HEAD equals the README commit (`131db347`); idempotency re-checked 2026-06-24 (file-specific commit unchanged from the first cycle).
- Three ingest cycles, all 2026-06-24. Cycle 1 (begin-ingest, job `scholar-ingest-new-forks`) filed the four conceptual sections. Cycle 2 (job `scholar-ingest-frb`) filed the eight operator-tutorial sections and added the `frb-incremental-update` and `frb-compiled-observer-tree` concepts. Cycle 3 (job `scholar-ingest-frb-2`) filed the four declarative/observer-machinery sections (parameters-and-components; observer-interface; bindings-interface; converters-computed-and-traces) and the five Reference sections (programmatic-api; grammar; semantics; syntax-tree-and-language-interface; observers-and-binders), and enriched `frb-compiled-observer-tree`.
- The README's Reference section restates the six design adjectives (lines 1768-1806) and the four-layer architecture (lines 1808-1828) it shares with the tutorial. Those two reference restatements were **not** re-ingested as separate sections; they duplicate `frb--readme--properties` and `frb--readme--architecture`. The genuinely-new Reference material (the per-module API, the grammar, the semantics, the syntax tree, the observers/binders catalog) is what cycle 3 filed.
- Deferred to the follow-on `scholar-ingest-frb-3` job: the grammar/compiler **source** files (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`), ingested per the longform-comment / source-file conventions, with `frb-compiled-observer-tree` as the natural concept home. The README's prose Grammar/Semantics/Syntax-Tree sections (now ingested) double as the readable spec of those source files.
- The flat `sections/README.md` index is produced by an external indexer process and was stale for the frb sections at the time of every cycle (it lacked the cycle-1 and cycle-2 frb rows too); cycle 3 did not hand-edit that 8600-line auto-generated file. The `sources/`, `topics/`, `concepts/`, and `keywords.md` indexes are kept current by hand.
- Bot fork: `kriscendobot/frb` (content identical to upstream).

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
