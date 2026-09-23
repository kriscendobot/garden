---
title: Refinements — the storage boundary and deliberate non-goals
source: notes/refinements.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, content-addressed-storage]
status: current
---

> Abstract: Where refinements become key ranges. `ArtifactSelector` gains prefix bounds beside its exact fields (`the_starting_with(prefix)` / `of_starting_with(prefix)`, both producing a `Constrained` selector). The scan (`ArtifactTreeExt::scan`) picks the index as before by exact fields, letting a prefix on a leading dimension pick its index when no exact field does; it tightens every branch's `(start, end)` keys with the prefix bounds (bound segment = the prefix's raw bytes then `0x00` lower / `0xFF` upper fill), sound even on a non-leading dimension because the range stays a superset and `matches_selector` filters per entry. Per-segment encoding sets what pushdown is possible: **Attribute** (64 raw padded bytes) gives *exact* prefix ranges; **Entity** (32 raw bytes + 32-byte hash of the URI tail) is tight to 32 bytes with the per-entry check confirming the remainder; **Value** (type tag + blake3 hash) permits *no* range pushdown because the hash destroys order (refinements still travel so dialog-db-57's re-encoding turns them into ranges with only a selector change). Deliberate non-goals: no cost-model change (the planner does not yet prefer prefix-bounded scans), no numeric intervals in `Refinement` yet (no consumer while the value segment is hashed), and no `the!`-macro surface (prefixes arrive via `starts_with` premises).

## The storage boundary

`ArtifactSelector` gains prefix bounds beside its exact fields: `the_starting_with(prefix)` / `of_starting_with(prefix)` (both produce a `Constrained` selector — a prefix is a constraint). The scan (`ArtifactTreeExt::scan`):

- picks the index as before by exact fields (entity / value / attribute), and a prefix on a leading dimension picks its index when no exact field does;
- tightens every branch's `(start, end)` keys with whatever prefix bounds the selector carries: the bound segment is the prefix's raw bytes followed by `0x00` (lower) or `0xFF` (upper) fill. Applying a bound to a non-leading dimension is sound (the range stays a superset; `matches_selector` filters per entry) and tight when every more-significant dimension is exact;
- `matches_selector` re-checks prefixes per entry, so range construction can over-approximate freely.

What each segment's encoding permits (the dialog-db-57 analysis):

- **Attribute** (64 bytes, raw, zero-padded): prefix ranges are *exact*. A prefix longer than 64 bytes matches nothing, which the per-entry check yields naturally.
- **Entity** (32 raw bytes + 32-byte hash of the URI tail): ranges are tight up to 32 bytes; a longer prefix ranges over its 32-byte truncation and the per-entry check confirms the remainder against the stored datum's URI (`ENTITY_RAW_HEAD`).
- **Value** (type tag + blake3 hash): *no* range pushdown is possible — the hash destroys order. Value refinements still travel (inference, `admits` filtering, demand-cover input) so dialog-db-57's re-encoding turns them into ranges with only a selector-conversion change.

## What this deliberately does not do

- No cost-model change: the planner does not yet prefer prefix-bounded scans. Range bounds only shrink what the chosen scan reads.
- No numeric intervals in `Refinement` yet: with the value segment hashed there is no consumer, and the comparison predicates' sides are not scheme-linked. Both land together with dialog-db-57.
- No `the!`-macro-level surface: prefixes arrive via `starts_with` premises on attribute/entity variables, not via new scan syntax.

Source: [notes/refinements.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/refinements.md) at commit `d8c90b90`.
