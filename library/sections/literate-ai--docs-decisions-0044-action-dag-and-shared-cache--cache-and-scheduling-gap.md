---
title: "ADR 0044: Layer-barrier scheduling and cache gap"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: Static whole-Component layers, local-only test handlers, and unverified caches fall short of make/Bazel-like scheduling across every compatible private worker.

Release 1.1 overlaps whole-Component work only inside static topological layers and only when a caller supplies an exact worker per Component; production CLI composition supplies no routing, command and SSH overlap tests use local handlers, and each layer must finish before the next starts. Action dependencies are unioned into whole-Component edges, so a consumer action waits on unrelated provider work.

Accepted-source caching, resumable local test checkpoints, Bazel's ordinary local state, and provider package outputs do not establish a trustworthy shared test cache, compiler cache, or package/container custody, so a cache hit cannot count as accepted lifecycle evidence. [Bazel remote caching](https://bazel.build/remote/caching) (disk plus HTTP/HTTPS or gRPC action-cache and CAS namespaces) and [`sccache` WebDAV storage](https://github.com/mozilla/sccache/blob/main/docs/Webdav.md) together show a self-hostable LAN or DNS-named HTTP service suffices without any cloud provider.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
