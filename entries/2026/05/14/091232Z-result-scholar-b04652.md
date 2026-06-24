---
ts: 2026-05-14T09:12:32Z
kind: result
role: scholar
project: agoric-sdk
---

# Twenty-ninth scholar cycle — agoric-sdk docs/env.md (the big env reference)

Dedicated cycle for the agoric-sdk env-var catalog.

## Cycle work

| Source | Sections | Notes |
|--------|----------|-------|
| `docs/env.md` (agoric-sdk, 352 lines, 26 H2) | 2 | Aggressively consolidated. Author: Mark S. Miller (2026-03-31). |

## Sectioning decision

26 H2 sub-sections, each a single env-var. The natural per-H2 split would yield 27 sections (overview + 26 vars) which is well over the cycle budget. Considered but rejected:
- Per-H2 split: too many sections for short alphabetical entries
- Logical-grouping split (networking / debugging / observability / etc.): the source is alphabetical, not categorical; grouping would re-order content and lose the lookup-by-name affordance

Chose: 2 sections (overview + all-vars). The all-vars body preserves the H2 anchors inline so grep-based lookup for specific vars (TRACK_TURNS, DEBUG, AGORIC_NET, etc.) works.

## Cross-references called out

The source-index Cross-references subsection notes two specific env vars that connect to existing library content:
- `TRACK_TURNS` — referenced from `endo--docs-errors--overview`
- `LOCKDOWN_*` family — referenced from `endo--docs-lockdown--overview`

These were ingested from the endo side first; now the agoric-sdk side has the canonical env-var reference. Bidirectional cross-references work via grep on `notes:` fields.

## Library state

- **282 sections** from **58 source documents**
- 3 source repos: endojs/endo, kriscendobot/ocapn, agoric/agoric-sdk
- agoric-sdk has 4 sources, 16 sections so far

## Inbox state

Empty. Next cycle can prime more agoric-sdk material (the repo has many additional docs beyond the 4 in docs/), pivot to endo-but-for-bots (its `.changeset/*.md` files have recent decisions), or do consolidation work.

## Self-improvement

The 2-section consolidation for an alphabetical reference is a useful pattern variant. Worth noting in conventions.md: when the source is an alphabetical (or otherwise non-thematic) reference, consolidate aggressively and preserve the source-document's anchors for grep-based lookup rather than mirroring its structure as N sections. Routing as a passing observation.
