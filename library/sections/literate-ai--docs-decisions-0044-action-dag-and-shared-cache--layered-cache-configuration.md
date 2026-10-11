---
title: "ADR 0044: Layered provider-neutral cache configuration"
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

> Abstract: Private cache configuration layers a local CAS baseline with an optional HTTP(S)/WebDAV endpoint, with separate Bazel, sccache, test-receipt, and package adapters.

Private cache configuration has a local content-addressed baseline and an optional HTTP(S)/WebDAV endpoint named by operator URL or DNS name, carrying scope (`user`, `team`, `organization`, `company`), namespace, read/write mode, size/retention, TLS requirements, and credential references; it never stores credentials or resolved private hosts in project authority.

Namespaced adapters: Bazel actions use Bazel's disk and remote-cache protocols; non-Bazel compiler actions use `sccache` (no redundant `sccache` layer under Bazel without measured justification); test results use the finalized receipt model only once dependency closure, toolchain, environment, action, and oracle identities are complete; packages and containers store immutable bytes plus verifiable manifests keyed by product closure, provider/tool identity, target/ABI, SBOM, and packaging configuration. Local-only use stays fully supported, no cloud account or server product is required, and WebDAV is the portable shared baseline; gRPC, Redis, or memcached are optional explicit backends.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
