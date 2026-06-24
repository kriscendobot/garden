---
id: generic-collections
aliases: ["collections", "kriskowal/collections", "generic-collection", "idiomatic collection interface", "@collections", "collection interface"]
topics: [data-structures]
status: draft
---

# generic-collections

`kriskowal/collections`: a library of JavaScript data structures (maps, sets, lists, deques, heaps, sorted maps/sets, and LRU/LFU/fast/mini variants) presented behind one **idiomatic interface** — every structure exposes the same shape of API (`add`, `delete`, `has`, `get`, `forEach`, `map`, `filter`, `reduce`, `toArray`, content-change listeners) regardless of its representation, so structures are interchangeable at the call site. The shared behavior is factored into abstract mixin packages (`generic-collection`, `generic-map`, `generic-order`, `generic-set`) that a concrete structure composes, implementing only its primitive operations. The library is published as many separately-versioned `@collections/*` packages and is the data-structure companion to `frb`, which observes any of these collections through their generic change-notification methods.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--readme--overview](../sections/collections--readme--overview.md) | Idiomatic uniform interfaces across all structures; multi-package monorepo; the frb companion. |
| [collections--readme--package-catalog](../sections/collections--readme--package-catalog.md) | The catalog: concrete collections, abstract mixins, operators, helpers. |

## See also

- [[functional-reactive-bindings]] — frb consumes the generic change-notification interface these collections implement.
- [[parallel-arrays-columnar]] — a different data-structure organizing principle (columnar storage) used by cask.
