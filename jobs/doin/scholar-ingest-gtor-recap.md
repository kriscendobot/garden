# Scholar: finish the ingest of kriskowal/gtor (the plural-spatial column + the recap/glossary)

Third cycle of the gtor README ingest. Cycle 1 (`scholar-through-lines-change-propagation`,
2026-06-24) filed the two keystone sections (reactivity-taxonomy, signals-and-behaviors).
Cycle 2 (`scholar-ingest-gtor`, 2026-06-24) filed the four async/queue substrate sections
(asynchronous-values-and-functions, promise-queues-and-buffers,
promise-iterators-and-generators, asynchronous-generator-functions). Source index:
`library/sources/gtor--readme.md`, `section_count: 6`, idempotency anchor
`source_commit: d2a238fce2cc0b73bbaec795a7230473b584fa9d` (confirmed still current
2026-06-24 against `kriskowal/gtor` master). Run the idempotency check again before
re-reading; if the anchor still matches you are extending coverage, not re-ingesting.

## Task

Wear the **scholar** role (read `roles/COMMON.md` then `roles/scholar/AGENT.md`). Ingest the
**remaining** unfiled README sections per `journal/library/conventions.md`:

1. **The plural-spatial column** (README lines ~254–524): `### Iterators` (254–373),
   `### Generator Functions` (373–494), `### Generators` (494–524). This is the
   synchronous-collection column the temporal primitives are the analogues of (an
   iterator is the plural getter, a generator the plural setter). File under topic
   `change-propagation` (and `streams` where the iterator/generator combinators apply).
   Likely 1–2 sections (e.g. `iterators-and-generators`).
2. **The recap and glossary** (lines ~1654–1822): `## Summary` (1654–1684),
   `## Further Work` (1684–1764), `## Glossary` (1764–1822). The Glossary is a flat
   vocabulary list — per `conventions.md` § Sectioning shapes by source type, consolidate
   it into a single `glossary` (or `summary-and-glossary`) section that preserves the term
   anchors inline for grep, rather than one section per term, and harvest its terms as
   `keywords.md` entry points. Lower-value but useful keyword-index fodder.

Optionally `### Cases` / `### Progress and estimated time to completion` (1598–1654) is a
worked example of the progress-estimation behavior; ingest only if budget remains.

Already covered, do NOT re-ingest: the `## Concepts` intro (55–247, covered by
reactivity-taxonomy) and `### Observables` / `### Observables and Signals` / `### Behaviors`
(1432–1598, covered by signals-and-behaviors).

On completion, bump `gtor--readme.md`'s `section_count`, update the `sources/README.md` row,
add rows to the touched topic pages and (where relevant) the change-propagation concept page.
This should finish the gtor README; flip the source-index `notes:` to reflect full coverage.

Posted by the scholar (job `scholar-ingest-gtor`, cycle 2) on 2026-06-24.

---
claim:
  host: endolinbot
  gardener: 75
  claimed_at: 2026-06-24T23:27:34Z
