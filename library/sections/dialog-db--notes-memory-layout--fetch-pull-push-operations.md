---
title: Fetch, pull, and push over the memory cells
source: notes/memory-layout.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: The three sync operations read and write the branch/remote memory cells like Git. **fetch** reads `branch/{name}/upstream` for the remote `{ name, branch }`, loads `remote/{remote}/address` for connection info and subject DID, resolves the remote revision, and writes it to `remote/{remote}/branch/{branch}/revision` — leaving the local branch revision and upstream untouched. **pull** fetches, then three-way merges upstream vs the base (the last-synced `upstream` tree) vs local, updating `branch/{name}/revision` with the merged result and advancing `branch/{name}/upstream` to the upstream revision. **push** reads the local head and the last-synced `upstream` base, computes the novel blocks (base-to-local diff), uploads them to the remote, publishes the local revision, then advances both `branch/{name}/upstream` and `remote/{remote}/branch/{branch}/revision` to the pushed revision. Supporting types: `SiteAddress` (enum `S3(Address) | Ucan(UcanAddress)`, connection info only), `RemoteAddress` (wraps `SiteAddress` with a `subject: Did`), `UpstreamState` (enum `Local { branch, tree } | Remote { name, branch, tree }` — the subject DID lives on `RemoteAddress`, not here), and `Revision` (`{ subject, issuer, authority, tree, cause, period, moment }`, where `tree` is a `NodeReference`, the blake3 hash of the prolly-tree root).

## Operations

### fetch

1. Read `branch/{name}/upstream` to get the remote `{ name, branch }`
2. Load `remote/{remote}/address` to get connection info and subject DID
3. Resolve remote revision using the address + subject
4. Write result to `remote/{remote}/branch/{branch}/revision`
5. Local `branch/{name}/revision` and `branch/{name}/upstream` are unchanged

### pull

1. Fetch (as above)
2. Read `remote/{remote}/branch/{branch}/revision` -- the upstream revision
3. Read `branch/{name}/upstream` tree -- the last sync point
4. Three-way merge: upstream vs base vs local
5. Update `branch/{name}/revision` with merged result
6. Update `branch/{name}/upstream` tree to match upstream revision

### push

1. Read `branch/{name}/revision` -- local head
2. Read `branch/{name}/upstream` tree -- last sync point (base for novelty)
3. Compute novel blocks (diff between base and local)
4. Upload blocks to remote via `remote/{remote}/address`
5. Publish local revision to remote
6. Update `branch/{name}/upstream` tree to match pushed revision
7. Update `remote/{remote}/branch/{branch}/revision` to match

## Type Notes

- `SiteAddress` -- enum: `S3(Address)` | `Ucan(UcanAddress)`. Connection info only.
- `RemoteAddress` -- wraps `SiteAddress` with a `subject: Did` identifying which repository at the site.
- `UpstreamState` -- enum: `Local { branch, tree }` | `Remote { name, branch, tree }`. The `subject` DID lives on the `RemoteAddress`, not on `UpstreamState`.
- `Revision` -- `{ subject, issuer, authority, tree, cause, period, moment }`. The `tree` is a `NodeReference` (blake3 hash of the prolly tree root).

Source: [notes/memory-layout.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/memory-layout.md) at commit `18c640a0`.
