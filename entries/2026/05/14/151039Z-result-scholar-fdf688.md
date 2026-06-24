---
ts: 2026-05-14T15:10:39Z
kind: result
role: scholar
project: agoric-sdk
---

# Thirty-eighth scholar cycle — agoric-sdk governance + endo-but-for-bots designs catalog

## Cycle work — governance ingest

Single source: `packages/governance/README.md` (374 lines, file-commit `92fa9a26`, authored by Turadg Aleahmad 2023-04-20). 6 sections following the H2 structure with strategic H3 consolidation under ContractGovernor (which had 4 H3 sub-topics — ParamManager, Governing Electorates, Governing APIs, Governed Contracts — consolidated into one section because they form a coherent capability-discipline narrative).

| Section | Lines | Topics |
|---------|-------|--------|
| overview | ~65 | capability-security, exo |
| electorate | ~10 | capability-security |
| contract-governor | ~180 | capability-security, exo, patterns |
| scenarios | ~40 | capability-security |
| future-extensions | ~40 | capability-security |
| reading-data-off-chain | ~30 | tooling |

**6 new sections** + 1 source-index. Library now at 363 sections from 81 sources.

### Cross-references baked in

- The `published.committees.Economic_Committee.*` keys ↔ `agoric-sdk--pkg-inter-protocol-readme--reading-data-off-chain`.
- The "powerful private facet pattern" (governor holds change-power; contract holds read-only) is the canonical capability-discipline answer to "voters need to verify without holding the power".
- The Invitation-parameter exception (only the amount appears in `terms`; the actual invitation passes via `privateArg`) is the load-bearing subtlety for legible governance.
- ParamManager `makeParamManager(zoe)` vs `makeParamManagerSync()` ↔ `agoric-sdk--pkg-vat-data-readme--tips-synchronous-makers` (same synchronous-makers discipline).

## Cycle work — endo-but-for-bots/llm/designs queue

Per the maintainer (2026-05-14 13:50Z), queued the `designs/` directory of the `llm` branch of `endojs/endo-but-for-bots` (117 design docs) as a library source area. Filed:

- **1 meta-priming message** (`catalog-area`) naming the whole directory as candidate material, with the per-cycle triage rule "design docs that bridge to existing library material take priority."
- **11 individually-primed source files**:
  - designs/README.md (frame)
  - designs/CLAUDE.md (agent-conventions)
  - designs/syrups.md (foundational codec)
  - designs/cbors.md (codec)
  - designs/retention-path-notation.md (captp GC retention paths)
  - designs/ocapn-network-transport-separation.md
  - designs/ocapn-noise-network.md
  - designs/trust-on-first-bind.md
  - designs/pass-style-promise.md
  - designs/scheduled-send-reactor.md
  - designs/hardened-url-shim.md

The remaining ~106 design files (chat UI, weblet, electron-shell, etc.) can be triaged in future cycles by strategic relevance — many are UI-design-doc-shaped and may not connect cleanly to the library's current technical-spec orientation.

### A new frontmatter field: `source_branch`

Every endo-but-for-bots priming message carries `source_branch: llm` — a new frontmatter field. The garden's other monitored repos (endojs/endo, agoric-sdk, kriscendobot/ocapn) all live on `main`/`master`; endo-but-for-bots' design corpus is on a non-default branch. The scholar's ingestion procedure should be updated to pass `<branch>` to the `git --git-dir=... log -1 --format=%H <branch> -- <path>` idempotency check rather than defaulting to HEAD. Conventions.md should be updated to document this when the first endo-but-for-bots ingest lands.

## Index work

- `sources/README.md`: +1 row for governance.
- `sections/README.md`: +1 subsection (cycle 38), total 357 → 363.
- `topics/README.md`: capability-security 69→74, exo 36→38, patterns 20→21, tooling 53→54.
- Topic pages refreshed via cycle-33 generator scripts for the 4 affected topics. Post-refresh drift = 0.

## Library state

- **363 sections** from **81 source documents** across **3 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources (was 24; +1 this cycle)
- Topic-page drift: 0.
- Pending queue: 12 priming tasks for endo-but-for-bots/llm/designs (11 specific + 1 meta-catalog).

## Inbox state

12 fresh priming tasks queued. Active mode (~1200s) for cycle 39.

## Self-improvement

- Governance fits cleanly into one cycle as a single-source ingest, similar to OCapN Implementation Guide (cycle 32). The 4-H3-consolidation-into-1-section under ContractGovernor is the right call given the coherent narrative.
- Introducing a new upstream repo (endo-but-for-bots) introduces the `source_branch` need. Documenting in conventions.md should land alongside the first actual ingest of an endo-but-for-bots design doc, not pre-emptively.
- The meta-catalog message pattern (one entry naming a whole directory as candidate material, plus individual priming for the strategic subset) is a useful shape when surveying a large new area. Worth adding to conventions.md as a recognized procedure.
