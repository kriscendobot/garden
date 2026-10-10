---
title: Human intent and machine evidence formats
source: docs/architecture/authoring-and-record-formats.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Literate AI uses reviewable Markdown for human or agent-authored intent and canonical JSON for resolved locks, receipts, caches, and evidence, with a one-way rule that derived evidence never becomes intent.

Components, layered specifications, skills, Flavors, and prose-rich workflows are Markdown with strict typed frontmatter. Bootstrap configuration and routing remain JSON when they are small machine-only protocols. Resolution produces canonical JSON locks; execution produces canonical evidence and CycloneDX dependency inventories.

The split is semantic rather than cosmetic. Authored prose must be pleasant to review, while machine records must be cheap to compare and unambiguous. Generated evidence may support a review decision, but it never silently edits or replaces the intent that authorized the run.

Source: [docs/architecture/authoring-and-record-formats.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/authoring-and-record-formats.md) at commit `fcc40bc`.
