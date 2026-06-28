---
source_kind: web
source_url: http://erights.org/elang/grammar/dispatchee.html
source_effective_url: https://erights.github.io/erights-org-website/elang/grammar/dispatchee.html
source_fetched_via: mirror
source_content_sha256: 56341a00677acea44758e6bde32b8dc5ba7b2a83d1184376f9e19960497daf30
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
section_count: 1
status: current
notes: >
  The Methods and Matchers child page of the grammar chapter, ingested by
  scholar-ingest-erights-7. A thin page defining E's two dispatchees: methods
  (named) and matchers (catch-all), each a head of patterns plus a body, not first
  class, appearing only in dispatching contexts. Ancestor of exo / Far method
  definitions and the catch-all forwarding pattern.
---

The **Methods and Matchers** page of E's grammar chapter: the two kinds of
dispatchee that an object or class definition dispatches to. Each is a head of
patterns plus a body expression: head patterns match the specimen, and on success
the body evaluates in the resulting scope. Methods are named and handle a specific
message; matchers are the unnamed catch-all. Neither is first class. This is why
parameter binding in E is pattern matching.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [methods-and-matchers](../sections/erights--elang-grammar-dispatchee--methods-and-matchers.md) | e-language, patterns | current |

## Provenance

- Fetched 2026-06-28 via `scripts/jobs/fetch-source.sh`; served by the erights.org GitHub Pages mirror (`source_fetched_via=mirror`).
- Effective URL: `https://erights.github.io/erights-org-website/elang/grammar/dispatchee.html`.
- Content SHA-256 `56341a00677acea44758e6bde32b8dc5ba7b2a83d1184376f9e19960497daf30`, 7589 bytes, last modified 1998-10-03.
