---
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: The root README of `kriskowal/frb` (Functional Reactive Bindings), a large tutorial-plus-reference document (~2600 lines) for a JavaScript library that incrementally maintains consistency between object properties and collection contents through one- and two-way bindings declared in a small query language. This "begin" ingest files the four conceptual sections (overview, design properties, architecture, the bindings API and query language); the long per-operator tutorial (map, filter, sum, sorted, group, flatten, and dozens more, lines ~46-1767) is deferred to a follow-on ingest.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/frb--readme--overview.md) | reactive-bindings | current |
| [properties](../sections/frb--readme--properties.md) | reactive-bindings | current |
| [architecture](../sections/frb--readme--architecture.md) | reactive-bindings | current |
| [bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | reactive-bindings | current |

## Provenance

- Repository default branch `master`; README last modified 2013-09-15 by Kris Kowal. Repo HEAD equals the README commit (`131db347`).
- This is a "begin" ingest of a large document. Deferred to a follow-on `scholar-ingest-frb` job: the per-operator tutorial sections (lines ~46-1767, ~50 H3 subsections covering each query-language operator with worked examples) and the source-file / grammar material (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`).
- Bot fork: `kriscendobot/frb` (content identical to upstream).

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
