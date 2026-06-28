---
source_kind: web
source_url: http://erights.org/elib/concurrency/queuing.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/queuing.html
source_fetched_via: mirror
source_content_sha256: 6eda18a04216a130d8dafaf5befe4fc0db7f95db36b103e65dde02c0087d74ab
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Distributed Queuing — child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). One consolidated section: the L-shaped
  per-vat stack (LIFO green frames) plus queue (FIFO purple pending deliveries),
  `.` pushes a frame / `<-` enqueues a delivery on the receiver's vat, and the
  FIFO picture is an over-specification of E's partial-order spec. Ancestor of the
  JS call-stack-plus-microtask-queue under `@endo/eventual-send`. source_date is an
  era approximation matching the sibling concurrency chapters.
---

**Distributed Queuing** chapter under ELib — the mechanics of communicating event
loops. Each vat holds an L-shaped data structure: a vertical LIFO **stack** of
green call frames and a horizontal FIFO **queue** of purple pending deliveries. An
immediate call `.` (NEAR references only) pushes a green frame on the calling vat's
stack; an eventual send `<-` enqueues a purple block onto the back of the receiver
vat's event queue. The FIFO full-order shown is a deliberate over-specification: E
specifies only partial order on references. The operational ancestor of the
JavaScript call stack plus microtask queue.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [the-stack-queue-L-and-eventual-send](../sections/erights--elib-concurrency-queuing--the-stack-queue-L-and-eventual-send.md) | e-language, eventual-send | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/queuing.html`.
- Content SHA-256 `6eda18a04216a130d8dafaf5befe4fc0db7f95db36b103e65dde02c0087d74ab`, 10151 bytes.
