---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/git-store.ts
source_line_range: "1-588"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: the workspace git object store — refless content-addressed storage, plumbing-only GitStore over an fs shim, and a never-throwing three-way file-map merge
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
section_count: 3
status: current
---

`git-store.ts` is Cloudflare OS's per-workspace git object database, held in the Overseer Durable Object as real git loose objects. This digest captures its three design contracts: a refless, content-addressed, GC-free object store using real git formats for future export/import interoperability; a plumbing-only `GitStore` over a virtual filesystem shim that presents commits as flat `path -> text` maps and diffs by oid; and a never-throwing three-way file-map merge that deliberately replaces both Yjs CRDT merging and isomorphic-git's index-bound merge, with lossless line splitting that keeps exotic separators intact. The canonical implementation home of the [[git-backed-gadget-code]] concept whose commit model the `plans/git-storage.md` design first described.

| Section | Topics | Status |
|---------|--------|--------|
| [Refless content-addressed git object store](../sections/cloudflare-os--packages-workshop-backend-src-git-store--refless-content-addressed-object-store.md) | content-addressed-storage, persistence | current |
| [Plumbing-only GitStore and the fs shim](../sections/cloudflare-os--packages-workshop-backend-src-git-store--plumbing-only-gitstore-and-fs-shim.md) | content-addressed-storage, persistence | current |
| [Three-way file-map merge](../sections/cloudflare-os--packages-workshop-backend-src-git-store--three-way-file-map-merge.md) | content-addressed-storage, local-first-sync, change-propagation | current |
