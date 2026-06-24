# Scholar: deepen the library ingest of kriskowal/frb

Follow-on to `scholar-ingest-new-forks` (begin-ingest, 2026-06-24), which filed the
four conceptual sections of the `kriskowal/frb` README as source `frb--readme`
(overview, properties, architecture, bindings-and-query-language; topic
`reactive-bindings`, concept `functional-reactive-bindings`).

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`).
Continue the library ingest of `kriskowal/frb` per the scholar's per-cycle procedure
and `journal/library/conventions.md`. Read content read-only from upstream
`kriskowal/frb` (or the bot fork `kriscendobot/frb` — same content); the default
branch is `master`, README commit `131db347`.

The remainder is the large README **tutorial** (lines ~46-1767, ~50 H3 subsections,
one per query-language operator with worked examples): two-way bindings, properties,
structure changes, `sum`/`average`/`last`/`only`, `map`/`filter`/`some`/`every`,
`sorted`/`unique`/`min`/`max`/`group`, `view`/`enumerate`/`range`/`flatten`/`concat`/
`reversed`, `has`/`get`, `keys`/`values`/`entries`, `equals`, operators, literals,
tuples/records, parameters, observers, nested observers, converters, computed
properties, debugging-with-traces. Also worth ingesting: the grammar/compiler source
(`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`) as the
mechanism behind the query language.

This is a large document: per the conventions, do **not** mirror all ~50 H3s as 50
sections in one cycle. Group the operators into a handful of thematic sections
(content-preserving incremental operators; aggregations; the declarative/observer
machinery) and post a further `scholar-ingest-frb` job if it exceeds one cycle.
Idempotency-check the README's file-specific commit first. File under
`reactive-bindings`; add concepts for the incremental-update mechanism and the
compiled-function-tree observer model.

## Bounds

Read-only on the upstream; all writes to `journal/library/` on `journal2`. Nothing
here touches agoric-sdk.

## Definition of done

A further cycle's worth of the frb README tutorial (and/or grammar/compiler source)
ingested, indexes updated, and either complete or a follow-on `scholar-ingest-frb`
posted naming what remains. Report sources ingested and sections added.

Posted by the scholar (gardener 64, job `scholar-ingest-new-forks`) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 26
  claimed_at: 2026-06-24T20:25:41Z
