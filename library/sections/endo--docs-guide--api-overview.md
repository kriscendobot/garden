---
title: API Overview: lockdown, repairIntrinsics, hardenIntrinsics, harden
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: Canonical for the four main API verbs (lockdown, repairIntrinsics, hardenIntrinsics, harden). As of cycle 30 supersedes endo--docs-reference--lockdown-api, endo--docs-reference--repair-intrinsics-api, endo--docs-reference--harden-intrinsics-api, endo--docs-reference--lockdown-and-harden. For exhaustive per-option detail on lockdown() see endo--docs-lockdown--*.
kind: index
section_count: 5
---

> Abstract: Consolidated coverage of the four main API verbs: lockdown() one-time setup, the lower-level repairIntrinsics() + hardenIntrinsics() pair that lockdown() composes, and harden() for per-value transitive freezing. Includes a short section on how lockdown() and harden() relate. Overlaps with docs/reference.md's separate API sections; this version is guide-shaped with more context.

Sections:

- [`lockdown()`](endo--docs-guide--api-overview--lockdown.md)
- [`repairIntrinsics()`](endo--docs-guide--api-overview--repairintrinsics.md)
- [`hardenIntrinsics()`](endo--docs-guide--api-overview--hardenintrinsics.md)
- [`harden()`](endo--docs-guide--api-overview--harden.md)
- [`lockdown()` and `harden()`](endo--docs-guide--api-overview--lockdown-and-harden.md)

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
