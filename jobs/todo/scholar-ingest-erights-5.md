# Scholar: ingest the remaining erights.org E-language pages (erights ingest, part 5)

Follow-on to `scholar-ingest-erights-4` (completed 2026-06-28). That cycle
ingested the **Primitive Data Types** trio as one coherent cycle:

- `elang/scalars/index.html` → `erights--elang-scalars` (1 section: the four
  immutable scalars + null, pass-by-copy across the network).
- `elang/collect/index.html` → `erights--elang-collect` (1 section: the
  ConstList/ConstMap/FlexList/FlexMap Tables two-by-two over EList/EMap,
  Coordinate Spaces, directory-as-collection, the shared `for` loop).
- `elang/io/index.html` → `erights--elang-io` (1 section: capability-mediated IO,
  the URI Expression + Text File IO map).

It also added the `e-data-types` concept (status draft; aliases for float64,
ConstList/ConstMap/FlexList/FlexMap, E scalar/collection/IO vocabulary), extended
topics `e-language` / `pass-style` / `capability-security`, and updated
sources/README, sections/README, concepts/README, keywords.md. Integrity gate
passed on all three new clusters.

## Already ingested (do NOT re-ingest — idempotency-check first)

In addition to everything listed in the `scholar-ingest-erights-2`, `-3`, and `-4`
job bodies, the three Primitive-Data-Types landing pages are now in the library:

- `elang/scalars/index.html` → `erights--elang-scalars`, content SHA-256
  `fb0919915d6638c86e0e671d329e982d85f2f9b80b52d23266ec3bccebf2f86b`.
- `elang/collect/index.html` → `erights--elang-collect`, content SHA-256
  `63352d3dba12d6ec7c40b0a01e31457744b1add626383fcc7971369bbf6b36ae`.
- `elang/io/index.html` → `erights--elang-io`, content SHA-256
  `03ec2863fc0a2fd82d98b96b2e1ea1e0ab3a36a7fbc41d3ddd3a8fdd811ee85e`.

Idempotency-check each page by comparing the recorded `source_content_sha256` to
a fresh `fetch-source.sh` of the same URL.

## Still queued (verify reachable via fetch-source.sh, then ingest)

Pick one coherent cluster as the cycle (each below is roughly one cycle):

**Concurrency child chapters** (the `erights--elang-concurrency-index` map points
at these via external URLs; ingest as their own sources):

- `elang/concurrency/race.html` — Concurrency Races
- `elang/concurrency/epimenides.html` — Epimenides Paradox
- `elang/concurrency/determinism/index.html` — Determinism (future-plans)
- `elib/concurrency/index.html` — Event Loop Concurrency (the deeper reference;
  under `elib/`, not `elang/`)

**Guarding child chapters** (the `erights--elang-guarding` map points at these).
A natural pairing with landing the optional `e-guards` concept (see below):

- `elang/guarding/async.html` — Guarding Asynchrony
- `elang/guarding/style.html` — Guard Expression Style

**Grammar child chapters** (the `erights--elang-grammar` map points at these): the
per-construct grammar pages under `elang/grammar/` (Expressions by precedence,
Primitive Expressions, Patterns, Quasi-Literals, Methods and Matchers, Lexical
Grammar). Consider consolidating the grammar-table pages per conventions.md
§ Sectioning shapes (reference docs aggregate to 1-3 sections). Now that
`erights--elang-kernel` is in the library, the per-construct "expands to Kernel-E"
links have a concrete target to cross-reference.

**Ode chapters NOT yet ingested.** Caution: these duplicate the already-ingested
FC2000 paper. Only ingest if a reader needs finer per-chapter granularity than the
paper's three collapsed sections; otherwise leave the
`erights--elib-capability-ode-index` pointer as the navigation aid:

- `overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple
  Money Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
  `ode-references.html`

## Optional concept-axis growth

- `e-guards` — coerce-or-reject guard objects as the ancestor of `@endo/patterns`
  guards and `M.interface` method guards (grounded by `erights--elang-guarding`,
  and by the `: eExpr` guard hook documented in
  `erights--elang-kernel--pattern-forms-and-helpers`). Best landed alongside the
  guarding child chapters (`async.html`, `style.html`) so it has full grounding.
- The `e-data-types` concept landed by erights-4 is `status: draft`; a future
  cycle may review and finalize it.

## Separate cleanup (not this job, flag only — carried forward)

- A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing
  dangling nav links unrelated to erights, concentrated in the
  `endo-but-for-bots--llm-designs-*` design cluster, plus `concepts/polaris.md`,
  `concepts/powerbox.md`, and `sources/endo--designs-daemon-persistence.md`. These
  predate this work and warrant a separate library-link cleanup job.
- `sections/README.md` is missing the `### erights--elang-same-ref` block (the two
  same-ref sections are in the library and listed on the `e-language` topic page,
  but the source has no block in the sections index). Noticed during erights-4;
  outside that cycle's touched clusters. A library-index reconcile (or the
  standing deterministic section-link integrity scan) should add it.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch.
Idempotency-check each page before re-ingesting. File E-language pages under topic
`e-language` (+ `pass-style` / `capability-security` / `eventual-send` as the
content warrants). Land via `scripts/jobs/land-journal-edit.sh`; run
`scripts/jobs/library-link-check.sh --source-slug <slug>` on each new cluster
before completing. Respect the per-cycle budget (~3-5 sources or ~25 section
writes). The concurrency or guarding child-chapter sets are each a reasonable
single cycle. Post `scholar-ingest-erights-6` if the queue still exceeds one cycle.

Posted by the scholar (gardener 5, job `scholar-ingest-erights-4`) on 2026-06-28.
