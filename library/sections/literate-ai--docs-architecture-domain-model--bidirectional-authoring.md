---
title: Bidirectional source and specification authoring
source: docs/architecture/domain-model.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Reverse engineering existing source produces evidence-linked specification drafts and uncertainty records, not authoritative intent; forward generation consumes separately pinned implementation skills, and explicit review plus clean regeneration is required to transfer authority from source to specification.

The source-to-specification path records observations against exact source and evidence identities. Its outputs include provider-valid draft requirements, a coverage map, an uncertainty ledger that distinguishes observed behavior from inferred intent or suspected defects, a proposed patch, and complete skill/model provenance. Drafts require explicit acceptance and cannot silently promote observed bugs into requirements.

The specification-to-source direction uses separately pinned planning and implementation skills. Their identities affect the generation recipe, but skills cannot add behavioral authority, select the model route, change the workflow, or grant build privileges. Source-derived specifications gain release authority only after policy-defined clean rebuilds exclude the original implementation and pass independent parity checks.

Source: [docs/architecture/domain-model.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/domain-model.md) at commit `2820f85`.
