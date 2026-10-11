---
title: "ADR 0040: Model-free artifact delivery"
source: docs/decisions/0040-retained-cargo-library-bridge.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [software-supply-chain, capability-security]
status: current
---

> Abstract: Offline files and reviewed HTTPS locations may deliver only the exact bounded export bundle; URLs, caches, registries, model regeneration, and redirects cannot broaden authority.

The bundle carries the sealed graph and evidence. Retrieval validates TLS, sizes, paths, collisions, credentials, redirects, and archive shape, executes no member, and implies no publication or account authority.

Source: [docs/decisions/0040-retained-cargo-library-bridge.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0040-retained-cargo-library-bridge.md) at commit fcc40bc6.
