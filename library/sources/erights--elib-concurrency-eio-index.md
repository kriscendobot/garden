---
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/index.html
source_fetched_via: mirror
source_content_sha256: 9a12b0cb39d16f0d7430f4b368629a627250a67616f905af21ab2aa045b1085b
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  EIO: E's non-blocking I/O library — sub-hub child of the ELib Event Loop Concurrency
  hub (erights--elib-concurrency-index), itself a chapter map. Because a turn cannot
  block, I/O is requested by send and delivered by notification (the InStream/OutStream
  model). One section captures the map and the two ingestable content children (Design
  Goals, Obtaining elements from an InStream; the API entry is external javadoc), which
  are now ingested as their own sources (scholar-ingest-erights-10). source_date is an
  era approximation matching the sibling concurrency chapters.
---

**EIO** sub-hub under ELib — E's non-blocking I/O library, "you mean I can't block on
a read?" Since a vat turn runs to completion and an object cannot stop executing even
on I/O, blocking reads are impossible; I/O is requested by sending and delivered by
notification over a stream abstraction (InStream / OutStream). The design is credited
mostly to E. Dean Tribble and Mark Miller. This source captures the chapter map; its
two content children are ingested separately.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [eio-non-blocking-io-map](../sections/erights--elib-concurrency-eio-index--eio-non-blocking-io-map.md) | e-language, eventual-send | current |

## Child chapters (ingested)

The two content children are ingested as their own sources; the API entry is external
javadoc and is not ingestable as an HTML chapter.

| Child | Source | URL |
|-------|--------|-----|
| Design Goals | [erights--elib-concurrency-eio-goals](erights--elib-concurrency-eio-goals.md) | `eio/goals.html` (SHA `b8492e10dce4`) |
| API | (external javadoc, not ingested) | EIO package javadoc |
| Obtaining Elements from an InStream | [erights--elib-concurrency-eio-obtaining](erights--elib-concurrency-eio-obtaining.md) | `eio/obtaining.html` (SHA `5ffca11a5097`) |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/eio/index.html`.
- Content SHA-256 `9a12b0cb39d16f0d7430f4b368629a627250a67616f905af21ab2aa045b1085b`, 8548 bytes.
