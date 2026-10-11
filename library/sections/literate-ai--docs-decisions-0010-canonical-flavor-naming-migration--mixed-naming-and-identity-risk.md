---
title: "ADR 0010: Mixed naming and identity risk"
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

> Abstract: Flavor coordinates mixed dash, dot, and bare spellings while aliases, directories, canonical names, and target values diverged; because authority bytes feed locks and receipts, renaming without coordinated re-pinning would corrupt distributed identities.

Canonical coordinates used incompatible forms such as `lang-python`, `package.pip`,
and `google-workspace`. One Flavor could accept five spellings, several axes lacked
flat aliases, and directory names differed from both canonical names and target values.
Catalog-derived selector tables removed Python registration edits but preserved the
mixed coordinate scheme in each `flavor.md`.

Flavor authority bytes contribute to revision identities stored in Component locks,
sample harness manifests, and receipts. A textual rename without updating all bound
consumers would invalidate the graph rather than merely clean up names.

Source: [docs/decisions/0010-canonical-flavor-naming-migration.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0010-canonical-flavor-naming-migration.md) at commit `fcc40bc6` (source lines 1-28).
