---
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/obtaining.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/obtaining.html
source_fetched_via: mirror
source_content_sha256: 5ffca11a509780bc89cd7f5c1c8bcf0a9ca564ea28497fd1982cefa2cf128a46
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Obtaining-elements child chapter of the EIO sub-hub
  (erights--elib-concurrency-eio-index). One consolidated section: the single
  `obtain/5` primitive and the 2*2*3*2 = 24-cell taxonomy of input operations it
  generates (reading / skipping / peeking / checking, crossed with NOW / WAIT /
  LATER scheduling and the atLeast..atMost bounds), plus the convenience-method
  expansions. The LATER mode returns a promise/vow — the ancestor of `@endo/stream`'s
  async-iterator pull. source_date is an era approximation matching the sibling
  concurrency chapters.
---

**Obtaining Elements from an InStream** child chapter under ELib — how an EIO
consumer reads. InStream has only a few primitives; element-obtaining is the single
`obtain(atLeast, atMost, sched, proceed, report)` (`obtain/5`), of which every other
input method is a convenient repackaging. The five parameters generate a 2\*2\*3\*2
taxonomy of 24 input operations: `proceed` (ADVANCE vs QUERY) crossed with `report`
(ELEMENTS vs STATUS) yields the four families reading / skipping / peeking /
checking; `sched` (NOW vs WAIT vs LATER) is the non-blocking hinge (NOW throws if
not ready, WAIT may block and risk deadlock, LATER returns a vow for the elements);
and `atLeast..atMost` bound how many elements are sufficient. LATER is the ancestor
of `@endo/stream`'s pull-based async-iterator read.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [obtain-primitive-and-input-operation-taxonomy](../sections/erights--elib-concurrency-eio-obtaining--obtain-primitive-and-input-operation-taxonomy.md) | e-language, eventual-send, streams | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/eio/obtaining.html`.
- Content SHA-256 `5ffca11a509780bc89cd7f5c1c8bcf0a9ca564ea28497fd1982cefa2cf128a46`, 26471 bytes.
