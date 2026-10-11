---
title: "ADR 0044: Qualification and sliced rollout"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [testing, agentic-sdlc]
status: current
---

> Abstract: Qualification proves prerequisite-driven overlap, capacity-honoring placement, real remote transports, descendant-only cancellation, cache-case equivalence, and cross-platform fail-closed behavior.

Accepted by maintainers on 2026-09-25, qualification must prove: a dependent action starts as soon as its own prerequisites finish while an unrelated slow action continues; interface-only consumers overlap later provider phases while artifact consumers wait for accepted exports; independent ready actions occupy distinct compatible slots without double-booking or exceeding caps; incompatible, stale, unhealthy, or unreachable workers get no work; command and SSH fixtures perform real actuation, byte handoff, cancellation, recovery, and overlap; failure cancels descendants only and recovery rejects changed routing; cold, warm, partial, corrupted, poisoned, unavailable, read-only, and concurrent local/LAN cache cases yield identical accepted outputs; a second exact build shows measured Bazel and/or sccache hits without weakening toolchain identity; package/container restores verify manifests, payloads, modes, SBOMs, target/ABI, and provider identities; and installed-wheel Linux, macOS, Windows, and hosted CI share configuration and fail-closed behavior.

Rollout slices: scheduler primitive and deterministic fixtures; production worker composition and real transports; local cache adapters; optional LAN endpoint; then package/container reuse and cross-platform release qualification, each keeping uncached execution available and authoritative.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
