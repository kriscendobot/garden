---
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
section_count: 2
status: current
notes: 352-line reference doc, 25 alphabetical env-var entries. Aggressively consolidated to 2 sections (overview + all-vars) because the entries are short alphabetical references, not coherent partitions. H2 anchors preserved inline in the all-vars body for grep-based lookup. Two specific vars are cross-referenced from existing library sections: TRACK_TURNS (endo--docs-errors--overview) and LOCKDOWN_* (endo--docs-lockdown--overview). A future maintainer pass could split into logical groups (networking, debugging, observability, ag-solo, build-tuning) if specific groups become high-traffic lookups; for now, the alphabetical-with-anchors form is sufficient.
---

> Abstract: The complete catalog of agoric-sdk environment variables. 2 sections: overview (the doc's Template section establishing the per-var documentation pattern) and all-vars (the 25-entry alphabetical reference, with H2 anchors preserved inline). TRACK_TURNS and LOCKDOWN_* are notable cross-references to existing endo material.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--docs-env--overview.md) | tooling, repository-governance | current |
| [all-vars](../sections/agoric-sdk--docs-env--all-vars.md) | tooling, repository-governance, errors | current |

## Cross-references

- TRACK_TURNS in this doc is referenced from `endo--docs-errors--overview` (the SES error-handling doc names this var as the trigger for deep asynchronous stacks via `@endo/eventual-send`).
- LOCKDOWN_* family in this doc is referenced from `endo--docs-lockdown--overview` (the SES lockdown options doc names the env-var fallthrough pattern).

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md).
