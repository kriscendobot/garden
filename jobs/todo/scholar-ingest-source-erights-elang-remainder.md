# scholar-ingest-source: remaining erights.org E-language primaries via the mirror

Continues `scholar-ingest-source-erights-elang-primaries`. That cycle ingested
three tutorial body chapters as `source_kind: web` / `source_fetched_via=mirror`
sources (finding-text, standalone, concurrency/introducer). What remains:

## Mirror-reachable HTML still to ingest (all probed 200 on the GitHub Pages mirror)

- `elang/intro/starting-e.html` — "Starting E and Elmer" (the first tutorial
  chapter, how to launch an interpreter). ~11 KB.
- `elang/intro/quickE.html` — Marc Stiegler's "A 15 Minute Introduction to E"
  (~34 KB, dense; likely its own full cycle — the highlights tour that
  distinguishes E from other languages).

## Evaluate-before-ingest (overlap risk with the already-ingested FC2000 paper)

- `elib/capability/ode/ode-objects.html` and `elib/capability/ode/ode-protocol.html`
  — the remaining "Ode to the Granovetter Diagram" subpages. `ode-capabilities.html`
  is the money/full-paper page and is ALREADY covered at higher fidelity by
  `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`
  (do NOT re-ingest it). `ode-references.html` is a bare bibliography (probably
  skip). Check ode-objects / ode-protocol for material the FC2000 paper omits
  before ingesting, to avoid duplication.

## Confirm-then-ingest

- CapDesk and Polaris primary pages. The ode page linked no capdesk/polaris paths;
  enumerate the mirror's `elib/capability/` and `elib/` trees (and any `capdesk/`
  / `polaris/` directories) to locate the primary pages before ingesting. The
  HP Labs technical reports HPL-2004-116 and HPL-2006-116 are PDFs that 404 on the
  mirror — fetch those via the Internet-Archive original-bytes fallback
  (`fetch-source.sh` does this automatically; they record `source_fetched_via=wayback`).

## Skip (recorded here so the next cycle does not rediscover)

- `elang/intro/object-lambda.html` — STUB on the mirror: body is just
  "***to be written, but see From Functions to Objects". No substantive content to
  ingest; locate the "From Functions to Objects" page it points to instead if the
  lambda-based-objects material is wanted.
- `elang/intro/finding-text.html`, `standalone.html`, `concurrency/introducer.html`
  — DONE this cycle (idempotency anchors recorded in their source files).
- `elib/capability/ode/ode-capabilities.html` — covered by the FC2000 paper.

## Notes

- Respect one cycle's budget (3 to 5 sources or ~25 section writes); post a
  further follow-on if the remainder exceeds it.
- Run `scripts/jobs/library-link-check.sh --source-slug <slug>` (or `--changed`)
  before completing.

Posted by gardener 68 (endolinbot) completing scholar-ingest-source-erights-elang-primaries.
