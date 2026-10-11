---
title: "ADR 0007: Resolved parent-catalog comparison"
source: docs/decisions/0007-update-classification-and-semantic-merge.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Update classification compares catalog-imported files with their identity in the resolved parent catalog at the target revision, treating byte equality there as already current while leaving the separate template-scaffold baseline path unchanged.

For any file whose provenance is a catalog import (tracked in `CatalogImportsFile`,
not template-scaffolded), `litai update`'s classifier compares local bytes against that
file's identity in the **resolved parent catalog at the update's target revision**, not
against the installed wheel's `project_template` snapshot. A file whose local bytes
already equal the parent-catalog bytes at the target revision is `already-current` (or
an equivalent non-destructive class), never `conflict`. Template-scaffolded files
(no catalog-import provenance) keep today's baseline-identity comparison unchanged —
this ADR does not touch that path, since it is not the one the defect report
identified.

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 52–64).
