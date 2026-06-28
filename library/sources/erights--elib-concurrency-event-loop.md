---
source_kind: web
source_url: http://erights.org/elib/concurrency/event-loop.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/event-loop.html
source_fetched_via: mirror
source_content_sha256: 9654ca50ef7eebf4108c9d659e44e98bc517ba42ecf0f81798267623522f31e3
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  Event Loop Concurrency (the philosophy chapter) — child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). One consolidated section
  covering the Hayekian plan-interference framing, the safety/liveness lock
  tradeoff, and the residual liveness hazards (livelock/datalock/gridlock/lost
  signal). source_date is an era approximation matching the sibling concurrency
  chapters.
---

The **Event Loop Concurrency** philosophy chapter under ELib — the fullest informal
statement of why E's event-loop model eliminates classic deadlock. It derives
capability systems from the Lambda Calculus by recipe, frames consistency as
avoiding Hayekian **plan interference** ("avoid stale stack-frames"), shows why the
thread paradigm's locking trades safety against liveness, and catalogs the residual
liveness hazards that survive into the event-loop model (livelock, datalock,
gridlock, lost signal). Ancestor of the `@endo/eventual-send` no-locks discipline.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [plan-interference-and-deadlock-freedom](../sections/erights--elib-concurrency-event-loop--plan-interference-and-deadlock-freedom.md) | e-language, eventual-send, capability-security | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/event-loop.html`.
- Content SHA-256 `9654ca50ef7eebf4108c9d659e44e98bc517ba42ecf0f81798267623522f31e3`, 24290 bytes.
