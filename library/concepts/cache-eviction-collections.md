---
id: cache-eviction-collections
aliases: ["LRU", "LFU", "LruSet", "LruMap", "LfuSet", "LfuMap", "least recently used", "least frequently used", "eviction", "cache eviction", "bounded collection", "bounded cache", "@collections/lru-set", "@collections/lru-map", "@collections/lfu-set", "@collections/lfu-map"]
topics: [data-structures]
status: draft
---

# cache-eviction-collections

The `kriskowal/collections` family of **bounded** collections that evict an element when full to make room for a new one — the building blocks of an in-memory cache. Two eviction policies, each in a set-shaped and a map-shaped package: **LRU** (least *recently* used) drops the element touched longest ago, in `@collections/lru-set` and `@collections/lru-map`; **LFU** (least *frequently* used) drops the element touched fewest times, in `@collections/lfu-set` and `@collections/lfu-map`. In both families the set is the primitive and the map is composed from it (`LruMap` wraps an `LruSet`, `LfuMap` wraps an `LfuSet`), mirroring how the ordered `Map` is built over `Set` elsewhere in the library. They share the same idiomatic collection surface as every other structure, so a bounded cache is a drop-in for an unbounded set/map at the call site, differing only in that adds past capacity silently evict rather than grow.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--pkg-lru-set-readme--overview](../sections/collections--pkg-lru-set-readme--overview.md) | Bounded set evicting the least recently used value; the recency primitive. |
| [collections--pkg-lru-map-readme--overview](../sections/collections--pkg-lru-map-readme--overview.md) | Bounded map over an LruSet; recency eviction, map-shaped. |
| [collections--pkg-lfu-set-readme--overview](../sections/collections--pkg-lfu-set-readme--overview.md) | Bounded set evicting the least frequently used value; the frequency primitive. |
| [collections--pkg-lfu-map-readme--overview](../sections/collections--pkg-lfu-map-readme--overview.md) | Bounded map over an LfuSet; frequency eviction, map-shaped. |

## See also

- [[generic-collections]] — the library these bounded structures belong to; they share its idiomatic interface.
- [[generic-collection-mixin-protocol]] — the primitives-in / derived-methods-out factoring the set primitive and the map-over-set composition follow.
