---
title: GenericMap mixin
source: packages/generic-map/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/generic-map` is the abstract mixin for maps that are *backed by a set*. A map is modeled as a set of `{key, value}` items, each hashed and compared by only its key. The concrete map supplies a `store` property implementing the set interface (`get`, `add`, `delete`, `has`, `clear`, `reduce`, `reduceRight`); from that, the mixin derives `addEach`, `get`, `set`, `add`, `has`, `delete`, `clear`, `iterate`, `reduce`, `reduceRight`, `keys`, `values`, `entries`, and `equals`. Two further protocol points: a map may override `getDefault` to control `get` behavior on absent keys, and every generic map is implicitly observable (it must provide the ObservableMap methods, and all mutators dispatch map-change notifications when observers are present).

The GenericMap is an abstract implementation of many common methods of maps that are backed by a set. The map is a set of `{key, value}` items, each hashed and compared by only the item's key.

The generic map depends on the implementation to provide a `store` property, which must implement the `get`, `add`, `delete`, `has`, `clear`, `reduce`, and `reduceRight` methods expected of any set implementation.

With these methods, the generic map provides implementations of `addEach`, `get`, `set`, `add`, `has`, `delete`, `clear`, `iterate`, `reduce`, `reduceRight`, `keys`, `values`, `entries`, and `equals`.

The `Item` type captures `key` and `value`, and provides `equals` and `compare` methods, suitable for storage in a Set.

Map implementations can override the `getDefault` method, altering the behavior of `get` when keys are absent.

The map implementation must also provide the ObservableMap methods. Any generic map is also observable. All mutation methods incidentally dispatch map change notifications if there are any map observers.

```
npm install @collections/generic-map
```

Source: [packages/generic-map/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/generic-map/README.md) at commit `4688abad`.
