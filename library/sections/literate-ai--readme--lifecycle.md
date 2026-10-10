---
title: Specification-to-release lifecycle
source: README.md
source_repo: jordanhubbard/literate-ai
source_commit: 76f498a824f74ec94ee7d03500913025579fb15f
source_date: 2026-10-04
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
---

> Abstract: Literate AI resolves a specification, target profile, Flavors, assets, pinned skills, and exact dependency graph into bounded per-Component plans, then separates model-driven source generation from typed build, test, acceptance, packaging, publication, and evidence-producing stages.

The high-level operator path is create or adopt, inspect status, verify, lock and plan, rebuild, and finally plan, prepare, check, and publish a release. When a coding agent participates, exact Component inputs are resolved first and split into bounded plans rather than sent as one flattened prompt.

Generated source and model-produced tests enter a source cache. A worker then performs the typed lifecycle against an immutable locked overlay. Generated tests are implementation checks; independent acceptance is a separate gate. Only an accepted result can produce receipts, artifacts, provenance, and packages. A failed candidate returns to authority revision rather than silently becoming workspace truth.

Source: [README.md](https://github.com/jordanhubbard/literate-ai/blob/76f498a824f74ec94ee7d03500913025579fb15f/README.md) at commit `76f498a`.
