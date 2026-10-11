---
title: "ADR 0034: Checkpoint and layer ownership"
source: docs/decisions/0034-continuous-evidence-bound-release-closure.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Repair checkpoints are reusable only as the exact still-valid prefix of the current fail-fast plan, while semantic judgment, deterministic observation, and entry-point wiring remain owned by separate layers.

Inserted or reordered gates reset progress unless completed gates form the exact current prefix and retain the same pins. Final evidence always begins at gate one, though durable known-failure annotations survive resets.

Skills own judgment and operator communication. Python owns Git, tracker, account, resource, hashing, receipt, and phase enforcement. Make exposes only thin named entry points, and shared root and template authority remains byte-identical.

Source: [docs/decisions/0034-continuous-evidence-bound-release-closure.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0034-continuous-evidence-bound-release-closure.md) at commit `fcc40bc6`.
