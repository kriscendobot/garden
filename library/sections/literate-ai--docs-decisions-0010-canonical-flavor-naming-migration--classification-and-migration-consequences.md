---
title: "ADR 0010: Classification and migration consequences"
source: docs/decisions/0010-canonical-flavor-naming-migration.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Fail-closed unambiguous resolution and canonical lock bytes are invariant, while the prefix table is policy; deprecated alias directories are forbidden because two paths would create two authorities for one coordinate, even though bare selectors remain valid.

One identity must resolve to exactly one coordinate and locks contain canonical forms.
The prefix table and separator are project policy. The former claim that every Flavor
had one accepted spelling was deferred until the compatibility window closed.

Adding an axis updates the recorded prefix table and derived-alias logic together. The
migration re-pins all affected samples and receipts in one enumerable change. A
catalog cannot retain an old directory next to its canonical replacement: validation
fails closed and migration removes the alias tree. Dotted selectors now fail closed;
bare values resolve to the canonical directory without recreating legacy authority.

Source: [docs/decisions/0010-canonical-flavor-naming-migration.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0010-canonical-flavor-naming-migration.md) at commit `fcc40bc6` (source lines 76-107).
