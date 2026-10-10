---
title: Repository inheritance: bounded fetch policy
source: docs/architecture/repository-inheritance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [tooling]
status: current
---

> Abstract: Each shallow lineage fetch runs under an explicit operational policy (default 300 s total, 180 s without forced-progress bytes, 30 s per SSH connect; CLI overrides bounded to 30–1800, 15–600, and 5–120 s with connect ≤ no-progress ≤ total, validated before Git starts). The policy is content-identified with `framework-default` or `cli` provenance but is availability policy, not authority, so it never changes commit, lineage, or catalog identities; Git gets only per-process configuration, success never depends on a warm cache, and expiry kills the whole process tree.

Each shallow fetch is bounded by an explicit operational policy. The framework default allows 300 seconds total, 180 seconds without bytes from forced Git progress, and 30 seconds for one non-interactive SSH connection attempt. `init`, `update`, and `reparent` accept corresponding `--repository-fetch-total-seconds`, `--repository-fetch-no-progress-seconds`, and `--repository-fetch-connect-seconds` overrides. Fixed framework bounds are respectively 30–1800, 15–600, and 5–120 seconds; connect must not exceed no-progress, and no-progress must not exceed total. Invalid policy fails before Git starts.

The selected policy is content-identified in deterministic command evidence together with `framework-default` or `cli` provenance. It is operational availability policy, not repository authority, so it does not alter exact commit, lineage, or imported-catalog identities. Timeout diagnostics name code, elapsed time, applicable deadline, policy identity, and provenance without retaining the repository locator. Git receives only per-process environment/configuration: no global Git configuration is changed, and successful resolution never depends on a warmed object cache. Total or no-progress expiry terminates the complete process tree and drains its already-bounded output.

Source: [docs/architecture/repository-inheritance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/repository-inheritance.md) at commit `fcc40bc`.
