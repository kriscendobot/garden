---
title: Member Table CLI, Root Extension, and Server Use
source: doc/design/membertable-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking, capability-security, content-addressed-storage]
status: current
---

> Abstract: How the member table is driven from the CLI, threaded through the CASK root, and consulted by the server. The `cask member add|rm|set-traffic-class|ls` commands operate directly on the tip file (ROOT) and the store (diskstore) under `CASK_PATH`, with no server running; a `node_id` is exactly 32 bytes given as 64 hex characters. The CASK root gains a membership link (`Links[2]`, ZeroHash when empty; the first `cask member add` creates the table and sets the link), accessed via `GetMembershipRoot`/`SetMembershipRoot` following the same load-modify-set-new-root reducer pattern as sessions. On each `ini6` the server parses the node_id, calls `membertable.Has(node_id)` (backed by the store), and responds with `statusNotMember` and no session if absent, otherwise proceeds with existing `ini6` logic. This iteration keeps no in-memory membership cache: every `Has()` hits the store, deferring the privileged-update-channel problem a cache would create.

## CLI Usage

All commands use `CASK_PATH` (or the nearest `.cask`). They read and write the tip file (ROOT) and the store (diskstore) directly. No server need be running.

```
cask member add NODE_ID [--traffic-class TC]
  Add the peer with the given node_id (64 hex chars) to the membership set.
  Optionally set the best traffic class (default 5).
  Updates the membership root and the store tip. Exits 0 on success.

cask member rm NODE_ID
  Remove the peer with the given node_id from the membership set.
  Updates the membership root and the store tip. Exits 0 on success.
  Error if NODE_ID is not in the set.

cask member set-traffic-class NODE_ID TC
  Set the best traffic class for the given member.
  TC is a uint8 (0-128). Lower values grant higher priority.
  Error if NODE_ID is not in the set.

cask member ls
  List all node_ids in the membership set, one per line (64 hex chars),
  followed by the best traffic class.
  Exits 0. If the set is empty, prints nothing.
```

**NODE_ID** must be exactly 32 bytes, given as 64 hexadecimal characters.

## Root Block Extension

The CASK root gains a third link:

```
CASKHEAD0
 │
 ├─► Links[0] : schema_hash
 ├─► Links[1] : sessions_hash
 ├─► Links[2] : membership_hash   (ZeroHash = no membership / empty set)
 └─► Links[3] : nursery_hash      (ZeroHash = no nursery / empty)
```

- **GetMembershipRoot** / **SetMembershipRoot**: Same pattern as sessions. Caller (CLI or server) loads root, gets membership hash, performs member table ops, then sets the new membership hash and writes a new root.
- **New root**: When creating a new caskhead, membership can start as ZeroHash. The first `cask member add` will create the member table structure and set the root's membership link.

## Server Use

The server loads the root, then `GetMembershipRoot`. On each `ini6` it will:

1. Parse `node_id` from the packet.
2. Call `membertable.Has(node_id)` (backed by the store).
3. If false, respond with `statusNotMember` and do not create a session.
4. If true, proceed with existing `ini6` logic.

No in-memory cache of membership in this iteration: every `Has()` hits the store. A future cache would require a strategy for applying privileged add/rm (e.g. via a private channel).

Source: [doc/design/membertable-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/membertable-design.md) at commit `cdb975d8`.
