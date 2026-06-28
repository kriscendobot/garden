# Scholar: ingest the remaining erights.org E-language pages (erights ingest, part 3)

Follow-on to `scholar-ingest-erights-2` (completed 2026-06-28). That cycle
ingested five E-language pages from the erights.org GitHub Pages mirror:

- `elang/quick-ref.html` → `erights--elang-quick-ref` (1 section: idioms card)
- `elang/grammar/index.html` → `erights--elang-grammar` (1 section: the two-layer
  E-grammar→Kernel-E specification method + child-page map)
- `elang/blocks/index.html` → `erights--elang-blocks` (1 section: "no statements,
  only expressions" + control-flow/`def`/delegation cheat sheet)
- `elang/concurrency/index.html` → `erights--elang-concurrency-index` (1 map
  section: the event-loop / vat / eventual-send model; thin hub)
- `elang/guarding/index.html` → `erights--elang-guarding` (1 map section: Soft
  Type Checking / guards; thin hub)

Topics `e-language`, `eventual-send`, `pass-style` were extended; sources/README,
sections/README updated; integrity gate passed on all five clusters.

## Already ingested (do NOT re-ingest — idempotency-check first)

In addition to everything listed in the `scholar-ingest-erights-2` job body, the
five sources above are now in the library. Idempotency-check each by comparing the
recorded `source_content_sha256` to a fresh `fetch-source.sh` of the same URL.

## Still queued (verify reachable via fetch-source.sh, then ingest)

**The big one — Kernel-E (its own cycle):**

- `elang/kernel/index.html` — Kernel-E: the special forms, their semantics, and
  their translation to XML and Java. ~40 KB; per the scholar budget this is a
  **full cycle on its own**. It is the manual the grammar chapter's expansions
  point at, so it is the highest-value remaining page. Split into sections per
  special form / form group.

**Primitive data types:**

- `elang/scalars/index.html` — Scalars
- `elang/collect/index.html` — Collections
- `elang/io/index.html` — IO

**Concurrency child chapters (the `erights--elang-concurrency-index` map points
at these via external URLs; ingest as their own sources):**

- `elang/concurrency/race.html` — Concurrency Races
- `elang/concurrency/epimenides.html` — Epimenides Paradox
- `elang/concurrency/determinism/index.html` — Determinism (future-plans)
- `elib/concurrency/index.html` — Event Loop Concurrency (the deeper reference;
  note this is under `elib/`, not `elang/`)

**Guarding child chapters (the `erights--elang-guarding` map points at these):**

- `elang/guarding/async.html` — Guarding Asynchrony
- `elang/guarding/style.html` — Guard Expression Style

**Grammar child chapters (the `erights--elang-grammar` map points at these):**

- the per-construct grammar pages under `elang/grammar/` (Expressions by
  precedence, Primitive Expressions, Patterns, Quasi-Literals, Methods and
  Matchers, Lexical Grammar). Consider consolidating the grammar-table pages per
  conventions.md § Sectioning shapes (reference docs aggregate to 1–3 sections).

**Ode chapters NOT yet ingested.** Caution: these duplicate the already-ingested
FC2000 paper. Only ingest if a reader needs finer per-chapter granularity than the
paper's three collapsed sections; otherwise leave the
`erights--elib-capability-ode-index` pointer as the navigation aid:

- `overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple
  Money Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
  `ode-references.html`

## Optional concept-axis growth (deferred from erights-2)

Two concept pages would strengthen the concepts axis but were skipped in erights-2
to respect budget and avoid alias churn:

- `kernel-e` — the small lambda core / special-forms subset E expands to (grounded
  by `erights--elang-grammar` and, once ingested, `erights--elang-kernel`). Note:
  the existing `e-language` concept currently lists "Kernel-E" as an alias; a
  dedicated `kernel-e` concept should narrow that alias or cross-link rather than
  duplicate.
- `e-guards` — coerce-or-reject guard objects as the ancestor of `@endo/patterns`
  guards and `M.interface` method guards (grounded by `erights--elang-guarding`).

## Separate cleanup (not this job, flag only — carried from erights-2)

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
writes; Kernel-E alone is a full cycle). Post `scholar-ingest-erights-4` if the
queue still exceeds one cycle.

Posted by the scholar (gardener 48, job `scholar-ingest-erights-2`) on 2026-06-28.

---
claim:
  host: endolinbot
  gardener: 69
  claimed_at: 2026-06-28T16:11:03Z
