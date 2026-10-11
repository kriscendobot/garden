---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-10-11T17:24:11Z
job: scholar-ingest-literate-ai-remainder-8-20261010
claim: 0cbffe0c583f1ea4
---
# Literate AI ingest: ADRs 0003–0006

Ingested four `jordanhubbard/literate-ai` decision records at file commit `fcc40bc617a2bc2455627db7396a1e016ebfbab6`:

- `docs/decisions/0003-constraint-classification.md`: 4 sections; Jev `proceed` (`jev-1.13.0`, injection 0.10 clean, slant neutral 0.83; usage 2,378 input / 71 output tokens).
- `docs/decisions/0004-executable-port-boundaries.md`: 3 sections; Jev `proceed_with_caveat` (injection 0.05 clean, neutral slant at low confidence 0.31; usage 1,465 / 71 tokens). The source provenance carries the classifier uncertainty.
- `docs/decisions/0005-executable-component-semantics.md`: 8 sections; Jev `proceed` (injection 0.07 clean, slant neutral 0.75; usage 2,825 / 71 tokens).
- `docs/decisions/0006-significant-feature-request-governance.md`: 3 sections; Jev `proceed_with_caveat` (injection 0.24 clean, advocacy 0.40; usage 2,056 / 73 tokens). The source provenance explicitly attributes the maintainer process position.

Touched topic pages: `agentic-sdlc` (18 rows), `software-supply-chain` (5 rows), and `repository-governance` (3 rows). Updated `sources/README.md` with four source routes. No concept pages or keywords changed.

Fresh idempotency survey compared all 29 pre-existing `literate-ai--*` source pages with GitHub's per-file `main` commit API: 29 matches, 0 mismatches. The six Jev-halted architecture sources remain blocked; no maintainer disposition was present in the current or remainder-3 through remainder-7 inboxes, so none was fetched, read, or ingested.

Validation passed: `library-link-check.sh --changed` and final per-source `--source-slug` checks resolved every committed target; declared source counts equal on-disk and regenerated-index counts (4 + 3 + 8 + 3 = 18); `regenerate-sections-index.sh` landed the current `sections/README.md`; `regenerate-topics-counts.sh` landed and then reported the topic-count projection current and idempotent.

Posted follow-on `scholar-ingest-literate-ai-remainder-9-20261010`, beginning at `docs/decisions/0007-update-classification-and-semantic-merge.md` and preserving the classifier, blocked-source, idempotency, ordering, pacing, and validation constraints. Eligible backlog remains through ADR 0049.

Self-improvement: nothing this time.
