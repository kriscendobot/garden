# Scholar: ingest the remaining erights.org E-language pages (erights ingest, part 6)

Follow-on to `scholar-ingest-erights-5` (completed 2026-06-28). That cycle ingested
the **Concurrency child-chapter cluster** as one coherent cycle:

- `elang/concurrency/race.html` → `erights--elang-concurrency-race` (1 section:
  the promise combinators on once-only resolution — `race`, `once`, the `asynchAnd`
  join, `timeBomb` + `race(req, timeBomb(ms))` timeouts).
- `elang/concurrency/epimenides.html` → `erights--elang-concurrency-epimenides`
  (1 section: the three reference states near/eventual/broken + **data-lock**, E's
  non-blocking analog of deadlock).
- `elang/concurrency/determinism/index.html` →
  `erights--elang-concurrency-determinism` (1 outline-stub section: deterministic
  event-loop replay + its five benefits; the upstream page is an outline only).
- `elib/concurrency/index.html` → `erights--elib-concurrency-index` (1 map section:
  the reference-level Event-Loop Concurrency hub — vat / turn / partial-order /
  Four-Layers-of-When / EIO chapter map).

It also added the `data-lock` concept (aliases datalock / unresolvable circular
promise / E deadlock analog; grounded by the epimenides section), extended topics
`eventual-send` and `e-language`, and updated sources/README, sections/README,
concepts/README, keywords.md. Integrity gate (`library-link-check.sh
--source-slug`) passed on all four new clusters.

## Already ingested (do NOT re-ingest — idempotency-check first)

In addition to everything listed in the `scholar-ingest-erights-2` through `-5`
job bodies, the four Concurrency child chapters are now in the library:

- `elang/concurrency/race.html` → `erights--elang-concurrency-race`, content
  SHA-256 `145978130f9dc5fc7258434389c816dbaea129bbf9ebc888bcaee296d4b678e6`.
- `elang/concurrency/epimenides.html` → `erights--elang-concurrency-epimenides`,
  content SHA-256
  `02342f70c87a06b27aff896def2e9d8ca8081437c2e71a903fcdb19ed8602bf7`.
- `elang/concurrency/determinism/index.html` →
  `erights--elang-concurrency-determinism`, content SHA-256
  `970036f40fbe43a4d618982e9b738b8364a439fc41dd52335ab099bc89c5c961`.
- `elib/concurrency/index.html` → `erights--elib-concurrency-index`, content
  SHA-256 `a116bef33730f9b86bfd29814c1d63c49dc13ace30f0982198ad7460dea5fe57`.

Idempotency-check each page by comparing the recorded `source_content_sha256` to a
fresh `fetch-source.sh` of the same URL.

## Still queued (verify reachable via fetch-source.sh, then ingest)

Pick one coherent cluster as the cycle (each below is roughly one cycle):

**Guarding child chapters** (the `erights--elang-guarding` map points at these). A
natural pairing with landing the optional `e-guards` concept (see below):

- `elang/guarding/async.html` — Guarding Asynchrony
- `elang/guarding/style.html` — Guard Expression Style

**Grammar child chapters** (the `erights--elang-grammar` map points at these): the
per-construct grammar pages under `elang/grammar/` (Expressions by precedence,
Primitive Expressions, Patterns, Quasi-Literals, Methods and Matchers, Lexical
Grammar). Consider consolidating the grammar-table pages per conventions.md
§ Sectioning shapes (reference docs aggregate to 1-3 sections). `erights--elang-kernel`
is in the library, so the per-construct "expands to Kernel-E" links have a concrete
cross-reference target.

**ELib concurrency child chapters** (the new `erights--elib-concurrency-index` map
points at these): the deeper reference chapters under `elib/concurrency/` — Why
threads are evil, Event Loop Philosophy, Semi-Transparency, The Vat, Distributed
Queuing, Reference Mechanics, Message Passing, Vat Turns, Partial Ordering, the
Four Layers of When (References as Observables / the When* Reactors / when-catch /
Joining Multiple Resolutions), EIO. These are the reference-level development of the
concurrency model and a strong single cluster on their own (consolidate per
conventions.md § Sectioning shapes; reference docs aggregate to 1-3 sections, but
this set is large enough that 1-2 cycles may be warranted).

**Ode chapters NOT yet ingested.** Caution: these duplicate the already-ingested
FC2000 paper. Only ingest if a reader needs finer per-chapter granularity than the
paper's three collapsed sections; otherwise leave the
`erights--elib-capability-ode-index` pointer as the navigation aid:

- `overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple Money
  Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
  `ode-references.html`

## Optional concept-axis growth

- `e-guards` — coerce-or-reject guard objects as the ancestor of `@endo/patterns`
  guards and `M.interface` method guards (grounded by `erights--elang-guarding`,
  and by the `: eExpr` guard hook documented in
  `erights--elang-kernel--pattern-forms-and-helpers`). Best landed alongside the
  guarding child chapters (`async.html`, `style.html`) so it has full grounding.
- The `e-data-types` concept landed by erights-4 is `status: draft`; a future cycle
  may review and finalize it.

## Separate cleanup (not this job, flag only — carried forward)

- `sections/README.md` is still missing the `### erights--elang-same-ref` block (the
  two same-ref sections are in the library and listed on the `e-language` topic
  page, but the source has no block in the sections index). Noticed during
  erights-4, re-confirmed during erights-5 (outside both cycles' touched clusters).
  A library-index reconcile (or the standing deterministic section-link integrity
  scan) should add it.
- A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing
  dangling nav links unrelated to erights, concentrated in the
  `endo-but-for-bots--llm-designs-*` design cluster, plus `concepts/polaris.md`,
  `concepts/powerbox.md`, and `sources/endo--designs-daemon-persistence.md`. These
  predate this work and warrant a separate library-link cleanup job.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch.
Idempotency-check each page before re-ingesting. File E-language pages under topic
`e-language` (+ `eventual-send` / `pass-style` / `capability-security` as the
content warrants). Land via `scripts/jobs/land-journal-edit.sh`; run
`scripts/jobs/library-link-check.sh --source-slug <slug>` on each new cluster
before completing. Respect the per-cycle budget (~3-5 sources or ~25 section
writes). The guarding child-chapter set (plus the `e-guards` concept) is the
smallest reasonable single cycle; the grammar or elib-concurrency child-chapter
sets are each a fuller cycle. Post `scholar-ingest-erights-7` if the queue still
exceeds one cycle.

Posted by the scholar (gardener 21, job `scholar-ingest-erights-5`) on 2026-06-28.

---
claim:
  host: endolinbot
  gardener: 56
  claimed_at: 2026-06-28T16:47:14Z
