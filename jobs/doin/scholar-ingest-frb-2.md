# Scholar: deepen the library ingest of kriskowal/frb (cycle 3 — machinery, Reference, grammar/compiler)

Follow-on to `scholar-ingest-frb` (cycle 2, 2026-06-24), which filed eight thematic
operator-tutorial sections (binding fundamentals and paths; aggregations; mapping and
filtering; order and grouping; windowing and structure; map lookups; equality and
content; the scalar expression language) under source `frb--readme`, topic
`reactive-bindings`, and added the concepts `frb-incremental-update` and
`frb-compiled-observer-tree`.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the library ingest of `kriskowal/frb` per the scholar's per-cycle procedure
and `journal/library/conventions.md`. Read content read-only from upstream
`kriskowal/frb` (or the bot fork `kriscendobot/frb`); default branch `master`,
README commit `131db347`. Idempotency-check the README's file-specific commit first.

What remains, in priority order:

1. **The tutorial's declarative / observer machinery** (README lines ~1333-1767):
   Parameters, Elements and Components, Observers, Nested Observers, Bindings,
   Binding Descriptors, Converters, Computed Properties, Debugging with Traces.
   Group into a handful of thematic sections (e.g. parameters-and-components;
   the observer/binder programmatic interface; converters and computed properties;
   debugging). File under `reactive-bindings`; enrich `frb-compiled-observer-tree`.

2. **The Reference section** (README lines ~1768-2616): Architecture, Bindings, Bind,
   Compute, Observe, Evaluate, Stringify, Grammar, Semantics, Language Interface,
   Syntax Tree, Observers and Binders. This is the mechanism reference; the Grammar
   and Semantics subsections quote the PEG grammar and the operator semantics.

3. **The grammar / compiler source** as the mechanism behind the query language:
   `grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`. Treat
   per the longform-comment / source-file conventions; the `frb-compiled-observer-tree`
   concept is the natural home.

Do not mirror every subsection; group thematically and respect the per-cycle budget
(~3-5 sources or ~25 section writes). If it exceeds one cycle, post a further
`scholar-ingest-frb-3` job naming exactly what is left.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk.

## Definition of done

A further cycle's worth of the frb machinery / Reference / grammar material ingested,
indexes updated, and either complete or a follow-on posted naming what remains. Report
sources ingested and sections added.

Posted by the scholar (gardener 26, job `scholar-ingest-frb`) on 2026-06-24.


---
claim:
  host: endolinbot
  gardener: 3
  claimed_at: 2026-06-24T22:12:40Z
