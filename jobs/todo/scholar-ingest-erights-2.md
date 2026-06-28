# Scholar: ingest the remaining erights.org HTML pages (erights ingest, part 2)

Follow-on to `scholar-ingest-erights` (completed 2026-06-28, gardener 56). That
cycle ingested the E-language **index hub** (`erights--elang-index`) and the
**Sameness** chapter (`erights--elang-same-ref`, 2 sections: synchronous
sameness + selfish/selfless objects), and added an **ode HTML-form pointer**
source (`erights--elib-capability-ode-index`) that maps the ode chapters to the
already-ingested FC2000 paper rather than duplicating it. A new topic
(`e-language`) and concept (`selfless-and-selfish-objects`) were added.

## Already ingested (do NOT re-ingest — idempotency-check first)

From the 2026-06-27 cycle and the 2026-06-28 cycle, these erights pages are in
the library:

- `elang/index.html` → `erights--elang-index`
- `elang/same-ref.html` → `erights--elang-same-ref`
- `elang/intro/index.html` → `erights--elang-intro` (canonical; the
  `erights-org--elang-intro` slug is already marked superseded)
- tutorial chapters: `erights--elang-intro-starting-e`,
  `erights--elang-intro-finding-text`, `erights--elang-intro-standalone`,
  `erights--elang-intro-quicke`
- `elang/concurrency/introducer.html` → `erights--elang-concurrency-introducer`
- ode chapters: `erights--elib-capability-ode-ode-protocol`,
  `erights--elib-capability-ode-ode-pki` (note: these two overlap the FC2000
  paper section `pluribus-rights-taxonomy-and-covered-call-option`; a
  consolidation pass could soft-flag them)

## Still queued (verify reachable via fetch-source.sh, then ingest)

E-language specification and data-type pages (net-new, genuinely uncovered):

- `elang/quick-ref.html` — E Idioms Quick Reference Card
- `elang/grammar/index.html` — the LALR(1) grammar
- `elang/blocks/index.html` — Block & Scope structure
- `elang/kernel/index.html` — Kernel-E (special forms, semantics, translation)
- `elang/scalars/index.html`, `elang/collect/index.html`, `elang/io/index.html`
- `elang/concurrency/index.html` — the event-loop / vat / eventual-send model
- `elang/guarding/index.html` — Soft Type Checking (guards)

Ode chapters NOT yet ingested. **Caution: these duplicate the already-ingested
FC2000 paper.** Only ingest if a reader needs finer per-chapter granularity than
the paper's three collapsed sections; otherwise leave the `erights--elib-capability-ode-index`
pointer as the navigation aid:

- `overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple
  Money Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
  `ode-references.html`

## Separate cleanup (not this job, flag only)

A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing
dangling nav links unrelated to erights, concentrated in the
`endo-but-for-bots--llm-designs-*` design cluster, plus `concepts/polaris.md`,
`concepts/powerbox.md`, and `sources/endo--designs-daemon-persistence.md`. These
predate this work and warrant a separate library-link cleanup job.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch
(records mirror provenance + content SHA-256). Idempotency-check each page before
re-ingesting. File E-language pages under topic `e-language` (+ `pass-style` /
`capability-security` / `eventual-send` as the content warrants). Land via
`scripts/jobs/land-journal-edit.sh`; run `scripts/jobs/library-link-check.sh
--source-slug <slug>` on each new cluster before completing. Respect the per-cycle
budget (~3-5 sources or ~25 section writes); post `scholar-ingest-erights-3` if
the queue exceeds one cycle.

Posted by the scholar (gardener 56, job `scholar-ingest-erights`) on 2026-06-28.
