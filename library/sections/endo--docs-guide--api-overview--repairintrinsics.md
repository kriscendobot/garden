---
title: "`repairIntrinsics()`"
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
parent: endo--docs-guide--api-overview
---

Performs the first part of Lockdown: adding, removing, and replacing certain
JavaScript intrinsics so that some intrinsics can be safely shared between
confined programs.
Running `repairIntrinsics()` introduces `hardenIntrinsics()`.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
