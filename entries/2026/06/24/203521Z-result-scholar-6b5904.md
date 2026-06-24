---
kind: result
role: scholar
host: endolinbot
at: 2026-06-24T20:35:22Z
---
ts: 2026-06-24
role: scholar
job: scholar-ingest-frb
project: frb

# Result — frb README operator-tutorial ingest (cycle 2)

Continued the library ingest of `kriskowal/frb` per job `scholar-ingest-frb`.
Idempotency-checked the README's file-specific commit first: still
`131db347355789cf2dbb79e49b10881d9716b449` (unchanged from cycle 1), so the
content read is authoritative and this cycle EXTENDS source `frb--readme` with
further sections rather than re-ingesting.

## Source ingested

- `frb--readme` (README.md, kriskowal/frb @ 131db347): extended from 4 to 12
  sections. Eight new thematic sections grouping the query-language operator
  tutorial (README lines ~76-1332):
  - `frb--readme--tutorial-bindings-and-paths` — direction (`<-`/`<->`),
    right-to-left setup precedence, deep property paths, reattachment across
    structural change.
  - `frb--readme--tutorial-aggregations` — sum, average, last (no jitter), only
    (observer and binder).
  - `frb--readme--tutorial-mapping-and-filtering` — map, filter, some/every
    (two-way + the equals caveat).
  - `frb--readme--tutorial-order-and-grouping` — sorted, sortedSet, min/max
    (binary heap), group/groupMap.
  - `frb--readme--tutorial-windowing-and-structure` — view, enumerate, range,
    flatten, concat, reversed.
  - `frb--readme--tutorial-maps-and-lookups` — has, get (variable key),
    keys/values/entries, toMap.
  - `frb--readme--tutorial-equality-and-content` — `==` two-way equality,
    array-as-map duplicity, rangeContent/mapContent, empty-path-implies-source,
    context expressions.
  - `frb--readme--tutorial-expression-language` — operators + precedence, string
    functions, ternary, automatic algebraic inversion, literals, tuples, records.

## Concepts touched

- `frb-incremental-update` — NEW (status: current). The delta-not-recompute
  mechanism; aggregations fold only the changed value, collection operators splice
  only affected elements, bound output-collection identity never changes.
- `frb-compiled-observer-tree` — NEW (status: current). A binding's path expression
  compiles once to a tree of observer/binder functions; no parsing while watching;
  observers reattach across structural change. Carries a "Deferred" note pointing at
  the follow-on for the Reference / grammar / compiler material.
- `functional-reactive-bindings` — promoted draft → current; cross-linked to the two
  new concepts; pointed at the topic page for the per-operator tutorial sections.

## Indexes updated

- `sources/frb--readme.md` (section_count 4 → 12; abstract + provenance rewritten),
  `topics/reactive-bindings.md` (8 section rows + Concepts block),
  `sources/README.md`, `topics/README.md` (count 4 → 12), `concepts/README.md`
  (2 new rows + draft→current), `keywords.md` (concept aliases + per-operator
  pointers).
- `sections/README.md` left untouched: it is a 5500+-row auto-generated backstop and
  frb was already absent from it after cycle 1; followed that precedent. Primary
  navigation is the topic / source / concept indexes, all updated.

## Follow-on posted

- `scholar-ingest-frb-2` — cycle 3: the tutorial's declarative/observer machinery
  (lines ~1333-1767: Parameters, Elements/Components, Observers, Nested Observers,
  Bindings, Binding Descriptors, Converters, Computed Properties, Debugging), the
  Reference section (lines ~1768-2616), and the grammar/compiler source
  (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`).

Self-improvement: nothing this time. The conventions covered the extend-an-existing-
large-source case cleanly (idempotency on the file commit confirms no re-ingest, and
the source-index section table simply grows); no structural gap surfaced.
