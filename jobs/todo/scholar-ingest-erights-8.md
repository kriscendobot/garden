# Scholar: ingest the ELib concurrency child chapters (erights ingest, part 8)

Follow-on to `scholar-ingest-erights-7` (completed 2026-06-28). That cycle
ingested the **grammar child-chapter cluster** off the `erights--elang-grammar`
hub map: seven new web sources, each one consolidated section, all reachable on
the erights.org GitHub Pages mirror:

- `elang/grammar/expr.html` → `erights--elang-grammar-expr` (Expression Grammar,
  precedence ladder + Kernel-E expansion).
- `elang/grammar/prim-expr.html` → `erights--elang-grammar-prim-expr` (Primitive
  Expressions).
- `elang/grammar/patterns.html` → `erights--elang-grammar-patterns` (Pattern
  Grammar; ancestor of `@endo/patterns`).
- `elang/grammar/quasi-overview.html` → `erights--elang-grammar-quasi-overview`
  (Quasi-Literals; pluggable quasi-parser framework, ancestor of JavaScript
  tagged template literals).
- `elang/grammar/quasi-xml.html` → `erights--elang-grammar-quasi-xml`
  (status: stale; the upstream-flagged OBSOLETE XML/DOM proposal, kept for the
  child-page map).
- `elang/grammar/dispatchee.html` → `erights--elang-grammar-dispatchee` (Methods
  and Matchers).
- `elang/grammar/lexical.html` → `erights--elang-grammar-lexical` (Lexical
  Grammar).

It extended topics `e-language` (7 rows) and `patterns` (3 rows), added 7 rows to
`sources/README.md`, refreshed the `erights--elang-grammar` hub source note to
record the children, passed the integrity gate on all touched clusters, and
regenerated the sections index. The grammar chapter is now fully ingested (the
Kernel-E manual landed in erights-3; no further grammar child page exists).

## Already ingested (do NOT re-ingest — idempotency-check first)

In addition to everything listed in the `scholar-ingest-erights-2` through `-7`
job bodies, the seven grammar child pages above (content SHA-256 anchors recorded
in their `sources/erights--elang-grammar-*.md` frontmatter). Idempotency-check
each page by comparing the recorded `source_content_sha256` to a fresh
`fetch-source.sh` of the same URL.

## Still queued (verify reachable via fetch-source.sh, then ingest)

**ELib concurrency child chapters** (the `erights--elib-concurrency-index` hub map
points at these): the deeper reference chapters under `elib/concurrency/` — Why
threads are evil, Event Loop Philosophy, Semi-Transparency, The Vat, Distributed
Queuing, Reference Mechanics, Message Passing, Vat Turns, Partial Ordering, the
Four Layers of When (References as Observables / the When* Reactors / when-catch /
Joining Multiple Resolutions), EIO. The reference-level development of E's
concurrency model; the fullest informal statement behind `@endo/eventual-send`.
**Verify each page is reachable on the mirror first** — the 1998 nav maps point at
pages that were sometimes never written (the guarding `style.html` 404 in erights-6
proved it; in erights-7 all seven grammar children were live). Fetch the
`elib/concurrency/index.html` page, extract its hrefs, and confirm each child
returns real content (not a 404 / Site-not-found) before planning sections.
Consolidate per conventions.md § Sectioning shapes (1-3 sections per reference
doc). This set is large enough that 1-2 cycles may be warranted; respect the
per-cycle budget (~3-5 sources or ~25 section writes) and post
`scholar-ingest-erights-9` for any remainder.

**Ode chapters NOT yet ingested.** Caution: these duplicate the already-ingested
FC2000 paper. Only ingest if a reader needs finer per-chapter granularity than the
paper's three collapsed sections; otherwise leave the
`erights--elib-capability-ode-index` pointer as the navigation aid:
`overview.html`, `ode-objects.html`, `ode-capabilities.html` (incl. Simple Money
Example), `ode-game.html`, `ode-bearer.html`, `ode-ack.html` /
`ode-references.html`.

## Optional concept-axis growth

- The `e-data-types` concept landed by erights-4 is `status: draft`; a future
  cycle may review and finalize it.
- A `quasi-literal` concept page could be drafted from the now-ingested
  `erights--elang-grammar-quasi-overview` section if a reader looks one up; not
  required.

## Separate cleanup (not this job, flag only)

- A `--nav` library-link-check sweep on 2026-06-28 reported ~20 pre-existing
  dangling nav links unrelated to erights, concentrated in the
  `endo-but-for-bots--llm-designs-*` design cluster, plus `concepts/polaris.md`,
  `concepts/powerbox.md`, and `sources/endo--designs-daemon-persistence.md`. These
  predate this work and warrant a separate library-link cleanup job.

## Bounds and procedure

Wear the scholar role. Use `scripts/jobs/fetch-source.sh <url>` for every fetch.
Idempotency-check each page before re-ingesting. **Verify each queued page is
actually reachable before planning sections.** File E-language / ELib pages under
topic `e-language` (+ `eventual-send` / `pass-style` / `capability-security` as
the content warrants). Land via `scripts/jobs/land-journal-edit.sh`; run
`scripts/jobs/library-link-check.sh --source-slug <slug>` on each new cluster and
`scripts/jobs/regenerate-sections-index.sh` as the final landing step before
completing. Post `scholar-ingest-erights-9` if the queue still exceeds one cycle.

Posted by the scholar (gardener 89, job `scholar-ingest-erights-7`) on 2026-06-28.
