---
title: Store Wrapper Architecture and Root-Set Keying
source: doc/design/store-gc-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: A garbage-collecting Store that wraps a backing `cask.Store`, tracks retained roots in a **`cask/set`** keyed by a 32-bit projection of each 32-byte block hash, and collects by retaining only blocks reachable from those roots. The components are a **backing store** (diskstore/memstore, which may or may not support listing), a **root set** (a cask/set stored in the backing store, so the set itself has a root hash that must be retained externally), a **store wrapper** (implements `cask.Store`; writes through and optionally indexes stored hashes for sweep; delegates Load without intercepting it), and a **collector** (runs mark from the root set then sweep). Because cask/set uses 32-bit keys but a hash is 256 bits, the design needs a Hash→uint32 mapping: use the low 20 bits (filling the 4-level trie, accepting rare collisions where two distinct hashes map to one set key and are both retained if either is a root), hash the hash to uint32, or store roots in a separate full-Hash structure. The design must account for **blocks with missing links** because large trees are inserted top-to-bottom, so the collector routinely sees blocks whose links point to hashes not yet stored.

## Goal

Elaborate a Store that wraps a backing CASK Store, uses **cask/set** to track retained roots (as 32-bit key hashes derived from block hashes), and collects garbage by retaining only blocks reachable from those roots. The design must account for **blocks with missing links**: large trees are typically inserted top-to-bottom, so the collector will see blocks whose links point to hashes not yet in the store.

## Components

- **Backing store**: A `cask.Store` (e.g. diskstore, memstore) that actually holds blocks. It may or may not support listing all stored hashes (see Sweep).
- **Root set**: A **cask/set** (or equivalent) keyed by a 32-bit projection of the block hash (e.g. low 20 bits of the hash for the existing 4-level trie). The set is stored *in the backing store* (or a separate store), so the root set itself has a root hash that must be retained by some external mechanism (e.g. a fixed "meta" root or a separate pin).
- **Store wrapper**: Implements `cask.Store`; on `Store()` it writes to the backing store and (optionally) maintains an index of stored hashes for sweep. On `Load()` it delegates to the backing store. It does not intercept Load.
- **Collector**: Periodically (or on demand) runs **mark** from the root set, then **sweep**: deletes from the backing store any block whose hash is not in the retained set.

## Root set keying

The existing cask/set uses 32-bit keys. A `cask.Hash` is 32 bytes (256 bits). We need a mapping from Hash to uint32 for use as the set key. Options:

- Use the **low 20 bits** of the hash (so the set's 4-level trie is fully used); collision means two distinct block hashes map to the same set key, so we'd treat them as one root for retention (both retained if either is a root). Acceptable if rare.
- Use a **hash function** from Hash to uint32 (e.g. first 4 bytes of SHA-256 of the hash). Same collision tradeoff.
- Store the root set in a **separate structure** that supports full Hash keys (e.g. a different trie or a list of roots stored as a block). Then the "set" of roots is not cask/set but a structure that can hold 32-byte hashes; the design below still applies.

For simplicity, assume we derive a uint32 from each root hash (e.g. low 20 bits) and store those in cask/set. The **retained set** computed during mark is the full set of `cask.Hash` values reachable from roots; the root set (pins) is the set of root hashes, represented via cask/set with a derived key.

Source: [doc/design/store-gc-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/store-gc-design.md) at commit `cdb975d8`.
