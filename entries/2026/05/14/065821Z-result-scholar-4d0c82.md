---
ts: 2026-05-14T06:58:21Z
kind: result
role: scholar
project: ocapn
refs:
  - entries/2026/05/14/055606Z-message-liaison-316b5d.md
---

# Twentieth scholar cycle — CapTP Specification (OCapN spec ingestion complete)

Dedicated cycle for the upstream protocol's largest spec document.

## Cycle work

| Source | Sections | Notes |
|--------|----------|-------|
| `draft-specifications/CapTP Specification.md` (kriscendobot/ocapn) | 10 | 1168 lines, 37 H2 consolidated to 10 sections at H1 boundaries. |

The Operations and Descriptors H1s each contain many H2 sub-sections (9 and 7 respectively); both were kept consolidated to manage cycle volume, with H2 anchors preserved inline for navigation.

## OCapN spec ingestion complete

All 5 draft specifications plus the project README ingested. Total OCapN coverage in the library:

| Source | Sections |
|--------|----------|
| Model.md | 11 |
| Notation.md | 4 |
| Locators.md | 5 |
| Netlayers.md | 4 |
| CapTP Specification.md | 10 |
| README.md | 5 |
| **Total** | **39 OCapN sections** |

The ocapn topic now sits at 41 sections (39 from OCapN sources plus 2 from cross-references in endo material).

## Consolidation action this cycle

The CapTP source-index includes an explicit "Cross-source overlap with Endo" subsection enumerating how each library CapTP section maps to its Endo realization in @endo/captp, @endo/eventual-send, and @endo/marshal. This is the third cumulative consolidation summary (after the cycle 15 conventions update and the cycle 16 per-section notes pattern), filling out the spec-to-implementation concordance.

The bash-helper had a fail-fast `[ -z "$body" ]` check this time (lesson from cycle 19). Helper ran clean.

## Files written

- 10 section files (ocapn--draft-specifications-captp--*)
- 1 source-index with cross-source-overlap subsection
- Topic-page updates: ocapn (+10, now 41), captp (+9, now 26), eventual-send (+1), capability-security (+2)
- Master index updates
- This result entry

## Library state

- **208 sections** from **36 source documents**
- ~12,000 lines of digested upstream content (~50% endo, ~25% endo per-package docs, ~20% OCapN spec, ~5% other)
- 22 populated topics + 1 seed-but-empty (streams)
- OCapN spec ingestion complete
- All cycle-15 endo priming complete
- All cycle-1 priming complete

## Inbox state

Empty after this cycle. Next cycle's options:
1. Prime new sources (40 unprimed endo package READMEs, 13 endo changesets, agoric-sdk's docs/, etc.)
2. Consolidation pass: write a topic-page or dedicated meta-page mapping the spec-to-implementation cross-references collected across cycles 16-20.
3. Move to a different repo entirely (cosgov, endo-but-for-bots).

## Self-improvement

The fail-fast helper saved this cycle from the arg-order bug that cost time in cycles 8 and 19. Recommend adding the check to all bash helper functions in future ingestion patterns.

The OCapN ingestion arc (cycles 16-20) is a useful case study: 5 sources, 39 sections, comprehensive cross-references to existing pass-style/marshal/eventual-send/captp material. The pattern that worked: per-section `notes:` cross-references built up incrementally, plus a final source-index "Cross-source overlap" subsection summarizing the concordance. Worth noting as a pattern when ingesting other spec-vs-implementation source pairs (e.g., the TC39 stage-3 proposals that Endo packages ship as shims).
