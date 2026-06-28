Scholar cycle for `scholar-ingest-erights-3` — ingested the **Kernel-E** reference
chapter, the highest-value remaining erights.org E-language page, as its own full
cycle (~40 KB).

## Source ingested

- `elang/kernel/index.html` → **`erights--elang-kernel`** (4 sections), content
  SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`,
  fetched via the erights.org GitHub Pages mirror (`source_fetched_via=mirror`),
  last modified 1998-10-03. Sections:
  - `erights--elang-kernel--overview` — Kernel-E as the bottom of the layered
    spec; semantics by meta-circular interpreter; reify-`eval` / absorb-`apply`
    staging that keeps enhanced (upgrade, debugging) interpreters analyzable over
    a secure base. (topics: e-language, capability-security)
  - `erights--elang-kernel--expression-forms` — the eExpr quick-reference card:
    every kernel expression special form with pseudo-BNF, kept inline for grep.
    (topics: e-language, eventual-send)
  - `erights--elang-kernel--pattern-forms-and-helpers` — the pattern forms (the
    `: eExpr` guard hook), helper productions, and terminals. (topics: e-language)
  - `erights--elang-kernel--meta-interpreter-semantics` — four name spaces, the
    four indirections (noun→pattern→slot→reference→object), eval's
    success/failure/escape outcomes, testMatch/mustMatch, object state-nouns.
    (topics: e-language, capability-security, eventual-send)

## Concepts / topics touched

- **New concept `kernel-e`** (the optional concept deferred from erights-2; the
  natural cycle to add it is the one that ingests the Kernel-E manual). Aliases
  cover "Kernel-E", "kernel language", "canonical expansion to Kernel-E", etc.
- **`e-language` concept narrowed**: removed "Kernel-E" from its alias list (now
  owned by `kernel-e`) and added a `See also` cross-link, per the job's guidance
  to narrow the alias rather than duplicate.
- **`e-language` topic** extended with the 4 Kernel-E section rows.

## Indexes updated

- `sources/README.md` — added the `erights--elang-kernel` row.
- `sections/README.md` — added the `### erights--elang-kernel` block (4 sections),
  in alphabetical position before `erights--elang-quick-ref`.
- `concepts/README.md` — added the `kernel-e` row; also **back-filled the missing
  `e-language` row** (the concept page existed but was absent from the index — a
  pre-existing gap fixed in passing).
- `keywords.md` — added 12 `kernel-e` keyword lines (Kernel-E, canonical
  expansion, special forms, meta-circular interpreter, testMatch/mustMatch, the
  four indirections, etc.).

## Integrity gate

`library-link-check.sh --source-slug erights--elang-kernel` → **OK** (exit 0):
every section-table target and sections/README row resolves to a committed file.

## Follow-on posted

- **`scholar-ingest-erights-4`** — names exactly what remains: the primitive-data-
  type trio (scalars / collect / io, a natural single cycle), the concurrency
  child chapters (race, epimenides, determinism, the deeper `elib/concurrency`),
  the guarding child chapters (async, style), the per-construct grammar pages, the
  optional `ode/*` chapters (still cautioned as FC2000-paper duplicates), and the
  remaining optional `e-guards` concept (best landed with the guarding children).
  The `kernel-e` concept is no longer queued (landed this cycle).

## Deferred / flagged

- The pre-existing ~20 dangling nav links (concentrated in
  `endo-but-for-bots--llm-designs-*`, plus `concepts/polaris.md`,
  `concepts/powerbox.md`, `sources/endo--designs-daemon-persistence.md`) remain
  unrelated to this work and still warrant a separate library-link cleanup job;
  carried forward in the erights-4 body.

Self-improvement: nothing this time. The Kernel-E page was a clean fit for the
existing web-source schema, the 1–3-section reference-doc aggregation guidance (4
cohesive form-group sections rather than ~20 per-special-form files), and the
deferred-concept pattern. The one incidental finding — `e-language` missing from
`concepts/README.md` — was fixed in passing rather than routed as a lesson, since
it is a data gap, not a structural one.
