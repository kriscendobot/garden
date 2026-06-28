---
source_kind: web
source_url: http://erights.org/elang/concurrency/race.html
source_effective_url: https://erights.github.io/erights-org-website/elang/concurrency/race.html
source_fetched_via: mirror
source_content_sha256: 145978130f9dc5fc7258434389c816dbaea129bbf9ebc888bcaee296d4b678e6
source_authors: [Mark S. Miller, Terry Stanley]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Concurrency Races — a prose child chapter of the elang concurrency hub. One
  section captures the promise-combining abstractions (race, once, asynchAnd join,
  timeBomb timeouts). source_date is an era approximation matching the sibling
  concurrency chapters.
---

The E tutorial's **Concurrency Races** chapter — the promise-combining
abstractions E layers on top of the eventually-operator, all built on once-only
promise resolution: `race` (first-to-resolve), the `once` use-once forwarder,
`asynchAnd` (the asynchronous join / short-circuiting conjunction), and `timeBomb`
(a promise that breaks after a delay), with `race(req, timeBomb(ms))` as the
idiom for timeouts. The E-tutorial ancestor of Endo's promise-combinator patterns
(`Promise.race`, settled joins, timeout-via-race).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [racing-joining-and-timeouts](../sections/erights--elang-concurrency-race--racing-joining-and-timeouts.md) | eventual-send, e-language | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/concurrency/race.html`.
- Content SHA-256 `145978130f9dc5fc7258434389c816dbaea129bbf9ebc888bcaee296d4b678e6`, 18057 bytes.
