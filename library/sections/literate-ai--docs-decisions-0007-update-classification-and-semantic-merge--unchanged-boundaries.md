---
title: "ADR 0007: Unchanged update boundaries"
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

> Abstract: The ADR preserves mechanical classifications, plan/apply separation, prior collision and retired-authority behavior, and anonymous synthetic fixtures; it only narrows false conflicts and adds an optional resolution path for genuine ones.

- Mechanical `upstream-only` and `already-current` classification and apply remain
  exactly as they are today; this ADR only narrows what counts as a `conflict` (via the
  reference fix) and adds an opt-in resolution path for what remains one.
- No project-specific vocabulary, paths, or release evidence from any downstream
  project (including Physics Workbench sample) enters this repository's fixtures or gate. Test
  fixtures use anonymous initialized projects and a synthetic release where template
  and catalog deliberately differ for the same path, per the originating issue's
  stated non-goal.
- This does not change `litai update`'s plan/apply separation, the catalog-import
  collision handling already fixed in `UPDATE-APPLY-001`, or `_retired_local_authority_paths`'s
  divergence-preserving behavior for retired imports.

Source: [docs/decisions/0007-update-classification-and-semantic-merge.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0007-update-classification-and-semantic-merge.md) at commit `2820f853` (source lines 95–107).
