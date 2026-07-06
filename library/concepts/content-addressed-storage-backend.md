---
id: content-addressed-storage-backend
aliases: [storage backend, pluggable storage backend, dialog-storage, Storage::default, MemoryStorageBackend, FileSystemStorageBackend, IndexedDbStorageBackend, S3 backend, content-addressed storage API, encoding scheme, R2 backend, native vs WASM storage]
topics: [content-addressed-storage, persistence]
---

# content-addressed-storage-backend

Dialog-db's abstraction (the `dialog-storage` crate) that presents **one content-addressed storage interface over several interchangeable backends and encoding schemes**, so the rest of the stack reads and writes blocks identically regardless of the durable medium underneath. Four backends ship, each rated for native and WASM availability: `MemoryStorageBackend` (testing/caching/temporary — native + WASM), `FileSystemStorageBackend` (local desktop/server persistence — native only), `IndexedDbStorageBackend` (browser persistent storage — WASM only), and `S3` (cloud storage: AWS S3, Cloudflare R2, MinIO — native + WASM). Because storage is content-addressed, a block's identity is its content hash, so a block written to the local filesystem and the same block synced to S3 share one identity and can be freely relocated between media. This availability matrix is exactly what makes `Storage::default()` *target-appropriate* — filesystem on native, IndexedDB on web — without the application choosing a backend explicitly. The `S3` backend is also the medium dialog-db's remotes push to: `dialog-remote-s3` (direct SigV4 credentials) and `dialog-remote-ucan-s3` (UCAN-authorized access service) both move archive blocks and memory cells over it. Running `S3` against Cloudflare R2 needs an Object Read & Write API token and a CORS policy exposing `ETag` and `x-amz-checksum-sha256` so a web client can verify each block's content hash.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--rust-dialog-storage-readme--storage-backends](../sections/dialog-db--rust-dialog-storage-readme--storage-backends.md) | The four pluggable backends (Memory/FileSystem/IndexedDb/S3) and their native/WASM availability matrix behind one storage API. |
| [dialog-db--rust-dialog-storage-readme--r2-configuration](../sections/dialog-db--rust-dialog-storage-readme--r2-configuration.md) | Backing the S3 backend with Cloudflare R2: the Object Read & Write token and the checksum-exposing CORS policy. |
| [dialog-db--rust-dialog-remote-s3-readme--overview](../sections/dialog-db--rust-dialog-remote-s3-readme--overview.md) | The S3 backend as a repository remote — direct SigV4 access pushing archive blocks and memory cells. |

## See also

- [[content-addressed-block-store]] — kriskowal/cask's fixed-1KB-block content-addressed store; the same content-hash-as-identity principle, a different block regime.
- [[value-based-cas]] — how dialog-db surfaces provenance/compare-and-swap over the content it stores.
- [[repository-branch-remote]] — the git-like layer whose remotes push to the `S3` backend defined here.
- [[dialog-db]] — the local-first database this storage layer underpins.
- [[persistence]] — Endo's formula-graph value persistence; a sibling notion of durable identity keyed on formula rather than content hash.
