---
title: Content-bound skills and Flavors
source: docs/architecture/authoring-and-record-formats.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Each skill or Flavor has one Markdown authority whose complete bytes determine identity; typed frontmatter declares structure and dependencies while the body carries rationale or model-facing instruction, and dual legacy/current authorities fail closed.

A skill's frontmatter holds stable ID, version, stages or capabilities, dependency pins, limitations, and trust metadata. Its body is the sole instruction authority. Hashing the complete UTF-8 file means a prose change changes identity and forces dependent references to be repinned.

A Flavor follows the same single-authority rule: strict frontmatter describes its coordinate, axis, target value, constraints, contributions, and conflicts, while prose explains why the choice applies. Resolver-owned digests are derived into locks instead of maintained by people. Coexisting Markdown and legacy JSON authorities are rejected as ambiguous.

Source: [docs/architecture/authoring-and-record-formats.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/authoring-and-record-formats.md) at commit `fcc40bc`.
