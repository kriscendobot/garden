---
title: Refless content-addressed git object store
source: packages/workshop-backend/src/git-store.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/git-store.ts
source_line_range: "1-74"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the workspace git object store — real git formats, no ref layer, no GC, content-addressed dedup
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [content-addressed-storage, persistence]
status: current
---

Abstract: Each Cloudflare OS workspace's Overseer Durable Object holds a real git object database — SHA-1, zlib-deflated loose objects byte-identical to what `git` itself would write — stored in a `gitObjects` typed-storage collection, with each gadget record pointing at its head commit. There is deliberately no ref layer: branches, tags, and HEAD are replaced by the gadget records, blueprint records, and chats' pinned commits the Overseer's own workflow manages. Because the store is content-addressed and refless, unrelated histories coexist freely and related histories (forks, blueprint instantiations) deduplicate at the blob/tree level. Real git formats (not a git-shaped custom encoding) are used so gadget code can later be exported to and imported from real repositories and agents can eventually mount arbitrary repos through gatekeeper-gated push/pull. There is no garbage collector — dangling objects come only from accepted merges, imports, and migration, never in-flight chats — but the GC roots are enumerable if one is ever needed.

## The store

Each workspace's Overseer DO holds a real git object database: SHA-1, zlib-deflated loose objects, byte-identical to what `git` itself would write, stored in the `gitObjects` typed-storage collection. Mainline gadget code is (will be, once the commit-backed code flow lands) represented as commits in this store, with each `GadgetRecord` pointing at its head commit.

## No ref layer

There is deliberately no ref layer — no branches, tags, or HEAD. The "refs" are the gadget records, blueprint records, and chats' pinned commits, all managed by the Overseer's own workflow. Because the store is content-addressed and refless, unrelated histories coexist freely in the same collection, and related histories (gadgets forked from each other, or instantiated from the same blueprint) deduplicate at the blob/tree level.

## Real git formats

Real git formats are used rather than a git-shaped custom encoding, so that gadget code can later be exported to and imported from real git repositories, and so agents can eventually "mount" arbitrary repos through gatekeeper-gated push/pull. `isomorphic-git` provides the object codec; only its plumbing (`writeBlob`/`writeTree`/`writeCommit`/`read*`/`log`) is used, operating against a gitdir containing nothing but `objects/**`. The porcelain is off-limits: `git.commit` requires HEAD/index/config, and `git.merge` cannot represent the wanted merge behavior (see the three-way merge section).

## Storage notes

- **Loose objects only**, one collection record per object keyed by oid. `isomorphic-git` never writes deltified data (it reads deltas only in packfiles fetched from remotes), so each record is a zlib'd whole object. Dedup comes from content addressing, not deltas.
- **No object exceeds ~2 MB today** (records hold single source files, small trees, and commit headers). If large blobs ever appear, chunking records or spilling to R2 is a change local to the fs shim.
- **No GC.** Dangling objects come only from accepted merges, imports, and migration — never in-flight chats — and are cheap. If GC is ever needed, the roots are enumerable: gadget records, blueprint gadget records, live chats' pinned commits, the pin declarations in chat logs and compaction checkpoints (closed epochs are reconstructed from them), and the `observedCommit` stamps on chats' `readFile` tool calls (which nothing else roots — a future GC must either root them or the agent's elision path must tolerate a missing commit by eliding unconditionally).

A `GitObjectRecord` is `{oid, data}`: `data` is the zlib-deflated object exactly as git would store it under `.git/objects/xx/yyyy...`, and `oid` is its 40-hex SHA-1 name. Content-addressed, hence immutable and idempotent to rewrite.

Source: [packages/workshop-backend/src/git-store.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-backend/src/git-store.ts) at commit `1ef6020a`.
