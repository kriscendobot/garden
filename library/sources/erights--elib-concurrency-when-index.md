---
source_kind: web
source_url: http://erights.org/elib/concurrency/when/index.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/when/index.html
source_fetched_via: mirror
source_content_sha256: dcf52b12f6348edc08580427e9fa46e2f9607fd8efee7778fcad2a28d5ff487c
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The Four Layers of When — sub-hub child of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index), itself a chapter map. The chapter prose is a stub
  ("*** To be written"); the value is the four-layer child map (references as
  observables, the When* reactors, the when-catch syntactic shorthand, joining
  multiple resolutions). The when-catch layer is the direct ancestor of
  `@endo/eventual-send`'s `E.when` / promise-reaction combinators. The four child
  chapters are now ingested as their own sources (scholar-ingest-erights-10), each an
  unwritten upstream stub recorded for its place in the map and its Endo lineage.
  source_date is an era approximation matching the sibling concurrency chapters.
---

**The Four Layers of When** sub-hub under ELib — the mechanism for turning
semi-data-flow back into control flow, arranging immediate reactions when an eventual
reference becomes fulfilled or broken. The chapter body is a stub; its value is the
four-layer map that builds from the lowest-level primitive (references as observables)
through the When* reactors and the when-catch syntactic shorthand up to joining
multiple resolutions. The when-catch layer is the direct ancestor of Endo's `E.when`
and promise-reaction combinators. This source captures the map; its four child
chapters are ingested separately.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [four-layers-of-when-map](../sections/erights--elib-concurrency-when-index--four-layers-of-when-map.md) | e-language, eventual-send | current |

## Child chapters (ingested)

Each child chapter is an unwritten upstream stub ("\*\*\* To be written"); its source
records the layer's place in the four-layer map and its Endo lineage.

| Child | Source | URL |
|-------|--------|-----|
| 1. References as Observables | [erights--elib-concurrency-when-ref-when](erights--elib-concurrency-when-ref-when.md) | `when/ref-when.html` (SHA `d943520d3936`) |
| 2. The When* Reactors | [erights--elib-concurrency-when-reactors](erights--elib-concurrency-when-reactors.md) | `when/when-reactors.html` (SHA `b39e64ddb55a`) |
| 3. The when-catch Syntactic Shorthand | [erights--elib-concurrency-when-catch](erights--elib-concurrency-when-catch.md) | `when/when-catch.html` (SHA `6f664b3f644a`) |
| 4. Joining Multiple Resolutions | [erights--elib-concurrency-when-joiners](erights--elib-concurrency-when-joiners.md) | `when/joiners.html` (SHA `73d5b78c4795`) |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/when/index.html`.
- Content SHA-256 `dcf52b12f6348edc08580427e9fa46e2f9607fd8efee7778fcad2a28d5ff487c`, 7421 bytes.
