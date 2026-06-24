---
title: Collections package catalog
source: README.md
source_repo: kriskowal/collections
source_commit: 63ac271fdff6c329a00fd33902907f1af686e948
source_date: 2017-10-15
source_authors: [Kris Kowal, Stuart Knightley]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: The catalog of separately-published `@collections/*` packages, grouped as the README groups them: concrete collections, abstract (mixin) collections, generic operators, and helpers. This is the index of structures available; each package has its own README with the per-structure API. Consolidated into one section per the conventions' rule for non-thematic reference lists (the package list changes at upstream's cadence; the catalog captures the taxonomy, not a per-package transcription).

The repository publishes the following packages, grouped by kind. Package directories sit at the repository root (e.g. `deque/`, `dict/`); the npm scope is `@collections/<name>`.

**Concrete collections** — `deque`, `dict`, `fast-map`, `fast-set`, `heap`, `iterator`, `lfu-map`, `lfu-set`, `list`, `lru-map`, `lru-set`, `map`, `mini-map`, `multi-map`, `set`, `sorted-array`, `sorted-array-map`, `sorted-array-set`, `sorted-map`, `sorted-set`. These are the user-facing data structures: doubly-linked lists, deques, hash maps and sets (with `fast`, `mini`, `lru`, and `lfu` eviction variants), binary heaps, and sorted (array- or tree-backed) maps and sets.

**Abstract collections** — `generic-collection`, `generic-map`, `generic-order`, `generic-set`. Mixin packages that supply the shared method implementations (the idiomatic interface) every concrete structure composes. A new collection becomes idiomatic by mixing in the relevant generic package and implementing only its primitive operations.

**Operators** — `clear`, `clone`, `compare`, `equals`, `has`, `hash`, `iterate`, `observable`, `swap`, `to-array`, `zip`. Standalone generic functions over collections and values: structural `equals` / `compare` / `clone`, content-`hash`, the `observable` change-notification mixin, and iteration helpers.

**Helpers** — `copy`, `jasminum`, `operators`, `permute`, `specs`, `tree-log`. Internal utilities, the shared test specifications (`specs`), and the test runner (`jasminum`) used across the packages.

Each package directory carries its own README documenting the structure's full idiomatic API; ingesting those per-package READMEs is deferred to a follow-on `scholar-ingest-collections` job (see this cycle's `result`).

Source: [README.md](https://github.com/kriskowal/collections/blob/63ac271fdff6c329a00fd33902907f1af686e948/README.md) at commit `63ac271f`.
