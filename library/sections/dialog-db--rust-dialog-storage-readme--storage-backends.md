---
title: Storage backends — one content-addressed API over Memory/FileSystem/IndexedDb/S3
source: rust/dialog-storage/README.md
source_repo: dialog-db/dialog-db
source_commit: 4ded84e340bbc56c6bd5f9ebd1db7c534cc9bdda
source_date: 2025-12-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [content-addressed-storage, persistence]
status: current
---

> Abstract: `dialog-storage` is the generalized API for constructing content-addressed storage from different backends and encoding schemes — the layer that lets the rest of the stack program against one storage interface while the concrete durable medium is chosen per target. Four backends are offered, each rated for native and WASM availability: `MemoryStorageBackend` (testing, caching, temporary storage — native ✓, WASM ✓); `FileSystemStorageBackend` (local persistence for desktop/server apps — native ✓, WASM ✗); `IndexedDbStorageBackend` (browser persistent storage — native ✗, WASM ✓); and `S3` (cloud storage: AWS S3, Cloudflare R2, MinIO — native ✓, WASM ✓). This is what makes `Storage::default()` target-appropriate — filesystem on native, IndexedDB on web — and lets an application move its content-addressed blocks between local and cloud storage without changing how it reads or writes them.

## Storage Backends

Generalized API for constructing content-addressed storage from different backends and encoding schemes.

| Backend | Use Case | Native | WASM |
|---------|----------|:------:|:----:|
| `MemoryStorageBackend` | Testing, caching, temporary storage | ✓ | ✓ |
| `FileSystemStorageBackend` | Local persistence, desktop/server apps | ✓ | ✗ |
| `IndexedDbStorageBackend` | Browser persistent storage | ✗ | ✓ |
| `S3` | Cloud storage (AWS S3, Cloudflare R2, MinIO) | ✓ | ✓ |

The backend is a pluggable choice behind one content-addressed storage interface (see [[content-addressed-storage-backend]]): the same blocks read and write identically whichever medium backs them, and the availability matrix is what lets `Storage::default()` pick filesystem on native and IndexedDB on web. The `S3` backend is also the medium the `dialog-remote-s3` / `dialog-remote-ucan-s3` remotes push to; content-addressing means a block written locally and a block synced to S3 share the same identity.

Source: [rust/dialog-storage/README.md](https://github.com/dialog-db/dialog-db/blob/4ded84e340bbc56c6bd5f9ebd1db7c534cc9bdda/rust/dialog-storage/README.md) at commit `4ded84e3`.
