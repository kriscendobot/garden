---
title: "ADR 0044: Private cache configuration and read-only Bazel custody"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

> Abstract: Rebuild loads a private `shared-cache.json`, keeps bearer credentials in a per-invocation Bazel RC, and gives read-only builds a bounded disposable cache copy.

Standard rebuild loads `shared-cache.json` from the private directory reported by `litai config paths`, or an absolute `LITAI_SHARED_CACHE_CONFIG`; an absent default leaves caching unconfigured, while explicit missing, unsafe, malformed, duplicate-key, or changed configuration is refused. The cache contract binds the rebuild identity, credentials resolve through `env:NAME`, and bearer tokens live in a temporary private Bazel RC per invocation, excluded from arguments and diagnostics.

Because Bazel's remote read-only flag does not stop disk-cache writes, read-only builds use a disposable copy of local cache entries with remote uploads disabled, excluding expired entries and bounded by configured bytes, 100,000 entries, and 30 seconds; unavailable, changing, or over-budget contents yield an empty view and no writable hard links are used. Planning without an execution workspace disables the disk cache in read-only mode, trading copy cost for correctness.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
