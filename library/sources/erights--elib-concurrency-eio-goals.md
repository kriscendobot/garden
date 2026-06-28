---
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/goals.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/goals.html
source_fetched_via: mirror
source_content_sha256: b8492e10dce45a0bbb4c4c25bd56d85a7d7e80ef11b5cce46cb98f872bd90919
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Design Goals child chapter of the EIO sub-hub (erights--elib-concurrency-eio-index).
  One consolidated section: EIO's requirements and preferences (non-blocking even
  with buggy code; the InStream/OutStream stream model with its terminator and
  producer/consumer roles; fail-stop delivery; composability via pipes, filters,
  opto-isolation, failure/close propagation, bounded-buffer backpressure, flush
  pressure, preserved immediacy). Direct ancestor of `@endo/stream`. source_date is
  an era approximation matching the sibling concurrency chapters.
---

**EIO Design Goals** child chapter under ELib — the requirements-and-preferences
charter for EIO, E's non-blocking I/O library. Because a vat turn cannot block,
blocking reads are impossible, so EIO requests I/O by send and delivers by
notification over the InStream / OutStream stream abstraction. The chapter states
the general requirements (non-blocking even under buggy E code; efficiently
implementable later over NIO; possible now over plain Java 1.3), the stream model
(an ongoing sequence of typed elements with a terminator, flowing producer to
consumer), the stream goals (wraps and tames legacy `java.io`, carries objects,
fail-stop), and the composability goals (pipes, filters, opto-isolation,
failure/close propagation, bounded-buffer backpressure, flush pressure, preserved
immediacy). This is the direct ancestor of `@endo/stream`'s async-iterator
reader/writer streams and Endo's no-blocking-reads discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [design-goals-requirements-and-preferences](../sections/erights--elib-concurrency-eio-goals--design-goals-requirements-and-preferences.md) | e-language, eventual-send, streams | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/eio/goals.html`.
- Content SHA-256 `b8492e10dce45a0bbb4c4c25bd56d85a7d7e80ef11b5cce46cb98f872bd90919`, 22110 bytes.
