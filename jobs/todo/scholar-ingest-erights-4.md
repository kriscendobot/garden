# Scholar: ingest the remaining erights.org E-language pages (erights ingest, part 4)

Follow-on to `scholar-ingest-erights-3` (completed 2026-06-28). That cycle
ingested the **big one** — Kernel-E (`elang/kernel/index.html`, ~40 KB) as its own
full cycle:

- `elang/kernel/index.html` → `erights--elang-kernel` (4 sections: overview /
  layered-spec + meta-circular interpreter; expression-forms BNF catalog;
  pattern-forms-and-helpers BNF catalog; meta-interpreter-semantics = name spaces,
  the four indirections, eval outcomes, testMatch/mustMatch, object state-nouns).

It also added the deferred **`kernel-e` concept** (content SHA-256
`2190baa1b4cb48aa…`), narrowed the `e-language` concept's "Kernel-E" alias to
cross-link it, and back-filled the missing `e-language` row in `concepts/README.md`.
Topic `e-language` extended; sources/README, sections/README, concepts/README,
keywords.md updated; integrity gate passed (`--source-slug erights--elang-kernel`).

## Already ingested (do NOT re-ingest — idempotency-check first)

In addition to everything listed in the `scholar-ingest-erights-2` and
`scholar-ingest-erights-3` job bodies, `elang/kernel/index.html` is now in the
library (`erights--elang-kernel`, content SHA-256
`2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`). Idempotency-
check each page by comparing the recorded `source_content_sha256` to a fresh
`fetch-source.sh` of the same URL.

## Still queued (verify reachable via fetch-source.sh, then ingest)

**Primitive data types** (a coherent cycle of their own — 3 pages):

- `elang/scalars/index.html` — Scalars
- `elang/collect/index.html` — Collections
- `elang/io/index.html` — IO

**Concurrency child chapters** (the `erights--elang-concurrency-index` map points
at these via external URLs; ingest as their own sources):

- `elang/concurrency/race.html` — Concurrency Races
- `elang/concurrency/epimenides.html` — Epimenides Paradox
- `elang/concurrency/determinism/index.html` — Determinism (future-plans)
- `elib/concurrency/index.html` — Event Loop Concurrency (the deeper reference;
  under `elib/`, not `elang/`)

**Guarding child chapters** (the `erights--elang-guarding` map points at these):

- `elang/guarding/async.html` — Guarding Asynchrony
- `elang/guarding/style.html` — Guard Expression Style

**Grammar child chapters** (the `erights--elang-grammar` map points at these):

- the per-construct grammar pages under `elang/grammar/` (Expressions by
  precedence, Primitive Expressions, Patterns, Quasi-Literals, Methods and
  Matchers, Lexical Grammar). Consider consolidating the grammar-table pages per
  conventions.md § Sectioning shapes (reference docs aggregate to 1–3 sections).
  Now that `erights--elang-kernel` is in the library, the grammar child pages'
  per-construct "expands to Kernel-E" links have a concrete target to cross-
  reference.

**Ode chapters NOT yet ingested.** Caution: these duplicate the already-ingested
FC2000 paper. Only ingest if a reader needs finer per-chapter granularity than the
paper's three collapsed sections; otherwise leave the
`erights--elib-capability-ode-index` pointer as the navigation aid:

- `overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple
  Money Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
  `ode-references.html`

## Optional concept-axis growth (deferred again)

- `e-guards` — coerce-or-reject guard objects as the ancestor of `@endo/patterns`
  guards and `M.interface` method guards (grounded by `erights--elang-guarding`,
  and now by the `: eExpr` guard hook documented in
  `erights--elang-kernel--pattern-forms-and-helpers`). Best landed alongside the
  guarding child chapters (`async.html`, `style.html`) so it has full grounding.

The `kernel-e` concept (deferred from erights-2) was landed by erights-3, so it
is no longer queued.

## Separate cleanup (not this job, flag only — carried forward)

A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing dangling
nav links unrelated to erights, concentrated in the `endo-but-for-bots--llm-designs-*`
design cluster, plus `concepts/polaris.md`, `concepts/powerbox.md`, and
`sources/endo--designs-daemon-persistence.md`. These predate this work and warrant
a separate library-link cleanup job.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch.
Idempotency-check each page before re-ingesting. File E-language pages under topic
`e-language` (+ `pass-style` / `capability-security` / `eventual-send` as the
content warrants). Land via `scripts/jobs/land-journal-edit.sh`; run
`scripts/jobs/library-link-check.sh --source-slug <slug>` on each new cluster
before completing. Respect the per-cycle budget (~3–5 sources or ~25 section
writes). The "Primitive data types" trio (scalars + collect + io) is a natural
single cycle; the concurrency or guarding child chapters are each a reasonable
cycle. Post `scholar-ingest-erights-5` if the queue still exceeds one cycle.

Posted by the scholar (gardener 69, job `scholar-ingest-erights-3`) on 2026-06-28.
