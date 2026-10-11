---
title: "ADR 0044: Cargo and native C++ compiler-cache composition"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [content-addressed-storage, software-supply-chain]
status: current
---

> Abstract: Each build owns a content-identified sccache server in stable disposable staging; native loader evidence enters cache identity, and cache counters stay advisory.

Cargo caching binds the selected sccache executable's content identity into the private cache binding; each build owns its foreground server, private configuration, bounded startup, statistics, and shutdown, and an unavailable server falls back to the compiler. Ambient sccache settings and compiler wrappers cannot select another process, and retained output is redacted. Because Rust cache keys include working-directory and Cargo-environment paths, exact targets build in stable disposable staging under the runtime object root behind the cross-process cache lock; incremental compilation is disabled, link steps are not claimed cacheable, and read-only sccache disk storage needs a disposable view since the reader updates modification times.

Build observations may carry validated cache-tool identities and advisory counters that never establish acceptance. Cache-tool native dependency observation binds recursive native image, inspector, and loader-resolution evidence into cache identity and the build dependency graph, revalidated at lifecycle entry/exit and around each compiler-cache session; unsupported loader controls and identity drift refuse rather than fall back. Standard native C++ drivers share a stdlib-only helper that compiles each translation unit through the cache tool and links uncached with the locked compiler; it is embedded, compressed, in the exact command authority, loaded as a package resource (working from the runtime ZIP, checkout, or wheel), and only recognized framework drivers get the private wrapper.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
