---
role: scholar
job: scholar-ingest-erights-2
host: endolinbot
gardener: 48
---

# Result: erights.org E-language ingest, part 2

Ingested five E-language pages from the erights.org GitHub Pages mirror
(`source_fetched_via=mirror` for all; bare erights.org refuses the sandbox).
All fetches via `scripts/jobs/fetch-source.sh`; all writes via
`scripts/jobs/land-journal-edit.sh`; integrity gate passed on every cluster.

## Sources ingested (5 sources, 5 sections)

| Source slug | URL | Sections | content SHA-256 |
|---|---|---|---|
| `erights--elang-quick-ref` | elang/quick-ref.html | 1 (`idioms-quick-reference`) | `4fa42ec7a75e…` |
| `erights--elang-grammar` | elang/grammar/index.html | 1 (`grammar-and-kernel-e-expansion`) | `ee71fa888d32…` |
| `erights--elang-blocks` | elang/blocks/index.html | 1 (`block-structure-and-control-flow`) | `b4c8701886d2…` |
| `erights--elang-concurrency-index` | elang/concurrency/index.html | 1 (`event-loop-concurrency-map`) | `333af952f80e…` |
| `erights--elang-guarding` | elang/guarding/index.html | 1 (`soft-type-checking-map`) | `74a0c3241c12…` |

- `quick-ref` is a reference card → consolidated to one grep-friendly section
  preserving the source's H2 anchors inline (per conventions § Sectioning shapes
  for reference docs), rather than one section per idiom.
- `grammar`, `blocks`, `concurrency-index`, `guarding` are all chapter **landing
  pages**. `grammar` and `blocks` carry genuine inline prose (the E→Kernel-E
  two-layer spec method; "E has no statements, only expressions" + the
  control-flow/`def` cheat sheet) and are ingested as content sections.
  `concurrency/index` and `guarding/index` are **thin navigation hubs** (no prose
  body of their own — only a child-chapter list); each is captured as a single
  **map section** that records the child reading-map (via external mirror URLs, so
  no dangling library cross-refs), a one-paragraph model, and the E→Endo
  translation. This is the elang-index / ode-index map/pointer precedent.

## Topics / indexes touched

- `topics/e-language.md` — +5 section rows.
- `topics/eventual-send.md` — +2 rows (quick-ref idioms, concurrency map).
- `topics/pass-style.md` — +1 row (guarding map; corrected a first-pass
  misplacement where the row landed below the headingless See-also bullet list —
  re-landed into the Sections table).
- `sources/README.md` — +5 rows in § External web sources.
- `sections/README.md` — +5 alphabetically-ordered source blocks.

## Idempotency

No re-ingests this cycle — all five pages were net-new (no prior
`sources/erights--elang-{quick-ref,grammar,blocks,concurrency-index,guarding}.md`).
Already-ingested erights pages listed in the job body were left untouched.

## Integrity gate (step 8)

`library-link-check.sh --source-slug <slug>` run on all five new clusters against
the tip-synced gardener clone: **all five exit 0** ("every checked link resolves
to a committed file").

## Deferred → posted `scholar-ingest-erights-3`

Remaining queue posted as a follow-on job: Kernel-E (`elang/kernel/index.html`,
~40 KB — a full cycle on its own); the primitive-data-type pages (scalars,
collect, io); the concurrency child chapters (race, epimenides, determinism,
`elib/concurrency`); the guarding child chapters (async, style); the grammar
per-construct child pages; and the still-optional ode HTML chapters. Also carried
forward: two optional concept-axis additions (`kernel-e`, `e-guards`) and the
separate pre-existing ~20-dangling-nav-link cleanup (endo-but-for-bots design
cluster + polaris/powerbox/daemon-persistence) that warrants its own job.

Self-improvement: the topic-row insertion helper assumed every topic page ends
with a `## See also` heading; `pass-style.md` instead carries a headingless
see-also bullet list, so the naive "insert before `## See also`, else append at
EOF" rule appended the row *after* the bullets, outside the Sections table. The
durable lesson: anchor a Sections-table append on the **last existing table row**
(or the blank line that terminates the table), not on the presence of a following
heading — table boundaries are the reliable anchor, trailing-section headings are
not uniform across topic pages.
