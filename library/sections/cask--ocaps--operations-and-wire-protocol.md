---
title: Capability Operations and Wire Protocol
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage, networking]
status: current
---

Abstract: The operational and on-wire surface of the ocap model. **Operations**: `ALLOC(root_cap) -> (cell_id, read_cap, write_cap, observe_cap)` mints a new cell and its facet capabilities; `DELETE(write_cap, cell_id)` removes a cell so all its facet capabilities become invalid; **capability rotation** is atomic — generate a new capability hash, update the cell's facet mapping, and the old capability is immediately invalid (no migration window, because rotation is a CAS on the cell's caskmap entry — explicitly contrasted with "the previous design"). **Wire protocol**: a `read` packet carries the 32-byte read_cap and returns the current content hash; a `casw` packet carries write_cap plus expected-old and desired-new hashes and returns success/failure plus current hash; an `observe` packet carries observe_cap, a peer address, and a register/deregister action; and a `notify` packet (CASK → observer) carries cell_id, the 8-byte version, and the new content hash.

## Capability operations

**Cell allocation** — `ALLOC(root_cap) -> (cell_id, read_cap, write_cap, observe_cap)`. The root capability holder allocates new cells; the call returns a new cell ID (added to the cells caskmap) and the capability hashes for the cell's facets.

**Cell deletion** — `DELETE(write_cap, cell_id) -> error`. Removes a cell from the cells caskmap; requires the write capability; all facet capabilities become invalid.

**Capability rotation** — generate a new capability hash, update the cell's facet mapping, and the old capability hash immediately becomes invalid. Unlike the previous design there is no migration window: rotation is atomic via CAS on the cell's caskmap entry.

## Wire protocol

```
read packet:
  read_cap (32):  capability hash for read access
                  → response: current content hash

casw packet:
  write_cap (32): capability hash for write access
  old (32):       expected current content hash
  new (32):       desired new content hash
                  → response: success/failure and current hash

observe packet:
  observe_cap (32): capability hash for observe access
  peer_addr:        where to send notifications
  action:           register/deregister

notify packet:     (from CASK to observer)
  cell_id (32):      which cell changed
  version (8):       monotonic version number
  content_hash (32): new content hash
```

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
