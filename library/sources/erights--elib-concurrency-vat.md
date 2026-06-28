---
source_kind: web
source_url: http://erights.org/elib/concurrency/vat.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/vat.html
source_fetched_via: mirror
source_content_sha256: 841a8ccc68f9af47f58cbf8fea0ce094f9c8d5870bfa0e969bceb64cd992334f
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The Vat — child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). One consolidated section: the canonical
  definition of the vat (heap + single thread + pending-delivery queue, run one
  turn to completion), the ancestor of Agoric's vat and the `@endo/eventual-send`
  run-to-completion discipline. source_date is an era approximation matching the
  sibling concurrency chapters.
---

**The Vat** chapter under ELib — the canonical definition of E's unit of separate
computation. A vat bundles a single thread with an address space of synchronously
accessible objects; it is hosted on one machine at a time, hosts many objects, and
each object lives in exactly one vat. Its thread is a non-blocking event loop
servicing a queue of pending deliveries, running each delivery to completion as one
**turn**. Intra-vat is sequential call-return (Local-E); inter-vat is only
asynchronous non-blocking message sending. The direct ancestor of Agoric's vat and
of Endo's agent / event-loop domain.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [the-vat-heap-thread-queue](../sections/erights--elib-concurrency-vat--the-vat-heap-thread-queue.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/vat.html`.
- Content SHA-256 `841a8ccc68f9af47f58cbf8fea0ce094f9c8d5870bfa0e969bceb64cd992334f`, 12112 bytes.
