---
title: "ADR 0044: Cache hits are untrusted inputs"
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

> Abstract: Every restored object is rehashed and revalidated; a hit skips only proven work, and cache availability is an optimization, never a correctness dependency.

Every restored object, test result, package, image, manifest, and receipt is rehashed and revalidated against the current action and complete authority before use. A hit skips only work whose exact output is proven, never indexing, validation, required execution, independent acceptance, or release verification unless the owning contract defines a current reusable receipt for that gate. Corruption, ambiguity, missing content, incompatible toolchains, unsafe transport, changed scope, incomplete keys, or stale evidence become a miss or typed refusal. Shared writers are least-privilege and may be CI-only, read-only consumers stay supported, and cache availability is never a correctness dependency.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
