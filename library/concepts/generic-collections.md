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
| [collections--pkg-generic-collection-readme--overview](../sections/collections--pkg-generic-collection-readme--overview.md) | The base mixin and the primitives-in / derived-methods-out factoring. |
| [collections--pkg-map-readme--overview](../sections/collections--pkg-map-readme--overview.md) | Concrete insertion-ordered map (Set of entries over List + FastSet). |
| [collections--pkg-set-readme--overview](../sections/collections--pkg-set-readme--overview.md) | Concrete insertion-ordered set (List + FastSet). |
| [collections--pkg-list-readme--overview](../sections/collections--pkg-list-readme--overview.md) | Circular doubly-linked list, the order substrate under Set/Map. |
| [collections--pkg-dict-readme--overview](../sections/collections--pkg-dict-readme--overview.md) | String-keyed map over one JS object. |
| [collections--pkg-deque-readme--overview](../sections/collections--pkg-deque-readme--overview.md) | Circular-buffer double-ended queue. |
| [collections--pkg-heap-readme--overview](../sections/collections--pkg-heap-readme--overview.md) | Array-backed binary max-heap. |

## See also

- [[generic-collection-mixin-protocol]] — the four abstract mixins (`generic-collection`/`-set`/`-map`/`-order`) and the primitives-in / derived-methods-out factoring.
- [[generic-order-comparison-protocol]] — the `compare`/`equals` operators structures use for ordering and deduplication.
- [[content-change-listener]] — the synchronous change-notification interface every collection mutator dispatches.
- [[functional-reactive-bindings]] — frb consumes the generic change-notification interface these collections implement.
- [[parallel-arrays-columnar]] — a different data-structure organizing principle (columnar storage) used by cask.
