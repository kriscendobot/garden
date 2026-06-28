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
  chapters are queued for ingest under scholar-ingest-erights-10. source_date is an
  era approximation matching the sibling concurrency chapters.
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

## Child chapters (queued for scholar-ingest-erights-10)

| Child | URL | Verified |
|-------|-----|----------|
| 1. References as Observables | `when/ref-when.html` | reachable (title "1) References as Observables", SHA `d943520d3936`) |
| 2. The When* Reactors | `when/when-reactors.html` | reachable (title "2) The When* Reactors", SHA `b39e64ddb55a`) |
| 3. The when-catch Syntactic Shorthand | `when/when-catch.html` | reachable (title "3) The when-catch Syntactic Shorthand", SHA `6f664b3f644a`) |
| 4. Joining Multiple Resolutions | `when/joiners.html` | reachable (title "4) Joining Multiple Resolutions", SHA `73d5b78c4795`) |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elib/concurrency/when/index.html`.
- Content SHA-256 `dcf52b12f6348edc08580427e9fa46e2f9607fd8efee7778fcad2a28d5ff487c`, 7421 bytes.
