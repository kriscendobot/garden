---
title: Member Table Structure and Operations
source: doc/design/membertable-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking, capability-security, content-addressed-storage, data-structures]
status: current
---

> Abstract: The member table is the persistent structure under the CASK root that answers one question quickly: is this 32-byte peer identity (`node_id`) in the set? Only peers in the set may establish a session (`ini6`). It follows the same parallel-array pattern as the session table (minus expiry and data columns): a swap-to-end allocator root (`Links[0]`) for stable indexes, a `keys` array of 32-byte node_ids (`Links[1]`), a `byKey` hashtreetouint64 mapping `hash(node_id) → logical index` (`Links[2]`), and a `trafficClasses` uint8array of the best traffic class per member (`Links[3]`), with the byKey index width in `Bytes[0]`. Operations are `Has` (O(1) byKey lookup verified against `keys[index]`), `Add`/`AddWithTrafficClass` (alloc slot, set keys, default traffic class 5, byKey.Set), `Remove` (Free with swap-to-end, fix the moved key's byKey entry), `GetTrafficClass`/`SetTrafficClass`, and `ForEach`. Lookups verify `keys[index] == node_id` to handle hash collisions; the default traffic class 5 makes acknowledgements (class minus 5) land at class 0, and legacy roots without the column read as the default.

## Purpose

The member table lives under the CASK root block. It answers one question quickly: **is this 32-byte peer identity (`node_id`) in the set?** Only peers in the set are allowed to establish a session (`ini6`).

The set is primed from the command line; the server consults the store (e.g. diskstore) for every membership query. If the server later adds an in-memory cache, privileged updates may need a separate channel (e.g. Unix domain socket) so that `cask member add/rm` are applied consistently; that is out of scope for this iteration.

## Structure

Same pattern as the session table (without expiry or data columns):

```
MEMBER_TABLE_ROOT
 │
 ├─► Links[0] : allocator root   (swap-to-end index allocator)
 ├─► Links[1] : keys             (array of 32-byte node_ids)
 ├─► Links[2] : byKey            (hashtreetouint64: hash(node_id) → logical index)
 └─► Links[3] : trafficClasses   (uint8array: best traffic class per member)
 Bytes[0]     : byKey index width (1, 2, 4, or 8)
```

- **allocator**: Stable indexes; swap-to-end on remove so we can remove without scanning.
- **keys**: One 32-byte node_id per allocated slot. `keys[i]` is the node_id at logical index `i`.
- **byKey**: Lookup by node_id. Key for the trie is uint32 derived from node_id (e.g. first 4 bytes, little-endian, as in session table). Value is the logical index. On lookup we also verify `keys[index] == node_id` to handle hash collisions.
- **trafficClasses**: One uint8 per allocated slot. `trafficClasses[i]` is the best (lowest) traffic class that member `i` may claim. Incoming datagrams with a lower (higher-priority) class are clamped to this value. The default is 5, so that acknowledgements (class minus 5) land at class 0. Legacy roots without this column are treated as if every member has the default.

## Operations

| Operation | Description |
|-----------|-------------|
| **Has(node_id)** | O(1) index lookup via byKey; verify `keys[index] == node_id`. |
| **Add(node_id)** | Alloc slot, set `keys[slot]=node_id`, `trafficClasses[slot]=5`, `byKey.Set(hash(node_id), slot)`. Error if already present. |
| **AddWithTrafficClass(node_id, tc)** | Like Add but sets `trafficClasses[slot]=tc`. |
| **Remove(node_id)** | Lookup index, `Free(index)` (swap-to-end), update byKey for the key that moved. |
| **GetTrafficClass(node_id)** | Lookup index, return `trafficClasses[index]`. Returns default (5) for unknown members or legacy roots. |
| **SetTrafficClass(node_id, tc)** | Lookup index, set `trafficClasses[index]=tc`. Error if not in set. |
| **ForEach(fn)** | Iterate allocated indexes, call `fn(node_id)` for each. |

Source: [doc/design/membertable-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/membertable-design.md) at commit `cdb975d8`.
