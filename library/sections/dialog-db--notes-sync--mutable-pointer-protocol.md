---
title: Mutable Pointer (query and compare-and-swap update)
source: notes/sync.md
source_repo: dialog-db/dialog-db
source_commit: bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1
source_date: 2025-10-20
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync]
status: current
---

> Abstract: The Mutable Pointer is the single authoritative reference to a tree's root hash (like a Git remote ref), storing only the root and enforcing access/consistency constraints. **Query** is a `HEAD` request carrying a signature-based `Authorization` over a `{iss, aud, sub, cmd:/state/query}` payload; the signer must match the queried `did:key`, and the response returns the current root as an `ETag`. **Update** follows compare-and-swap: a `PUT` with an `If-Match` of the base root and a `/state/assert` payload; the server returns `412 Precondition Failed` (with the current `ETag`) if another writer already advanced the pointer. UCANs may replace the direct-signature scheme in future versions.

A **Mutable Pointer** represents the shared state of the tree and serves as a single authoritative reference — conceptually similar to a Git remote reference. It stores only the root hash and enforces access and consistency constraints.

### Query Mutable Pointer

A `HEAD` request queries the latest known root. Requests MUST include a valid `Authorization` header, `Basic ${principal.sign(blake3(payload))}`, over a payload:

```javascript
{ "iss": tree.did(), "aud": tree.did(), "sub": tree.did(), "cmd": "/state/query", "args": {} }
```

The signer MUST match `payload.iss`, `payload.sub`, and the `did:key` being queried; an invalid authorization returns `401 Unauthorized`. If authorized, the response MUST include an `ETag` header with the current tree root. (Future versions may replace the signature scheme with [UCAN]s or other decentralized auth, and may add `GET` to read the latest published payload.)

### Update Mutable Pointer

Updating follows [Compare-and-Swap](https://en.wikipedia.org/wiki/Compare-and-swap) semantics: the remote root moves `A → B`, where `A` is the tree root the local changes are based on and `B` is the new local root. Requests MUST carry a valid `Authorization` over a `/state/assert` payload with `args.revision = tree.revision()`.

**Invariant check:** the implementation MUST return `412 Precondition Failed` if the `If-Match` header does not match the pointer's current root (another writer already updated it); the `412` response carries an `ETag` of the current root and an error body naming `expected`/`actual`. A successful `PUT` returns `200 OK` with the new `ETag`.

Source: [notes/sync.md](https://github.com/dialog-db/dialog-db/blob/bf88f2c3313f54e3bd2d89f394f2c4aaf1f1d6c1/notes/sync.md) at commit `bf88f2c3`.
