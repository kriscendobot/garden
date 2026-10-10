---
title: Workflow catalogs and round-trip invariants
source: docs/architecture/authoring-and-record-formats.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: Workflow Markdown combines a typed stage DAG with per-stage model instructions, supports filesystem-scoped nested catalogs and explicit extension, and must round-trip to one stable byte sequence without unknown fields or duplicate authorities.

Workflow frontmatter owns stage identities, kinds, dependencies, response shapes, capabilities, and output bounds. Model instructions appear only under corresponding stage headings. Missing, duplicated, or unknown stage sections fail before model egress; routing selection remains a separate strict JSON policy.

Catalogs may nest, and a child workflow can explicitly extend another by overlaying existing stages and inserting new stages after declared dependencies. Canonical rendering and parsing must reproduce the same typed value and body. Derived JSON is disposable, but deleting the Markdown destroys authority and cannot be repaired from locks or receipts.

Source: [docs/architecture/authoring-and-record-formats.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/authoring-and-record-formats.md) at commit `fcc40bc`.
