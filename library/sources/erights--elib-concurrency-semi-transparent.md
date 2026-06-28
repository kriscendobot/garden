---
source_kind: web
source_url: http://erights.org/elib/concurrency/semi-transparent.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/semi-transparent.html
source_fetched_via: mirror
source_content_sha256: 262a7e4ca284f3741d2856acb9a4bd9fef07157e44e33409f57a5c3836f3a1a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Semi-Transparency — child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). One consolidated section on why E chooses
  semi-transparent (distributed-semantics-subset-of-local) networking over full
  transparency; the rationale for `E()`-everywhere vs synchronous-only-intra-agent.
  source_date is an era approximation matching the sibling concurrency chapters.
---

The **Semi-Transparency** chapter under ELib — the rationale for E's most
consequential design choice. It explains why E gives up *full* network transparency
(local-and-distributed semantics identical) for the reasons of Waldo's *A Note on
Distributed Computing*, and keeps *semi*-transparency instead: any correct program
written for distributed objects stays correct collapsed into one address space, so
the distributed semantics are a strict subset of the local ones. The direct
ancestor of Endo's rule that synchronous `.` works only intra-agent while `E()`
works everywhere.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [semi-transparent-networking](../sections/erights--elib-concurrency-semi-transparent--semi-transparent-networking.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/semi-transparent.html`.
- Content SHA-256 `262a7e4ca284f3741d2856acb9a4bd9fef07157e44e33409f57a5c3836f3a1a4`, 21688 bytes.
