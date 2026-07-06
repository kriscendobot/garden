---
source: rust/dialog-storage/README.md
source_repo: dialog-db/dialog-db
source_commit: 4ded84e340bbc56c6bd5f9ebd1db7c534cc9bdda
source_date: 2025-12-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The README for `dialog-storage`, dialog-db's generalized API for constructing content-addressed storage from different backends and encoding schemes. It documents the four pluggable backends with their native/WASM availability — `MemoryStorageBackend`, `FileSystemStorageBackend`, `IndexedDbStorageBackend`, and `S3` (AWS S3 / Cloudflare R2 / MinIO) — the abstraction that lets `Storage::default()` pick a target-appropriate medium and lets blocks move between local and cloud storage unchanged. It also gives the operational R2 configuration: an Object Read & Write API token and a web-client CORS policy that exposes `ETag` and `x-amz-checksum-sha256`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [storage-backends](../sections/dialog-db--rust-dialog-storage-readme--storage-backends.md) | content-addressed-storage, persistence | current |
| [r2-configuration](../sections/dialog-db--rust-dialog-storage-readme--r2-configuration.md) | content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `4ded84e3` (2025-12-12), authored by Irakli Gozalishvili. This is the oldest-dated file in the storage cluster; the crate has been stable since.
- The storage-abstraction crate underneath the whole dialog-db stack; the `S3` backend here is the medium the `rust/dialog-remote-s3` / `rust/dialog-remote-ucan-s3` remotes (ingested the same cycle) push to.
- Ingested in the `scholar-ingest-dialog-db-remainder-12` cycle (2026-07-06).
