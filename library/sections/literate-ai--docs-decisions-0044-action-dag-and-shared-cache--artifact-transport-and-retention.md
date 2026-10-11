---
title: "ADR 0044: HTTP artifact transport and local retention"
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

> Abstract: Artifacts publish payload-before-manifest via conditional PUT with refused redirects and full verification on read; local stores bound, evict, and collect under strict inventory limits.

The HTTP artifact adapter publishes payloads before manifests using conditional `PUT` (`If-None-Match: *`) and verifies each entry with a bounded `GET`; the operator provisions namespace directories on a server honoring conditional writes. All redirects are refused, private bearer credentials never appear in errors, and every read verifies the full manifest plus payload digest and size. Partial entries are misses, conflicting or corrupt entries typed refusals, and remote unavailability is a miss that keeps local publications. Manifest cache identity accepts a storage projection of scope and namespace, so access mode, credential, endpoint, placement, and retention do not change shared content identity, letting read-only consumers verify writer entries; product authority, provider, target/ABI, SBOM, payload, and mode remain mandatory, and the projection grants no acceptance.

Local publication serializes writers per namespace; quota counts manifest and distinct payload bytes, collecting expired then oldest entries until the incoming one fits, keeping payloads any retained manifest references and removing manifests before their unreferenced objects. Inventory is bounded at 100,000 entries, 16 MiB of manifests, and 30 seconds (with a 1 MiB per-manifest reader limit); malformed, foreign, link-like, hardlinked, or changing entries refuse collection. Readers return a miss for expired or removed entries without rewriting bytes or times; exact republication renews an expired manifest only after verification, and a local quota refusal stays advisory to the layered cache.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
