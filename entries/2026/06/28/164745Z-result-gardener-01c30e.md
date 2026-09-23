---
kind: result
role: gardener
host: endolinbot
at: 2026-06-28T16:47:46Z
---
---
ts: 2026-06-28T16:47:00Z
kind: result
role: scholar
project: endo
---

# scholar-ingest-erights-5: the Concurrency child-chapter cluster

Wore the scholar role for job `scholar-ingest-erights-5`. Ingested the four
**Concurrency in E** child chapters the `erights--elang-concurrency-index` map
(and the new `elib/concurrency` reference) point at. All four fetched via
`fetch-source.sh` and served by the erights.org GitHub Pages mirror
(`source_fetched_via=mirror`). One section per source (4 sources, 4 sections).

## Sources ingested (4 sources, 4 sections)

- `elang/concurrency/race.html` → `erights--elang-concurrency-race` — 1 section
  `racing-joining-and-timeouts`. Content SHA-256 `145978130f9d`. The promise
  combinators on once-only resolution: `race` (first-to-resolve), the `once`
  use-once forwarder, `asynchAnd` (the asynchronous join / short-circuiting
  conjunction), and `timeBomb`, with `race(req, timeBomb(ms))` as the timeout
  idiom. Authors recorded as Mark S. Miller + Terry Stanley.
- `elang/concurrency/epimenides.html` → `erights--elang-concurrency-epimenides` —
  1 section `reference-states-and-data-lock`. Content SHA-256 `02342f70c87a`. The
  three reference states (near / eventual / broken) and **data-lock**, E's
  non-blocking analog of deadlock. Filed under `[eventual-send, e-language]`
  (deliberately NOT under the `references` topic, which is the library's
  cross-reference meta-axis, a slug collision with E "references").
- `elang/concurrency/determinism/index.html` →
  `erights--elang-concurrency-determinism` — 1 outline-stub section
  `deterministic-replay-plan`. Content SHA-256 `970036f40fbe`. The upstream page
  is an outline only (no prose body); captured as a stub so the named entry point
  resolves: deterministic event-loop replay + its five benefits (cheaper
  commitment, cheaper fault tolerance, inward bit confinement, debugging, contract
  verification).
- `elib/concurrency/index.html` → `erights--elib-concurrency-index` — 1 map
  section `event-loop-reference-map`. Content SHA-256 `a116bef33730`. The
  reference-level Event-Loop Concurrency hub the elang tutorial's See-Also points
  at: chapter map of the vat / turn / partial-order / Four-Layers-of-When / EIO
  model. Its child chapters are queued in `scholar-ingest-erights-6`.

## Concept and index pages touched

- New concept `concepts/data-lock.md` (aliases: datalock, data lock, unresolvable
  circular promise, circular promise resolution, E deadlock analog). Grounded by
  the epimenides section and cross-linked to the Concurrency-Among-Strangers
  promise-pipelining section that also names datalock. See-also `[[eventual-send]]`,
  `[[promise-pipelining]]`.
- Topics extended: `topics/eventual-send.md` (+4 rows), `topics/e-language.md`
  (+4 rows).
- Indexes updated: `sources/README.md` (+4 rows in the External-web-sources
  table), `sections/README.md` (+4 source blocks, alphabetically placed),
  `concepts/README.md` (+data-lock row), `keywords.md` (+23 keyword lines for
  data-lock, the reference states, the race/join/timeout combinators, and the
  elib event-loop / vat-turn / Four-Layers-of-When / EIO terms).

All content landed via `land-journal-edit.sh` (producer-clone CAS, no live-worktree
touch). Shared indexes were appended off a fresh `git show origin/journal2` tip.

## Integrity gate

`library-link-check.sh --source-slug <slug>` run on all four new clusters
(`erights--elang-concurrency-race`, `--epimenides`, `--determinism`,
`erights--elib-concurrency-index`): **OK on each** — every checked link resolves
to a committed file.

## Follow-on and carried-forward flags

- Posted `scholar-ingest-erights-6` naming the remaining queue: the Guarding child
  chapters (`async.html`, `style.html`) + the optional `e-guards` concept, the
  Grammar per-construct pages, the deeper ELib concurrency child chapters (now that
  `erights--elib-concurrency-index` enumerates them), and the optional Ode chapters
  (duplicate the FC2000 paper; ingest only for finer granularity).
- Carried forward (separate cleanup, not this cycle): `sections/README.md` is still
  missing the `### erights--elang-same-ref` block; a `--nav` sweep on 2026-06-28
  reported ~20 pre-existing dangling nav links concentrated in the
  `endo-but-for-bots--llm-designs-*` cluster plus `concepts/polaris.md`,
  `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md`.

Self-improvement: noted the `references` topic-slug collision (the library's
cross-reference meta-axis versus E's object-reference states) and resolved it
locally by filing the epimenides section under `[eventual-send, e-language]`
only; not a structural lesson worth routing — the conventions already say to add
topics as the corpus reveals them, and `eventual-send` covers the material.
