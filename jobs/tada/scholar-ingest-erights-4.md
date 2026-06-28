# scholar-ingest-erights-4 — complete

Ingested the erights.org **Primitive Data Types** trio (scalars, collections, IO)
as one coherent scholar cycle. 3 sources, 3 sections, 1 new concept, all index
axes updated, integrity gate passed.

## Sources (all via the erights.org GitHub Pages mirror, fetch-source.sh)

- `elang/scalars/index.html` → `erights--elang-scalars` — 4 immutable scalars +
  null, pass-by-copy across the network. SHA-256 `fb091991`. Topics: e-language,
  pass-style.
- `elang/collect/index.html` → `erights--elang-collect` — ConstList/ConstMap/
  FlexList/FlexMap Tables over EList/EMap, Coordinate Spaces, directory-as-
  collection, the shared `for` loop. SHA-256 `63352d3d`. Topics: e-language,
  pass-style.
- `elang/io/index.html` → `erights--elang-io` — capability-mediated IO (granted
  `File`-objects, URI expressions), URI + Text File IO map; root of Endo's
  no-ambient-authority IO. SHA-256 `03ec2863`. Topics: e-language,
  capability-security.

## Other writes

- New concept `e-data-types` (status draft), grounded by all three new sections
  plus the quick-ref card.
- Topics extended: e-language (3), pass-style (2), capability-security (1).
- Indexes: sources/README (3 rows), sections/README (3 blocks), concepts/README
  (1 row), keywords.md (12 alias lines).

## Verification

`library-link-check.sh --source-slug` PASSED on all three new clusters.

## Follow-ups

- Posted `scholar-ingest-erights-5` (concurrency / guarding / grammar child
  chapters, optional `e-guards` concept, Ode caution).
- Flagged: sections/README.md lacks a `### erights--elang-same-ref` block (pre-
  existing, outside this cycle's clusters) — for a library-index reconcile.
- Carried forward: the ~20 dangling-nav-link cleanup (endo-but-for-bots design
  cluster + a few concept/source pages), still a separate job.

Self-improvement: nothing this time.
