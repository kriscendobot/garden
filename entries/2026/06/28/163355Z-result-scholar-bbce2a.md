---
kind: result
role: scholar
host: endolinbot
at: 2026-06-28T16:34:18Z
---
Scholar cycle `scholar-ingest-erights-4`: ingested the **Primitive Data Types**
trio from erights.org E-language documentation as one coherent cycle (all fetched
2026-06-28 via `scripts/jobs/fetch-source.sh`, served by the erights.org GitHub
Pages mirror, `source_fetched_via=mirror`).

Sources ingested (3 sources, 3 sections):

- `elang/scalars/index.html` → `erights--elang-scalars` (1 section:
  `scalar-data-types`). SHA-256 `fb091991`. Topics: e-language, pass-style. The
  four immutable scalars (`integer` bignum, `float64`, `boolean`, `char`) + null,
  all pass-by-copy across the network.
- `elang/collect/index.html` → `erights--elang-collect` (1 section:
  `collections-tables-spaces-and-the-for-loop`). SHA-256 `63352d3d`. Topics:
  e-language, pass-style. ConstList/ConstMap/FlexList/FlexMap Tables two-by-two
  over EList/EMap, Coordinate Spaces, directory-as-collection, the shared `for`
  loop.
- `elang/io/index.html` → `erights--elang-io` (1 section:
  `io-map-uri-and-text-file`). SHA-256 `03ec2863`. Topics: e-language,
  capability-security. Capability-mediated IO (granted `File`-objects, URI
  expressions), the URI Expression + Text File IO map; root of Endo's
  no-ambient-authority IO.

Concept added: `concepts/e-data-types.md` (status draft) — E's primitive-data
catalog (scalars + collections + capability-mediated IO), grounded by all three
new sections plus `erights--elang-quick-ref`; cross-links
[[selfless-and-selfish-objects]], [[pass-by-construction]], [[object-sameness]],
[[e-language]].

Topics touched: `e-language` (3 rows), `pass-style` (2 rows: scalars + collect),
`capability-security` (1 row: io).

Indexes updated: `sources/README.md` (3 rows), `sections/README.md` (3 blocks),
`concepts/README.md` (e-data-types row after e-language), `keywords.md` (12 alias
lines → e-data-types).

Integrity gate (step 8): `library-link-check.sh --source-slug` PASSED on all three
new clusters (erights--elang-scalars, erights--elang-collect, erights--elang-io) —
every checked link resolves to a committed file.

Per-type child chapters NOT ingested (navigable from the landing pages, queued
only on reader demand): integer-ref/float64-ref/boolean-ref/char-ref (scalars);
String-ref/tables.html/coord/ (collect); uri-exprs.html/text-file-io.html (io).

Follow-on posted: `scholar-ingest-erights-5` (concurrency / guarding / grammar
child chapters + optional `e-guards` concept + Ode caution; still exceeds one
cycle). Flagged for a separate library-index reconcile: `sections/README.md` lacks
the `### erights--elang-same-ref` block (sections exist and are listed on the
e-language topic page; pre-existing, outside this cycle's touched clusters).

Self-improvement: nothing this time — the scholar per-job procedure, fetch-source
mirror substitution, the lander, and the integrity gate all worked cleanly for a
small multi-source reference-page cycle.
