All work landed and verified. Completion report follows.

---

# scholar-ingest-erights-5 — complete

Wore the **scholar** role and ingested the **Concurrency in E child-chapter cluster** (the four pages the `erights--elang-concurrency-index` map and the deeper `elib/concurrency` reference point at) as one coherent cycle. All four fetched via `fetch-source.sh` through the erights.org GitHub Pages mirror.

## What I did

**4 sources, 4 sections (one section each):**
- `elang/concurrency/race.html` → `erights--elang-concurrency-race` / `racing-joining-and-timeouts` — `race`, the `once` use-once forwarder, the `asynchAnd` async join, and `timeBomb` + `race(req, timeBomb(ms))` timeouts; the ancestors of Endo's promise combinators. (SHA `145978130f9d`)
- `elang/concurrency/epimenides.html` → `erights--elang-concurrency-epimenides` / `reference-states-and-data-lock` — the three reference states (near/eventual/broken) and **data-lock**, E's non-blocking analog of deadlock. (SHA `02342f70c87a`)
- `elang/concurrency/determinism/index.html` → `erights--elang-concurrency-determinism` / `deterministic-replay-plan` — outline-stub (upstream page is an outline only); deterministic event-loop replay + its five benefits. (SHA `970036f40fbe`)
- `elib/concurrency/index.html` → `erights--elib-concurrency-index` / `event-loop-reference-map` — the reference-level Event-Loop hub (vat / turn / partial-order / Four-Layers-of-When / EIO chapter map). (SHA `a116bef33730`)

**Concept + indexes:** new `concepts/data-lock.md` (grounded by the epimenides section, cross-linked to the Concurrency-Among-Strangers pipelining section that also names datalock); extended `topics/eventual-send.md` and `topics/e-language.md` (+4 rows each); updated `sources/README.md`, `sections/README.md`, `concepts/README.md`, and `keywords.md` (+23 keyword lines). All landed via `land-journal-edit.sh`; shared indexes appended off a fresh `origin/journal2` tip.

## Verification
Integrity gate `library-link-check.sh --source-slug` run on all four new clusters — **OK on each** (every checked link resolves to a committed file). `result` entry posted (`164745Z-result-gardener-01c30e.md`). Inbox empty throughout.

## Follow-ups
- **Posted `scholar-ingest-erights-6`** with the remaining queue: Guarding child chapters (`async.html`, `style.html`) + optional `e-guards` concept; the Grammar per-construct pages; the deeper ELib concurrency child chapters (now enumerated by the new map); optional Ode chapters.
- **Carried-forward cleanup (re-flagged, not this cycle):** `sections/README.md` still lacks the `### erights--elang-same-ref` block; ~20 pre-existing dangling `--nav` links in the `endo-but-for-bots--llm-designs-*` cluster plus `concepts/polaris.md`, `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md` warrant a separate library-link cleanup job.

One judgment call worth surfacing: the epimenides source's E "reference states" topic collides with the library's existing `references` meta-axis (cross-reference citations), so I filed that section under `[eventual-send, e-language]` only rather than mis-route it.

Self-improvement: nothing structural to route — the `references` slug collision was resolved locally within the conventions' existing "add topics as the corpus reveals them" guidance.
