---
id: cask-caskhead-root
aliases: ["caskhead", "caskhead0", "caskhead root", "CASK root structure", "SchemaV0", "schema hash", "root block", "sessions hash", "membership hash", "nursery hash", "sessiontable", "membertable root", "cask member", "session state blob", "best_traffic_class", "GetSessionsRoot", "SetSessionsRoot", "GetMembershipRoot", "SetMembershipRoot", "schema version detection"]
topics: [content-addressed-storage, networking, capability-security]
status: current
---

# cask-caskhead-root

CASK's **minimal-viable concrete bootstrap root block** (`caskhead0`, caskroot-design.md): the on-disk root structure that bootstraps a server with secure transport, in contrast to ocaps.md's fuller aspirational "ROOT (caskmap)". The root is a fixed-layout block with four links — a **schema hash** (`Links[0]`, a fixed random 32-byte value identifying the format so `Load()` can branch for O(1) version detection and future migration), a **sessions hash** (`Links[1]`, a sessiontable root), a **membership hash** (`Links[2]`, a member-set root, ZeroHash when empty), and a **nursery hash** (`Links[3]`, ZeroHash when empty). v0 carries no bytes, and legacy roots with fewer links remain valid because missing links read as ZeroHash. Everything else (identity, cells, consensus, pinned roots) is deferred to future iterations or handled via cells. The API — `New` / `Load` / `GetSessionsRoot` / `SetSessionsRoot` / `GetMembershipRoot` / `SetMembershipRoot` — threads the immutable-tree reducer idiom through a mutable root: each session or membership mutation produces a new sub-hash that `Set*Root` folds back into a new root hash. The **membership set** is 32-byte node_ids (gating who may establish a session) backed by the membertable package and the `cask member add|rm|ls` CLI. The session-state blob packs send/recv counters, a 32-byte ChaCha20-Poly1305 session key, role, mode, and best-traffic-class. The package lands in `go/cask/head/`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--caskroot-design--scope-and-structure](../sections/cask--caskroot-design--scope-and-structure.md) | The caskhead0 four-link root block, the schema hash, and the session-state blob layout. |
| [cask--caskroot-design--operations-and-usage](../sections/cask--caskroot-design--operations-and-usage.md) | New/Load/Get-Set session and membership roots; the bootstrap-to-expiry usage cycle; the `cask member` CLI. |
| [cask--caskroot-design--versioning-and-implementation](../sections/cask--caskroot-design--versioning-and-implementation.md) | Schema-hash-driven O(1) version detection and migration; the five-step build plan and go/cask/head/ files. |
| [cask--membertable-design--cli-root-and-server-integration](../sections/cask--membertable-design--cli-root-and-server-integration.md) | The Root Block Extension giving the membership link (`Links[2]`, ZeroHash when empty) and `GetMembershipRoot`/`SetMembershipRoot`. |

## See also

- [[cask-cell-facets]] — ocaps.md's fuller "ROOT (caskmap)" with cells/sessions sections; caskhead0 is the minimal shippable subset.
- [[member-table-authorization]] — the membership set (`Links[2]`) is casknet's peer-admission layer.
- [[noise-ik-session-establishment]] — how the cryptographic sessions tracked in `Links[1]` are established.
- [[cask-reducer-pattern]] — the `(state_hash, args) -> new_state_hash` shape every Set*Root call follows.
