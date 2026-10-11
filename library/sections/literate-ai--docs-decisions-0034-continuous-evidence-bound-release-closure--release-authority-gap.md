---
title: "ADR 0034: Release authority gaps"
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

> Abstract: Release tags, provider artifacts, collateral publication, and contribution decisions could disagree because no executable contract closed all of them as one evidence set.

The 0.9.0 release existed as a tag, release line, GitHub release, notes, and wheel while its required document pair remained locally staged and its stable remote resources still showed 0.8.0. Missing cloud credentials exposed the deeper gap: release policy, plans, gates, receipts, and verification did not model the collateral deliverables at all.

Contribution closure had the same defect. Issues, reviews, unmerged branches, and attached worktrees could remain unevaluated, leaving the next release engineer to reconstruct decisions from conversation.

Source: [docs/decisions/0034-continuous-evidence-bound-release-closure.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0034-continuous-evidence-bound-release-closure.md) at commit `fcc40bc6`.
